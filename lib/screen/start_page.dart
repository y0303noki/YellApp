import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/firebase/my_goal_firebase.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/screen/my/start_my_setting_page.dart';
import 'package:yell_app/screen/other/start_other_setting_code_page.dart';
import 'package:yell_app/screen/other/start_other_yell_list_page.dart';
import 'package:yell_app/state/counter_provider.dart';

MyGoalFirebase _myGoalFirebase = MyGoalFirebase();

class StartPage extends ConsumerWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: bodyWidget(context),
      ),
    );
  }

  Widget bodyWidget(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _myGoalButton(context),
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

  // タグを遅延読み込み
  Widget _myGoalButton(BuildContext context) {
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
                  Text('あああ'),
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
