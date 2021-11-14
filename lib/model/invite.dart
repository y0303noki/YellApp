/// 招待モデル
class InviteModel {
  String id;
  String ownerUserId; // 招待コードの発行主
  String code;
  bool isDeleted;
  DateTime? expiredAt; // 有効期限
  DateTime? createdAt;
  DateTime? updatedAt;
  InviteModel({
    this.id = '',
    this.ownerUserId = '',
    this.code = '',
    this.isDeleted = false,
    this.expiredAt,
    this.createdAt,
    this.updatedAt,
  });
}
