import 'package:flutter/material.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/utility/dialog_utility.dart';

class DialogWidget {
  // 間違えて達成ボタンを押したとき

  Future<String?> achieveCancelDialog(
    BuildContext dialogContext,
  ) async {
    String? result;
    await DialogUtil.show(
      context: dialogContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('取り消しますか？'),
          content: const Text('間違えて達成ボタンを押した場合は取り消すことができます'),
          actions: [
            TextButton(
              child: const Text('取り消す'),
              onPressed: () {
                result = 'YES';
                Navigator.of(context).pop('YES');
              },
            ),
            TextButton(
              child: const Text('なにもしない'),
              onPressed: () {
                result = 'NO';
                Navigator.of(context).pop('NO');
              },
            ),
          ],
        );
      },
    );
    return result;
  }
}
