import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/firebase/member_firebase.dart';
import 'package:yell_app/firebase/my_goal_firebase.dart';
import 'package:yell_app/model/member.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/model/yell_message.dart';
import 'package:yell_app/screen/other/other_yell_main_page.dart';
import 'package:yell_app/screen/other/start_other_setting_code_page.dart';
import 'package:yell_app/state/other_achievment_provider.dart';
import 'package:yell_app/state/user_auth_provider.dart';
import 'package:yell_app/utility/utility.dart';

MyGoalFirebase myGoalFirebase = MyGoalFirebase();
MemberFirebase memberFirebase = MemberFirebase();

class StartOtherYellListPage extends ConsumerWidget {
  const StartOtherYellListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherAchievment = ref.watch(otherAchievmentProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
        elevation: 5,
        leading: IconButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: _futureBody(context, otherAchievment),
    );
  }

  Widget _futureBody(BuildContext context, OtherAchievment otherAchievment) {
    return FutureBuilder(
      // future属性で非同期処理を書く
      future: myGoalFirebase.fetchRegistedOtherGoals(),
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
          Map<String, Object?>? _data = snapshot.data;
          if (_data == null) {
            // データがない、おかしい
            return const Center(
              child: Text('エラーがおきました'),
            );
          }
          List<MyGoalModel> goalDatas = _data.containsKey('goals')
              ? _data['goals'] as List<MyGoalModel>
              : [];

          List<MemberModel> memberDatas = _data.containsKey('members')
              ? _data['members'] as List<MemberModel>
              : [];

          otherAchievment.myGoalList = goalDatas;
          otherAchievment.memberList = memberDatas;

          List<MyGoalModel> _goals = goalDatas;
          if (_goals.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const StartOtherSettingCodePage(),
                        ),
                      );
                    },
                    child: TextWidget.headLineText6('招待コードを入力する'),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _goals.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _yellItem(context, _goals[index], otherAchievment);
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 100,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const StartOtherSettingCodePage(),
                        ),
                      );
                    },
                    child: TextWidget.headLineText5('招待コードを入力する'),
                  ),
                ),
              ],
            );
          }
        }
        return Container();
      },
    );
  }

  Widget _yellItem(BuildContext context, MyGoalModel myGoalModel,
      OtherAchievment _otherAchievment) {
    String _iconName = '';
    if (myGoalModel.myName.isNotEmpty) {
      _iconName = Utility.substring1or2(myGoalModel.myName);
    }
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 3.0, color: Colors.grey),
        ),
      ),
      child: ListTile(
        title: Text(
          myGoalModel.goalTitle,
          style: const TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        leading: ButtonWidget.iconMainMiniWidget(_iconName),
        trailing: TextWidget.subTitleText3(
            '${Utility.toDateFormatted(myGoalModel.createdAt!)} ~'),
        onTap: () async {
          // 選択したらデータをセット
          _otherAchievment.resetData();

          // 自分の名前を取得
          final UserAuth _userAuth = UserAuth();
          final _userId = _userAuth.user != null ? _userAuth.user!.uid : '';
          MemberModel myMemberModel = _otherAchievment.memberList
              .firstWhere((member) => member.memberUserId == _userId);

          // リセット後にデータを付け直す
          _otherAchievment.setInitialData(myGoalModel);
          _otherAchievment.otherName = myMemberModel.memberName;

          // メッセージを取得
          await selectYellMessage(_otherAchievment);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OtherYellMainPage(),
            ),
          );
        },
      ),
    );
  }
}

// 自分が送信した応援メッセージを取得してセット
Future<void> selectYellMessage(OtherAchievment _otherAchievment) async {
  List<YellMessage> messages =
      await yellMessageFirebase.fetchMyGoalYellMessage(_otherAchievment.goalId);

  int searchDayOrTime = 0;
  if (_otherAchievment.isAchieved) {
    searchDayOrTime = _otherAchievment.continuationCount - 1;
  } else {
    searchDayOrTime = _otherAchievment.continuationCount;
  }

  YellMessage? myMessage;
  for (YellMessage yellMessage in messages) {
    // 既に応援メッセージを送信ずみ
    if (yellMessage.dayOrTimes == searchDayOrTime) {
      myMessage = yellMessage;
      print(myMessage.message);
      _otherAchievment.yellMessage = myMessage.message;
      break;
    }
  }
  if (myMessage == null) {
    print('NO MEssage');
    _otherAchievment.yellMessage = '';
  }
  return;
}
