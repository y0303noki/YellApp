/**
 * 自分の目標設定のモデル
 */
class MyGoalModel {
  String id;
  String goalTitle = '';
  int howManyTimes = 0; // 1週間に何日（1~7)
  bool isDeleted = false;
  DateTime? startAt;
  DateTime? endAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  MyGoalModel({
    this.id = '',
    this.goalTitle = '',
    this.howManyTimes = 0,
    this.isDeleted = false,
    this.startAt,
    this.endAt,
    this.createdAt,
    this.updatedAt,
  });
}
