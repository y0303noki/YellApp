import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/screen/my/start_my_setting_confirm_page.dart';
import 'package:yell_app/screen/my/start_my_setting_myname_page.dart';
import 'package:yell_app/state/start_my_setting_provider.dart';

class StartMySettingSelectUnitPage extends ConsumerWidget {
  // final startMySetting = ref.watch(startMySettingProvider);
  final double bodyPaddingLeft = 10;
  final double bodyPaddingRight = 10;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startMySetting = ref.watch(startMySettingProvider);
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(
          left: bodyPaddingLeft,
          right: bodyPaddingRight,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget.headLineText5('数え方を選択してください。'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    startMySetting.selectUnit(0);
                  },
                  child: unitDayContaner(
                      deviceSize.width, '日 / days', startMySetting),
                ),
                GestureDetector(
                  onTap: () {
                    startMySetting.selectUnit(1);
                  },
                  child: unitTimeContaner(
                      deviceSize.width, '回 / times', startMySetting),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    left: 100,
                    right: 100,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: startMySetting.selectedUnit == 0
                              ? Colors.black
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: startMySetting.selectedUnit == 1
                              ? Colors.black
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
                selectUnitDescriptionContainer(
                    deviceSize.width, startMySetting),
              ],
            ),

            // TODO
            // Container(
            //   child: Text(
            //     'イラストとか説明が入る予定',
            //   ),
            // ),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StartMySettinMynamePage(),
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

  // 日
  Widget unitDayContaner(
      double deviceSizeWidth, String _text, StartMySetting startMySetting) {
    return Container(
      width: (deviceSizeWidth - bodyPaddingLeft - bodyPaddingRight) / 2 -
          bodyPaddingLeft,
      height: (deviceSizeWidth - bodyPaddingLeft - bodyPaddingRight) / 2 -
          bodyPaddingLeft,
      decoration: BoxDecoration(
        color: startMySetting.selectedUnit == 0 ? Colors.red : Colors.grey,
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: TextWidget.headLineText4(_text),
      ),
    );
  }

  // 回数
  Widget unitTimeContaner(
      double deviceSizeWidth, String _text, StartMySetting startMySetting) {
    return Container(
      width: (deviceSizeWidth - bodyPaddingLeft - bodyPaddingRight) / 2 -
          bodyPaddingLeft,
      height: (deviceSizeWidth - bodyPaddingLeft - bodyPaddingRight) / 2 -
          bodyPaddingLeft,
      decoration: BoxDecoration(
        color: startMySetting.selectedUnit == 1 ? Colors.red : Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: TextWidget.headLineText4(_text),
      ),
    );
  }

  Widget selectUnitDescriptionContainer(
      double deviceSizeWidth, StartMySetting startMySetting) {
    switch (startMySetting.selectedUnit) {
      case -1:
        return _unitDefaultDescriptionContainer(deviceSizeWidth);
      case 0:
        return _unitDayDescriptionContainer(deviceSizeWidth);
      case 1:
        return _unitTimeDescriptionContainer(deviceSizeWidth);
      default:
        return _unitDefaultDescriptionContainer(deviceSizeWidth);
    }
  }

  // デフォルトの説明
  Widget _unitDefaultDescriptionContainer(double deviceSizeWidth) {
    return Container(
      width: CommonWidget.defaultDescriptionWidth(deviceSizeWidth),
      height: CommonWidget.defaultDescriptionHeight(deviceSizeWidth),
      decoration: CommonWidget.defaultDescriptionDecoration(),
    );
  }

  // 日の説明
  Widget _unitDayDescriptionContainer(double deviceSizeWidth) {
    return Container(
      width: CommonWidget.defaultDescriptionWidth(deviceSizeWidth),
      height: CommonWidget.defaultDescriptionHeight(deviceSizeWidth),
      decoration: CommonWidget.defaultDescriptionDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            'images/calender_himekuri.png',
            width: 100,
          ),
          TextWidget.headLineText6('毎日記録したいとき'),
        ],
      ),
    );
  }

  // 回数の説明
  Widget _unitTimeDescriptionContainer(double deviceSizeWidth) {
    return Container(
      width: CommonWidget.defaultDescriptionWidth(deviceSizeWidth),
      height: CommonWidget.defaultDescriptionHeight(deviceSizeWidth),
      decoration: CommonWidget.defaultDescriptionDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            'images/ticket_kaisuuken.png',
            width: 100,
          ),
          TextWidget.headLineText6('回数を記録したいとき'),
        ],
      ),
    );
  }

  // 1 ~ 7 のwidget
  List<Widget> weekDayWidget(StartMySetting startMySetting) {
    List<Widget> row = <Widget>[];
    List<String> weekDays = ['1', '2', '3', '4', '5', '6', '7'];
    List<int> weekDaysNum = [1, 2, 3, 4, 5, 6, 7];
    for (int num in weekDaysNum) {
      Widget tempWidget = InkWell(
        onTap: () {
          startMySetting.selectHowManyTime(num);
        },
        child: Container(
          margin: const EdgeInsets.only(
            left: 1,
            right: 1,
          ),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
                color: startMySetting.selectedHowManyTime == num
                    ? Colors.red
                    : Colors.blue),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(num.toString()),
          ),
        ),
      );
      row.add(tempWidget);
    }
    return row;
  }
}
