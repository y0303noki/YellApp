import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/utility/utility.dart';

final myAchievmentProvider = ChangeNotifierProvider((ref) => MyAchievment());

class MyAchievment extends ChangeNotifier {
  String goalId = ''; // firestoreに格納されているid
  String goalTitle = '';
  String myName = '';
  int selectedHowManyTime = 0;
  String selectedMemberId = '';
  List<String> memberIdList = [];
  bool isTapedToday = false;

  int currentDay = 1; // 現在の達成日（例：5日目 / 40日 の5日目の部分）
  int lastDay = 0; // 最後の日（例：40日間中の40日の部分）

  bool refresh = false; // データを通信し直すかどうか。画面を最初に表示したときとリフレッシュしたとき
  DateTime? updatedCurrentDayAt; // 最後に達成ボタンを押した日付
  // // データを初期化
  // void resetData() {
  //   goalTitle = '';
  //   DateTime now = DateTime.now();
  //   startAtStr = Utility.toDateFormatted(now);
  //   startAt = now;
  //   endAt = null;
  //   endAtStr = '無期限';
  //   notifyListeners();
  // }

  void setInitialData(
    String id,
    String title,
    String name,
    int manyTimes,
    List<String> memberIds,
    DateTime? currentDayAt,
  ) {
    goalId = id;
    goalTitle = title;
    myName = name;
    selectedHowManyTime = manyTimes;
    memberIdList = memberIds;
    refresh = false;

    // 達成ボタンを押した日付と現在の日付が同じか比較
    if (currentDayAt != null) {
      DateTime now = DateTime.now();
      DateTime nowDate = DateTime(now.year, now.month, now.day);
      DateTime tapDate =
          DateTime(currentDayAt.year, currentDayAt.month, currentDayAt.day);
      if (!nowDate.isAtSameMomentAs(tapDate)) {
        isTapedToday = false;
      }
    }
  }

  // メンバーを選択
  void selectMemberId(String memberId) {
    if (memberIdList.contains(memberId)) {
      selectedMemberId = memberId;
    }
    notifyListeners();
  }

  // 達成ボタンをタップ
  void tapToday() {
    if (!isTapedToday) {
      currentDay++;
    } else {
      currentDay--;
    }
    isTapedToday = !isTapedToday;
    notifyListeners();
  }

  void refreshNotifyListeners() {
    notifyListeners();
  }
}
