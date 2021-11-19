import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yell_app/firebase/common_firebase.dart';
import 'package:yell_app/firebase/invite_firebase.dart';
import 'package:yell_app/firebase/member_firebase.dart';
import 'package:yell_app/model/invite.dart';
import 'package:yell_app/model/member.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/state/user_auth_provider.dart';
import 'package:uuid/uuid.dart';

class MyGoalFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final InviteFirebase _inviteFirebase = InviteFirebase();
  final MemberFirebase _memberFirebase = MemberFirebase();
  Uuid _uuid = Uuid();

  // コレクション名前
  final String myGoals = 'my_goals';

  // 自分の目標データとメンバーデータを取得
  Future<Map<String, Object?>?> fetchGoalAndMemberData() async {
    Map<String, Object?> result = {};
    MyGoalModel? goalData = await fetchGoalData();
    if (goalData != null) {
      List<MemberModel> members = await _fetchMember(goalData.id);
      result['goal'] = goalData;
      result['members'] = members;
    } else {
      return null;
    }
    return result;
  }

  /// 目標を取得する
  /// 引数が指定されなければ自分のデータ
  Future<MyGoalModel?> fetchGoalData({String userId = ''}) async {
    if (userId.isEmpty) {
      final UserAuth _userAuth = UserAuth();
      userId = _userAuth.user != null ? _userAuth.user!.uid : '';
    }
    final QuerySnapshot snapshots = await _firestore
        .collection(myGoals)
        .where('userId', isEqualTo: userId)
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
      inviteId: data['inviteId'] ?? '',
      updatedCurrentDayAt: data['updatedCurrentDayAt']?.toDate(),
      isDeleted: data['isDeleted'] ?? false,
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
    );

    return _myGoalModel;
  }

  Future<List<MemberModel>> _fetchMember(String goalId) async {
    return await _memberFirebase.fetchMemberDatasByGoalId(goalId);
  }

  /// 自分の目標をfirestoreに格納
  Future<Map<String, Object?>> insertMyGoalData(MyGoalModel myGoalModel) async {
    Map<String, Object?> resultMap = {}; // 返り値
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

    // inviteのデータも作っておく
    String inviteDocId = _uuid.v4().replaceAll('-', '').substring(0, 20);
    addObject['inviteId'] = inviteDocId;

    try {
      // 実際にfirestoreに格納する処理
      final DocumentReference result =
          await _firestore.collection(myGoals).add(addObject);
      final data = await result.get();
      final String docId = data.id;
      CommonFirebase().updateDocId(myGoals, docId);

      InviteModel? _inviteModel =
          await _inviteFirebase.insertInviteData(inviteDocId);
      resultMap['invite'] = _inviteModel;

      final _myGoalModel = MyGoalModel(
        id: docId,
        goalTitle: addObject['title'],
        myName: addObject['myName'],
        howManyTimes: addObject['howManyTimes'],
        currentDay: addObject['currentDay'],
        inviteId: addObject['inviteId'],
        updatedCurrentDayAt: addObject['updatedCurrentDayAt'],
        isDeleted: addObject['isDeleted'] ?? false,
        createdAt: addObject['createdAt'],
        updatedAt: addObject['updatedAt'],
      );

      resultMap['myGoal'] = _myGoalModel;

      return resultMap;
    } catch (e) {
      print(e);
      return {};
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
