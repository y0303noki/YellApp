import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/screen/my/start_my_setting_confirm_page.dart';
import 'package:yell_app/state/start_my_setting_provider.dart';

final errorTextProvider = StateProvider((ref) => '');

class StartMySettinMynamePage extends ConsumerWidget {
  const StartMySettinMynamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceSize = MediaQuery.of(context).size;
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
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: deviceSize.height - 100,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    TextWidget.headLineText5('最後にあなたの'),
                    TextWidget.headLineText5('ニックネームを教えてください'),
                    TextField(
                      controller: _textEditingController,
                      maxLength: 10,
                      style: const TextStyle(),
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'ニックネーム',
                        errorText: errorText.isEmpty ? null : errorText,
                      ),
                      onSubmitted: (text) {
                        startMySetting.myName = text;
                      },
                    ),
                  ],
                ),
                // TODO
                Container(
                  width: CommonWidget.defaultDescriptionWidth(deviceSize.width),
                  height:
                      CommonWidget.defaultDescriptionHeight(deviceSize.width),
                  decoration: CommonWidget.defaultDescriptionDecoration(),
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
                        child: TextWidget.headLineText5('戻る'),
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
                              builder: (context) =>
                                  const StartMySettingConfirmPage(),
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
        ),
      ),
    );
  }
}
