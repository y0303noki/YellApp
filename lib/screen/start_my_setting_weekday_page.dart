import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/screen/start_my_setting_confirm_page.dart';
import 'package:yell_app/state/start_my_setting_provider.dart';

final errorTextProvider = StateProvider((ref) => '');

class StartMySettinWeekdayPage extends HookWidget {
  // final startMySetting = useProvider(startMySettingProvider);

  @override
  Widget build(BuildContext context) {
    final errorText = useProvider(errorTextProvider);
    final startMySetting = useProvider(startMySettingProvider);
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
                    TextWidget.mainText2('何曜日にやりますか？'),
                    Row(
                      children: weekDayWidget(startMySetting),
                    ),
                    errorText.state.isNotEmpty
                        ? TextWidget.mainText2('選択して！')
                        : Container(),
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
                      // 曜日を選択する
                      if (startMySetting.selectedWeekDay.isEmpty) {
                        errorText.state = '選択して！';
                        return;
                      } else {
                        errorText.state = '';
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StartMySettingConfirmPage(),
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

  // 日　〜　土　まで1週間分のWidget
  List<Widget> weekDayWidget(StartMySetting startMySetting) {
    List<Widget> row = <Widget>[];
    List<String> weekDays = ['日', '月', '火', '水', '木', '金', '土'];
    List<int> weekDaysNum = [0, 1, 2, 3, 4, 5, 6];
    for (int num in weekDaysNum) {
      Widget tempWidget = InkWell(
        onTap: () {
          startMySetting.selectWeekDay(num);
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
                color: startMySetting.selectedWeekDay.contains(num)
                    ? Colors.red
                    : Colors.blue),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(weekDays[num]),
          ),
        ),
      );
      row.add(tempWidget);
    }
    return row;
  }
}
