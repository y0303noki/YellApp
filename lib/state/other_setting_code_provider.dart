import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/utility/utility.dart';

final otherSettingCodeProvider =
    ChangeNotifierProvider((ref) => OtherSettingCode());

class OtherSettingCode extends ChangeNotifier {
  String code = '';

  // データを初期化
  void resetData() {
    notifyListeners();
  }
}
