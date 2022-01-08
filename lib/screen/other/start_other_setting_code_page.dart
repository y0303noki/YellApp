import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/const.dart';
import 'package:yell_app/firebase/invite_firebase.dart';
import 'package:yell_app/firebase/member_firebase.dart';
import 'package:yell_app/firebase/my_goal_firebase.dart';
import 'package:yell_app/firebase/user_firebase.dart';
import 'package:yell_app/model/invite.dart';
import 'package:yell_app/model/member.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/screen/other/start_other_setting_confirm_page.dart';
import 'package:yell_app/screen/other/start_other_setting_yourinfo_page.dart';
import 'package:yell_app/state/other_achievment_provider.dart';

InviteFirebase inviteFirebase = InviteFirebase();
MyGoalFirebase myGoalFirebase = MyGoalFirebase();
final MemberFirebase memberFirebase = MemberFirebase();
UserFirebase userFirebase = UserFirebase();

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
        automaticallyImplyLeading: false,
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
                    otherAchievment.errorText.isEmpty
                        ? Container()
                        : Container(
                            child: Text(
                              otherAchievment.errorText,
                              style: TextStyle(color: Colors.red),
                            ),
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
                          otherAchievment.resetData();
                          Navigator.pop(context);
                        },
                        child: TextWidget.headLineText5('戻る'),
                      ),
                      TextButton(
                        onPressed: () async {
                          // 招待コードを検索
                          // 正しいコードなら次に遷移
                          Map<String, Object?> result =
                              // MyGoalModel? myGoalModel =
                              await _searchInviteByCode(otherAchievment);
                          if (result.containsKey('errorText')) {
                            String errorText = result['errorText'] as String;
                            otherAchievment.resetData();
                            if (errorText == Const.INVALID_CODE) {
                              otherAchievment.setErrorText('正しいコードを入力してください');
                            } else if (errorText == Const.EXPIRED_CODE) {
                              otherAchievment.setErrorText('有効期限が切れています');
                            } else if (errorText == Const.MYSELF_CODE) {
                              otherAchievment.setErrorText('自分自身のコードは使えません');
                            } else {
                              otherAchievment.setErrorText('予期しないエラーが発生しました');
                            }

                            return;
                          }

                          MyGoalModel myGoalModel =
                              result['ownerGoalModel'] as MyGoalModel;
                          otherAchievment.setInitialData(myGoalModel);

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

  Future<Map<String, Object?>> _searchInviteByCode(
      OtherAchievment _otherAchievment) async {
    DateTime now = DateTime.now();
    Map<String, Object?> result = {};
    InviteModel? inviteModel =
        await inviteFirebase.fetchInviteByCode(_otherAchievment.code);
    // コードが存在しない
    if (inviteModel == null) {
      result['errorText'] = Const.INVALID_CODE;
      return result;
    }
    // 有効期限切れ
    if (now.isAfter(inviteModel.expiredAt as DateTime) ||
        inviteModel.isDeleted) {
      result['errorText'] = Const.EXPIRED_CODE;
      return result;
    }

    // 自分自身の招待コードは利用不可
    if (inviteModel.ownerUserId == userFirebase.getMyUserId()) {
      result['errorText'] = Const.MYSELF_CODE;
      return result;
    }

    List<MemberModel> members = await memberFirebase.fetchMemberDatas();
    MemberModel existData = members.firstWhere(
        (member) => member.ownerGoalId == inviteModel.goalId,
        orElse: () => MemberModel());
    // 既に同じ目標を登録中
    if (existData.ownerGoalId.isNotEmpty) {
      result['errorText'] = Const.REGISTED_CODE;
      return result;
    }
    // 有効なコード
    // 持ち主の名前を取得
    String ownerUserId = inviteModel.ownerUserId;
    MyGoalModel? ownerGoalModel =
        await myGoalFirebase.fetchGoalData(userId: ownerUserId);
    if (ownerGoalModel == null) {
      // 持ち主のユーザーidが不正
      result['errorText'] = Const.UNEXPECTED_CODE;
      return result;
    }
    // セット
    _otherAchievment.goalTitle = ownerGoalModel.goalTitle;
    _otherAchievment.goalId = ownerGoalModel.id;
    _otherAchievment.ownerName = ownerGoalModel.myName;
    result['ownerGoalModel'] = ownerGoalModel;
    return result;
  }
}
