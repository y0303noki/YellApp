import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yell_app/model/myGoal.dart';
import 'package:yell_app/model/user.dart';

class CommonFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// firestoreのidでドキュメントのidも更新する
  Future<void> updateDocId(String collection, String docId) async {
    Map<String, dynamic> updateData = {};
    updateData['id'] = docId;

    try {
      await _firestore.collection(collection).doc(docId).update(updateData);
    } catch (e) {
      print(e);
    }
  }
}
