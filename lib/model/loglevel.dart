/// Cherri log levels.
/// Ranking of importance from highest to lowest
enum CherriLogLevel {
  /// All log level.
  all('ALL'),

  /// Error log level.
  error('ERROR'),

  /// Warning log level.
  warning('WARNING'),

  /// Info log level.
  info('INFO'),

  /// Debug log level.
  debug('DEBUG'),

  /// Off log level.
  off('OFF');

  const CherriLogLevel(this.name);

  final String name;
}
