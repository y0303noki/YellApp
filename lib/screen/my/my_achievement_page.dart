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
          memberModel.memberName.substring(0, 1),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // タイトル
              Expanded(
                child: Center(
                  child: TextWidget.headLineText4(myAchievment.goalTitle),
                ),
              ),
              // ロゴ
              InkWell(
                onTap: () {
                  print('tap');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectLogoPage(),
                    ),
                  ).then(
                    (value) {
                      print(value);
                      if (value != null && value) {
                        myAchievment.refresh = true;
                        myAchievment.refreshNotifyListeners();
                      }
                    },
                  );
                },
                child: _logoByNumber(myAchievment.logoImageNumber),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 自分のでかいアイコン
              ButtonWidget.iconBigMainWidget(
                myAchievment.myName.substring(0, 1),
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
              child: const Text('ひとこと残す')),
          // 目標タイトル
          Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              bottom: 10,
            ),
            child: TextWidget.headLineText4(myAchievment.goalTitle),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/yazirusi.png',
                    width: 60,
                  ),
                  const Text('右まで引っ張ると達成済みになります'),
                ],
              ),

              Slider(
                label: myAchievment.sliderLabel,
                min: 0,
                max: 5,
                value: myAchievment.achieved
                    ? MyAchievment.sliderMaxValue
                    : myAchievment.sliderValue,
                activeColor: Colors.orange,
                inactiveColor: Colors.blueAccent,
                divisions: 5,
                onChanged: myAchievment.achieved
                    ? null
                    : (double _value) {
                        myAchievment.updateSliderValue(_value);
                        // 右まで到達したら達成処理
                        if (_value == MyAchievment.sliderMaxValue) {
                          _achievementFunc(context, myAchievment);
                        }
                      },
              ),
              // 継続何日目？
              Container(
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget.headLineText5('継続'),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      child: myAchievment.achieved
                          ? TextWidget.headLineText3(
                              '${myAchievment.currentDayOrTime - 1}')
                          : TextWidget.headLineText3(
                              '${myAchievment.currentDayOrTime}'),
                    ),
                    TextWidget.headLineText5(
                        myAchievment.unitType == 0 ? '日目' : '回目'),
                  ],
                ),
              ),
            ],
          ),
          // コメント一覧
          _memberWidget(context, myAchievment),
        ],
      ),
    );
  }

  Widget _logoByNumber(int _num) {
    String _imagePath = '';
    switch (_num) {
      case 0:
        _imagePath = 'images/run.png';
        break;
      case 1:
        _imagePath = 'images/souzi.png';
        break;
      case 2:
        _imagePath = 'images/benkyou.png';
        break;
      case 3:
        _imagePath = 'images/kintore.png';
        break;
      case 4:
        _imagePath = 'images/pc.png';
        break;
      case 5:
        _imagePath = 'images/sumaho.png';
        break;
      default:
        _imagePath = 'images/kintore.png';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(
        left: 10,
        right: 20,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image.asset(
        _imagePath,
        width: 60,
      ),
    );
  }

  /// SNSにシェア
  Future _shareSns(String _text) async {
    _text += '#今日もえらい！';
    await Share.share(_text);
  }

  /// 達成時の処理
  void _achievementFunc(BuildContext context, MyAchievment myAchievment) async {
    if (myAchievment.achieved) {
      // 達成をキャンセルするとややこしいのでさせない
      return;
    }
    myAchievment.tapToday();
    int dayOrTime = myAchievment.currentDayOrTime;

    await _myGoalFirebase.updateAchieveCurrentDayOrTime(myAchievment.goalId,
        myAchievment.unitType, dayOrTime, myAchievment.achievedDayOrTime);

    // スナックバー表示
    String xDayMessage = '';
    int showDayOrTime = 0;
    // タップしてたら1減らす
    if (myAchievment.achieved) {
      showDayOrTime = myAchievment.currentDayOrTime - 1;
    } else {
      showDayOrTime = myAchievment.currentDayOrTime;
    }
    // タイプによってメッセージを変更
    if (myAchievment.unitType == 0) {
      xDayMessage = '$showDayOrTime日目';
    } else {
      xDayMessage = '$showDayOrTime回目';
    }
    xDayMessage += 'おめでとう';
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
                  Icons.emoji_people,
                  size: 40,
                ),
                TextWidget.snackBarText(xDayMessage),
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
                    _shareSns(xDayMessage);
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
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
