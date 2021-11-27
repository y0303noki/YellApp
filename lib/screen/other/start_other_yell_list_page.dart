import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/firebase/member_firebase.dart';
import 'package:yell_app/firebase/my_goal_firebase.dart';
import 'package:yell_app/model/member.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/model/yell_message.dart';
import 'package:yell_app/screen/other/other_yell_main_page.dart';
import 'package:yell_app/screen/other/start_other_setting_code_page.dart';
import 'package:yell_app/screen/other/start_other_setting_confirm_page.dart';
import 'package:yell_app/screen/other/start_other_setting_yourinfo_page.dart';
import 'package:yell_app/state/other_achievment_provider.dart';
import 'package:yell_app/state/other_setting_code_provider.dart';

MyGoalFirebase myGoalFirebase = MyGoalFirebase();

class StartOtherYellListPage extends ConsumerWidget {
  const StartOtherYellListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherAchievment = ref.watch(otherAchievmentProvider);
    TextEditingController _textEditingController =
        TextEditingController(text: '');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
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
          List<MyGoalModel> _goals = snapshot.data;
          if (_goals.isEmpty) {
            return Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StartOtherSettingCodePage(),
                    ),
                  );
                },
                child: TextWidget.headLineText6('招待コードを入力する'),
              ),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _goals.length, // この行を追加
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
                          builder: (context) => StartOtherSettingCodePage(),
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
      _iconName = myGoalModel.myName.substring(0, 1);
    }
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey),
        ),
      ),
      child: ListTile(
        title: Text(
          myGoalModel.goalTitle,
          style: const TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        leading: ButtonWidget.iconMainMiniWidget(_iconName),
        onTap: () async {
          _otherAchievment.goalTitle = myGoalModel.goalTitle;
          _otherAchievment.goalId = myGoalModel.id;
          _otherAchievment.ownerName = myGoalModel.myName;
          _otherAchievment.unitType = myGoalModel.unitType;
          _otherAchievment.updateCurrentDayOrTime =
              myGoalModel.updatedCurrentDayAt;
          _otherAchievment.achievedDayOrTime = myGoalModel.achievedDayOrTime;
          _otherAchievment.ownerAchievedment = myGoalModel.achievedMyComment;
          if (_otherAchievment.unitType == 0) {
            _otherAchievment.currentDay = myGoalModel.currentDay;
          } else {
            _otherAchievment.currentTime = myGoalModel.currentTimes;
          }
          // メッセージを取得
          await selectYellMessage(_otherAchievment);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtherYellMainPage(),
            ),
          );
        }, // タップ
        onLongPress: () {
          print("onLongTap called.");
        }, // 長押し
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
    searchDayOrTime = _otherAchievment.currentDayOrTime - 1;
  } else {
    searchDayOrTime = _otherAchievment.currentDayOrTime;
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
