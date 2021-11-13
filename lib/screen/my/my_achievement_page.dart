import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/dialog/dialog_widget.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/firebase/my_goal_firebase.dart';
import 'package:yell_app/model/member.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/state/my_achievment_provider.dart';
import 'package:yell_app/utility/dialog_utility.dart';

MyGoalFirebase _myGoalFirebase = MyGoalFirebase();

class MyAchievementPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAchievment = ref.watch(myAchievmentProvider);
    TextEditingController _textEditingController =
        TextEditingController(text: myAchievment.goalTitle);
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: TextWidget.mainText3('トップに戻る'),
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
              child: _futureBody(context, myAchievment))),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).canvasColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: '設定',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          // フッターを押して画面切り替え
          // bottomNavigationData.setCurrentIndex(index);
        },
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
            TextWidget.mainText3('まだメンバーがいません'),
            TextButton(
              onPressed: () {
                // メンバー追加画面に遷移
              },
              child: TextWidget.mainText3('メンバーを追加する'),
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
          child: Text(myAchievment.selectedMemberId),
        ),
      ],
    );
  }

  // メンバーアイコン
  List<Widget> _memberIconWidget(MyAchievment myAchievment) {
    List<Widget> row = <Widget>[];
    List<MemberModel> members = [];
    // テスト用のデータ作成
    for (String id in myAchievment.memberIdList) {
      MemberModel tempMember = MemberModel(
        id: id,
        name: id + '-name',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
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
            child: Text(member.name.substring(0, 1)),
          ),
        ),
      );
      row.add(tempWidget);
    }
    return row;
  }

  // 非同期処理でbodyWidgetを作る
  Widget _futureBody(BuildContext context, MyAchievment myAchievment) {
    if (!myAchievment.refresh) {
      return _body(context, myAchievment);
    } else {
      myAchievment.refresh = false;
      return FutureBuilder(
        // future属性で非同期処理を書く
        future: _myGoalFirebase.fetchMyGoalData(),
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
            MyGoalModel? _data = snapshot.data;
            // 既に登録ずみ
            if (_data != null && !_data.isDeleted) {
              // TODO:テスト用にメンバーidをセット
              List<String> _testMemberId = ['member-1', 'Bember-'];
              myAchievment.setInitialData(_data.id, _data.goalTitle,
                  _data.myName, _data.howManyTimes, _testMemberId);
              return _body(context, myAchievment);
            } else {
              // データが消えている場合はエラー
              // 初期画面に戻る
              return Container();
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
            child: TextWidget.mainText1(myAchievment.goalTitle),
          ),
          Column(
            children: [
              // 達成ボタン
              InkWell(
                onTap: () async {
                  if (myAchievment.isTapedToday) {
                    String? result =
                        await DialogWidget().achieveCancelDialog(context);

                    if (!(result != null && result == 'YES')) {
                      // 何もしない
                      return;
                    }
                  }
                  myAchievment.tapToday();
                  _myGoalFirebase.updateAchieveCurrentDay(
                      myAchievment.goalId, myAchievment.currentDay);
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
                    TextWidget.mainText2('継続'),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      child: TextWidget.mainText1('${myAchievment.currentDay}'),
                    ),
                    TextWidget.mainText2('日目'),
                  ],
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              TextWidget.mainText2('応援してくれるメンバー'),
              _memberWidget(context, myAchievment),
            ],
          ),
          Column(),
        ],
      ),
    );
  }
}
