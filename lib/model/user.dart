/// ユーザーモデル
class UserModel {
  String id;
  String name = '';
  bool isDeleted;
  DateTime? lastLoginAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel({
    this.id = '',
    this.name = '',
    this.isDeleted = false,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
  });
}
