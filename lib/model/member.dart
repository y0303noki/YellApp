/// メンバーモデル
class MemberModel {
  String id = '';
  String ownerGoalId = ''; // 持ち主の目標id
  String memberUserId = ''; // メンバーのユーザーid
  String memberName = ''; // ,メンバーの名前
  bool isDeleted = false;
  DateTime? createdAt;
  DateTime? updatedAt;
}
