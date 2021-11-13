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

class StartMySettinWeekdayPage extends ConsumerWidget {
  // final startMySetting = ref.watch(startMySettingProvider);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startMySetting = ref.watch(startMySettingProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget.mainText2('頻度を教えてください。'),
                    TextWidget.mainText2('1週間のうちに何日おこないますか？'),
                    Row(
                      children: weekDayWidget(startMySetting),
                    ),
                  ],
                ),
              ],
            ),
            // TODO
            Container(
              child: Text(
                'イラストとか説明が入る予定',
              ),
            ),
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
                    child: TextWidget.mainText2('戻る'),
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
                    child: TextWidget.mainText2('次へ'),
                  )
                ],
              ),
            ),
          ],
        ),
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
