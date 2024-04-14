import 'package:cherrilog/formatter/timestamp.dart';
import 'package:cherrilog/level/log_level.dart';
import 'package:cherrilog/level/log_level_ranges.dart';

class CherriOptions {
  (CherriLogLevel, CherriLogLevel) logLevelRange = CherriLogLevelRanges.all;

  String timeStampPattern = CherriFormatterTimeStampPattern.standardLongDateTime;

  bool useBuffer = true;

  int bufferLineLength = 30;

  Duration flushInterval = const Duration(milliseconds: 500);
}
