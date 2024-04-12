import 'package:cherrilog/formatter/timestamp.dart';
import 'package:cherrilog/model/log_level.dart';

class CherriOptions {
  CherriLogLevel maximumLevel = CherriLogLevel.warning;

  CherriLogLevel minimumLevel = CherriLogLevel.all;

  String timeStampPattern = CherriFormatterTimeStampPattern.standardLongDateTime;

  bool useBuffer = true;

  int bufferLineLength = 30;

  Duration flushInterval = const Duration(milliseconds: 500);
}
