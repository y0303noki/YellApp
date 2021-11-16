import 'package:flutter/material.dart';
import 'package:yell_app/components/widget/text_widget.dart';

class ButtonWidget {
  static const mainButtonWidth = 330;
  static const mainButtonHeight = 100;

  // スタート画面のボタン
  // widthは端末サイズを基準にする
  static startMyButton(double deviceWidth) {
    return Container(
      height: 100,
      width: deviceWidth * 0.8,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: TextWidget.mainButtonText('自分の記録を始める')),
    );
  }

  // スタート画面のボタン
  static startAtherButton(double deviceWidth) {
    return Container(
      height: 100,
      width: deviceWidth * 0.8,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextWidget.mainButtonText('応援する'),
      ),
    );
  }

  // 今日の達成ボタン（未完了）
  static yetAchievementToday(double deviceWidth) {
    return Container(
      height: 100,
      width: deviceWidth * 0.8,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextWidget.mainButtonText('達成'),
      ),
    );
  }

  // 達成ずみ
  static achievementedToday(double deviceWidth) {
    return Container(
      height: 100,
      width: deviceWidth * 0.8,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextWidget.mainButtonText('達成ずみ'),
      ),
    );
  }

  // 円形のウィジット。アイコン
  static iconMainWidget(String text) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(text),
    );
  }

  // 円形のウィジット。アイコン
  static iconMainMiniWidget(String text) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(text),
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
                  child: Text('選択中の応援メッセージ')),
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
}
