import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yell_app/firebase/member_firebase.dart';
import 'package:yell_app/model/invite.dart';
import 'package:yell_app/state/user_auth_provider.dart';
import 'package:uuid/uuid.dart';

class InviteFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MemberFirebase _memberFirebase = MemberFirebase();
  final Uuid _uuid = const Uuid();

  // コレクション名前
  final String invite = 'invites';
  final String myGoals = 'my_goals';

  /// 招待コードを自分のuserIdで検索
  Future<InviteModel?> fetchOwnInviteFirst(String inviteId) async {
    final UserAuth _userAuth = UserAuth();
    final _userId = _userAuth.user != null ? _userAuth.user!.uid : '';
    final QuerySnapshot snapshots = await _firestore
        .collection(invite)
        .where('ownerUserId', isEqualTo: _userId)
        .where('id', isEqualTo: inviteId)
        .where('isDeleted', isEqualTo: false)
        .get();

    List<QueryDocumentSnapshot> docs = snapshots.docs;
    if (docs.isEmpty) {
      return null;
    }
    Map<String, dynamic> data = docs.first.data() as Map<String, dynamic>;
    final _inviteModel = InviteModel(
      id: data['id'],
      ownerUserId: data['ownerUserId'],
      code: data['code'],
      expiredAt: data['expiredAt']?.toDate(),
      isDeleted: data['isDeleted'] ?? false,
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
    );

    return _inviteModel;
  }

  /// 招待コードをコードで検索
  Future<InviteModel?> fetchInviteByCode(String code) async {
    // final UserAuth _userAuth = UserAuth();
    // final _userId = _userAuth.user != null ? _userAuth.user!.uid : '';
    final QuerySnapshot snapshots = await _firestore
        .collection(invite)
        .where('code', isEqualTo: code)
        .where('isDeleted', isEqualTo: false)
        .get();

    List<QueryDocumentSnapshot> docs = snapshots.docs;
    if (docs.isEmpty) {
      return null;
    }
    Map<String, dynamic> data = docs.first.data() as Map<String, dynamic>;
    final _inviteModel = InviteModel(
      id: data['id'],
      ownerUserId: data['ownerUserId'],
      goalId: data['goalId'],
      code: data['code'],
      expiredAt: data['expiredAt']?.toDate(),
      isDeleted: data['isDeleted'] ?? false,
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
    );

    return _inviteModel;
  }

  /// 招待コードをfirestoreに格納
  /// 発行が終わったらそのデータを返す
  /// mygoalを作ったときに既に作っておく
  Future<InviteModel?> insertInviteData(String docId, String goalId) async {
    // ドキュメント作成
    Map<String, dynamic> addObject = <String, dynamic>{};
    DateTime now = DateTime.now();
    // 有効期限は24時間
    DateTime nowAdd24h = now.add(const Duration(hours: 24));
    // uuidを生成してハイフンを削除し、10桁にする
    String code = _uuid.v4().replaceAll('-', '').substring(0, 10);
    final UserAuth _userAuth = UserAuth();
    final _userId = _userAuth.user != null ? _userAuth.user!.uid : '';

    addObject['id'] = docId;
    addObject['ownerUserId'] = _userId;
    addObject['goalId'] = goalId;
    addObject['code'] = code;
    addObject['expiredAt'] = nowAdd24h;
    addObject['isDeleted'] = false;
    addObject['createdAt'] = now;
    addObject['updatedAt'] = now;

    try {
      // 実際にfirestoreに格納する処理
      // final DocumentReference result =
      //     await _firestore.collection(invite).add(addObject);

      // docidを指定して追加
      await _firestore.collection(invite).doc(docId).set(addObject);
      // final data = await result.get();
      // final String docId = data.id;
      // CommonFirebase().updateDocId(invite, docId);

      // 格納するデータをそのまま返す
      final _inviteModel = InviteModel(
        id: docId,
        ownerUserId: addObject['ownerUserId'],
        goalId: addObject['goalId'],
        code: addObject['code'],
        expiredAt: addObject['expiredAt'],
        isDeleted: addObject['isDeleted'] ?? false,
        createdAt: addObject['createdAt'],
        updatedAt: addObject['updatedAt'],
      );

      return _inviteModel;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// 招待コードを更新
  Future<InviteModel?> updateInviteCode(String docId) async {
    // 新しい日付に更新
    Map<String, dynamic> updateData = {};
    DateTime now = DateTime.now();
    DateTime nowAdd24h = now.add(const Duration(hours: 24));
    String code = _uuid.v4().replaceAll('-', '').substring(0, 10);

    updateData['code'] = code;
    updateData['expiredAt'] = nowAdd24h;
    updateData['updatedAt'] = now;

    try {
      await _firestore.collection(invite).doc(docId).update(updateData);
      return await fetchOwnInviteFirst(docId);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
