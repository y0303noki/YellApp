import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/components/dialog/dialog_widget.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/firebase/my_goal_firebase.dart';
import 'package:yell_app/model/member.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/model/yell_message.dart';
import 'package:yell_app/screen/my/invite_main_page.dart';
import 'package:yell_app/state/invite_provider.dart';
import 'package:yell_app/state/my_achievment_provider.dart';

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
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () async {
              await _myGoalFirebase.deleteMyGoalData(myAchievment.goalId);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: TextWidget.headLineText6('目標をやり直す'),
          ),
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: TextWidget.headLineText6('トップに戻る'),
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
    final deviceSize = MediaQuery.of(context).size;

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _memberIconWidget(myAchievment),
        ),
        Container(
          width: deviceSize.width * 0.8,
          height: 100,
          color: Colors.grey,
          child: _selectYellMessage(myAchievment),
        ),
      ],
    );
  }

  Widget _selectYellMessage(MyAchievment myAchievment) {
    if (myAchievment.selectedMemberId == '' ||
        myAchievment.yellMessages.isEmpty) {
      return Text('メッセージなし');
    }
    YellMessage? selectedMessage = myAchievment.yellMessages.firstWhere(
        (message) => message.memberId == myAchievment.selectedMemberId,
        orElse: () => YellMessage());
    if (selectedMessage.message.isEmpty) {
      return Text('見つかりません');
    } else {
      return Text(selectedMessage.message);
    }
  }

  // メンバーアイコン
  List<Widget> _memberIconWidget(MyAchievment myAchievment) {
    List<Widget> row = <Widget>[];
    List<MemberModel> members = [];
    // テスト用のデータ作成
    for (String id in myAchievment.memberIdList) {
      MemberModel tempMember = MemberModel();
      tempMember.id = id;
      tempMember.memberName = id + '-name';
      tempMember.createdAt = DateTime.now();
      tempMember.updatedAt = DateTime.now();

      members.add(tempMember);
    }
    List<String> memberIdList = myAchievment.memberIdList;

    for (String memberId in memberIdList) {
      MemberModel member = members.firstWhere((mem) => mem.id == memberId);
      Widget tempWidget = InkWell(
        onTap: () {
          myAchievment.selectMemberId(memberId);
        },
        child: Container(
          margin: const EdgeInsets.only(
            left: 1,
            right: 1,
          ),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(
                color: myAchievment.selectedMemberId == memberId
                    ? Colors.red
                    : Colors.blue),
            borderRadius: BorderRadius.circular(60 / 2),
          ),
          child: Center(
            child: Text(member.memberName.substring(0, 1)),
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
              myAchievment.setInitialData(goalData, messages);
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
        left: 0,
        right: 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 1,
                  right: 1,
                ),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(120 / 2),
                ),
                child: Center(
                  child: Text('a'),
                ),
              ),
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
              TextWidget.headLineText5('応援してくれるメンバー'),
              _memberWidget(context, myAchievment),
            ],
          ),
          Column(),
        ],
      ),
    );
  }
}
