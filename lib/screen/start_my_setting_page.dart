import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/screen/start_my_setting_startday_page.dart';
import 'package:yell_app/state/counter_provider.dart';
import 'package:yell_app/state/start_my_setting_provider.dart';

final disabledProvider = StateProvider((ref) => true);
final errorTextProvider = StateProvider((ref) => '');

class StartMySettingPage extends ConsumerWidget {
  const StartMySettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String errorText = ref.watch(errorTextProvider);
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
              children: [
                TextWidget.mainText1('続けること'),
                TextField(
                  controller: _textEditingController,
                  maxLength: 20,
                  style: TextStyle(),
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: '（例）筋トレ、勉強',
                    errorText: errorText.isEmpty ? null : errorText,
                  ),
                ),
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
                      startMySetting.goalTitle = _textEditingController.text;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StartMySettingStartdayPage(),
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
