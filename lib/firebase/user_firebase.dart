import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yell_app/model/user.dart';

class UserFirebase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // コレクション名前
  final String userDatas = 'user_infos';

  /// userIdで検索して見つかれば返す。なければnullを返す
  Future<UserModel?> fetchUserData(String userId) async {
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
}
