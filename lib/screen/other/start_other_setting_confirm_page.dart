import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/screen/other/start_other_setting_yourinfo_page.dart';
import 'package:yell_app/state/other_achievment_provider.dart';
import 'package:yell_app/state/other_setting_code_provider.dart';
import 'package:yell_app/state/start_my_setting_provider.dart';

class StartOtherSettingConfirmPage extends ConsumerWidget {
  const StartOtherSettingConfirmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherAchievment = ref.watch(otherAchievmentProvider);
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Text('a'),
                      ),
                    ],
                  ),
                  TextWidget.headLineText4('${otherAchievment.ownerName}さんを'),
                  TextWidget.headLineText4('応援しますか？'),
                  TextWidget.headLineText4('やること'),
                  TextWidget.headLineText4(otherAchievment.goalTitle),
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
                      child: TextWidget.headLineText5('戻る'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StartOtherSettingYourinfoPage(),
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
    );
  }
}
