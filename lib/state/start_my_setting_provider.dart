import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/utility/utility.dart';

final startMySettingProvider =
    ChangeNotifierProvider((ref) => StartMySetting());

class StartMySetting extends ChangeNotifier {
  String goalTitle = '';
  DateTime? startAt = DateTime.now();
  String startAtStr = '今日から';
  DateTime? endAt;
  String endAtStr = '無期限';
  List<int> selectedWeekDay = [];

  // データを初期化
  void resetData() {
    goalTitle = '';
    DateTime now = DateTime.now();
    startAtStr = Utility.toDateFormatted(now);
    startAt = now;
    endAt = null;
    endAtStr = '無期限';
    notifyListeners();
  }

  // 開始日付をセット
  void selectStartAt(DateTime? dateTime) {
    DateTime now = DateTime.now();
    DateTime tommorow = now.add(
      const Duration(days: 1),
    );
    startAt = dateTime;
    if (dateTime != null) {
      if (dateTime.difference(now).inDays == 0 && dateTime.day == now.day) {
        startAtStr = '今日から';
      } else if (dateTime.difference(tommorow).inDays == 0 &&
          dateTime.day == tommorow.day) {
        startAtStr = '明日から';
      } else {
        startAtStr = Utility.toDateFormatted(dateTime);
      }
    }

    notifyListeners();
  }

  // 終了日付をセット
  void selectEndAt(DateTime? dateTime) {
    endAt = dateTime;
    if (dateTime != null) {
      endAtStr = Utility.toDateFormatted(dateTime);
    } else {
      endAtStr = '無期限';
    }

    notifyListeners();
  }

  // 曜日を選択。0:日曜日 ~ 6:土曜日
  // 選択ずみなら削除する
  void selectWeekDay(int dayNum) {
    if (!selectedWeekDay.contains(dayNum)) {
      selectedWeekDay.add(dayNum);
    } else {
      selectedWeekDay.remove(dayNum);
    }
    selectedWeekDay.sort();
    print(selectedWeekDay);
    notifyListeners();
  }
}
