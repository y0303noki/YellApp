import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

///  ロゴ選択ページ
class SelectLogoPage extends ConsumerWidget {
  const SelectLogoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('ロゴ選択'),
            Container(),
          ],
        ),
      ),
    );
  }
}
