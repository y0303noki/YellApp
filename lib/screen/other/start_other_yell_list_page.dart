import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/screen/my/start_my_setting_startday_page.dart';
import 'package:yell_app/screen/other/start_other_setting_code_page.dart';
import 'package:yell_app/screen/other/start_other_setting_confirm_page.dart';
import 'package:yell_app/screen/other/start_other_setting_yourinfo_page.dart';
import 'package:yell_app/state/other_setting_code_provider.dart';
import 'package:yell_app/state/start_my_setting_provider.dart';

class StartOtherYellListPage extends ConsumerWidget {
  const StartOtherYellListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherSettingCode = ref.watch(otherSettingCodeProvider);
    TextEditingController _textEditingController =
        TextEditingController(text: '');

    var list = [
      "メッセージ1",
      "メッセージ2",
      "メッセージ3",
      "メッセージ4",
      "メッセージ5",
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: list.length, // この行を追加
              itemBuilder: (BuildContext context, int index) {
                return _yellIconAndTitle(list[index]);
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 100,
            ),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StartOtherSettingCodePage(),
                  ),
                );
              },
              child: TextWidget.mainText2('招待コードを入力する'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _yellIconAndTitle(String title) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        leading: ButtonWidget.iconMainMiniWidget('a'),
        onTap: () {
          print("onTap called.");
        }, // タップ
        onLongPress: () {
          print("onLongTap called.");
        }, // 長押し
      ),
    );
  }
}
