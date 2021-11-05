/**
 * 自分の目標設定のモデル
 */
class MyGoalModel {
  String id;
  String goalTitle = '';
  List<int> dayOfWeekList = []; // 実行する曜日（0:日曜日, 1:月曜日 ~ 6:土曜日）
  DateTime? startAt;
  DateTime? endAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  MyGoalModel({
    this.id = '',
    this.goalTitle = '',
    this.dayOfWeekList = const [],
    this.createdAt,
    this.updatedAt,
  });
}
