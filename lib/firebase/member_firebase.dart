import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yell_app/firebase/common_firebase.dart';
import 'package:yell_app/model/member.dart';
import 'package:yell_app/state/user_auth_provider.dart';

// Ownerとその応援する人を紐づける
class MemberFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // コレクション名前
  final String members = 'members';

  /// 自分が招待コードを入力して応援中のデータを取得する
  Future<List<MemberModel>> fetchMemberDatas() async {
    final UserAuth _userAuth = UserAuth();
    String userId = _userAuth.user != null ? _userAuth.user!.uid : '';

    final QuerySnapshot snapshots = await _firestore
        .collection(members)
        .where('memberUserId', isEqualTo: userId)
        .where('isDeleted', isEqualTo: false)
        .orderBy('updatedAt', descending: true)
        .limit(10) // 10個までにしておく
        .get();

    List<QueryDocumentSnapshot> docs = snapshots.docs;
    if (docs.isEmpty) {
      return [];
    }

    // firestoreから取得したデータを変換
    List<MemberModel> memberList = [];
    for (QueryDocumentSnapshot doc in docs) {
      MemberModel tempMemberModel = MemberModel();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      tempMemberModel.id = data['id'] ?? '';
      tempMemberModel.memberUserId = data['memberUserId'] ?? '';
      tempMemberModel.ownerGoalId = data['ownerGoalId'] ?? '';
      tempMemberModel.isDeleted = data['isDeleted'] ?? false;
      tempMemberModel.createdAt = data['createdAt']?.toDate();
      tempMemberModel.updatedAt = data['updatedAt']?.toDate();
      memberList.add(tempMemberModel);
    }

    return memberList;
  }

  /// 自分の目標に紐づいているメンバーを取得する
  Future<List<MemberModel>> fetchMemberDatasByGoalId(String goalId) async {
    final QuerySnapshot snapshots = await _firestore
        .collection(members)
        .where('ownerGoalId', isEqualTo: goalId)
        .where('isDeleted', isEqualTo: false)
        .limit(5) // 5個までにしておく
        .get();

    List<QueryDocumentSnapshot> docs = snapshots.docs;
    if (docs.isEmpty) {
      return [];
    }

    // firestoreから取得したデータを変換
    List<MemberModel> memberList = [];
    for (QueryDocumentSnapshot doc in docs) {
      MemberModel tempMemberModel = MemberModel();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      tempMemberModel.id = data['id'] ?? '';
      tempMemberModel.memberUserId = data['memberUserId'] ?? '';
      tempMemberModel.memberName = data['memberName'] ?? '';
      tempMemberModel.ownerGoalId = data['ownerGoalId'] ?? '';
      tempMemberModel.isDeleted = data['isDeleted'] ?? false;
      tempMemberModel.createdAt = data['createdAt']?.toDate();
      tempMemberModel.updatedAt = data['updatedAt']?.toDate();
      memberList.add(tempMemberModel);
    }

    return memberList;
  }

  /// メンバーの情報をfirestoreに格納
  Future<Map<String, Object?>> insertMemberData(MemberModel memberModel) async {
    Map<String, Object?> resultMap = {}; // 返り値
    // ドキュメント作成
    Map<String, dynamic> addObject = <String, dynamic>{};
    DateTime now = DateTime.now();
    final UserAuth _userAuth = UserAuth();
    final _userId = _userAuth.user != null ? _userAuth.user!.uid : '';

    addObject['memberUserId'] = _userId;
    addObject['ownerGoalId'] = memberModel.ownerGoalId;
    addObject['memberName'] = memberModel.memberName;
    addObject['isDeleted'] = false;
    addObject['createdAt'] = now;
    addObject['updatedAt'] = now;

    try {
      // 実際にfirestoreに格納する処理
      final DocumentReference result =
          await _firestore.collection(members).add(addObject);
      final data = await result.get();
      final String docId = data.id;
      CommonFirebase().updateDocId(members, docId);

      return resultMap;
    } catch (e) {
      print(e);
      return {};
    }
  }

  /// 指定されたidのメンバーデータを物理削除する
  Future<void> deleteMemberData(String memberId) async {
    _firestore.collection(members).doc(memberId).delete();
  }
}
