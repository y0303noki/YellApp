import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yell_app/firebase/common_firebase.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/model/user.dart';
import 'package:yell_app/state/user_auth_provider.dart';

class MyGoalFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // コレクション名前
  final String myGoals = 'my_goals';

  /// 自分の目標を取得する
  Future<MyGoalModel?> fetchMyGoalData() async {
    final UserAuth _userAuth = UserAuth();
    final _userId = _userAuth.user != null ? _userAuth.user!.uid : '';
    final QuerySnapshot snapshots = await _firestore
        .collection(myGoals)
        .where('id', isEqualTo: _userId)
        .get();

    List<QueryDocumentSnapshot> docs = snapshots.docs;
    if (docs.isEmpty) {
      return null;
    }
    Map<String, dynamic> data = docs.first.data() as Map<String, dynamic>;
    final _myGoalModel = MyGoalModel(
      id: data['id'],
      goalTitle: data['title'],
      howManyTimes: data['howManyTimes'],
      isDeleted: data['isDeleted'] ?? false,
      startAt: data['startAt'].toDate(),
      endAt: data['endAt']?.toDate(),
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
    );

    return _myGoalModel;
  }

  /// ユーザーデータをfirestoreに格納
  Future insertMyGoalData(MyGoalModel myGoalModel) async {
    // ドキュメント作成
    Map<String, dynamic> addObject = <String, dynamic>{};
    DateTime now = DateTime.now();
    final UserAuth _userAuth = UserAuth();
    final _userId = _userAuth.user != null ? _userAuth.user!.uid : '';

    addObject['userId'] = _userId;
    addObject['title'] = myGoalModel.goalTitle;
    addObject['howManyTimes'] = myGoalModel.howManyTimes;
    addObject['startAt'] = myGoalModel.startAt;
    addObject['endAt'] = myGoalModel.endAt;
    addObject['isDeleted'] = false;
    addObject['createdAt'] = now;
    addObject['updatedAt'] = now;

    try {
      // 実際にfirestoreに格納する処理
      final DocumentReference result =
          await _firestore.collection(myGoals).add(addObject);
      final data = await result.get();
      final String docId = data.id;
      CommonFirebase().updateDocId(myGoals, docId);

      return;
    } catch (e) {
      print(e);
      return;
    }
  }
}
