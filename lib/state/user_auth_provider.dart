import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yell_app/firebase/user_firebase.dart';
import 'package:yell_app/model/user.dart';

final userAuthProvider = ChangeNotifierProvider((ref) => UserAuth());

class UserAuth extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserFirebase _userFirebase = UserFirebase();

  // firebaseAuthのユーザーモデル
  User? _user;
  User? get user => _user;

  // yellApp用のユーザーモデル
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  // データを初期化
  void resetData() {
    notifyListeners();
  }

  UserAuth() {
    final User? _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      _user = _currentUser;
    }
  }

  // 匿名ログイン
  Future<UserCredential> _signInAnon() async {
    UserCredential user = await _auth.signInAnonymously();
    return user;
  }

  // サインアウト
  Future signOut() async {
    await _auth.signOut();
    await _signInAnon();
  }

  // ログイン処理
  // アプリを起動したときに呼ぶ
  // return True:成功 False:失敗
  Future<bool> autoSignIn() async {
    try {
      UserCredential _userCredential = await _signInAnon();
      _user = _userCredential.user;
      // 自動ログインできなかったらエラー
      if (_user == null) {
        print('自動ログインに失敗しました。');
        return false;
      }

      String userId = _user!.uid;

      // userIdでfirestoreにあるか探す
      UserModel? findUserData = await _userFirebase.fetchUserData(userId);

      // ない場合はユーザーを新規登録
      if (findUserData == null || findUserData.isDeleted) {
        DateTime now = DateTime.now();
        _userModel = UserModel(
          id: _user!.uid,
          isDeleted: false,
          createdAt: now,
          updatedAt: now,
        );

        // firestoreに追加
        await _userFirebase.insertUserData(_userModel!);
      } else {
        // ある場合はマスタの情報を利用
        _userModel = findUserData;
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
