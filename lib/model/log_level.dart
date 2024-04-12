/// Cherri log levels.
/// Ranking of importance from highest to lowest
///
/// # WARN !!!
///
/// Don't change the order of the enum values, it will break the log level comparison.
enum CherriLogLevel {
  /// All log level.
  all('ALL'),

  /// Fatal log level.
  fatal('FTL'),

  /// Error log level.
  error('ERR'),

  /// Warning log level.
  warning('WAR'),

  /// Info log level.
  info('INF'),

  /// Debug log level.
  debug('DBG'),

  /// Off log level.
  off('OFF');

  const CherriLogLevel(this.name);

  final String name;
}
