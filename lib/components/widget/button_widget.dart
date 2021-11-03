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
    // return SizedBox(
    //   height: 100,
    //   width: deviceWidth * 0.8,
    //   child: ElevatedButton(
    //     onPressed: () {},
    //     child: const Text(
    //       '自分の記録',
    //     ),
    //     style: ButtonStyle(),
    //   ),
    // );
  }

  static startAtherButton(double deviceWidth) {
    return Container(
      height: 100,
      width: deviceWidth * 0.8,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: TextWidget.mainButtonText('応援する')),
    );
  }
}
