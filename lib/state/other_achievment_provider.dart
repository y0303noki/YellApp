import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/utility/utility.dart';

final otherAchievmentProvider =
    ChangeNotifierProvider((ref) => OtherAchievment());

class OtherAchievment extends ChangeNotifier {
  String goalId = ''; // firestoreに格納されているid
  String goalTitle = ''; // 持ち主の目標タイトル
  String code = ''; // 招待コード
  String errorText = ''; // エラーテキスト
  String ownerName = ''; // 持ち主の名前
  String otherName = ''; // 応援している自分の名前
  List<String> memberIdList = []; // 応援しているメンバー
  bool isTapedToday = false; // 本日の分達成ずみフラグ
  String ownerAchievedment = ''; // オーナーが達成したときのひとこと

  int unitType = 0; // 0:日 1:回数
  int currentDay = 1; // 現在の達成日（例：5日目 / 40日 の5日目の部分）
  int currentTime = 1; // 何回目？
  DateTime? updateCurrentDayOrTime; // 達成した日付
  String achievedDayOrTime = ''; // 達成したら2-ok

  bool refresh = false; // データを通信し直すかどうか。画面を最初に表示したときとリフレッシュしたとき

  int messageType = 0; // 0 or 1 or 2
  String yellMessage = ''; // 今回のメッセージ

  // 達成済みか否か
  bool get isAchieved {
    // 達成してから12時間以内は「達成済み」
    // 12時間後は「挑戦中」
    DateTime now = DateTime.now();
    DateTime nowBefore12h = now.add(
      const Duration(hours: -12),
    );
    if (updateCurrentDayOrTime == null) {
      // まだ1つも達成していないので挑戦中
      return false;
    }

    if (nowBefore12h.isBefore(updateCurrentDayOrTime!)) {
      // 達成済み
      return true;
    } else {
      // 挑戦中
      return false;
    }
  }

  // 現在の日付or回数を返す
  int get currentDayOrTime {
    if (unitType == 0) {
      return currentDay;
    } else {
      return currentTime;
    }
  }

  void setInitialData(MyGoalModel _ownerGoalModel) {
    goalId = _ownerGoalModel.id;
    goalTitle = _ownerGoalModel.goalTitle;
    ownerName = _ownerGoalModel.myName;
    memberIdList = _ownerGoalModel.memberIds;
    refresh = false;
  }

  // エラーテキスト
  void setErrorText(String _text) {
    errorText = _text;
    notifyListeners();
  }

  // 応援メッセージ更新
  void setYellMessage(String _message) {
    yellMessage = _message;
    notifyListeners();
  }

  void refreshNotifyListeners() {
    notifyListeners();
  }
}
