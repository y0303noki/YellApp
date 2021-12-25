import 'package:flutter/material.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';

class ButtonWidget {
  static const mainButtonWidth = 330;
  static const mainButtonHeight = 100;

  // アイコンのサイズ
  static const double mainIconSize = 50;

  // メインボタンelevation
  static const double mainButtonElevation = 5.0;

  // スタート画面で設置するボタン
  static startMainButton(
    double deviceWidth,
    String buttonText,
    IconData iconData,
    Color color,
  ) {
    return Material(
      elevation: mainButtonElevation,
      child: Container(
        height: 150,
        width: deviceWidth * 0.8,
        decoration: BoxDecoration(
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              iconData,
              size: mainIconSize,
            ),
            TextWidget.headLineText5(buttonText),
          ],
        ),
      ),
    );
  }

  /// 通信中のスタートメインボタン
  static startMainWaitingButton(
    double deviceWidth,
  ) {
    return Material(
      elevation: mainButtonElevation,
      child: Container(
        height: 150,
        width: deviceWidth * 0.8,
        decoration: BoxDecoration(
          color: CommonWidget.myDefaultColor(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(),
            TextWidget.headLineText5(''),
          ],
        ),
      ),
    );
  }

  // 今日の達成ボタン（未完了）
  static yetAchievementToday(double deviceWidth) {
    return Material(
      elevation: mainButtonElevation,
      child: Container(
        height: 100,
        width: deviceWidth * 0.8,
        decoration: BoxDecoration(
          color: CommonWidget.myDefaultColor(),
        ),
        child: Center(
          child: TextWidget.mainButtonText('達成済み'),
        ),
      ),
    );
  }

  // 達成ずみ
  static achievementedToday(double deviceWidth) {
    return Container(
      height: 100,
      width: deviceWidth * 0.8,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextWidget.mainButtonText('達成済み'),
      ),
    );
  }

  // 円形のウィジット。アイコン
  static iconBigMainWidget(String text) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 5),
        borderRadius: BorderRadius.circular(120 / 2),
      ),
      child: Center(
        child: TextWidget.headLineText3(text),
      ),
    );
  }

  // 円形のウィジット。アイコン
  static iconMainWidget(String text) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 5),
        borderRadius: BorderRadius.circular(80 / 2),
      ),
      child: Center(
        child: TextWidget.headLineText5(text),
      ),
    );
  }

  // 円形のウィジット。アイコン
  static iconMainMiniWidget(String text) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(40 / 2),
      ),
      child: Center(
        child: Text(text),
      ),
    );
  }

  // 登録ボタン
  static registerYellComment() {
    return Container(
      height: 50,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextWidget.mainButtonText('登録'),
      ),
    );
  }

  // 登録ずみの応援メッセージ
  static rgisterdYellMessageWidget(double width, String text) {
    return Container(
      height: 100,
      width: width,
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    top: 5,
                  ),
                  child: const Text('選択中の応援メッセージ')),
            ],
          ),
          TextWidget.headLineText6(text),
        ],
      ),
      // child: Center(
      //   child: TextWidget.headLineText6(text),
      // ),
    );
  }

  static speechMessageWidget(String text) {}
}
