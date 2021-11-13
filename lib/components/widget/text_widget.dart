import 'package:flutter/material.dart';

class TextWidget {
  static mainButtonText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 28,
        color: Colors.white,
      ),
    );
  }

  static mainText1(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 30),
      overflow: TextOverflow.clip,
    );
  }

  static mainText2(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20),
      overflow: TextOverflow.clip,
    );
  }

  static mainText3(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15),
      overflow: TextOverflow.clip,
    );
  }
}
