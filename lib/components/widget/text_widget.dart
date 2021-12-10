import 'package:flutter/material.dart';

class TextWidget {
  static mainButtonText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 28,
      ),
    );
  }

  static headLineText3(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 48),
      overflow: TextOverflow.clip,
    );
  }

  static headLineText4(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 34),
      overflow: TextOverflow.clip,
    );
  }

  static headLineText5(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 24),
      overflow: TextOverflow.clip,
    );
  }

  static headLineText6(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20),
      overflow: TextOverflow.clip,
    );
  }

  static subTitleText1(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16),
      overflow: TextOverflow.clip,
    );
  }

  static subTitleText2(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14),
      overflow: TextOverflow.clip,
    );
  }

  static subTitleText3(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12),
      overflow: TextOverflow.clip,
    );
  }
}
