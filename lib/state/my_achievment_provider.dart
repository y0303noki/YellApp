import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/model/yell_message.dart';
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

  List<YellMessage> yellMessages = []; // 自分宛の応援メッセージ

  // 達成済みか否か
  bool get isAchieved {
    // 達成してから12時間以内は「達成済み」
    // 12時間後は「挑戦中」
    DateTime now = DateTime.now();
    DateTime nowBefore12h = now.add(
      const Duration(hours: -12),
    );
    if (updatedCurrentDayAt == null) {
      // まだ1つも達成していないので挑戦中
      return false;
    }

    if (nowBefore12h.isBefore(updatedCurrentDayAt!)) {
      // 達成済み
      return true;
    } else {
      // 挑戦中
      return false;
    }
  }

  // day or time
  int get currentDayOrTime {
    if (unitType == 0) {
      return currentDay;
    } else {
      return currentTime;
    }
  }

  void setInitialData(MyGoalModel _myGoalModel, List<YellMessage> messages) {
    goalId = _myGoalModel.id;
    goalTitle = _myGoalModel.goalTitle;
    myName = _myGoalModel.myName;
    unitType = _myGoalModel.unitType;
    memberIdList = _myGoalModel.memberIds;
    refresh = false;
    inviteId = _myGoalModel.inviteId;
    currentDay = _myGoalModel.currentDay;
    currentTime = _myGoalModel.currentTimes;
    yellMessages = messages;

    // 達成ボタンを押した日付と現在の日付が同じか比較
    if (_myGoalModel.createdAt != null) {
      if (_myGoalModel.updatedCurrentDayAt == null) {
        isTapedToday = false;
        return;
      }
      DateTime now = DateTime.now();
      DateTime nowDate = DateTime(now.year, now.month, now.day);
      DateTime tapDate = DateTime(
          _myGoalModel.updatedCurrentDayAt!.year,
          _myGoalModel.updatedCurrentDayAt!.month,
          _myGoalModel.updatedCurrentDayAt!.day);
      if (nowDate.isAfter(tapDate)) {
        isTapedToday = false;
      } else {
        isTapedToday = true;
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
    if (unitType == 0) {
      achievedDayOrTime = '$currentDay-ok';
      currentDay++;
    } else if (unitType == 1) {
      achievedDayOrTime = '$currentTime-ok';
      currentTime++;
    }

    isTapedToday = true;
    notifyListeners();
  }

  void refreshNotifyListeners() {
    notifyListeners();
  }
}
