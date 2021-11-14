import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/model/invite.dart';
import 'package:yell_app/utility/utility.dart';

final inviteProvider = ChangeNotifierProvider((ref) => Invite());

class Invite extends ChangeNotifier {
  String id = ''; // firestoreのdocId
  String code = ''; // 招待コード
  DateTime? expiredAt; // 有効期限
  String expiredAtStr = ''; // 有効期限を文字列で

  // 招待コード更新
  void refreshInviteCode(String _code) {
    code = _code;
    notifyListeners();
  }

  void setInviteCode(String _code) {
    code = _code;
  }

  void setInitialData(InviteModel inviteModel) {
    id = inviteModel.id;
    code = inviteModel.code;
    expiredAt = inviteModel.expiredAt;
    if (expiredAt == null) {
      expiredAtStr = '';
    } else {
      expiredAtStr = Utility.toStringyyyyMMddhh(expiredAt!);
    }
  }

  // 招待コードを更新して再描画
  void setExpiredAt(String _code, DateTime? _expiredAt) {
    if (_expiredAt == null) {
      return;
    }
    code = _code;
    expiredAt = _expiredAt;
    expiredAtStr = Utility.toStringyyyyMMddhh(_expiredAt);
    notifyListeners();
  }

  void refreshInvite() {
    notifyListeners();
  }
}
