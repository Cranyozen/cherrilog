import 'package:intl/intl.dart';

class CherriFormatterTimestampPattern {
  /// Pattern: `yyyy-MM-dd HH:mm:ss`
  ///     e.g: `2021-07-01 12:34:56`
  static const String dateTimeFormat1 = 'yyyy-MM-dd HH:mm:ss';

  /// Pattern: `yyyy/MM/dd HH:mm:ss`
  ///     e.g: `2022/04/05 12:34:56`
  static const String dateTimeFormat2 = 'yyyy/MM/dd HH:mm:ss';

  /// Pattern: `MMM dd, yyyy - HH:mm:ss`
  ///     e.g: `Apr 05, 2022 - 12:34:56`
  static const String dateTimeFormat3 = 'MMM dd, yyyy - HH:mm:ss';

  /// Pattern: `dd-MM-yyyy HH:mm:ss`
  ///     e.g: `05-04-2022 12:34:56`
  static const String dateTimeFormat4 = 'dd-MM-yyyy HH:mm:ss';

  /// Pattern: `dd/MM/yyyy kk:mm:ss`
  ///     e.g: `05/04/2022 12:34:56`
  static const String dateTimeFormat5 = 'dd/MM/yyyy HH:mm:ss';

  /// Pattern: `HH:mm:ss`
  ///     e.g: `12:34:56`
  static const String timeFormat1 = 'HH:mm:ss';

  /// Pattern: `yyyy-MM-dd`
  ///     e.g: `2022-04-05`
  static const String dateFormat1 = 'yyyy-MM-dd';

  /// Pattern: `MM/dd/yyyy`
  ///     e.g: `04/05/2022`
  static const String dateFormat2 = 'MM/dd/yyyy';
}

class CherriFormatterTimestamp {
  static String format(DateTime timestamp, String pattern) {
    return DateFormat(pattern).format(timestamp);
  }
}
