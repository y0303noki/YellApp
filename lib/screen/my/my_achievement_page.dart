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
import 'package:yell_app/state/invite_provider.dart';
import 'package:yell_app/state/my_achievment_provider.dart';
import 'package:bubble/bubble.dart';

MyGoalFirebase _myGoalFirebase = MyGoalFirebase();

class MyAchievementPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAchievment = ref.watch(myAchievmentProvider);
    final invite = ref.watch(inviteProvider);

    TextEditingController _textEditingController =
        TextEditingController(text: myAchievment.goalTitle);
    final deviceSize = MediaQuery.of(context).size;

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
                    builder: (context) => InviteMainPage(),
                  ),
                );
              },
              child: TextWidget.headLineText6('メンバーを追加する'),
            ),
          ],
        ),
      );
    }

    // メンバーがいるとき
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 10,
          ),
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _memberIconWidget(myAchievment),
            ),
          ),
        ),
        // メンバーの応援メッセージ
        Row(
          children: [
            Expanded(
              child: Bubble(
                margin: const BubbleEdges.only(left: 10, right: 10),
                padding: const BubbleEdges.only(top: 20, bottom: 20),
                nip: BubbleNip.leftTop,
                color: CommonWidget.otherDefaultColor(),
                child: _selectYellMessage(myAchievment),
              ),
            ),
          ],
        ),

        // メンバー追加ボタン
        TextButton(
          onPressed: () {
            // 招待ページに遷移
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InviteMainPage(),
              ),
            );
          },
          child: TextWidget.subTitleText1('メンバーを追加する'),
        ),
      ],
    );
  }

  // 応援メッセージ表示
  Widget _selectYellMessage(MyAchievment myAchievment) {
    if (myAchievment.selectedMemberId == '' ||
        myAchievment.yellMessages.isEmpty) {
      return const Text('メッセージなし', textAlign: TextAlign.left);
    }
    YellMessage? selectedMessage = myAchievment.yellMessages.firstWhere(
        (message) => message.memberId == myAchievment.selectedMemberId,
        orElse: () => YellMessage());
    if (selectedMessage.message.isEmpty) {
      // メッセージなし
      return const Text(
        'メッセージがここに表示されます',
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.grey,
        ),
      );
    } else {
      // メッセージあり
      return Text(
        selectedMessage.message,
        textAlign: TextAlign.left,
      );
    }
  }

  // メンバーアイコン
  List<Widget> _memberIconWidget(MyAchievment myAchievment) {
    List<Widget> row = <Widget>[];
    // 一番左のウィジット
    Widget memberFirstWidget = Container(
      margin: const EdgeInsets.only(
        left: 5,
        right: 5,
      ),
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: 5,
        right: 5,
      ),
      color: Colors.white,
      child: const Text('選択'),
    );

    row.add(memberFirstWidget);

    List<String> memberIdList = myAchievment.memberIdList;
    for (String memberId in memberIdList) {
      MemberModel member = myAchievment.yellMembers
          .firstWhere((mem) => mem.memberUserId == memberId);
      Widget tempWidget = InkWell(
        onTap: () {
          myAchievment.selectMemberId(memberId);
        },
        child: Container(
          margin: const EdgeInsets.only(
            left: 5,
            right: 5,
          ),
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          width: 100,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: myAchievment.selectedMemberId == memberId
                ? Colors.grey[700]
                : null,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              member.memberName,
              overflow: TextOverflow.ellipsis,
              style: myAchievment.selectedMemberId == memberId
                  ? const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)
                  : null,
            ),
          ),
        ),
      );
      row.add(tempWidget);
    }
    return row;
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
            MyGoalModel goalData = _data['goal'] as MyGoalModel;
            List<MemberModel> memberDatas =
                _data['members'] as List<MemberModel>;
            // 応援メッセージ
            List<YellMessage> messages = _data['messages'] as List<YellMessage>;

            // 既に登録ずみ
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

  Widget _body(BuildContext context, MyAchievment myAchievment) {
    final deviceSize = MediaQuery.of(context).size;
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget.iconBigMainWidget('a'),
            ],
          ),
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
              // 達成ボタン
              InkWell(
                onTap: () async {
                  // スナックバー表示
                  String message = 'おつかれさまです！';
                  final snackBar = SnackBar(
                    content: Text(message),
                    duration: const Duration(seconds: 5),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  if (myAchievment.isTapedToday) {
                    // 達成をキャンセルするとややこしいのでさせない
                    return;
                  }
                  myAchievment.tapToday();
                  int dayOrTime = myAchievment.currentDayOrTime;

                  // 一言コメント
                  String achievedMyMessage =
                      await DialogWidget().achievedMyMessagelDialog(context);

                  await _myGoalFirebase.updateAchieveCurrentDayOrTime(
                      myAchievment.goalId,
                      myAchievment.unitType,
                      dayOrTime,
                      myAchievment.achievedDayOrTime,
                      achievedMyMessage);
                },
                child: myAchievment.isTapedToday
                    ? ButtonWidget.achievementedToday(deviceSize.width)
                    : ButtonWidget.yetAchievementToday(deviceSize.width),
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
                      padding: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      child: myAchievment.isTapedToday
                          ? TextWidget.headLineText4(
                              '${myAchievment.currentDayOrTime - 1}')
                          : TextWidget.headLineText4(
                              '${myAchievment.currentDayOrTime}'),
                    ),
                    TextWidget.headLineText5(
                        myAchievment.unitType == 0 ? '日目' : '回目'),
                  ],
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              TextWidget.headLineText5('応援中の仲間'),
              _memberWidget(context, myAchievment),
            ],
          ),
          Column(),
        ],
      ),
    );
  }

  // モーダルシートを表示
}
