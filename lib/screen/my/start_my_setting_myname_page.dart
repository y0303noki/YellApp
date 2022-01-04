import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/firebase/my_goal_firebase.dart';
import 'package:yell_app/model/invite.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/screen/my/my_achievement_page.dart';
import 'package:yell_app/screen/my/start_my_setting_confirm_page.dart';
import 'package:yell_app/state/invite_provider.dart';
import 'package:yell_app/state/my_achievment_provider.dart';
import 'package:yell_app/state/start_my_setting_provider.dart';

final errorTextProvider = StateProvider((ref) => '');
MyGoalFirebase _myGoalFirebase = MyGoalFirebase();

class StartMySettinMynamePage extends ConsumerWidget {
  const StartMySettinMynamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAchievment = ref.watch(myAchievmentProvider);
    final invite = ref.watch(inviteProvider);

    final deviceSize = MediaQuery.of(context).size;
    String errorText = ref.watch(errorTextProvider);
    final startMySetting = ref.watch(startMySettingProvider);
    TextEditingController _textEditingController =
        TextEditingController(text: startMySetting.myName);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
        actions: const [],
      ),
      body: Container(
        margin: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: deviceSize.height - 100,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    TextWidget.headLineText5('あなたのニックネーム'),
                    TextField(
                      controller: _textEditingController,
                      maxLength: 10,
                      style: const TextStyle(),
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'ニックネームを入力',
                        errorText: errorText.isEmpty ? null : errorText,
                      ),
                      onSubmitted: (text) {
                        startMySetting.myName = text;
                      },
                    ),
                  ],
                ),
                // 説明
                Column(
                  children: [
                    CommonWidget.descriptionWidget(CommonWidget.lightbulbIcon(),
                        '応援してくれる人たちに表示されます。\n頭文字2文字がアイコンになります。'),
                    Image.asset(
                      'images/yell.png',
                      width: 200,
                    ),
                  ],
                ),

                // 戻る、次へ
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
                          if (_textEditingController.text.isEmpty) {
                            // エラーを出す
                            errorText = '入力してください。';
                            return;
                          } else {
                            errorText = '';
                          }
                          startMySetting.myName = _textEditingController.text;

                          myAchievment.refresh = true;
                          sendMyGoalData(startMySetting, myAchievment, invite);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyAchievementPage(),
                            ),
                          );
                        },
                        child: TextWidget.headLineText5('次へ'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
}
