import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/model/member.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/state/my_achievment_provider.dart';
import 'package:yell_app/state/start_my_setting_provider.dart';

class OtherYellMainPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAchievment = ref.watch(myAchievmentProvider);
    TextEditingController _textEditingController =
        TextEditingController(text: myAchievment.goalTitle);
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
            child: TextWidget.mainText3('トップに戻る'),
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
                TextWidget.mainText1('2日目達成！'),
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
                      TextField(
                        controller: _textEditingController,
                        maxLength: 20,
                        style: TextStyle(),
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: '',
                        ),
                      ),
                    ],
                  ),
                ),
                ButtonWidget.registerYellComment(),
                Text('過去の履歴を見る'),
              ],
            ),
            Column(),
          ],
        ),
      ),
    );
  }

  // メンバーアイコン
  List<Widget> memberWidget(MyAchievment myAchievment) {
    List<Widget> row = <Widget>[];
    List<MemberModel> members = [];
    // テスト用のデータ作成
    for (String id in myAchievment.memberIdList) {
      MemberModel tempMember = MemberModel(
        id: id,
        name: id + '-name',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      members.add(tempMember);
    }
    List<String> memberIdList = myAchievment.memberIdList;

    for (String memberId in memberIdList) {
      MemberModel member = members.firstWhere((mem) => mem.id == memberId);
      Widget tempWidget = InkWell(
        onTap: () {
          myAchievment.selectMemberId(memberId);
        },
        child: Container(
          margin: const EdgeInsets.only(
            left: 1,
            right: 1,
          ),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(
                color: myAchievment.selectedMemberId == memberId
                    ? Colors.red
                    : Colors.blue),
            borderRadius: BorderRadius.circular(60 / 2),
          ),
          child: Center(
            child: Text(member.name.substring(0, 1)),
          ),
        ),
      );
      row.add(tempWidget);
    }
    return row;
  }
}
