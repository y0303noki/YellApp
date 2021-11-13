import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/screen/my/start_my_setting_confirm_page.dart';
import 'package:yell_app/screen/my/start_my_setting_weekday_page.dart';
import 'package:yell_app/state/start_my_setting_provider.dart';

final errorTextProvider = StateProvider((ref) => '');

class StartMySettinMynamePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String errorText = ref.watch(errorTextProvider);
    final startMySetting = ref.watch(startMySettingProvider);
    TextEditingController _textEditingController =
        TextEditingController(text: startMySetting.myName);

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
              children: [
                TextWidget.mainText2('最後にあなたの'),
                TextWidget.mainText2('なまえを教えてください'),
                TextField(
                    controller: _textEditingController,
                    maxLength: 10,
                    style: TextStyle(),
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'なまえ',
                      errorText: errorText.isEmpty ? null : errorText,
                    ),
                    onSubmitted: (text) {
                      startMySetting.myName = text;
                    }),
              ],
            ),
            // TODO
            Container(
              child: Text(
                'イラストとか説明が入る予定',
              ),
            ),
            // 戻る、次へ
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
                      if (_textEditingController.text.isEmpty) {
                        // エラーを出す
                        errorText = '入力してください。';
                        return;
                      } else {
                        errorText = '';
                      }
                      startMySetting.myName = _textEditingController.text;
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
}
