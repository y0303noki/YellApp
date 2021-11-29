import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yell_app/firebase/common_firebase.dart';
import 'package:yell_app/model/yell_message.dart';
import 'package:yell_app/state/user_auth_provider.dart';
import 'package:uuid/uuid.dart';

class YellMessageFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Uuid _uuid = Uuid();

  // コレクション名前
  final String yellMessage = 'yell_messages';

  /// 応援メッセージをgoalIdで検索
  Future<List<YellMessage>> fetchMyGoalYellMessage(String goalId) async {
    final QuerySnapshot snapshots = await _firestore
        .collection(yellMessage)
        .where('goalId', isEqualTo: goalId)
        .where('isDeleted', isEqualTo: false)
        .get();

    List<QueryDocumentSnapshot> docs = snapshots.docs;
    return _mapYellMEssageFromDocs(docs);
  }

  /// 応援メッセージを自分のGoalIdと現在の分だけ取得
  Future<List<YellMessage>> fetchMyGoalYellMessageByGoalIdAndNowTime(
      String goalId, int dayOrTimes) async {
    List<int> list = [dayOrTimes - 1, dayOrTimes, dayOrTimes + 1];
    final QuerySnapshot snapshots = await _firestore
        .collection(yellMessage)
        .where('goalId', isEqualTo: goalId)
        .where('dayOrTimes', whereIn: list)
        .where('isDeleted', isEqualTo: false)
        .get();

    List<QueryDocumentSnapshot> docs = snapshots.docs;
    return _mapYellMEssageFromDocs(docs);
  }

  /// 応援メッセージを追加
  Future<YellMessage?> insertYellMessageData(
      YellMessage yellMessageModel) async {
    // ドキュメント作成
    Map<String, dynamic> addObject = <String, dynamic>{};
    DateTime now = DateTime.now();

    final UserAuth _userAuth = UserAuth();
    final _userId = _userAuth.user != null ? _userAuth.user!.uid : '';

    addObject['memberId'] = _userId;
    addObject['goalId'] = yellMessageModel.goalId;
    addObject['message'] = yellMessageModel.message;
    addObject['dayOrTimes'] = yellMessageModel.dayOrTimes;
    addObject['isDeleted'] = false;
    addObject['createdAt'] = now;
    addObject['updatedAt'] = now;

    try {
      // 実際にfirestoreに格納する処理
      final DocumentReference result =
          await _firestore.collection(yellMessage).add(addObject);

      final data = await result.get();
      final String docId = data.id;
      CommonFirebase().updateDocId(yellMessage, docId);

      final yellMessageData = YellMessage(
        id: docId,
        goalId: yellMessageModel.goalId,
        memberId: yellMessageModel.memberId,
        message: yellMessageModel.message,
        isDeleted: yellMessageModel.isDeleted,
        createdAt: yellMessageModel.createdAt,
        updatedAt: yellMessageModel.updatedAt,
      );

      return yellMessageData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // docsを応援メッセージにマッピングする
  List<YellMessage> _mapYellMEssageFromDocs(List<QueryDocumentSnapshot> docs) {
    if (docs.isEmpty) {
      return [];
    }

    List<YellMessage> yellMessages = [];
    for (QueryDocumentSnapshot doc in docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      YellMessage tempYellMessage = YellMessage(
        id: data['id'] ?? '',
        goalId: data['goalId'] ?? '',
        dayOrTimes: data['dayOrTimes'] ?? 0,
        memberId: data['memberId'] ?? '',
        message: data['message'] ?? '',
        isDeleted: data['isDeleted'] ?? false,
        createdAt: data['createdAt']?.toDate(),
        updatedAt: data['updatedAt']?.toDate(),
      );
      yellMessages.add(tempYellMessage);
    }
    return yellMessages;
  }
}
