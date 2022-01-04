import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/components/dialog/dialog_widget.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/firebase/member_firebase.dart';
import 'package:yell_app/firebase/user_firebase.dart';
import 'package:yell_app/firebase/yell_message_firebase.dart';
import 'package:yell_app/model/member.dart';
import 'package:yell_app/model/yell_message.dart';
import 'package:yell_app/state/other_achievment_provider.dart';
import 'package:bubble/bubble.dart';
import 'package:yell_app/utility/utility.dart';

TextEditingController _textEditingController = TextEditingController(text: '');
YellMessageFirebase yellMessageFirebase = YellMessageFirebase();
MemberFirebase memberFirebase = MemberFirebase();
UserFirebase userFirebase = UserFirebase();
bool isFirstFetchYellMessage = false;

class OtherYellMainPage extends ConsumerWidget {
  const OtherYellMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherAchievment = ref.watch(otherAchievmentProvider);
    print('名前：${otherAchievment.ownerName}');

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            icon: const Icon(Icons.home),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                String? result = await DialogWidget()
                    .exitOtherGoal(context, otherAchievment.ownerName);
                if (result == null || result == 'CANCEL') {
                  return;
                } else {
                  // 退出する
                  MemberModel? thisMemebrModel =
                      await memberFirebase.fetchMemberDatasByGoalIdAndMyUserId(
                          otherAchievment.goalId);
                  if (thisMemebrModel == null) {
                    // メンバーから既に退出されている状態
                  } else {
                    memberFirebase.deleteMemberData(thisMemebrModel.id);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                }
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(
              top: 10,
            ),
            child: Column(
              children: [
                CommonWidget.achieveTitleWidget(
                  null,
                  otherAchievment,
                  _logoWidget(otherAchievment, context),
                  otherAchievment.startDate,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: Row(
                    children: [
                      // アイコン
                      ButtonWidget.iconMainWidget(
                        Utility.substring1or2(otherAchievment.ownerName),
                      ),
                      Flexible(
                        child: Column(
                          children: [
                            Tooltip(
                              message: '応援してくれるメンバーにコメントが表示されます',
                              child: Bubble(
                                margin: const BubbleEdges.only(
                                  top: 10,
                                  right: 10,
                                ),
                                borderColor: CommonWidget.myDefaultColor(),
                                stick: true,
                                nip: BubbleNip.leftCenter,
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
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                              ),
                            ),
                            // Utility.toStringddhh(_myAchievment.updatedCurrentDayAt);
                            // Text(Utility.toStringddhh(otherAchievment)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // 達成したらコメントを残すように促す
                suggestSendMessage(context, otherAchievment),

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

                      ButtonWidget.iconMainWidget(
                        Utility.substring1or2(otherAchievment.otherName),
                      ),
                    ],
                  ),
                ),

                // const Text('過去のメッセージ'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    return true;
  }

  String substring1or2(String _str) {
    print(_str);
    if (_str.isEmpty) {
      return '';
    }
    if (_str.length == 1) {
      return _str.substring(0, 1);
    } else {
      return _str.substring(0, 2);
    }
  }

  /// 達成したのでメッセージを送るか表示ウィジット
  Widget suggestSendMessage(
      BuildContext context, OtherAchievment otherAchievment) {
    if (otherAchievment.updatedCurrentDayAt == null) {
      // 挑戦中
      return Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.yellow[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(' 今回の分を達成したらひとこと残してあげましょう。'),
      );
    } else {
      // リセットタイム
      int _resetHour =
          otherAchievment.resetHour > 0 ? otherAchievment.resetHour : 24;
      DateTime now = DateTime.now();
      DateTime nowhour = DateTime(now.year, now.month, now.day, now.hour);

      // オーナー達成日付
      DateTime archivedDate = DateTime(
        otherAchievment.updatedCurrentDayAt!.year,
        otherAchievment.updatedCurrentDayAt!.month,
        otherAchievment.updatedCurrentDayAt!.day,
        otherAchievment.updatedCurrentDayAt!.hour,
      );
      // 達成済み判定
      DateTime nextResetDate = archivedDate.add(Duration(hours: _resetHour));
      if (nextResetDate.isBefore(nowhour)) {
        otherAchievment.achieved = false;
      } else {
        otherAchievment.achieved = true;
      }
      String _text = '';
      String _imagePath = '';
      if (otherAchievment.achieved) {
        _text = '${otherAchievment.ownerName}さんが';
        _text += ' #${otherAchievment.continuationCount} を達成しました。';
        _text += '\nひとこと伝えましょう';
        _imagePath = 'images/erai.png';
      } else {
        _text = '${otherAchievment.ownerName}さんが';
        _text += '#${otherAchievment.continuationCount + 1}に挑戦中です。';
        _imagePath = 'images/mataasita.png';
      }
      return Container(
        margin: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
        ),
        padding: const EdgeInsets.only(
          top: 10,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.yellow[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CommonWidget.lightbulbIcon(),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    _text,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // // コメント残すボタン
                !otherAchievment.achieved
                    ? Container()
                    : TextButton(
                        child: const Text('伝える'),
                        onPressed: () {
                          _showModalBottomSheat(context, otherAchievment);
                        },
                      ),
              ],
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
          yellMessageModel.dayOrTimes = otherAchievment.continuationCount - 1;
        } else {
          yellMessageModel.dayOrTimes = otherAchievment.continuationCount;
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

    String str = '';
    int showDayOrTime = 0;
    String showStr = ''; // X日目（回目）挑戦中（達成済み）
    // if (updateAt == null) {
    //   otherAchievment.achieved = false;
    //   showDayOrTime = 1;
    //   str = '挑戦中';
    // } else {
    //   if (otherAchievment.isAchieved) {
    //     // 達成済み
    //     otherAchievment.achieved = true;
    //     str = '達成済み';
    //     showDayOrTime = otherAchievment.continuationCount - 1;
    //     showStr = '日目$str';
    //   } else {
    //     // 挑戦中
    //     otherAchievment.achieved = false;
    //     str = '挑戦中';
    //     showDayOrTime = otherAchievment.continuationCount;
    //     showStr = '日目$str';
    //   }
    // }

    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 5,
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: TextWidget.headLineText3(showDayOrTime.toString()),
          ),
          TextWidget.headLineText6(showStr),
        ],
      ),
    );
  }

  Widget _logoWidget(OtherAchievment _otherAchievment, BuildContext _context) {
    return CommonWidget.logoByNumber(_otherAchievment.logoImageNumber);
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
            searchDayOrTime = otherAchievment.continuationCount - 1;
          } else {
            searchDayOrTime = otherAchievment.continuationCount;
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
                            otherAchievment.continuationCount - 1;
                      } else {
                        yellMessageModel.dayOrTimes =
                            otherAchievment.continuationCount;
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
