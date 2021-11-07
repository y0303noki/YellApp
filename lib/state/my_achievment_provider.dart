import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/utility/utility.dart';

final myAchievmentProvider = ChangeNotifierProvider((ref) => MyAchievment());

class MyAchievment extends ChangeNotifier {
  String goalTitle = '';
  DateTime? endAt;
  int selectedHowManyTime = 0;
  String selectedMemberId = '';
  List<String> memberIdList = [];

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

  // メンバーを選択
  void selectMemberId(String memberId) {
    if (memberIdList.contains(memberId)) {
      selectedMemberId = memberId;
    }
    notifyListeners();
  }
}
