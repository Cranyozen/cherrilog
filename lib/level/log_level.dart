import 'dart:math' as math show max, min;

class CherriLogLevel {
  static CherriLogLevel max = CherriLogLevel('Max', 'MAX');

  static CherriLogLevel fatal = CherriLogLevel('Fatal', 'FTL', ansiColor: '91m');

  static CherriLogLevel error = CherriLogLevel('Error', 'ERR', ansiColor: '31m');

  static CherriLogLevel warning = CherriLogLevel('Warning', 'WAR', ansiColor: '33m');

  static CherriLogLevel info = CherriLogLevel('Info', 'INF', ansiColor: '32m');

  static CherriLogLevel debug = CherriLogLevel('Debug', 'DBG', ansiColor: '34m');

  static CherriLogLevel min = CherriLogLevel('Min', 'MIN');

  static List<CherriLogLevel> order = [
    CherriLogLevel.max,
    CherriLogLevel.fatal,
    CherriLogLevel.error,
    CherriLogLevel.warning,
    CherriLogLevel.info,
    CherriLogLevel.debug,
    CherriLogLevel.min,
  ];

  static void insertLevelAfter(CherriLogLevel origin, CherriLogLevel level) {
    order.insert(order.indexOf(origin), level);
  }

  static void removeLevel(CherriLogLevel level) {
    order.remove(level);
  }

  final String name;

  final String abbreviation;

  late String? ansiColor;

  String get ansiColorTemplate => "\x1B[$ansiColor@message\x1B[0m";

  CherriLogLevel(this.name, this.abbreviation, {this.ansiColor});

  bool inRange((CherriLogLevel, CherriLogLevel) range) {
    var indexA = order.indexOf(range.$1);
    var indexB = order.indexOf(range.$2);
    var maxIndex = math.max(indexA, indexB);
    var minIndex = math.min(indexA, indexB);
    return order.indexOf(this) >= minIndex && order.indexOf(this) <= maxIndex;
  }
}
