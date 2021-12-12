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
  const OtherYellMainPage({Key? key}) : super(key: key);

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
          icon: const Icon(Icons.home),
        ),
        actions: const [],
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
              Container(
                child: Row(
                  children: [
                    // アイコン
                    ButtonWidget.iconMainWidget('a'),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            left: 10,
                          ),
                          child: TextWidget.subTitleText1(
                              otherAchievment.ownerName),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 10,
                          ),
                          child: otherAchievment.ownerAchievedment.isEmpty
                              ? const Text(
                                  '達成時コメントがここに表示されます',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                )
                              : Text(
                                  otherAchievment.ownerAchievedment,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                      ],
                    ),
                    // 名前
                  ],
                ),
              ),
              // 達成したらコメントを残すように促す
              suggestSendMessage(otherAchievment),
              // コメント残すボタン
              !otherAchievment.achieved
                  ? Container()
                  : ElevatedButton(
                      child: const Text('メッセージを選択'),
                      onPressed: () {
                        _showModalBottomSheat(context, otherAchievment);
                      },
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
                    // メッセージ
                    Expanded(
                      child: Bubble(
                        margin: const BubbleEdges.only(top: 20),
                        padding: const BubbleEdges.only(top: 20, bottom: 20),
                        nip: BubbleNip.rightTop,
                        color: CommonWidget.otherDefaultColor(),
                        child: Text(otherAchievment.yellMessage,
                            textAlign: TextAlign.right),
                      ),
                    ),
                    // 名前とアイコン
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

              // const Text('過去のメッセージ'),
            ],
          ),
        ),
      ),
    );
  }

  /// 達成したのでメッセージを送るか表示ウィジット
  Widget suggestSendMessage(OtherAchievment otherAchievment) {
    if (!otherAchievment.achieved) {
      // 挑戦中
      return Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.yellow[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text('今回の分を達成したらひとこと残してあげましょう。'),
      );
    } else {
      String _text = '${otherAchievment.ownerName}さんが';
      if (otherAchievment.unitType == 0) {
        _text += '${otherAchievment.currentDayOrTime}日目達成しました。';
      } else if (otherAchievment.unitType == 1) {
        _text += '${otherAchievment.currentDayOrTime}回目達成しました。';
      } else {
        _text += '達成したようです？';
      }
      _text += '\nひとこと伝えませんか？';

      return Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.yellow[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Image.asset(
              'images/erai.png',
              width: 30,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text(_text, overflow: TextOverflow.clip),
            ),
          ],
        ),
      );
    }
  }

  // メッセージを送る
  _showModalBottomSheat(BuildContext context, OtherAchievment otherAchievment) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
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
        'images/iine.png',
        0,
      ),
      _tileContainer(
        context,
        otherAchievment,
        CommonWidget.quickAction1(),
        'images/erai.png',
        1,
      ),
      _tileContainer(
        context,
        otherAchievment,
        CommonWidget.quickAction2(),
        'images/sugokuerai.png',
        2,
      ),
      _tileContainer(
        context,
        otherAchievment,
        CommonWidget.quickAction3(),
        'images/tugimoganbarou.png',
        3,
      ),
      _tileContainer(
        context,
        otherAchievment,
        CommonWidget.quickAction4(),
        'images/mataasita.png',
        4,
      ),
      _tileContainer(
        context,
        otherAchievment,
        CommonWidget.quickAction5(),
        'images/otukaresama.png',
        5,
      ),
    ];
  }

  Widget _tileContainer(BuildContext context, OtherAchievment otherAchievment,
      String _text, String _imagePath, int _index) {
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
              Image.asset(
                _imagePath,
                width: 30,
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
      otherAchievment.achieved = false;
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
        otherAchievment.achieved = true;
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
        otherAchievment.achieved = false;
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

          List<YellMessage> _data = snapshot.data;
          if (_data.isEmpty) {}

          YellMessage? myMessage;
          for (YellMessage yellMessage in _data) {
            // 既に応援メッセージを送信ずみ
            if (yellMessage.dayOrTimes == searchDayOrTime) {
              myMessage = yellMessage;
              otherAchievment.yellMessage = myMessage.message;
              break;
            }
          }
          if (myMessage == null) {
            otherAchievment.yellMessage = '';
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _yellMessage(otherAchievment.yellMessage),
              ButtonWidget.iconMainWidget('a'),
            ],
          );
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
