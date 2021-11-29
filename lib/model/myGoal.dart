/**
 * 自分の目標設定のモデル
 */
class MyGoalModel {
  String id;
  String goalTitle = '';
  String myName = '';
  int unitType = 0; // 0: 日　1:回数
  int currentDay = 0; // 何日目？
  int currentTimes = 0; // 何回目？
  DateTime? updatedCurrentDayAt; // 完了した日付
  String achievedDayOrTime = ''; // 2日目が完了 '2-ok'
  String achievedMyComment = '';
  bool isDeleted = false;
  List<String> memberIds = [];
  String inviteId = '';
  DateTime? createdAt;
  DateTime? updatedAt;
  MyGoalModel({
    this.id = '',
    this.goalTitle = '',
    this.myName = '',
    this.unitType = 0,
    this.currentDay = 0,
    this.currentTimes = 0,
    this.updatedCurrentDayAt,
    this.achievedDayOrTime = '',
    this.achievedMyComment = '',
    this.isDeleted = false,
    this.memberIds = const [],
    this.inviteId = '',
    this.createdAt,
    this.updatedAt,
  });
}
