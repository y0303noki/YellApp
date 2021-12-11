import 'package:flutter/material.dart';
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

  // 達成ときにひとことメッセージのためのダイアログ
  Future<String> achievedMyMessagelDialog(
    BuildContext dialogContext,
  ) async {
    TextEditingController _textController = TextEditingController();
    String result = '';
    await DialogUtil.show(
      context: dialogContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ひとこと残しますか？'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: "ここに入力"),
          ),
          actions: [
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                result = '';
                Navigator.of(context).pop('NO');
              },
            ),
            TextButton(
              child: Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 5,
                  bottom: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '送信',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                result = _textController.text;
                Navigator.of(context).pop('YES');
              },
            ),
          ],
        );
      },
    );
    return result;
  }

  // 自分の目標を終了してデータを削除する
  Future<String?> endMyGoalDialog(
    BuildContext dialogContext,
  ) async {
    String? result;
    await DialogUtil.show(
      context: dialogContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('削除しますか？'),
          content: const Text(''),
          actions: [
            TextButton(
              child: const Text(
                '削除する',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                result = 'DELETE';
                Navigator.of(context).pop('DELETE');
              },
            ),
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                result = 'CANCEL';
                Navigator.of(context).pop('CANCEL');
              },
            ),
          ],
        );
      },
    );
    return result;
  }
}
