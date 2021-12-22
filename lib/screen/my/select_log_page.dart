import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/firebase/my_goal_firebase.dart';
import 'package:yell_app/state/my_achievment_provider.dart';

MyGoalFirebase _myGoalFirebase = MyGoalFirebase();

///  ロゴ選択ページ
class SelectLogoPage extends ConsumerWidget {
  const SelectLogoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAchievment = ref.watch(myAchievmentProvider);

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
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
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                bottom: 5,
              ),
              child: TextWidget.headLineText5('ロゴを変更'),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2,
                  children: _logItem(context, myAchievment),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _logItem(BuildContext context, MyAchievment myAchievment) {
    return [
      _tileContainer(
        context,
        myAchievment,
        'RUN',
        'images/run.png',
        0,
      ),
      _tileContainer(
        context,
        myAchievment,
        '掃除',
        'images/souzi.png',
        1,
      ),
      _tileContainer(
        context,
        myAchievment,
        '勉強',
        'images/benkyou.png',
        2,
      ),
      _tileContainer(
        context,
        myAchievment,
        '筋トレ',
        'images/kintore.png',
        3,
      ),
      _tileContainer(
        context,
        myAchievment,
        'PC',
        'images/pc.png',
        4,
      ),
      _tileContainer(
        context,
        myAchievment,
        'スマホ',
        'images/sumaho.png',
        5,
      ),
    ];
  }

  Widget _tileContainer(BuildContext context, MyAchievment myAchievment,
      String _text, String _imagePath, int _index) {
    return GestureDetector(
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                // color: CommonWidget.otherDefaultColor()!,
                ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                _imagePath,
                width: 80,
              ),
            ],
          ),
        ),
      ),
      onTap: () async {
        // ロゴを更新
        await _myGoalFirebase.updateLogoImageNumber(
            myAchievment.goalId, _index);
        Navigator.of(context).pop(true);
      },
    );
  }
}
