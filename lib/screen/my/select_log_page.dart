import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';

///  ロゴ選択ページ
class SelectLogoPage extends ConsumerWidget {
  const SelectLogoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
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
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2,
                  children: _logItem(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _logItem(BuildContext context) {
    return [
      _tileContainer(
        context,
        'RUN',
        'images/run.png',
        0,
      ),
      _tileContainer(
        context,
        '掃除',
        'images/souzi.png',
        1,
      ),
      _tileContainer(
        context,
        '勉強',
        'images/benkyou.png',
        2,
      ),
      _tileContainer(
        context,
        '筋トレ',
        'images/kintore.png',
        3,
      ),
      _tileContainer(
        context,
        'PC',
        'images/pc.png',
        4,
      ),
      _tileContainer(
        context,
        'スマホ',
        'images/sumaho.png',
        5,
      ),
    ];
  }

  Widget _tileContainer(
      BuildContext context, String _text, String _imagePath, int _index) {
    return GestureDetector(
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
            color: CommonWidget.otherDefaultColor()!,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                _imagePath,
                width: 80,
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
