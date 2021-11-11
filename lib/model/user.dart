/// ユーザーモデル
class UserModel {
  String id;
  String name = '';
  bool isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel({
    this.id = '',
    this.name = '',
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });
}
