import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/firebase/my_goal_firebase.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/screen/my/my_achievement_page.dart';
import 'package:yell_app/state/my_achievment_provider.dart';
import 'package:yell_app/state/start_my_setting_provider.dart';

MyGoalFirebase _myGoalFirebase = MyGoalFirebase();

class StartMySettingConfirmPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startMySetting = ref.watch(startMySettingProvider);
    final myAchievment = ref.watch(myAchievmentProvider);
    TextEditingController _textEditingController =
        TextEditingController(text: startMySetting.goalTitle);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget.mainText2('続けること'),
                Container(
                  margin: const EdgeInsets.only(
                    left: 30,
                  ),
                  child: TextField(
                    enabled: false,
                    controller: _textEditingController,
                    style: TextStyle(),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                TextWidget.mainText2('1週間に'),
                Container(
                  child: Text(startMySetting.selectedHowManyTime.toString()),
                ),
              ],
            ),
            Column(
              children: [
                TextWidget.mainText2('あなたのなまえ'),
                Container(
                  child: Text(startMySetting.myName),
                ),
              ],
            ),
            Column(
              children: [
                TextWidget.mainText2('はじめますか？'),
                TextWidget.mainText2('途中で変更することはできません。'),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 50,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: TextWidget.mainText2('戻る'),
                  ),
                  TextButton(
                    onPressed: () {
                      sendMyGoalData(startMySetting, myAchievment);
                      // sendMySettingDataTest(startMySetting, myAchievment);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyAchievementPage(),
                        ),
                      );
                    },
                    child: TextWidget.mainText2('はじめる'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 何日
  List<Widget> selectedWeekDayWidget(StartMySetting startMySetting) {
    List<Widget> row = <Widget>[];
    List<String> weekDays = ['1', '2', '3', '4', '5', '6', '7'];
    for (int num in startMySetting.selectedWeekDay) {
      Widget tempWidget = InkWell(
        onTap: () {
          // startMySetting.selectWeekDay(num);
        },
        child: Container(
          margin: const EdgeInsets.only(
            left: 1,
            right: 1,
          ),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(weekDays[num]),
          ),
        ),
      );
      row.add(tempWidget);
    }
    return row;
  }

  // firestoreに送信
  Future<void> sendMyGoalData(
      StartMySetting startMySetting, MyAchievment myAchievment) async {
    MyGoalModel model = MyGoalModel(
      goalTitle: startMySetting.goalTitle,
      myName: startMySetting.myName,
      howManyTimes: startMySetting.selectedHowManyTime,
    );

    // データ送信
    String _docId = await _myGoalFirebase.insertMyGoalData(model);

    // 達成画面にデータを渡す
    myAchievment.setInitialData(_docId, startMySetting.goalTitle,
        startMySetting.myName, startMySetting.selectedHowManyTime, [], null);
  }

  // Firebaseに自分のデータを送信のテスト
  void sendMySettingDataTest(
      StartMySetting startMySetting, MyAchievment myAchievment) {
    DateTime now = DateTime.now();
    MyGoalModel model = MyGoalModel(
      goalTitle: startMySetting.goalTitle,
      howManyTimes: startMySetting.selectedHowManyTime,
      createdAt: now,
      updatedAt: now,
    );

    // firebaseに送信したとする
    model.id = 'goalId1';

    // firebaseから取得したとする
    myAchievment.goalTitle = model.goalTitle;
    myAchievment.selectedHowManyTime = model.howManyTimes;

    // memberIdリストを取得したとする
    myAchievment.memberIdList = ['Amember-1', 'Bmember-2', 'Cmember-3'];
  }
}
