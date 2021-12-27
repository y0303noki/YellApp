import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/common_widget.dart';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 10,
              ),
              child: Column(
                children: [
                  TextWidget.headLineText5('${otherAchievment.ownerName}さんを'),
                  TextWidget.headLineText5('応援しますか？'),
                  TextWidget.headLineText5(
                      '${otherAchievment.goalTitle}を続けています'),
                ],
              ),
            ),
            CommonWidget.descriptionWidget(
                CommonWidget.lightbulbIcon(), '間違えている場合は「戻る」を押してください。'),

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
                              const StartOtherSettingYourinfoPage(),
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
    );
  }
}
