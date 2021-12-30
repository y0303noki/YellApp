import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yell_app/model/user.dart';
import 'package:yell_app/state/user_auth_provider.dart';

class UserFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // コレクション名前
  final String userDatas = 'user_infos';

  // 自分のuserIdを返す
  String getMyUserId() {
    final UserAuth _userAuth = UserAuth();
    String userId = _userAuth.user != null ? _userAuth.user!.uid : '';
    return userId;
  }

  /// userIdで検索して見つかれば返す。なければnullを返す
  Future<UserModel?> fetchUserData(String userId) async {
    await updateLastLoginAt();
    final QuerySnapshot snapshots = await _firestore
        .collection(userDatas)
        .where('id', isEqualTo: userId)
        .get();

    List<QueryDocumentSnapshot> docs = snapshots.docs;
    if (docs.isNotEmpty) {
      Map<String, dynamic> data = docs.first.data() as Map<String, dynamic>;
      final _userModel = UserModel(
        id: data['id'],
        name: data['name'],
        isDeleted: data['isDeleted'] ?? false,
        lastLoginAt: data['lastLoginAt'].toDate(),
        createdAt: data['createdAt'].toDate(),
        updatedAt: data['updatedAt'].toDate(),
      );

      return _userModel;
    }

    return null;
  }

  /// ユーザーデータをfirestoreに格納
  Future insertUserData(UserModel userModel) async {
    // ドキュメント作成
    Map<String, dynamic> addObject = <String, dynamic>{};
    DateTime now = DateTime.now();

    addObject['id'] = userModel.id;
    addObject['name'] = userModel.name;
    addObject['lastLoginAt'] = now;
    addObject['isDeleted'] = false;
    addObject['createdAt'] = now;
    addObject['updatedAt'] = now;

    try {
      // 実際にfirestoreに格納する処理
      _firestore.collection(userDatas).doc(userModel.id).set(addObject);
      return;
    } catch (e) {
      print(e);
      return;
    }
  }

  Future updateLastLoginAt() async {
    // 新しい日付に更新
    Map<String, dynamic> updateData = {};
    DateTime now = DateTime.now();

    updateData['lastLoginAt'] = now;
    updateData['updatedAt'] = now;

    try {
      await _firestore
          .collection(userDatas)
          .doc(getMyUserId())
          .update(updateData);
    } catch (e) {
      print(e);
    }
  }
}
