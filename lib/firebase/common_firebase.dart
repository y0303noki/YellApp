import 'package:cloud_firestore/cloud_firestore.dart';

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

  /// firestoreのドキュメントをidで物理削除
  Future<void> deleteCoffeeData(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      print(e);
    }
  }
}
