import 'package:cherrilog/formatter/timestamp.dart';
import 'package:cherrilog/level/log_level.dart';

class CherriOptions {
  (CherriLogLevel, CherriLogLevel) logLevelRange = (CherriLogLevel.min, CherriLogLevel.max);

  String timeStampPattern = CherriFormatterTimeStampPattern.standardLongDateTime;

  bool useBuffer = true;

  int bufferLineLength = 30;

  Duration flushInterval = const Duration(milliseconds: 500);
}
