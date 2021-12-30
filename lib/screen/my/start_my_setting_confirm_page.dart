import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/firebase/my_goal_firebase.dart';
import 'package:yell_app/model/invite.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/screen/my/my_achievement_page.dart';
import 'package:yell_app/state/invite_provider.dart';
import 'package:yell_app/state/my_achievment_provider.dart';
import 'package:yell_app/state/start_my_setting_provider.dart';

MyGoalFirebase _myGoalFirebase = MyGoalFirebase();

class StartMySettingConfirmPage extends ConsumerWidget {
  const StartMySettingConfirmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startMySetting = ref.watch(startMySettingProvider);
    final myAchievment = ref.watch(myAchievmentProvider);
    final invite = ref.watch(inviteProvider);
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
                TextWidget.headLineText5('続けること'),
                Container(
                  margin: const EdgeInsets.only(
                    left: 30,
                  ),
                  child: TextField(
                    enabled: false,
                    controller: _textEditingController,
                    style: const TextStyle(),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                TextWidget.headLineText5('日にち or　回数'),
                Text(startMySetting.selectedUnit.toString()),
              ],
            ),
            Column(
              children: [
                TextWidget.headLineText5('あなたのなまえ'),
                Text(startMySetting.myName),
              ],
            ),
            Column(
              children: [
                TextWidget.headLineText5('はじめますか？'),
                TextWidget.headLineText5('途中で変更することはできません。'),
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
                    child: TextWidget.headLineText5('戻る'),
                  ),
                  TextButton(
                    onPressed: () {
                      myAchievment.refresh = true;
                      sendMyGoalData(startMySetting, myAchievment, invite);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyAchievementPage(),
                        ),
                      );
                    },
                    child: TextWidget.headLineText5('はじめる'),
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
  Future<void> sendMyGoalData(StartMySetting startMySetting,
      MyAchievment myAchievment, Invite invite) async {
    MyGoalModel model = MyGoalModel(
      goalTitle: startMySetting.goalTitle,
      myName: startMySetting.myName,
    );

    // データ送信
    Map<String, Object?> resultMap =
        await _myGoalFirebase.insertMyGoalData(model);
    if (resultMap['myGoal'] != null) {
      myAchievment.setInitialData(resultMap['myGoal'] as MyGoalModel, [], []);
    }
    if (resultMap['invite'] != null) {
      invite.setInitialData(resultMap['invite'] as InviteModel);
    }
  }

  // Firebaseに自分のデータを送信のテスト
  void sendMySettingDataTest(
      StartMySetting startMySetting, MyAchievment myAchievment) {
    DateTime now = DateTime.now();
    MyGoalModel model = MyGoalModel(
      goalTitle: startMySetting.goalTitle,
      createdAt: now,
      updatedAt: now,
    );

    // firebaseに送信したとする
    model.id = 'goalId1';

    // firebaseから取得したとする
    myAchievment.goalTitle = model.goalTitle;

    // memberIdリストを取得したとする
    myAchievment.memberIdList = ['Amember-1', 'Bmember-2', 'Cmember-3'];
  }
}
