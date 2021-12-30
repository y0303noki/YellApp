import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/firebase/member_firebase.dart';
import 'package:yell_app/model/member.dart';
import 'package:yell_app/screen/other/other_yell_main_page.dart';
import 'package:yell_app/state/other_achievment_provider.dart';

MemberFirebase memberFirebase = MemberFirebase();

class StartOtherSettingYourinfoPage extends ConsumerWidget {
  const StartOtherSettingYourinfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceSize = MediaQuery.of(context).size;
    final otherAchievment = ref.watch(otherAchievmentProvider);
    TextEditingController _textEditingController =
        TextEditingController(text: otherAchievment.otherName);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
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
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget.headLineText6('あなたのニックネームを教えてください'),
                    TextField(
                      controller: _textEditingController,
                      maxLength: 10,
                      style: TextStyle(),
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: '入力してください・・・',
                        errorText: otherAchievment.errorText.isEmpty
                            ? null
                            : otherAchievment.errorText,
                      ),
                      onSubmitted: (text) {
                        otherAchievment.otherName = text;
                      },
                      onChanged: (text) {
                        otherAchievment.otherName = text;
                      },
                    ),
                  ],
                ),
                CommonWidget.descriptionWidget(CommonWidget.lightbulbIcon(),
                    '${otherAchievment.ownerName}さんに表示されます。'),

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
                        onPressed: () async {
                          // ニックネームを反映
                          if (_textEditingController.text.isEmpty) {
                            // エラーを出す
                            otherAchievment.setErrorText('入力してください。');
                            return;
                          } else {
                            otherAchievment.setErrorText('');
                          }
                          // このタイミングでownerのデータにユーザーidを紐づける
                          MemberModel _memberModel = MemberModel();
                          _memberModel.memberName = otherAchievment.otherName;
                          _memberModel.ownerGoalId = otherAchievment.goalId;
                          addMemberData(_memberModel);
                          otherAchievment.otherName = _memberModel.memberName;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OtherYellMainPage(),
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

  // ownerのgoalに自分のデータと名前を紐づける
  addMemberData(MemberModel memberModel) async {
    await memberFirebase.insertMemberData(memberModel);
  }
}
