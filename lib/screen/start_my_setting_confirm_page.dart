import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/state/start_my_setting_provider.dart';

class StartMySettingConfirmPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startMySetting = ref.watch(startMySettingProvider);
    TextEditingController _textEditingController =
        TextEditingController(text: startMySetting.goalTitle);

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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget.mainText2('続けること'),
                Container(
                  margin: const EdgeInsets.only(
                    left: 30,
                  ),
                  child: TextField(
                    enabled: false,
                    controller: _textEditingController,
                    style: TextStyle(),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget.mainText2('いつから'),
                Container(
                  margin: const EdgeInsets.only(
                    left: 30,
                  ),
                  child: TextWidget.mainText2(startMySetting.startAtStr),
                ),
                TextWidget.mainText2('いつまで'),
                Container(
                  margin: const EdgeInsets.only(
                    left: 30,
                  ),
                  child: TextWidget.mainText2(startMySetting.endAtStr),
                ),
                Container(),
              ],
            ),
            Column(
              children: [
                TextWidget.mainText2('曜日'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: selectedWeekDayWidget(startMySetting),
                ),
              ],
            ),
            Column(
              children: [
                TextWidget.mainText2('はじめますか？'),
                TextWidget.mainText2('途中で変更することはできません。'),
              ],
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => StartMySettingStartdayPage(),
                      //   ),
                      // );
                    },
                    child: TextWidget.mainText2('はじめる'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 曜日
  List<Widget> selectedWeekDayWidget(StartMySetting startMySetting) {
    List<Widget> row = <Widget>[];
    List<String> weekDays = ['日', '月', '火', '水', '木', '金', '土'];
    for (int num in startMySetting.selectedWeekDay) {
      Widget tempWidget = InkWell(
        onTap: () {
          // startMySetting.selectWeekDay(num);
        },
        child: Container(
          margin: const EdgeInsets.only(
            left: 1,
            right: 1,
          ),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
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
