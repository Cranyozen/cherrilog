import 'package:cherrilog/formatter/message.dart';
import 'package:cherrilog/formatter/template.dart';
import 'package:cherrilog/formatter/timestamp.dart';
import 'package:cherrilog/level/log_level.dart';
import 'package:cherrilog/level/log_level_ranges.dart';

class CherriOptions {
  (CherriLogLevel, CherriLogLevel) logLevelRange = CherriLogLevelRanges.all;

  String timeStampPattern = CherriFormatterTimeStampPattern.standardLongDateTime;

  /// An optional format template string.
  ///
  /// When set, loggers will use [CherriFormatterMessageTemplate] instead of
  /// [CherriFormatterMessageDefault].
  ///
  /// Supported placeholders: `{timestamp}`, `{level}`, `{levelName}`,
  /// `{message}`, `{className}`, `{methodName}`, `{error}`, `{stackTrace}`.
  ///
  /// Use `"json"` for single-line JSON output.
  ///
  /// When `null` (the default), the built-in default format is used.
  String? formatTemplate;

  /// Controls how stack trace frames are indented.
  ///
  /// - [StackTraceStyle.align] (default): frames right-aligned to the message body.
  /// - [StackTraceStyle.tab]: each frame on a new line with a single `\t` prefix.
  StackTraceStyle stackTraceStyle = StackTraceStyle.align;

  bool useBuffer = true;

  int bufferLineLength = 30;

  /// When `true` (default), Dart core library frames (`package == null`) are
  /// skipped when auto-detecting the caller's [className] and [methodName].
  ///
  /// Set to `false` to allow Dart core frames to be reported as the caller
  /// (rarely useful; mostly for debugging the frame detection itself).
  bool filterCoreFrames = true;

  Duration flushInterval = const Duration(milliseconds: 500);
}
