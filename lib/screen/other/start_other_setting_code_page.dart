import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/screen/my/start_my_setting_startday_page.dart';
import 'package:yell_app/screen/other/start_other_setting_confirm_page.dart';
import 'package:yell_app/screen/other/start_other_setting_yourinfo_page.dart';
import 'package:yell_app/state/other_setting_code_provider.dart';
import 'package:yell_app/state/start_my_setting_provider.dart';

class StartOtherSettingCodePage extends ConsumerWidget {
  const StartOtherSettingCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherSettingCode = ref.watch(otherSettingCodeProvider);
    TextEditingController _textEditingController =
        TextEditingController(text: '');

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
                TextWidget.mainText1('招待コード'),
                TextField(
                  controller: _textEditingController,
                  maxLength: 10,
                  style: TextStyle(),
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: '10桁のコード',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StartOtherSettingConfirmPage(),
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
