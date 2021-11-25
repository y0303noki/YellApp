class YellMessage {
  String id = '';
  String goalId = '';
  int dayOrTimes = 0; // x日目、x回目の応援メッセージ
  String memberId = '';
  String message = '';
  bool isDeleted = false;
  DateTime? createdAt;
  DateTime? updatedAt;
  YellMessage({
    this.id = '',
    this.goalId = '',
    this.dayOrTimes = 0,
    this.memberId = '',
    this.message = '',
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });
}
