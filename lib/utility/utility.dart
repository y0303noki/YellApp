import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Utility {
  // dateTimeをStringに変換
  static String toDateFormatted(DateTime _dateTime) {
    initializeDateFormatting("ja_JP");
    var formatter = DateFormat('yyyy/MM/dd', "ja_JP");
    var formatted = formatter.format(_dateTime); // DateからString
    return formatted;
  }

  static String toStringyyyyMMddhh(DateTime _dateTime) {
    initializeDateFormatting("ja_JP");
    var formatter = DateFormat('yyyy/MM/dd HH:mm', "ja_JP");
    var formatted = formatter.format(_dateTime); // DateからString
    return formatted;
  }

  static String toStringddhh(DateTime? _dateTime) {
    if (_dateTime == null) {
      return '--:--';
    }
    String _date = '${_dateTime.day}日 ${_dateTime.hour}:${_dateTime.minute}';
    return _date;
  }

  // 頭文字を2文字切り取る。1文字だったら1文字だけ
  static String substring1or2(String _str) {
    if (_str.isEmpty) {
      return '';
    }
    if (_str.length == 1) {
      return _str.substring(0, 1);
    } else {
      return _str.substring(0, 2);
    }
  }
}
