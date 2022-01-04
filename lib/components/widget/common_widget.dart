import 'package:flutter/material.dart';
import 'package:yell_app/components/widget/button_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/state/my_achievment_provider.dart';
import 'package:yell_app/state/other_achievment_provider.dart';
import 'package:yell_app/utility/utility.dart';

class CommonWidget {
  // dateピッカーを表示して選択したDateTimeを返す
  static Future<DateTime?> selectDatePicker(
    BuildContext context,
    DateTime? _initialDateTime,
    DateTime? _firstDateTime,
  ) async {
    DateTime nowDate = DateTime.now();
    DateTime _firstDate = DateTime(nowDate.year, nowDate.month, nowDate.day);
    if (_firstDateTime != null) {
      _firstDate = DateTime(
          _firstDateTime.year, _firstDateTime.month, _firstDateTime.day + 1);
    }
    DateTime _initialDate = _firstDate;
    if (_initialDateTime != null) {
      _initialDate = DateTime(
          _initialDateTime.year, _initialDateTime.month, _initialDateTime.day);
    }

    final DateTime? selectDateTime = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime(_firstDate.year, _firstDate.month, _firstDate.day),
      lastDate: DateTime(_firstDate.year + 1),
    );
    return selectDateTime;
  }

  static double defaultDescriptionWidth(double deviceWidth) {
    return deviceWidth - 30;
  }

  static double defaultDescriptionHeight(double deviceWidth) {
    return (deviceWidth - 20) / 2 - 10;
  }

  /// ボタンの基本色
  static Color? myDefaultColor() {
    return Colors.lightGreen[100];
  }

  static Decoration defaultDescriptionDecoration() {
    return BoxDecoration(
      color: Colors.grey.withOpacity(0.2),
      borderRadius: BorderRadius.circular(20),
    );
  }

  /// 応援のデフォルト色
  static Color? otherDefaultColor() {
    return Colors.lightBlue[100];
  }

  static String quickAction0() {
    return 'いいね!';
  }

  static String quickAction1() {
    return 'えらい!';
  }

  static String quickAction2() {
    return 'すごくえらい!';
  }

  static String quickAction3() {
    return '次もがんばろう';
  }

  static String quickAction4() {
    return 'またあした';
  }

  static String quickAction5() {
    return 'おつかれさま';
  }

  static Widget descriptionWidget(Widget _leftWidget, String _text) {
    return // 説明
        Container(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
        left: 10,
        right: 10,
      ),
      decoration: CommonWidget.defaultDescriptionDecoration(),
      child: Row(
        children: [
          _leftWidget,
          Flexible(
            child: Center(
              child: TextWidget.subTitleText1(_text),
            ),
          ),
        ],
      ),
    );
  }

  static Widget lightbulbIcon() {
    return Container(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: 5,
        right: 5,
      ),
      margin: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        Icons.lightbulb,
        color: Colors.yellow[300],
        size: 40,
      ),
    );
  }

//
  static achieveTitleWidget(
    MyAchievment? _myAchievment,
    OtherAchievment? _otherAchievment,
    Widget _logoWidget,
    DateTime _startDateTime,
  ) {
    int count = -1; // カウント
    String title = ''; // タイトル
    String lastTimeDate = ''; // 前回達成日時
    String resetTime = ''; // リセットタイム

    if (_myAchievment != null && _otherAchievment == null) {
      // オーナー画面
      count = _myAchievment.continuationCount;
      title = _myAchievment.goalTitle;
      lastTimeDate = Utility.toStringddhh(_myAchievment.updatedCurrentDayAt);
      resetTime = _myAchievment.resetHour.toString();
    } else if (_myAchievment == null && _otherAchievment != null) {
      // 応援画面
      count = _otherAchievment.continuationCount;
      title = _otherAchievment.goalTitle;
      lastTimeDate = Utility.toStringddhh(_otherAchievment.updatedCurrentDayAt);
    }
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        bottom: 20,
        left: 10,
        right: 10,
      ),
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 1.0,
            blurRadius: 10.0,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 5,
              bottom: 10,
            ),
            child: Row(
              children: [
                TextWidget.headLineText6('# $count'),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // タイトル
              Expanded(
                child: Center(
                  child: TextWidget.headLineText4(title),
                ),
              ),
              // ロゴ
              _logoWidget,
            ],
          ),
          const Divider(
            color: Colors.grey,
          ),
          _achieveDescriptionRow(
              'はじめた日', '${Utility.toDateFormatted(_startDateTime)}'),
          _achieveDescriptionRow(
            '前回',
            lastTimeDate,
          ),
          resetTime.isEmpty
              ? Container()
              : _achieveDescriptionRow('リセット時間', resetTime),
        ],
      ),
    );
  }

  // したの追加部分
  static Widget _achieveDescriptionRow(String key, String value) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      TextWidget.subTitleText2(key),
      TextWidget.subTitleText3(value),
    ]);
  }

  static Widget myInfoWidget(MyAchievment myAchievment) {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        bottom: 20,
        left: 10,
        right: 10,
      ),
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 1.0,
            blurRadius: 10.0,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Text('#23'),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 自分のアイコン
              // Container(
              //   margin: const EdgeInsets.only(
              //     left: 10,
              //     right: 10,
              //   ),
              //   child: ButtonWidget.iconMainWidget(
              //     Utility.substring1or2(myAchievment.myName),
              //   ),
              // ),
              // Text(
              //   myAchievment.myName,
              //   style: const TextStyle(
              //     fontSize: 28,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
            ],
          ),
          // ひとこと
          Container(
            margin: const EdgeInsets.only(
              top: 20,
              left: 10,
              right: 10,
            ),
            child: Text(
              myAchievment.achieveComment,
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }

// ロゴ
  static Widget logoByNumber(int _num) {
    String _imagePath = '';
    switch (_num) {
      case 0:
        _imagePath = 'images/run.png';
        break;
      case 1:
        _imagePath = 'images/souzi.png';
        break;
      case 2:
        _imagePath = 'images/benkyou.png';
        break;
      case 3:
        _imagePath = 'images/kintore.png';
        break;
      case 4:
        _imagePath = 'images/pc.png';
        break;
      case 5:
        _imagePath = 'images/sumaho.png';
        break;
      default:
        _imagePath = 'images/noimage.png';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(
        left: 10,
        right: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 3),
      ),
      child: Image.asset(
        _imagePath,
        width: 60,
      ),
    );
  }
}
