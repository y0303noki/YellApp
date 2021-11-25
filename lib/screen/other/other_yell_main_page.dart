import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/firebase/yell_message_firebase.dart';
import 'package:yell_app/model/yell_message.dart';
import 'package:yell_app/state/other_achievment_provider.dart';
import 'package:bubble/bubble.dart';

TextEditingController _textEditingController = TextEditingController(text: '');
YellMessageFirebase yellMessageFirebase = YellMessageFirebase();
bool isFirstFetchYellMessage = false;

class OtherYellMainPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherAchievment = ref.watch(otherAchievmentProvider);

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
        title: const Text('TabBar Widget'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    ButtonWidget.iconMainWidget('a'),
                    _speechMessage('つかれたーよおおおおお'),
                  ],
                ),
                _achievedCurrent(otherAchievment),
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 5,
                    bottom: 10,
                  ),
                  child: TextWidget.subTitleText1('メッセージを送ろう！'),
                ),
                _textEdit(otherAchievment),
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 5,
                    bottom: 10,
                  ),
                  child: _futureMessage(otherAchievment),
                ),
                Text('過去のメッセージ'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _achievedCurrent(OtherAchievment otherAchievment) {
    if (otherAchievment.unitType == 0) {
      if (otherAchievment.achievedDayOrTime ==
          '${otherAchievment.currentDay}-ok') {
        return Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 5,
            bottom: 10,
          ),
          child: TextWidget.headLineText4('${otherAchievment.currentDay}日目達成'),
        );
      } else {
        return Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 5,
            bottom: 10,
          ),
          child: TextWidget.headLineText4('${otherAchievment.currentDay}日目挑戦中'),
        );
      }
    } else {
      if (otherAchievment.achievedDayOrTime ==
          '${otherAchievment.currentTime}-ok') {
        return Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 5,
            bottom: 10,
          ),
          child: TextWidget.headLineText4('${otherAchievment.currentTime}回目達成'),
        );
      } else {
        return Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 5,
            bottom: 10,
          ),
          child:
              TextWidget.headLineText4('${otherAchievment.currentTime}回目挑戦中'),
        );
      }
    }
  }

  Widget _speechMessage(String _text) {
    return Expanded(
      child: Bubble(
        margin: BubbleEdges.only(top: 10),
        nip: BubbleNip.leftTop,
        child: Text(_text, textAlign: TextAlign.left),
      ),
    );
  }

  Widget _yellMessage(String _text) {
    return Expanded(
      child: Bubble(
        margin: BubbleEdges.only(top: 10),
        nip: BubbleNip.rightTop,
        child: Text(
          _text,
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  Widget _futureMessage(OtherAchievment otherAchievment) {
    if (!isFirstFetchYellMessage) {
      // 初めて取得するとき

      return FutureBuilder(
        future:
            yellMessageFirebase.fetchMyGoalYellMessage(otherAchievment.goalId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // 通信中
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.error != null) {
            // エラー
            return const Center(
              child: Text('エラーがおきました'),
            );
          }

          // 成功処理
          if (snapshot.connectionState == ConnectionState.done) {
            isFirstFetchYellMessage = true;
            // -okの部分を削除。
            // 現在オーナー側に表示されている数字を取得できる

            // int messageDayOrTime = int.parse(otherAchievment.achievedDayOrTime
            //     .substring(0, otherAchievment.achievedDayOrTime.length - 3));

            // List<YellMessage> _data = snapshot.data;
            // if (_data.isEmpty) {}

            // int dayOrTimes = 0;
            // YellMessage? myMessage;
            // for (YellMessage yellMessage in _data) {
            //   // 既に応援メッセージを送信ずみ
            //   if (yellMessage.dayOrTimes == messageDayOrTime) {
            //     myMessage = yellMessage;
            //     break;
            //   }
            // }
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _yellMessage(otherAchievment.yellMessage),
                ButtonWidget.iconMainWidget('a'),
              ],
            );

            // return _textEdit(otherAchievment);
          }
          return const Center(
            child: Text('エラーがおきました'),
          );
        },
      );
    } else {
      // 2回目以降は取得し直さない
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _yellMessage(otherAchievment.yellMessage),
          ButtonWidget.iconMainWidget('b'),
        ],
      );
    }
  }

  Widget _textEdit(OtherAchievment otherAchievment) {
    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: Column(
        children: [
          Text('(達成した日付)の分のメッセージ'),
          TextField(
            controller: _textEditingController,
            enabled: otherAchievment.yellMessage.isEmpty,
            maxLength: 20,
            style: TextStyle(),
            maxLines: 1,
            decoration: InputDecoration(
              hintText: '入力してください・・・',
              // errorText: errorText.isEmpty ? null : errorText,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: otherAchievment.yellMessage.isNotEmpty
                    ? null
                    : () {
                        otherAchievment.yellMessage =
                            _textEditingController.text;
                        YellMessage yellMessageModel = YellMessage(
                          goalId: otherAchievment.goalId,
                          message: otherAchievment.yellMessage,
                        );
                        // x日目 or x回目
                        if (otherAchievment.unitType == 0) {
                          yellMessageModel.dayOrTimes =
                              otherAchievment.currentDay;
                        } else {
                          yellMessageModel.dayOrTimes =
                              otherAchievment.currentTime;
                        }
                        yellMessageFirebase
                            .insertYellMessageData(yellMessageModel);

                        _textEditingController.clear();
                        otherAchievment.refreshNotifyListeners();
                      },
                child: TextWidget.subTitleText1('送信'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
