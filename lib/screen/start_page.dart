import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/firebase/my_goal_firebase.dart';
import 'package:yell_app/model/member.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/model/yell_message.dart';
import 'package:yell_app/screen/my/my_achievement_page.dart';
import 'package:yell_app/screen/my/start_my_setting_page.dart';
import 'package:yell_app/screen/other/start_other_setting_code_page.dart';
import 'package:yell_app/screen/other/start_other_yell_list_page.dart';
import 'package:yell_app/state/counter_provider.dart';
import 'package:yell_app/state/invite_provider.dart';
import 'package:yell_app/state/my_achievment_provider.dart';

MyGoalFirebase _myGoalFirebase = MyGoalFirebase();

class StartPage extends ConsumerWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAchievment = ref.watch(myAchievmentProvider);
    final invite = ref.watch(inviteProvider);

    return MaterialApp(
      home: Scaffold(
        body: bodyWidget(context, myAchievment, invite),
      ),
    );
  }

  Widget bodyWidget(
      BuildContext context, MyAchievment myAchievment, Invite invite) {
    final deviceSize = MediaQuery.of(context).size;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _myGoalButton(context, myAchievment, invite),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StartOtherYellListPage(),
                        ),
                      ).then(
                        (value) {
                          myAchievment.refreshNotifyListeners();
                        },
                      );
                    },
                    child: ButtonWidget.startMainButton(
                      deviceSize.width,
                      '応援する',
                      Icons.thumb_up,
                      CommonWidget.otherDefaultColor()!,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  // 自分の目標が既に設定ずみかチェック
  Widget _myGoalButton(
      BuildContext context, MyAchievment myAchievment, Invite invite) {
    final deviceSize = MediaQuery.of(context).size;
    return FutureBuilder(
      // future属性で非同期処理を書く
      future: _myGoalFirebase.fetchGoalAndMemberData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // 通信中
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 通信中
          return Center(
            child: ButtonWidget.startMainWaitingButton(deviceSize.width),
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
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StartMySettingPage(),
                  ),
                ).then(
                  (value) {
                    myAchievment.refreshNotifyListeners();
                  },
                );
              },
              child: Column(
                children: [
                  ButtonWidget.startMainButton(
                    deviceSize.width,
                    '自分の記録を始める',
                    Icons.directions_run,
                    CommonWidget.myDefaultColor()!,
                  ),
                ],
              ),
            );
          }

          MyGoalModel? goalData =
              _data.containsKey('goal') ? _data['goal'] as MyGoalModel : null;
          List<MemberModel> memberDatas = _data.containsKey('members')
              ? _data['members'] as List<MemberModel>
              : [];

          List<YellMessage> messages = _data.containsKey('messages')
              ? _data['messages'] as List<YellMessage>
              : [];

          if (goalData == null || goalData.isDeleted) {
            // 登録済みのデータなし
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StartMySettingPage(),
                  ),
                ).then((value) {
                  myAchievment.refreshNotifyListeners();
                });
              },
              child: Column(
                children: [
                  ButtonWidget.startMainButton(
                    deviceSize.width,
                    '自分の記録を始める',
                    Icons.directions_run,
                    CommonWidget.myDefaultColor()!,
                  ),
                ],
              ),
            );
          } else {
            // 登録ずみデータあり
            return InkWell(
              onTap: () {
                goalData.memberIds =
                    memberDatas.map((e) => e.memberUserId).toList();

                myAchievment.setInitialData(goalData, memberDatas, messages);
                invite.id = goalData.inviteId;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyAchievementPage(),
                  ),
                ).then((value) {
                  myAchievment.refreshNotifyListeners();
                });
              },
              child: Column(
                children: [
                  ButtonWidget.startMainButton(
                    deviceSize.width,
                    '自分の記録を始める',
                    Icons.directions_run,
                    CommonWidget.myDefaultColor()!,
                  ),
                ],
              ),
            );
          }
        } else {
          return const Center(
            child: Text('エラーがおきました'),
          );
        }
      },
    );
  }
}
