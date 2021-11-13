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

  void setInitialData(String id, String title, String name, int manyTimes,
      List<String> memberIds) {
    goalId = id;
    goalTitle = title;
    myName = name;
    selectedHowManyTime = manyTimes;
    memberIdList = memberIds;
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
    // if (isTapedToday) {
    //   return;
    // }
    if (!isTapedToday) {
      currentDay++;
    } else {
      currentDay--;
    }
    isTapedToday = !isTapedToday;
    notifyListeners();
  }

  // // 現在の日付を1日プラス
  // void incrementCurrentDay() {
  //   currentDay++;
  //   notifyListeners();
  // }
}
