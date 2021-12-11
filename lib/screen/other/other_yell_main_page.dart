import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/common_widget.dart';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
        elevation: 5,
        leading: IconButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
            top: 10,
          ),
          child: Column(
            children: [
              Container(
                child: TextWidget.headLineText3(otherAchievment.goalTitle),
              ),
              // 現在の継続日
              _achievedCurrent(otherAchievment),
              // オーナーのアイコンと名前
              Container(
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 0,
                  bottom: 0,
                ),
                child: Row(
                  children: [
                    // アイコン
                    ButtonWidget.iconMainWidget('a'),
                    // 名前
                    Container(
                      margin: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Column(
                        children: [
                          TextWidget.headLineText5(otherAchievment.ownerName),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // ひとことめっせーじ
              Container(
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 0,
                  bottom: 20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Bubble(
                        margin: const BubbleEdges.only(top: 20),
                        padding: const BubbleEdges.only(top: 20, bottom: 20),
                        nip: BubbleNip.leftTop,
                        color: CommonWidget.myDefaultColor(),
                        child: Text(otherAchievment.ownerAchievedment,
                            textAlign: TextAlign.left),
                      ),
                    ),
                  ],
                ),
              ),

              // 応援者のアイコンと名前
              Container(
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 5,
                  bottom: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // 名前
                    Container(
                      margin: const EdgeInsets.only(
                        right: 10,
                      ),
                      child: Column(
                        children: [
                          TextWidget.headLineText5(otherAchievment.otherName),
                        ],
                      ),
                    ),

                    ButtonWidget.iconMainWidget('a'),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 0,
                  bottom: 20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Bubble(
                        margin: const BubbleEdges.only(top: 20),
                        padding: const BubbleEdges.only(top: 20, bottom: 20),
                        nip: BubbleNip.rightTop,
                        color: CommonWidget.otherDefaultColor(),
                        child: Text(otherAchievment.yellMessage,
                            textAlign: TextAlign.left),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                child: const Text('メッセージを送る'),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.black,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  _showModalBottomSheat(context, otherAchievment);
                },
              ),
              // const Text('過去のメッセージ'),
            ],
          ),
        ),
      ),
    );
  }

  _showModalBottomSheat(BuildContext context, OtherAchievment otherAchievment) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // height: 400,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 3,
                    children: _quickAction(context, otherAchievment),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 5,
                  bottom: 30,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: TextWidget.subTitleText1('キャンセル'),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // メッセージを送れるリスト
  List<Widget> _quickAction(
      BuildContext context, OtherAchievment otherAchievment) {
    return [
      _tileContainer(
        context,
        otherAchievment,
        CommonWidget.quickAction0(),
        Icons.thumb_up_alt,
        0,
      ),
      _tileContainer(
        context,
        otherAchievment,
        CommonWidget.quickAction1(),
        Icons.mood,
        1,
      ),
      _tileContainer(
        context,
        otherAchievment,
        CommonWidget.quickAction2(),
        Icons.tag_faces,
        2,
      ),
      _tileContainer(
        context,
        otherAchievment,
        CommonWidget.quickAction3(),
        Icons.sentiment_satisfied_alt,
        3,
      ),
      _tileContainer(
        context,
        otherAchievment,
        CommonWidget.quickAction4(),
        Icons.sentiment_very_dissatisfied,
        4,
      ),
      _tileContainer(
        context,
        otherAchievment,
        CommonWidget.quickAction5(),
        Icons.emoji_people,
        5,
      ),
    ];
  }

  Widget _tileContainer(BuildContext context, OtherAchievment otherAchievment,
      String _text, IconData _iconData, int _index) {
    return GestureDetector(
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
            color: CommonWidget.otherDefaultColor()!,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                _iconData,
                size: 30,
              ),
              Center(
                child: TextWidget.subTitleText2(_text),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        otherAchievment.setQuickAction(_index);

        YellMessage yellMessageModel = YellMessage(
          goalId: otherAchievment.goalId,
          message: otherAchievment.yellMessage,
        );
        // x日目 or x回目
        if (otherAchievment.isAchieved) {
          yellMessageModel.dayOrTimes = otherAchievment.currentDayOrTime - 1;
        } else {
          yellMessageModel.dayOrTimes = otherAchievment.currentDayOrTime;
        }

        yellMessageFirebase.insertOrUpdateYellMessageData(yellMessageModel);

        Navigator.pop(context);
      },
    );
  }

  Widget _achievedCurrent(OtherAchievment otherAchievment) {
    // 達成してから12時間以内は「達成済み」
    // 12時間後は「挑戦中」
    DateTime now = DateTime.now();
    DateTime nowBefore12h = now.add(
      const Duration(hours: -12),
    );
    DateTime? updateAt = otherAchievment.updateCurrentDayOrTime; // 達成した日付

    String str = '';
    int showDayOrTime = 0;
    String showStr = ''; // X日目（回目）挑戦中（達成済み）
    if (updateAt == null) {
      showDayOrTime = 1;
      str = '挑戦中';
      if (otherAchievment.unitType == 0) {
        showStr = '$showDayOrTime日目$str';
      } else {
        showStr = '$showDayOrTime回目$str';
      }
    } else {
      if (otherAchievment.isAchieved) {
        // 達成済み
        str = '達成済み';
        if (otherAchievment.unitType == 0) {
          showDayOrTime = otherAchievment.currentDay - 1;
          showStr = '$showDayOrTime日目$str';
        } else {
          showDayOrTime = otherAchievment.currentTime - 1;
          showStr = '$showDayOrTime回目$str';
        }
      } else {
        // 挑戦中
        str = '挑戦中';
        if (otherAchievment.unitType == 0) {
          showDayOrTime = otherAchievment.currentDay;
          showStr = '$showDayOrTime日目$str';
        } else {
          showDayOrTime = otherAchievment.currentTime;
          showStr = '$showDayOrTime回目$str';
        }
      }
    }

    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 5,
        bottom: 10,
      ),
      child: TextWidget.headLineText4(showStr),
    );
  }
}

// // 達成コメント
// Widget _speechMessage(String _text) {
//   return Expanded(
//     child: Bubble(
//       margin: const BubbleEdges.only(top: 20),
//       padding: const BubbleEdges.only(top: 20, bottom: 20),
//       nip: BubbleNip.leftTop,
//       color: CommonWidget.myDefaultColor(),
//       child: Text(_text, textAlign: TextAlign.left),
//     ),
//   );
// }

// 応援コメント
Widget _yellMessage(String _text) {
  return Expanded(
    child: Bubble(
      margin: const BubbleEdges.only(top: 20),
      padding: const BubbleEdges.only(top: 20, bottom: 20),
      nip: BubbleNip.rightTop,
      color: CommonWidget.otherDefaultColor(),
      child: Text(
        _text,
        textAlign: TextAlign.right,
      ),
    ),
  );
}

Widget _futureMessage(OtherAchievment otherAchievment) {
  isFirstFetchYellMessage = false;
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
          int searchDayOrTime = 0;
          if (otherAchievment.isAchieved) {
            searchDayOrTime = otherAchievment.currentDayOrTime - 1;
          } else {
            searchDayOrTime = otherAchievment.currentDayOrTime;
          }

          // -okの部分を削除。
          // 現在オーナー側に表示されている数字を取得できる

          // int messageDayOrTime = int.parse(otherAchievment.achievedDayOrTime
          //     .substring(0, otherAchievment.achievedDayOrTime.length - 3));

          List<YellMessage> _data = snapshot.data;
          if (_data.isEmpty) {}

          int dayOrTimes = 0;
          YellMessage? myMessage;
          for (YellMessage yellMessage in _data) {
            // 既に応援メッセージを送信ずみ
            if (yellMessage.dayOrTimes == searchDayOrTime) {
              myMessage = yellMessage;
              print(myMessage.message);
              otherAchievment.yellMessage = myMessage.message;
              break;
            }
          }
          if (myMessage == null) {
            print('NO MEssage');
            otherAchievment.yellMessage = '';
          }
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
          // autofocus: true,
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
                      otherAchievment.yellMessage = _textEditingController.text;
                      YellMessage yellMessageModel = YellMessage(
                        goalId: otherAchievment.goalId,
                        message: otherAchievment.yellMessage,
                      );
                      // x日目 or x回目
                      if (otherAchievment.isAchieved) {
                        yellMessageModel.dayOrTimes =
                            otherAchievment.currentDayOrTime - 1;
                      } else {
                        yellMessageModel.dayOrTimes =
                            otherAchievment.currentDayOrTime;
                      }

                      // yellMessageFirebase
                      //     .insertYellMessageData(yellMessageModel);
                      yellMessageFirebase
                          .insertOrUpdateYellMessageData(yellMessageModel);

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
