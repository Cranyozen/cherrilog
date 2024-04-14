import 'package:cherrilog/formatter/timestamp.dart';
import 'package:cherrilog/level/log_level.dart';

class CherriOptions {
  CherriLogLevel maximumLevel = CherriLogLevel.all;

  CherriLogLevel minimumLevel = CherriLogLevel.warning;

  String timeStampPattern = CherriFormatterTimeStampPattern.standardLongDateTime;

  bool useBuffer = true;

  int bufferLineLength = 30;

  Duration flushInterval = const Duration(milliseconds: 500);
}
