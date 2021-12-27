import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/firebase/invite_firebase.dart';
import 'package:yell_app/firebase/my_goal_firebase.dart';
import 'package:yell_app/model/invite.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/screen/other/start_other_setting_confirm_page.dart';
import 'package:yell_app/screen/other/start_other_setting_yourinfo_page.dart';
import 'package:yell_app/state/other_achievment_provider.dart';

InviteFirebase inviteFirebase = InviteFirebase();
MyGoalFirebase myGoalFirebase = MyGoalFirebase();

class StartOtherSettingCodePage extends ConsumerWidget {
  const StartOtherSettingCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceSize = MediaQuery.of(context).size;
    final otherAchievment = ref.watch(otherAchievmentProvider);
    TextEditingController _textEditingController =
        TextEditingController(text: otherAchievment.code);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(
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
                    TextWidget.headLineText4('招待コード'),
                    TextField(
                      controller: _textEditingController,
                      maxLength: 10,
                      style: TextStyle(),
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: '10桁のコード',
                      ),
                      onSubmitted: (text) {
                        otherAchievment.code = text;
                      },
                      onChanged: (text) {
                        otherAchievment.code = text;
                      },
                    ),
                  ],
                ),
                CommonWidget.descriptionWidget(
                    CommonWidget.lightbulbIcon(), 'おともだちから招待コードをもらってください。'),
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
                          // 招待コードを検索
                          // 正しいコードなら次に遷移
                          MyGoalModel? myGoalModel =
                              await _searchInviteByCode(otherAchievment);
                          if (myGoalModel != null) {
                            otherAchievment.setInitialData(myGoalModel);
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const StartOtherSettingConfirmPage(),
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

  Future<MyGoalModel?> _searchInviteByCode(
      OtherAchievment _otherAchievment) async {
    DateTime now = DateTime.now();
    InviteModel? inviteModel =
        await inviteFirebase.fetchInviteByCode(_otherAchievment.code);
    // コードが存在しない
    if (inviteModel == null) {
      print('コードが不正');
      return null;
    }
    // 有効期限切れ
    if (now.isAfter(inviteModel.expiredAt as DateTime) ||
        inviteModel.isDeleted) {
      print('有効期限切れ');
      return null;
    }
    // 有効なコード
    // 持ち主の名前を取得
    String ownerUserId = inviteModel.ownerUserId;
    MyGoalModel? ownerGoalModel =
        await myGoalFirebase.fetchGoalData(userId: ownerUserId);
    if (ownerGoalModel == null) {
      // 持ち主のユーザーidが不正
      print('持ち主がいない');
      return null;
    }
    // セット
    _otherAchievment.goalTitle = ownerGoalModel.goalTitle;
    _otherAchievment.goalId = ownerGoalModel.id;
    _otherAchievment.ownerName = ownerGoalModel.myName;
    return ownerGoalModel;
  }
}
