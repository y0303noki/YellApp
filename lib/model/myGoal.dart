/// 自分の目標設定のモデル
class MyGoalModel {
  String id;
  String goalTitle = '';
  String myName = '';
  int continuationCount = 0;
  DateTime? updatedCurrentDayAt; // 完了した日付
  String achievedDayOrTime = ''; // 2日目が完了 '2-ok'
  String achievedMyComment = '';
  int logoImageNumber = -1; // ロゴ
  bool isDeleted = false;
  List<String> memberIds = [];
  String inviteId = '';
  int resetHour = 0; // リセットする時間（hrou)
  DateTime? createdAt;
  DateTime? updatedAt;
  MyGoalModel({
    this.id = '',
    this.goalTitle = '',
    this.myName = '',
    this.continuationCount = 0,
    this.updatedCurrentDayAt,
    this.achievedDayOrTime = '',
    this.achievedMyComment = '',
    this.logoImageNumber = -1,
    this.isDeleted = false,
    this.memberIds = const [],
    this.inviteId = '',
    this.resetHour = 0,
    this.createdAt,
    this.updatedAt,
  });
}
