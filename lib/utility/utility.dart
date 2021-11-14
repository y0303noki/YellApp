import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Utility {
  // dateTimeをStringに変換
  static String toDateFormatted(DateTime _dateTime) {
    initializeDateFormatting("ja_JP");
    var formatter = DateFormat('yyyy/MM/dd(E)', "ja_JP");
    var formatted = formatter.format(_dateTime); // DateからString
    return formatted;
  }

  static String toStringyyyyMMddhh(DateTime _dateTime) {
    initializeDateFormatting("ja_JP");
    var formatter = DateFormat('yyyy/MM/dd HH:mm', "ja_JP");
    var formatted = formatter.format(_dateTime); // DateからString
    return formatted;
  }
}
