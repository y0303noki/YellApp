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
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
        elevation: 5,
        actions: const [],
      ),
      body: Container(
        margin: const EdgeInsets.only(
          top: 20,
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
                    TextWidget.headLineText5('あなたのニックネーム'),
                    TextField(
                      controller: _textEditingController,
                      maxLength: 10,
                      style: const TextStyle(),
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'ニックネームを入力',
                        errorText: errorText.isEmpty ? null : errorText,
                      ),
                      onSubmitted: (text) {
                        startMySetting.myName = text;
                      },
                    ),
                  ],
                ),
                // 説明
                Column(
                  children: [
                    CommonWidget.descriptionWidget(CommonWidget.lightbulbIcon(),
                        '応援してくれる人たちに表示されます。\n頭文字2文字がアイコンになります。'),
                    Image.asset(
                      'images/yell.png',
                      width: 200,
                    ),
                  ],
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
