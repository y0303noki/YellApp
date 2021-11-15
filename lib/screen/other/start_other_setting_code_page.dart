import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/firebase/invite_firebase.dart';
import 'package:yell_app/firebase/my_goal_firebase.dart';
import 'package:yell_app/model/invite.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/screen/other/start_other_setting_confirm_page.dart';
import 'package:yell_app/screen/other/start_other_setting_yourinfo_page.dart';
import 'package:yell_app/state/other_achievment_provider.dart';
import 'package:yell_app/state/other_setting_code_provider.dart';
import 'package:yell_app/state/start_my_setting_provider.dart';

InviteFirebase inviteFirebase = InviteFirebase();
MyGoalFirebase myGoalFirebase = MyGoalFirebase();
final inviteCodeProvider = StateProvider((ref) => '');

class StartOtherSettingCodePage extends ConsumerWidget {
  const StartOtherSettingCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherSettingCode = ref.watch(otherSettingCodeProvider);
    final otherAchievment = ref.watch(otherAchievmentProvider);
    String inviteCode = ref.watch(inviteCodeProvider);
    TextEditingController _textEditingController =
        TextEditingController(text: inviteCode);

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
              children: [
                TextWidget.headLineText4('招待コード'),
                TextField(
                  controller: _textEditingController,
                  maxLength: 10,
                  style: TextStyle(),
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: '10桁のコード',
                  ),
                  onSubmitted: (text) {
                    inviteCode = text;
                  },
                ),
              ],
            ),
            // TODO
            Container(
              child: Text(
                'イラストとか説明が入る予定',
              ),
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
                    onPressed: () async {
                      // 招待コードを検索
                      // 正しいコードなら次に遷移
                      await _searchInviteByCode(inviteCode, otherAchievment);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StartOtherSettingConfirmPage(),
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
    );
  }

  _searchInviteByCode(String _code, OtherAchievment _otherAchievment) async {
    DateTime now = DateTime.now();
    InviteModel? inviteModel = await inviteFirebase.fetchInviteByCode(_code);
    // コードが存在しない
    if (inviteModel == null) {
      return;
    }
    // 有効期限切れ
    if (now.isAfter(inviteModel.expiredAt as DateTime) ||
        inviteModel.isDeleted) {
      return;
    }
    // 有効なコード
    // 持ち主の名前を取得
    String ownerUserId = inviteModel.ownerUserId;
    MyGoalModel? ownerGoalModel =
        await myGoalFirebase.fetchGoalData(userId: ownerUserId);
    if (ownerGoalModel == null) {
      // 持ち主のユーザーidが不正
      return;
    }
    // セット
    _otherAchievment.goalTitle = ownerGoalModel.goalTitle;
  }
}
