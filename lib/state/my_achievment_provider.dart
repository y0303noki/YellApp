import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/model/myGoal.dart';
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
  String inviteId = ''; // 招待コードのid

  int currentDay = 1; // 現在の達成日（例：5日目 / 40日 の5日目の部分）
  int lastDay = 0; // 最後の日（例：40日間中の40日の部分）

  bool refresh = false; // データを通信し直すかどうか。画面を最初に表示したときとリフレッシュしたとき
  DateTime? updatedCurrentDayAt; // 最後に達成ボタンを押した日付

  void setInitialData(MyGoalModel _myGoalModel) {
    goalId = _myGoalModel.id;
    goalTitle = _myGoalModel.goalTitle;
    myName = _myGoalModel.myName;
    selectedHowManyTime = _myGoalModel.howManyTimes;
    memberIdList = _myGoalModel.memberIds;
    refresh = false;
    inviteId = _myGoalModel.inviteId;

    // 達成ボタンを押した日付と現在の日付が同じか比較
    if (_myGoalModel.createdAt != null) {
      DateTime now = DateTime.now();
      DateTime nowDate = DateTime(now.year, now.month, now.day);
      DateTime tapDate = DateTime(_myGoalModel.createdAt!.year,
          _myGoalModel.createdAt!.month, _myGoalModel.createdAt!.day);
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
