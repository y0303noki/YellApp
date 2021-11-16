import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/model/member.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/state/my_achievment_provider.dart';
import 'package:yell_app/state/other_achievment_provider.dart';

class OtherYellMainPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherAchievment = ref.watch(otherAchievmentProvider);
    TextEditingController _textEditingController =
        TextEditingController(text: otherAchievment.goalTitle);
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: TextWidget.headLineText6('トップに戻る'),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(
          left: 0,
          right: 0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                // 達成ボタン
                ButtonWidget.iconMainWidget('a'),
                TextWidget.headLineText4('2日目達成！'),
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('今回'),
                          Text('次'),
                          Text('次の次'),
                        ],
                      ),
                      Column(
                        children: [
                          _selectDayWidth(deviceSize.width, 10, 0),
                          const Divider(
                            height: 0,
                            thickness: 3,
                          ),
                          TextField(
                            controller: _textEditingController,
                            maxLength: 20,
                            style: TextStyle(),
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: '応援メッセージを入力',
                            ),
                          ),
                          ButtonWidget.rgisterdYellMessageWidget(
                              deviceSize.width, 'がんばれー'),
                        ],
                      ),
                    ],
                  ),
                ),
                Text('過去の履歴を見る'),
                Container(
                  margin: const EdgeInsets.only(
                    top: 50,
                  ),
                  child: ButtonWidget.registerYellComment(),
                ),
              ],
            ),
            Column(),
          ],
        ),
      ),
    );
  }

  // 今回、次、次の次　を押したときの処理判断
  /// index = 0:今回 1:次 2:次の次
  _selectDayWidth(double deviceWidth, double marginWidth, int index) {
    double _indent = 0;
    double _endIndent = 0;
    double tenWidth = 10;
    double dividerWidth = deviceWidth - marginWidth;
    switch (index) {
      case 0:
        _indent = tenWidth;
        _endIndent = dividerWidth / 3 * 2;
        break;
      case 1:
        _indent = dividerWidth / 3 + tenWidth / 2;
        _endIndent = dividerWidth / 3 + tenWidth / 2;
        break;
      case 2:
        _indent = dividerWidth / 3 * 2;
        _endIndent = tenWidth;
        break;
    }

    return Divider(
      height: 10,
      thickness: 5,
      indent: _indent,
      endIndent: _endIndent,
      color: Colors.red,
    );
  }
}
