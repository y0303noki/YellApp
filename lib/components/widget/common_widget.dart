import 'package:flutter/material.dart';

class CommonWidget {
  // dateピッカーを表示して選択したDateTimeを返す
  static Future<DateTime?> selectDatePicker(
    BuildContext context,
    DateTime? _initialDateTime,
    DateTime? _firstDateTime,
  ) async {
    DateTime nowDate = DateTime.now();
    DateTime _firstDate = DateTime(nowDate.year, nowDate.month, nowDate.day);
    if (_firstDateTime != null) {
      _firstDate = DateTime(
          _firstDateTime.year, _firstDateTime.month, _firstDateTime.day + 1);
    }
    DateTime _initialDate = _firstDate;
    if (_initialDateTime != null) {
      _initialDate = DateTime(
          _initialDateTime.year, _initialDateTime.month, _initialDateTime.day);
    }

    final DateTime? selectDateTime = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime(_firstDate.year, _firstDate.month, _firstDate.day),
      lastDate: DateTime(_firstDate.year + 1),
    );
    return selectDateTime;
  }

  static double defaultDescriptionWidth(double deviceWidth) {
    return deviceWidth - 30;
  }

  static double defaultDescriptionHeight(double deviceWidth) {
    return (deviceWidth - 20) / 2 - 10;
  }

  /// ボタンの基本色
  static Color? myDefaultColor() {
    return Colors.lightGreen[100];
  }

  static Decoration defaultDescriptionDecoration() {
    return BoxDecoration(
      color: Colors.grey.withOpacity(0.2),
      borderRadius: BorderRadius.circular(20),
    );
  }

  /// 応援のデフォルト色
  static Color? otherDefaultColor() {
    return Colors.lightBlue[100];
  }
}
