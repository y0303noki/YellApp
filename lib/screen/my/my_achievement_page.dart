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
import 'package:yell_app/screen/my/select_log_page.dart';
import 'package:yell_app/state/invite_provider.dart';
import 'package:yell_app/state/my_achievment_provider.dart';
import 'package:bubble/bubble.dart';
import 'package:share/share.dart';
import 'package:yell_app/utility/utility.dart';

MyGoalFirebase _myGoalFirebase = MyGoalFirebase();

class MyAchievementPage extends ConsumerWidget {
  const MyAchievementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAchievment = ref.watch(myAchievmentProvider);
    final invite = ref.watch(inviteProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
        elevation: 10,
        leading: IconButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          // 目標を削除する
          IconButton(
            onPressed: () async {
              String? result = await DialogWidget().endMyGoalDialog(context);
              if (result == null || result == 'CANCEL') {
                return;
              } else {
                // 削除実行
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
        // 下に引っ張って更新
        onRefresh: () async {
          myAchievment.refresh = true;
          myAchievment.refreshNotifyListeners();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: _futureBody(context, myAchievment, invite),
        ),
      ),
    );
  }

  // メンバーウィジット
  Widget _memberWidget(BuildContext context, MyAchievment myAchievment) {
    // メンバーがいないとき
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
            TextWidget.headLineText6('まだメンバーがいません'),
            TextButton(
              onPressed: () {
                // 招待ページに遷移
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InviteMainPage(),
                  ),
                );
              },
              child: TextWidget.headLineText6('メンバーを追加する'),
            ),
          ],
        ),
      );
    } else {
      // メンバーがいるとき
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
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
                      left: 10,
                    ),
                    child: const Text(
                      '応援コメント',
                      // style: TextStyle(
                      //   color: Colors.white,
                      // ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      right: 5,
                    ),
                    child: IconButton(
                      color: Colors.blue,
                      onPressed: () {
                        // 招待ページに遷移
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
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
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

  // コメント
  Widget _memberComment(MyAchievment myAchievment, MemberModel memberModel) {
    // メンバーからのコメントを表示
    YellMessage comment = myAchievment.yellMessages.firstWhere(
        (message) => message.memberId == memberModel.memberUserId,
        orElse: () => YellMessage());
    Text commentText = comment.message.isEmpty
        ? const Text(
            'まだコメントがありません',
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
    // ui部分
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

  // 非同期処理でbodyWidgetを作る
  Widget _futureBody(
      BuildContext context, MyAchievment myAchievment, Invite invite) {
    if (!myAchievment.refresh) {
      return _body(context, myAchievment);
    } else {
      myAchievment.refresh = false;
      return FutureBuilder(
        // future属性で非同期処理を書く
        future: _myGoalFirebase.fetchGoalAndMemberData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // 通信中
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.error != null) {
            // エラー
            return const Center(
              child: Text('エラーがおきました'),
            );
          }

          // 成功処理
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, Object?>? _data = snapshot.data;
            if (_data == null) {
              // データがない、おかしい
              return const Center(
                child: Text('エラーがおきました'),
              );
            }
            MyGoalModel goalData = _data.containsKey('goal')
                ? _data['goal'] as MyGoalModel
                : MyGoalModel();

            List<MemberModel> memberDatas = _data.containsKey('members')
                ? _data['members'] as List<MemberModel>
                : [];

            // 応援メッセージ
            List<YellMessage> messages = _data.containsKey('messages')
                ? _data['messages'] as List<YellMessage>
                : [];

            // データをセット
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

  // ui部分
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
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 自分のでかいアイコン
              ButtonWidget.iconBigMainWidget(
                Utility.substring1or2(myAchievment.myName),
              ),
              Expanded(
                child: Tooltip(
                  message: '応援してくれるメンバーにコメントが表示されます',
                  child: Bubble(
                    margin: const BubbleEdges.only(
                      top: 10,
                      right: 10,
                    ),
                    borderColor: CommonWidget.myDefaultColor(),
                    stick: true,
                    nip: BubbleNip.leftCenter,
                    child: Text(
                      myAchievment.achieveComment,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          TextButton(
              onPressed: !myAchievment.achieved
                  ? null
                  : () async {
                      // ひとことコメント
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
              child: const Text('達成したのでひとこと残す')),
          Column(
            children: [
              Slider(
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
                        // 右まで到達したら達成処理
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/yazirusi.png',
                    width: 60,
                  ),
                  const Text('右まで引っ張って達成'),
                ],
              ),
            ],
          ),
          // コメント一覧
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
            // ロゴを選択してたらリロードする
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

  /// SNSにシェア
  Future _shareSns(String _text) async {
    _text += '#今日もえらい！';
    await Share.share(_text);
  }

  /// 達成時の処理
  /// true:成功 false:失敗
  Future<bool> _achievementFunc(
      BuildContext context, MyAchievment myAchievment) async {
    if (myAchievment.achieved) {
      // 達成をキャンセルするとややこしいのでさせない
      return false;
    }
    myAchievment.tapToday();
    int increment = myAchievment.continuationCount + 1;

    await _myGoalFirebase.updateAchieveCurrentDayOrTime(
        myAchievment.goalId, increment, myAchievment.achievedDayOrTime);

    // スナックバー表示
    String xDayMessage = '';
    bool is10times = myAchievment.continuationCount % 10 == 0; //10の倍数
    // 初めて
    if (increment == 1) {
      xDayMessage = 'はじめての達成おめでとうございます！\nこれからも続けてみましょう！';
    } else if (is10times) {
      xDayMessage = '$increment回続きました、すごい！';
    } else {
      xDayMessage = '達成おめでとう！';
    }

    String snsShareText =
        '${myAchievment.goalTitle}を$increment回目の達成です。今日もえらい！\n#今日もえらい\nhttp:googlecom;';
    String message = '今回の記録をSNSでシェアしますか？';
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
                  Icons.thumb_up_alt_outlined,
                  size: 60,
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
                  child: TextWidget.snackBarText('しない'),
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
                    child: TextWidget.snackBarText('シェアする'),
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
