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
import 'package:bubble/bubble.dart';

TextEditingController _textEditingControllerThisTime =
    TextEditingController(text: '');
TextEditingController _textEditingControllerNextTime =
    TextEditingController(text: '');
TextEditingController _textEditingControllerNextTime2 =
    TextEditingController(text: '');

class OtherYellMainPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherAchievment = ref.watch(otherAchievmentProvider);

    final deviceSize = MediaQuery.of(context).size;

    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
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
            title: const Text('TabBar Widget'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    ButtonWidget.iconMainWidget('a'),
                    _speechMessage('つかれたーよおおおおお'),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 5,
                    bottom: 10,
                  ),
                  child: TextWidget.headLineText4('2日目達成！'),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 5,
                    bottom: 10,
                  ),
                  child: TextWidget.subTitleText1('メッセージを送ろう！'),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 5,
                    bottom: 10,
                  ),
                  child: _tabBody(otherAchievment),
                ),
                Text('過去のメッセージ'),
              ],
            ),
          )),
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

  Widget _tabBody(OtherAchievment otherAchievment) {
    // 応援メッセージタブ一覧
    List<Tab> tabList = [
      Tab(
        child: TextWidget.headLineText6('今回'),
      ),
      Tab(
        child: TextWidget.headLineText6('次回'),
      ),
      Tab(
        child: TextWidget.headLineText6('次の次'),
      ),
    ];

    return Container(
      child: DefaultTabController(
        length: tabList.length, // length of tabs
        initialIndex: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: TabBar(
                onTap: (value) {
                  print(value);
                },
                labelColor: Colors.green,
                unselectedLabelColor: Colors.black,
                tabs: tabList,
              ),
            ),
            Container(
                height: 400, //height of TabBarView
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    left: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    right: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    bottom: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                ),
                child: TabBarView(children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Column(
                      children: [
                        Text('(達成した日付)の分のメッセージ'),
                        TextField(
                          controller: _textEditingControllerThisTime,
                          maxLength: 20,
                          style: TextStyle(),
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: '（例）えらい！',
                            // errorText: errorText.isEmpty ? null : errorText,
                          ),
                          onSubmitted: (text) {
                            // otherAchievment.thisTimeMessage = text;
                            // otherAchievment.refreshNotifyListeners();
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                print('a');
                                otherAchievment.thisTimeMessage =
                                    _textEditingControllerThisTime.text;
                                otherAchievment.refreshNotifyListeners();
                              },
                              child: TextWidget.subTitleText1('送信'),
                            ),
                          ],
                        ),
                        Text('届けたメッセージ'),
                        Text(otherAchievment.thisTimeMessage),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _yellMessage(otherAchievment.thisTimeMessage),
                            ButtonWidget.iconMainWidget('a'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text('Display Tab 2',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text('Display Tab 3',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ]))
          ],
        ),
      ),
    );
  }

  Widget _speechMessage(String _text) {
    return Bubble(
      margin: BubbleEdges.only(top: 10),
      nip: BubbleNip.leftTop,
      child: Text(_text),
    );
  }

  Widget _yellMessage(String _text) {
    return Bubble(
      margin: BubbleEdges.only(top: 10),
      nip: BubbleNip.rightTop,
      child: Text(_text),
    );
  }
}
