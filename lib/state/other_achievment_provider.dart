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

  int currentDay = 1; // 現在の達成日（例：5日目 / 40日 の5日目の部分）

  bool refresh = false; // データを通信し直すかどうか。画面を最初に表示したときとリフレッシュしたとき

  int messageType = 0; // 0 or 1 or 2
  String thisTimeMessage = ''; // 今回のメッセージ
  String nextTimeMessage = ''; // 次のメッセージ
  String next2TimeMessage = ''; // 次の次のメッセー

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

  void refreshNotifyListeners() {
    notifyListeners();
  }
}
