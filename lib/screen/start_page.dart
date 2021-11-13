import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/firebase/my_goal_firebase.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/screen/my/my_achievement_page.dart';
import 'package:yell_app/screen/my/start_my_setting_page.dart';
import 'package:yell_app/screen/other/start_other_setting_code_page.dart';
import 'package:yell_app/screen/other/start_other_yell_list_page.dart';
import 'package:yell_app/state/counter_provider.dart';
import 'package:yell_app/state/my_achievment_provider.dart';

MyGoalFirebase _myGoalFirebase = MyGoalFirebase();

class StartPage extends ConsumerWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAchievment = ref.watch(myAchievmentProvider);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: bodyWidget(context, myAchievment),
      ),
    );
  }

  Widget bodyWidget(BuildContext context, MyAchievment myAchievment) {
    final deviceSize = MediaQuery.of(context).size;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _myGoalButton(context, myAchievment),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StartOtherYellListPage(),
                        ),
                      );
                    },
                    child: ButtonWidget.startAtherButton(deviceSize.width),
                  ),
                  Text('招待コードが必要'),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  // 自分の目標が既に設定ずみかチェック
  Widget _myGoalButton(BuildContext context, MyAchievment myAchievment) {
    final deviceSize = MediaQuery.of(context).size;
    return FutureBuilder(
      // future属性で非同期処理を書く
      future: _myGoalFirebase.fetchMyGoalData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // 通信中
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 通信中
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
          MyGoalModel? _data = snapshot.data;
          // 既に登録ずみ
          if (_data != null && !_data.isDeleted) {
            return GestureDetector(
              onTap: () {
                // TODO:テスト用にメンバーidをセット
                List<String> _testMemberId = ['member-1', 'aember-2'];
                myAchievment.setInitialData(_data.id, _data.goalTitle,
                    _data.myName, _data.howManyTimes, _testMemberId);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyAchievementPage(),
                  ),
                );
              },
              child: Column(
                children: [
                  ButtonWidget.startMyButton(deviceSize.width),
                  Text('登録ずみ応援してもらう'),
                ],
              ),
            );
          } else {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StartMySettingPage(),
                  ),
                );
              },
              child: Column(
                children: [
                  ButtonWidget.startMyButton(deviceSize.width),
                  Text('友達に応援してもらう'),
                ],
              ),
            );
          }
        }
        // それ以外
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StartMySettingPage(),
              ),
            );
          },
          child: Column(
            children: [
              ButtonWidget.startMyButton(deviceSize.width),
              Text('友達に応援してもらう'),
            ],
          ),
        );
      },
    );
  }
}
