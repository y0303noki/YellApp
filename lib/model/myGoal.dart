/**
 * 自分の目標設定のモデル
 */
class MyGoalModel {
  String id;
  String goalTitle = '';
  String myName = '';
  int howManyTimes = 0; // 1週間に何日（1~7)
  int currentDay = 0;
  DateTime? updatedCurrentDayAt;
  bool isDeleted = false;
  List<String> memberIds = [];
  String inviteId = '';
  DateTime? createdAt;
  DateTime? updatedAt;
  MyGoalModel({
    this.id = '',
    this.goalTitle = '',
    this.myName = '',
    this.howManyTimes = 0,
    this.currentDay = 0,
    this.updatedCurrentDayAt,
    this.isDeleted = false,
    this.memberIds = const [],
    this.inviteId = '',
    this.createdAt,
    this.updatedAt,
  });
}
