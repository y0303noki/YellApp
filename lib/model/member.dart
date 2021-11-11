/**
 * メンバーモデル
 */
class MemberModel {
  String id;
  String name = '';
  DateTime? createdAt;
  DateTime? updatedAt;
  MemberModel({
    this.id = '',
    this.name = '',
    this.createdAt,
    this.updatedAt,
  });
}
