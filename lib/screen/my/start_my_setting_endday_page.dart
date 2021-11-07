import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/screen/my/start_my_setting_weekday_page.dart';
import 'package:yell_app/state/counter_provider.dart';
import 'package:yell_app/state/start_my_setting_provider.dart';

class StartMySettinEnddayPage extends ConsumerWidget {
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget.mainText2('いつまで'),
                    TextButton(
                      onPressed: () async {
                        DateTime? result = await CommonWidget.selectDatePicker(
                            context,
                            startMySetting.endAt,
                            startMySetting.startAt);
                        startMySetting.selectEndAt(result);
                      },
                      child: TextWidget.mainText1(startMySetting.endAtStr),
                    ),
                    startMySetting.endAt != null
                        ? TextButton(
                            onPressed: () async {
                              startMySetting.selectEndAt(null);
                            },
                            child: TextWidget.mainText2('無期限にする'),
                          )
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StartMySettinWeekdayPage(),
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
}
