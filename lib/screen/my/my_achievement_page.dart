import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/components/dialog/dialog_widget.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/firebase/my_goal_firebase.dart';
import 'package:yell_app/model/member.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/model/yell_message.dart';
import 'package:yell_app/screen/my/invite_main_page.dart';
import 'package:yell_app/screen/my/local_notification_page.dart';
import 'package:yell_app/screen/my/reset_time_page.dart';
import 'package:yell_app/screen/my/select_log_page.dart';
import 'package:yell_app/state/invite_provider.dart';
import 'package:yell_app/state/my_achievment_provider.dart';
import 'package:bubble/bubble.dart';
import 'package:share/share.dart';
import 'package:yell_app/utility/utility.dart';
import 'package:fluttertoast/fluttertoast.dart';

MyGoalFirebase _myGoalFirebase = MyGoalFirebase();

class MyAchievementPage extends ConsumerWidget {
  const MyAchievementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAchievment = ref.watch(myAchievmentProvider);
    final invite = ref.watch(inviteProvider);

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        drawerEdgeDragWidth: 0,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            // IconButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const LocalNotificationPage(),
            //       ),
            //     );
            //   },
            //   icon: const Icon(
            //     Icons.timer,
            //     color: Colors.red,
            //   ),
            // ),
            // ????????????????????????
            IconButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResetTimePage(),
                  ),
                ).then(
                  (value) {
                    // ?????????????????????????????????????????????
                    if (value != null && value) {
                      myAchievment.refresh = true;
                      myAchievment.refreshNotifyListeners();
                    }
                  },
                );
              },
              icon: const Icon(
                Icons.timer,
                color: Colors.yellow,
              ),
            ),
            // ?????????????????????
            IconButton(
              onPressed: () async {
                String? result = await DialogWidget().endMyGoalDialog(context);
                if (result == null || result == 'CANCEL') {
                  return;
                } else {
                  // ????????????
                  await _myGoalFirebase.deleteMyGoalData(myAchievment.goalId);
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              },
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          // ???????????????????????????
          onRefresh: () async {
            myAchievment.refresh = true;
            myAchievment.refreshNotifyListeners();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: _futureBody(context, myAchievment, invite),
          ),
        ),
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    return true;
  }

  // ???????????????????????????
  Widget _memberWidget(BuildContext context, MyAchievment myAchievment) {
    // ??????????????????????????????
    if (myAchievment.memberIdList.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 10,
        ),
        child: Column(
          children: [
            TextWidget.headLineText6('?????????????????????????????????'),
            TextButton(
              onPressed: () {
                // ????????????????????????
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InviteMainPage(),
                  ),
                );
              },
              child: TextWidget.headLineText6('???????????????????????????'),
            ),
          ],
        ),
      );
    } else {
      // ???????????????????????????
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 40,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 30,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: const Text(
                      '??????????????????',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      right: 5,
                    ),
                    child: IconButton(
                      color: Colors.blue,
                      onPressed: () {
                        // ????????????????????????
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InviteMainPage(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.person_add_alt,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: myAchievment.yellMembers.length,
                itemBuilder: (BuildContext context, int index) {
                  return _memberComment(
                      myAchievment, myAchievment.yellMembers[index]);
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  // ????????????
  Widget _memberComment(MyAchievment myAchievment, MemberModel memberModel) {
    // ??????????????????????????????????????????
    YellMessage comment = myAchievment.yellMessages.firstWhere(
        (message) => message.memberId == memberModel.memberUserId,
        orElse: () => YellMessage());
    Text commentText = comment.message.isEmpty
        ? const Text(
            '????????????????????????????????????',
            style: TextStyle(
              fontSize: 20,
            ),
          )
        : Text(
            comment.message,
            style: const TextStyle(
              fontSize: 26,
              color: Colors.black,
            ),
          );
    // ui??????
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
      child: ListTile(
        leading: ButtonWidget.iconMainMiniWidget(
          Utility.substring1or2(memberModel.memberName),
        ),
        title: TextWidget.subTitleText3(memberModel.memberName),
        subtitle: commentText,
      ),
    );
  }

  // ??????????????????bodyWidget?????????
  Widget _futureBody(
      BuildContext context, MyAchievment myAchievment, Invite invite) {
    if (!myAchievment.refresh) {
      return _body(context, myAchievment);
    } else {
      myAchievment.refresh = false;
      return FutureBuilder(
        // future?????????????????????????????????
        future: _myGoalFirebase.fetchGoalAndMemberData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // ?????????
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.error != null) {
            // ?????????
            return const Center(
              child: Text('???????????????????????????'),
            );
          }

          // ????????????
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, Object?>? _data = snapshot.data;
            if (_data == null) {
              // ?????????????????????????????????
              return const Center(
                child: Text('???????????????????????????'),
              );
            }
            MyGoalModel goalData = _data.containsKey('goal')
                ? _data['goal'] as MyGoalModel
                : MyGoalModel();

            List<MemberModel> memberDatas = _data.containsKey('members')
                ? _data['members'] as List<MemberModel>
                : [];

            // ?????????????????????
            List<YellMessage> messages = _data.containsKey('messages')
                ? _data['messages'] as List<YellMessage>
                : [];

            // ?????????????????????
            if (!goalData.isDeleted) {
              goalData.memberIds = memberDatas.map((e) => e.id).toList();
              myAchievment.setInitialData(goalData, memberDatas, messages);
              invite.id = goalData.inviteId;

              return _body(context, myAchievment);
            }
          }
          return Container();
        },
      );
    }
  }

  // ui??????
  Widget _body(BuildContext context, MyAchievment myAchievment) {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        left: 0,
        right: 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CommonWidget.achieveTitleWidget(
            myAchievment,
            null,
            _logoWidget(myAchievment, context),
            myAchievment.startDate,
          ),
          // CommonWidget.myInfoWidget(myAchievment),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: !myAchievment.achieved
                    ? null
                    : () async {
                        // ????????????????????????
                        String? achievedMyMessage = await DialogWidget()
                            .achievedMyMessagelDialog(
                                context, myAchievment.achieveComment);
                        if (achievedMyMessage == null) {
                          return;
                        } else {
                          await _myGoalFirebase.updateAchievecomment(
                              myAchievment.goalId, achievedMyMessage);
                          myAchievment.updatedAchieveComment(achievedMyMessage);
                        }
                      },
                child: const Text('??????????????????'),
              ),
              IconButton(
                onPressed: () {
                  Fluttertoast.showToast(
                      msg: "??????????????????????????????????????????",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      // backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                icon: const Icon(
                  Icons.help,
                  size: 24,
                ),
              )
            ],
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Slider(
                  label: myAchievment.sliderLabel,
                  min: MyAchievment.sliderMinValue,
                  max: MyAchievment.sliderMaxValue,
                  value: myAchievment.achieved
                      ? MyAchievment.sliderMaxValue
                      : myAchievment.sliderValue,
                  activeColor: Colors.orange,
                  inactiveColor: Colors.blueAccent,
                  divisions: 3,
                  onChanged: myAchievment.achieved
                      ? null
                      : (double _value) async {
                          myAchievment.updateSliderValue(_value);
                          // ????????????????????????????????????
                          if (_value == MyAchievment.sliderMaxValue) {
                            bool result =
                                await _achievementFunc(context, myAchievment);
                            if (result) {
                              myAchievment.refresh = true;
                              myAchievment.refreshNotifyListeners();
                            }
                          }
                        },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/yazirusi.png',
                    width: 60,
                  ),
                  const Text('??????????????????????????????'),
                ],
              ),
            ],
          ),
          // ??????????????????
          _memberWidget(context, myAchievment),
        ],
      ),
    );
  }

  Widget _logoWidget(MyAchievment _myAchievment, BuildContext _context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          _context,
          MaterialPageRoute(
            builder: (context) => const SelectLogoPage(),
          ),
        ).then(
          (value) {
            // ?????????????????????????????????????????????
            if (value != null && value) {
              _myAchievment.refresh = true;
              _myAchievment.refreshNotifyListeners();
            }
          },
        );
      },
      child: CommonWidget.logoByNumber(_myAchievment.logoImageNumber),
    );
  }

  /// SNS????????????
  Future _shareSns(String _text) async {
    _text += '#?????????????????????';
    await Share.share(_text);
  }

  /// ??????????????????
  /// true:?????? false:??????
  Future<bool> _achievementFunc(
      BuildContext context, MyAchievment myAchievment) async {
    if (myAchievment.achieved) {
      // ??????????????????????????????????????????????????????????????????
      return false;
    }
    myAchievment.tapToday();
    int increment = myAchievment.continuationCount + 1;

    await _myGoalFirebase.updateAchieveCurrentDayOrTime(
        myAchievment.goalId, increment, myAchievment.achievedDayOrTime);

    // ????????????????????????
    String xDayMessage = '';
    bool is10times = myAchievment.continuationCount % 10 == 0; //10?????????
    // ?????????
    if (increment == 1) {
      xDayMessage = '??????????????????????????????????????????????????????\n??????????????????????????????????????????';
    } else if (is10times) {
      xDayMessage = '$increment?????????????????????????????????';
    } else {
      xDayMessage = '????????????????????????';
    }

    String snsShareText = '${myAchievment.goalTitle}???$increment????????????????????????';
    String message = '??????????????????SNS???????????????????????????';
    final snackBar = SnackBar(
      backgroundColor: Colors.yellow[50],
      elevation: 30,
      content: SizedBox(
        height: 200.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(
                  Icons.done_outline,
                  size: 60,
                  color: Colors.blue,
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Center(
                      child: TextWidget.snackBarText(xDayMessage),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextWidget.snackBarText(message),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  child: TextWidget.snackBarText('?????????'),
                ),
                TextButton(
                  onPressed: () {
                    _shareSns(snsShareText);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: CommonWidget.myDefaultColor(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextWidget.snackBarText('???????????????'),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      duration: const Duration(seconds: 10),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    return true;
  }
}
