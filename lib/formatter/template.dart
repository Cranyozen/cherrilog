import 'dart:convert';

import 'package:cherrilog/formatter/message.dart';
import 'package:cherrilog/formatter/timestamp.dart';
import 'package:cherrilog/model/message.dart';
import 'package:stack_trace/stack_trace.dart';

/// A template-based message formatter that uses placeholders to control the
/// output format.
///
/// Supported placeholders:
/// - `{timestamp}` — the formatted timestamp (uses [timestampPattern])
/// - `{level}` — log level abbreviation (e.g. `DBG`, `ERR`)
/// - `{levelName}` — log level full name (e.g. `Debug`, `Error`)
/// - `{message}` — the log message text
/// - `{className}` — the calling class name (may be empty)
/// - `{methodName}` — the calling method name (may be empty)
/// - `{error}` — the error object (may be empty)
/// - `{stackTrace}` — the formatted stack trace
///
/// Use the special value `"json"` as the template to output each log entry as a
/// JSON object on a single line.
///
/// ```dart
/// final fmt = CherriFormatterMessageTemplate('{timestamp} [{level}] {message}');
/// ```
class CherriFormatterMessageTemplate extends CherriFormatterMessageBase<String> {
  /// The template string with optional placeholders.
  final String template;

  /// The timestamp pattern used by the `{timestamp}` placeholder.
  final String timestampPattern;

  /// Whether to colorize the output with ANSI escape codes.
  final bool autoColorize;

  /// Whether to format stack traces with aligned indentation.
  final bool autoFormatTrace;

  /// Controls how stack trace frames are indented.
  ///
  /// Only effective when [autoFormatTrace] is `true`.
  final StackTraceStyle stackTraceStyle;

  CherriFormatterMessageTemplate(
    this.template, {
    this.timestampPattern = CherriFormatterTimeStampPattern.standardLongDateTime,
    this.autoColorize = true,
    this.autoFormatTrace = true,
    this.stackTraceStyle = StackTraceStyle.align,
  });

  @override
  String format(CherriMessage message) {
    if (template.toLowerCase() == 'json') {
      return _formatJson(message);
    }
    return _formatTemplate(message);
  }

  String _formatTemplate(CherriMessage message) {
    var result = template
        .replaceAll('{timestamp}', CherriFormatterTimeStamp.format(message.timestamp, timestampPattern))
        .replaceAll('{level}', message.logLevel.abbreviation)
        .replaceAll('{levelName}', message.logLevel.name)
        .replaceAll('{message}', message.message)
        .replaceAll('{className}', message.className ?? '')
        .replaceAll('{methodName}', message.methodName ?? '')
        .replaceAll('{error}', message.error?.toString() ?? '');

    // Handle stackTrace placeholder separately (it is multi-line).
    if (template.contains('{stackTrace}')) {
      final st = _formatStackTrace(message.stackTrace);
      result = result.replaceAll('{stackTrace}', st);
    }

    if (autoColorize && message.logLevel.ansiColor != null) {
      result = message.logLevel.ansiColorTemplate.replaceFirst('@message', result);
    }

    return result;
  }

  String _formatJson(CherriMessage message) {
    final map = <String, String>{
      'timestamp': CherriFormatterTimeStamp.format(message.timestamp, timestampPattern),
      'level': message.logLevel.abbreviation,
      'levelName': message.logLevel.name,
      'message': message.message,
    };
    if (message.className != null && message.className!.isNotEmpty) {
      map['className'] = message.className!;
    }
    if (message.methodName != null && message.methodName!.isNotEmpty) {
      map['methodName'] = message.methodName!;
    }
    if (message.error != null) {
      map['error'] = message.error.toString();
    }
    if (message.stackTrace != null) {
      map['stackTrace'] = _formatStackTrace(message.stackTrace);
    }
    return jsonEncode(map);
  }

  String _formatStackTrace(StackTrace? stackTrace) {
    if (stackTrace == null) return '';
    final chain = Chain.forTrace(stackTrace);
    final lines = <String>[];
    final indent = !autoFormatTrace
        ? ''
        : stackTraceStyle == StackTraceStyle.tab
            ? '\t'
            : '    '; // align mode → 4-space indent
    for (final trace in chain.traces) {
      if (trace != chain.traces.first) {
        lines.add('$indent<asynchronous suspension>');
      }
      for (final frame in trace.frames) {
        if (frame.package == 'cherrilog') continue;
        lines.add('$indent${frame.toString()}');
      }
    }
    return lines.join('\n');
  }
}
