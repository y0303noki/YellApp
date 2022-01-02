import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/model/member.dart';
import 'package:yell_app/model/myGoal.dart';

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
  bool achieved = false; // 本日の分達成ずみフラグ
  String ownerAchievedment = ''; // オーナーが達成したときのひとこと

  int continuationCount = 0; // 継続回数
  String achievedDayOrTime = ''; // 達成したら2-ok

  bool refresh = false; // データを通信し直すかどうか。画面を最初に表示したときとリフレッシュしたとき

  int messageType = 0; // 0 or 1 or 2
  String yellMessage = ''; // 今回のメッセージ
  List<MemberModel> memberList = []; // メンバー
  List<MyGoalModel> myGoalList = []; // 目標

  int logoImageNumber = -1; // ロゴ画像（0 ~ 5)

  DateTime? updatedCurrentDayAt; // 達成した日付
  int resetHour = 0; // リセットタイム（hour)

  DateTime startDate = DateTime.now(); // 開始日時

  // 全部リセット
  void resetData() {
    goalId = '';
    goalTitle = '';
    code = '';
    errorText = '';
    ownerName = '';
    otherName = '';
    memberIdList = [];
    achieved = false;
    ownerAchievedment = '';
    continuationCount = 0;
    achievedDayOrTime = '';
    refresh = false;
    messageType = 0;
    yellMessage = '';
    updatedCurrentDayAt = null;
    resetHour = 0;
  }

  // 達成済みか否か
  bool get isAchieved {
    // 達成してから12時間以内は「達成済み」
    // 12時間後は「挑戦中」
    DateTime now = DateTime.now();
    DateTime nowBefore12h = now.add(
      const Duration(hours: -12),
    );
    return true;
  }

  void setInitialData(MyGoalModel _ownerGoalModel) {
    goalId = _ownerGoalModel.id;
    goalTitle = _ownerGoalModel.goalTitle;
    ownerName = _ownerGoalModel.myName;
    ownerAchievedment = _ownerGoalModel.achievedMyComment;
    memberIdList = _ownerGoalModel.memberIds;
    logoImageNumber = _ownerGoalModel.logoImageNumber;
    continuationCount = _ownerGoalModel.continuationCount;
    updatedCurrentDayAt = _ownerGoalModel.updatedCurrentDayAt;
    resetHour = _ownerGoalModel.resetHour;
    startDate = _ownerGoalModel.createdAt!;
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

  // クイックアクションでメッセージセット
  void setQuickAction(int _index) {
    switch (_index) {
      case 0:
        yellMessage = CommonWidget.quickAction0();
        break;
      case 1:
        yellMessage = CommonWidget.quickAction1();
        break;
      case 2:
        yellMessage = CommonWidget.quickAction2();
        break;
      case 3:
        yellMessage = CommonWidget.quickAction3();
        break;
      case 4:
        yellMessage = CommonWidget.quickAction4();
        break;
      case 5:
        yellMessage = CommonWidget.quickAction5();
        break;
      default:
        yellMessage = '';
    }
    notifyListeners();
  }

  void refreshNotifyListeners() {
    notifyListeners();
  }
}
