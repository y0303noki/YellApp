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
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';

class OtherYellMainPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherAchievment = ref.watch(otherAchievmentProvider);
    TextEditingController _textEditingController =
        TextEditingController(text: '');
    //  TabController _tabController = TabController(length: 3, vsync: );
    final deviceSize = MediaQuery.of(context).size;

    AdvancedSegmentController _seg_value1 = AdvancedSegmentController('0');

    // 応援メッセージ3回分
    const List<String> yellMessages = const <String>['今回', '次回', '次の次'];
    List<Tab> tabList = [
      Tab(
        child: Text('now'),
      ),
      Tab(
        child: Text('now2'),
      ),
    ];

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
          body: Column(
            children: [
              Text('AAA'),
              _tabBody(),
              Text('BBB'),
            ],
          )),
    );
  }

  _choiceType(int index) {
    return Column(
      children: [
        TextField(
          // controller: _textEditingController,
          maxLength: 20,
          style: TextStyle(),
          maxLines: 1,
          decoration: InputDecoration(
            hintText: '応援メッセージを入力',
          ),
        ),
        ButtonWidget.rgisterdYellMessageWidget(200, 'がんばれー'),
      ],
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

  Widget _segmentWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(
                left: 0,
                right: 0,
              ),
              padding: const EdgeInsets.only(
                left: 20,
                right: 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextWidget.headLineText6('今回'),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextWidget.headLineText6('次回'),
            ),
          ),
          TextWidget.headLineText6('次の次'),
        ],
      ),
    );
  }

  Widget _tabBody() {
    return DefaultTabController(
      length: 4, // length of tabs
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
              tabs: [
                Tab(text: 'Tab 1'),
                Tab(text: 'Tab 2'),
                Tab(text: 'Tab 3'),
                Tab(text: 'Tab 4'),
              ],
            ),
          ),
          Container(
              height: 400, //height of TabBarView
              decoration: BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.grey, width: 0.5))),
              child: TabBarView(children: <Widget>[
                Container(
                  child: Center(
                    child: Text('Display Tab 1',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
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
                Container(
                  child: Center(
                    child: Text('Display Tab 4',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                ),
              ]))
        ],
      ),
    );
  }
}
