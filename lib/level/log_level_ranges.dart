import 'package:cherrilog/level/log_level.dart';

class CherriLogLevelRanges {
  static (CherriLogLevel, CherriLogLevel) all = (CherriLogLevel.nether, CherriLogLevel.upperBond);

  static (CherriLogLevel, CherriLogLevel) major = (CherriLogLevel.warning, CherriLogLevel.fatal);

  static (CherriLogLevel, CherriLogLevel) debug = all;

  static (CherriLogLevel, CherriLogLevel) release = (CherriLogLevel.error, CherriLogLevel.fatal);

  static (CherriLogLevel, CherriLogLevel) upTo(CherriLogLevel level) => (CherriLogLevel.upperBond, level);

  static (CherriLogLevel, CherriLogLevel) downTo(CherriLogLevel level) => (CherriLogLevel.nether, level);
}
