class CherriLogLevel {
  static CherriLogLevel any = CherriLogLevel('Any', 'ANY');

  static CherriLogLevel fatal = CherriLogLevel('Fatal', 'FAT')..ansiColor = '91m';

  static CherriLogLevel error = CherriLogLevel('Error', 'ERR')..ansiColor = '31m';

  static CherriLogLevel warning = CherriLogLevel('Warning', 'WAR')..ansiColor = '33m';

  static CherriLogLevel info = CherriLogLevel('Info', 'INF')..ansiColor = '32m';

  static CherriLogLevel debug = CherriLogLevel('Debug', 'DBG')..ansiColor = '34m';

  static CherriLogLevel all = CherriLogLevel('All', 'ALL');

  static List<CherriLogLevel> order = [
    CherriLogLevel.any,
    CherriLogLevel.fatal,
    CherriLogLevel.error,
    CherriLogLevel.warning,
    CherriLogLevel.info,
    CherriLogLevel.debug,
    CherriLogLevel.all,
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

  CherriLogLevel(this.name, this.abbreviation);

  bool operator >(CherriLogLevel other) {
    return order.indexOf(this) > order.indexOf(other);
  }

  bool operator >=(CherriLogLevel other) {
    return order.indexOf(this) >= order.indexOf(other);
  }

  bool operator <(CherriLogLevel other) {
    return order.indexOf(this) < order.indexOf(other);
  }

  bool operator <=(CherriLogLevel other) {
    return order.indexOf(this) <= order.indexOf(other);
  }
}
