import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/firebase/my_goal_firebase.dart';
import 'package:yell_app/state/my_achievment_provider.dart';

MyGoalFirebase _myGoalFirebase = MyGoalFirebase();

///  リセットタイムページ
class ResetTimePage extends ConsumerWidget {
  const ResetTimePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAchievment = ref.watch(myAchievmentProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        margin: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                bottom: 5,
              ),
              child: TextWidget.headLineText5('リセットタイムを変更'),
            ),
            CommonWidget.descriptionWidget(
              CommonWidget.lightbulbIcon(),
              '達成してから次に達成可能になるまでの時間を設定します',
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2,
                  children: _templateButton(context, myAchievment),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _templateButton(BuildContext context, MyAchievment myAchievment) {
    return [
      _tileButton(
        context,
        myAchievment,
        6,
      ),
      _tileButton(
        context,
        myAchievment,
        12,
      ),
      _tileButton(
        context,
        myAchievment,
        24,
      ),
      _tileButton(
        context,
        myAchievment,
        48,
      ),
    ];
  }

  Widget _tileButton(
      BuildContext context, MyAchievment myAchievment, int _hour) {
    return GridTile(
      child: ElevatedButton(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _hour.toString(),
              style: TextStyle(
                color: myAchievment.resetHour == _hour
                    ? Colors.white
                    : Colors.orange,
                fontSize: 40,
              ),
            ),
            Text(
              '時間',
              style: TextStyle(
                color: myAchievment.resetHour == _hour
                    ? Colors.white
                    : Colors.black,
                // fontSize: 40,
              ),
            )
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary:
              myAchievment.resetHour == _hour ? Colors.orange : Colors.white,
          onPrimary: Colors.black,
          shape: const StadiumBorder(),
        ),
        onPressed: () async {
          // リセットタイマー更新
          await _myGoalFirebase.updateresetHour(myAchievment.goalId, _hour);
          Navigator.of(context).pop(true);
        },
      ),
    );
  }
}
