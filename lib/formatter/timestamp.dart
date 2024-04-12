import 'package:intl/intl.dart';

class CherriFormatterTimestampPattern {
  /// Pattern: `yyyy-MM-dd HH:mm:ss`
  ///     e.g: `2021-07-01 12:34:56`
  static const String standardLongDateTime = 'yyyy-MM-dd HH:mm:ss';

  /// Pattern: `yyyy/MM/dd HH:mm:ss`
  ///     e.g: `2022/04/05 12:34:56`
  static const String standardLongSlashDateTime = 'yyyy/MM/dd HH:mm:ss';

  /// Pattern: `dd-MM-yyyy HH:mm:ss`
  ///     e.g: `05-04-2022 12:34:56`
  static const String reversedLongDateTime = 'dd-MM-yyyy HH:mm:ss';

  /// Pattern: `dd/MM/yyyy kk:mm:ss`
  ///     e.g: `05/04/2022 12:34:56`
  static const String reversedLongSlashDateTime = 'dd/MM/yyyy HH:mm:ss';

  /// Pattern: `MMM dd, yyyy - HH:mm:ss`
  ///     e.g: `Apr 05, 2022 - 12:34:56`
  static const String standardFullDateTime = 'MMM dd, yyyy - HH:mm:ss';

  /// Pattern: `HH:mm:ss`
  ///     e.g: `12:34:56`
  static const String standardLongTime = 'HH:mm:ss';

  /// Pattern: `yyyy-MM-dd`
  ///     e.g: `2022-04-05`
  static const String standardLongDate = 'yyyy-MM-dd';

  /// Pattern: `MM/dd/yyyy`
  ///     e.g: `04/05/2022`
  static const String reversedLongDate = 'MM/dd/yyyy';
}

class CherriFormatterTimestamp {
  static String format(DateTime timestamp, String pattern) {
    return DateFormat(pattern).format(timestamp);
  }
}
