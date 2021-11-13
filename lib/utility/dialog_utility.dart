import 'package:flutter/material.dart';

class DialogUtil {
  static Future show({
    required BuildContext context,
    required Widget Function(
      BuildContext context,
    )
        builder,
  }) async {
    await showDialog(
      /// Dialogの周囲の黒い部分をタップしても閉じないようにする
      barrierDismissible: false,
      context: context,
      builder: (_context) {
        return WillPopScope(
          /// 戻るボタンを無効にする
          onWillPop: () async => false,
          child: builder(_context),
        );
      },
    );
  }
}
