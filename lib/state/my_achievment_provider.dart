import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/utility/utility.dart';

final myAchievmentProvider = ChangeNotifierProvider((ref) => MyAchievment());

class MyAchievment extends ChangeNotifier {
  String goalId = ''; // firestoreに格納されているid
  String goalTitle = '';
  String myName = '';
  int unitType = 0; // 0:日 1:回数
  String selectedMemberId = '';
  List<String> memberIdList = [];
  bool isTapedToday = false;
  String inviteId = ''; // 招待コードのid

  int currentDay = 1; // 現在の達成日（例：5日目 / 40日 の5日目の部分）
  int currentTime = 0; // 何回目？
  String achievedDayOrTime = ''; // 2日目達成 = '2-ok'

  bool refresh = false; // データを通信し直すかどうか。画面を最初に表示したときとリフレッシュしたとき
  DateTime? updatedCurrentDayAt; // 最後に達成ボタンを押した日付

  void setInitialData(MyGoalModel _myGoalModel) {
    goalId = _myGoalModel.id;
    goalTitle = _myGoalModel.goalTitle;
    myName = _myGoalModel.myName;
    unitType = _myGoalModel.unitType;
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
    if (isTapedToday) {
      return;
    }
    // インクリメントする前の数字を使う
    achievedDayOrTime = '$currentDay-ok';
    if (unitType == 0) {
      currentDay++;
    } else if (unitType == 1) {
      currentTime++;
    }

    isTapedToday = true;
    notifyListeners();
  }

  void refreshNotifyListeners() {
    notifyListeners();
  }
}
