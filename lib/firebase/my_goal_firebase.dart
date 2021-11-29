import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yell_app/firebase/common_firebase.dart';
import 'package:yell_app/firebase/invite_firebase.dart';
import 'package:yell_app/firebase/member_firebase.dart';
import 'package:yell_app/firebase/yell_message_firebase.dart';
import 'package:yell_app/model/invite.dart';
import 'package:yell_app/model/member.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/model/yell_message.dart';
import 'package:yell_app/state/user_auth_provider.dart';
import 'package:uuid/uuid.dart';

class MyGoalFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final InviteFirebase _inviteFirebase = InviteFirebase();
  final MemberFirebase _memberFirebase = MemberFirebase();
  final YellMessageFirebase _yellMessageFirebase = YellMessageFirebase();

  Uuid _uuid = Uuid();

  // コレクション名前
  final String myGoals = 'my_goals';

  // 自分の目標データとメンバーデータを取得
  Future<Map<String, Object?>?> fetchGoalAndMemberData() async {
    Map<String, Object?> result = {};
    MyGoalModel? goalData = await fetchGoalData();
    List<MemberModel> members = [];
    if (goalData != null) {
      members = await _fetchMember(goalData.id);
      result['goal'] = goalData;
      result['members'] = members;
    } else {
      return null;
    }

    // メンバーデータがあれば応援メッセージも取得
    if (members.isNotEmpty) {
      int dayOrTimes = 0;
      if (goalData.unitType == 0) {
        dayOrTimes = goalData.currentDay;
      } else {
        dayOrTimes = goalData.currentTimes;
      }
      // 対象となる日付のメッセージだけ取得
      List<YellMessage> messages = await _yellMessageFirebase
          .fetchMyGoalYellMessageByGoalIdAndNowTime(goalData.id, dayOrTimes);
      result['messages'] = messages;
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
      unitType: data['unitType'] ?? 0,
      currentDay: data['currentDay'] ?? 1,
      currentTimes: data['currentTimes'] ?? 1,
      inviteId: data['inviteId'] ?? '',
      updatedCurrentDayAt: data['updatedCurrentDayAt']?.toDate(),
      achievedDayOrTime: data['tempGoalModel'] ?? '',
      achievedMyComment: data['achievedMyComment'] ?? '',
      isDeleted: data['isDeleted'] ?? false,
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
    );

    return _myGoalModel;
  }

  Future<List<MemberModel>> _fetchMember(String goalId) async {
    return await _memberFirebase.fetchMemberDatasByGoalId(goalId);
  }

  // 自分が登録ずみの他人の目標一覧
  Future<List<MyGoalModel>> fetchRegistedOtherGoals() async {
    List<MemberModel> members = await _memberFirebase.fetchMemberDatas();
    List<String> goalIds = members.map((e) => e.ownerGoalId).toList();
    final QuerySnapshot snapshots = await _firestore
        .collection(myGoals)
        .where('id', whereIn: goalIds)
        .where('isDeleted', isEqualTo: false)
        .get();

    List<QueryDocumentSnapshot> docs = snapshots.docs;

    List<MyGoalModel> goalList = [];
    for (QueryDocumentSnapshot doc in docs) {
      MyGoalModel tempGoalModel = MyGoalModel();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      tempGoalModel.id = data['id'] ?? '';
      tempGoalModel.id = data['id'];
      tempGoalModel.goalTitle = data['title'] ?? '';
      tempGoalModel.myName = data['myName'] ?? '';
      tempGoalModel.unitType = data['unitType'] ?? 0;
      tempGoalModel.currentDay = data['currentDay'] ?? 1;
      tempGoalModel.currentTimes = data['currentTimes'] ?? 1;
      tempGoalModel.inviteId = data['inviteId'] ?? '';
      tempGoalModel.updatedCurrentDayAt = data['updatedCurrentDayAt']?.toDate();
      tempGoalModel.achievedDayOrTime = data['achievedDayOrTime'] ?? '';
      tempGoalModel.achievedMyComment = data['achievedMyComment'] ?? '';
      tempGoalModel.isDeleted = data['isDeleted'] ?? false;
      tempGoalModel.createdAt = data['createdAt'].toDate();
      tempGoalModel.updatedAt = data['updatedAt'].toDate();
      goalList.add(tempGoalModel);
    }
    return goalList;
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
    addObject['unitType'] = myGoalModel.unitType;
    addObject['currentDay'] = myGoalModel.unitType == 0 ? 1 : -1;
    addObject['currentTimes'] = myGoalModel.unitType == 1 ? 1 : -1;
    addObject['achievedDayOrTime'] = myGoalModel.achievedDayOrTime;
    addObject['achievedMyComment'] = myGoalModel.achievedMyComment;
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
        unitType: addObject['unitType'],
        currentDay: addObject['currentDay'],
        currentTimes: addObject['currentTimes'],
        inviteId: addObject['inviteId'],
        updatedCurrentDayAt: addObject['updatedCurrentDayAt'],
        achievedDayOrTime: addObject['achievedDayOrTime'],
        achievedMyComment: addObject['achievedMyComment'],
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

  /// 達成ボタンを押して継続日付（回数）を更新
  Future<void> updateAchieveCurrentDayOrTime(
      String docId,
      int unitType,
      int newDayOrTime,
      String achievedDayOrTime,
      String achievedMyComment) async {
    // 新しい日付に更新
    Map<String, dynamic> updateData = {};
    DateTime now = DateTime.now();
    if (unitType == 0) {
      updateData['currentDay'] = newDayOrTime;
    } else if (unitType == 1) {
      updateData['currentTimes'] = newDayOrTime;
    }
    updateData['achievedDayOrTime'] = achievedDayOrTime;
    updateData['achievedMyComment'] = achievedMyComment;
    updateData['updatedCurrentDayAt'] = now;
    updateData['updatedAt'] = now;

    try {
      await _firestore.collection(myGoals).doc(docId).update(updateData);
    } catch (e) {
      print(e);
    }
  }

  /// 指定されたidの目標データを物理削除する
  Future<void> deleteMyGoalData(String goalId) async {
    _firestore.collection(myGoals).doc(goalId).delete();
  }
}
