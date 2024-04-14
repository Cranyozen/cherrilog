/// Cherri log levels.
/// The higher the importance value, the more important the rank is.
enum CherriLogLevel {
  /// All log level.
  all('ALL', 1000),

  /// Fatal log level.
  fatal('FTL', 500),

  /// Error log level.
  error('ERR', 400),

  /// Warning log level.
  warning('WAR', 300),

  /// Info log level.
  info('INF', 200),

  /// Debug log level.
  debug('DBG', 100),

  /// Off log level.
  off('OFF', 0);

  const CherriLogLevel(this.name, this.importance);

  final String name;
  final int importance;

  bool operator >(CherriLogLevel other) => importance > other.importance;
  bool operator >=(CherriLogLevel other) => importance >= other.importance;
  bool operator <(CherriLogLevel other) => importance < other.importance;
  bool operator <=(CherriLogLevel other) => importance <= other.importance;
}
