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
        .where('userId', isEqualTo: _userId)
        .where('isDeleted', isEqualTo: false)
        .get();

    List<QueryDocumentSnapshot> docs = snapshots.docs;
    if (docs.isEmpty) {
      return null;
    }
    Map<String, dynamic> data = docs.first.data() as Map<String, dynamic>;
    final _myGoalModel = MyGoalModel(
      id: data['id'],
      goalTitle: data['title'] ?? '',
      myName: data['myName'] ?? '',
      howManyTimes: data['howManyTimes'] ?? 1,
      currentDay: data['currentDay'] ?? 1,
      updatedCurrentDayAt: data['updatedCurrentDayAt']?.toDate(),
      isDeleted: data['isDeleted'] ?? false,
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
    );

    return _myGoalModel;
  }

  /// 自分の目標をfirestoreに格納
  Future<String> insertMyGoalData(MyGoalModel myGoalModel) async {
    // ドキュメント作成
    Map<String, dynamic> addObject = <String, dynamic>{};
    DateTime now = DateTime.now();
    final UserAuth _userAuth = UserAuth();
    final _userId = _userAuth.user != null ? _userAuth.user!.uid : '';

    addObject['userId'] = _userId;
    addObject['title'] = myGoalModel.goalTitle;
    addObject['myName'] = myGoalModel.myName;
    addObject['howManyTimes'] = myGoalModel.howManyTimes;
    addObject['currentDay'] = 1;
    addObject['updatedCurrentDayAt'] = null;
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

      return docId;
    } catch (e) {
      print(e);
      return '';
    }
  }

  /// 達成ボタンを押して継続日付を更新
  Future<void> updateAchieveCurrentDay(String docId, int newDay) async {
    // 新しい日付に更新
    Map<String, dynamic> updateData = {};
    DateTime now = DateTime.now();
    updateData['currentDay'] = newDay;
    updateData['updatedCurrentDayAt'] = now;
    updateData['updatedAt'] = now;

    try {
      await _firestore.collection(myGoals).doc(docId).update(updateData);
    } catch (e) {
      print(e);
    }
  }
}
