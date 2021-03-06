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
                    TextWidget.headLineText4('???????????????'),
                    TextField(
                      controller: _textEditingController,
                      maxLength: 10,
                      style: TextStyle(),
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: '10???????????????',
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
                    CommonWidget.lightbulbIcon(), '??????????????????????????????????????????????????????????????????'),
                // ???????????????
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
                        child: TextWidget.headLineText5('??????'),
                      ),
                      TextButton(
                        onPressed: () async {
                          // ????????????????????????
                          // ????????????????????????????????????
                          Map<String, Object?> result =
                              // MyGoalModel? myGoalModel =
                              await _searchInviteByCode(otherAchievment);
                          if (result.containsKey('errorText')) {
                            String errorText = result['errorText'] as String;
                            otherAchievment.resetData();
                            if (errorText == Const.INVALID_CODE) {
                              otherAchievment.setErrorText('?????????????????????????????????????????????');
                            } else if (errorText == Const.EXPIRED_CODE) {
                              otherAchievment.setErrorText('?????????????????????????????????');
                            } else if (errorText == Const.MYSELF_CODE) {
                              otherAchievment.setErrorText('??????????????????????????????????????????');
                            } else if (errorText == Const.REGISTED_CODE) {
                              otherAchievment.setErrorText('????????????????????????');
                            } else {
                              otherAchievment.setErrorText('?????????????????????????????????????????????');
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
                        child: TextWidget.headLineText5('??????'),
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
    // ???????????????????????????
    if (inviteModel == null) {
      result['errorText'] = Const.INVALID_CODE;
      return result;
    }
    // ??????????????????
    if (now.isAfter(inviteModel.expiredAt as DateTime) ||
        inviteModel.isDeleted) {
      result['errorText'] = Const.EXPIRED_CODE;
      return result;
    }

    // ?????????????????????????????????????????????
    if (inviteModel.ownerUserId == userFirebase.getMyUserId()) {
      result['errorText'] = Const.MYSELF_CODE;
      return result;
    }

    List<MemberModel> members = await memberFirebase.fetchMemberDatas();
    MemberModel existData = members.firstWhere(
        (member) => member.ownerGoalId == inviteModel.goalId,
        orElse: () => MemberModel());
    // ??????????????????????????????
    if (existData.ownerGoalId.isNotEmpty) {
      result['errorText'] = Const.REGISTED_CODE;
      return result;
    }
    // ??????????????????
    // ???????????????????????????
    String ownerUserId = inviteModel.ownerUserId;
    MyGoalModel? ownerGoalModel =
        await myGoalFirebase.fetchGoalData(userId: ownerUserId);
    if (ownerGoalModel == null) {
      // ????????????????????????id?????????
      result['errorText'] = Const.UNEXPECTED_CODE;
      return result;
    }
    // ?????????
    _otherAchievment.goalTitle = ownerGoalModel.goalTitle;
    _otherAchievment.goalId = ownerGoalModel.id;
    _otherAchievment.ownerName = ownerGoalModel.myName;
    result['ownerGoalModel'] = ownerGoalModel;
    return result;
  }
}
