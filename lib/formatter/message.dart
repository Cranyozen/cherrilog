import 'package:cherrilog/level/log_level.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:cherrilog/formatter/timestamp.dart';
import 'package:cherrilog/model/message.dart';

/// Controls how stack trace frames are indented relative to the log body.
///
/// [StackTraceStyle.align] (default): each frame line is right-padded so it
/// starts at the same column as the log message body.
///
/// [StackTraceStyle.tab]: each frame line starts on a new line with a single
/// `\t` (tab) character as prefix, keeping the message body close to the
/// log prefix.
enum StackTraceStyle {
  /// Right-align stack trace frames to the message body position.
  align,

  /// Place each stack frame on a new line with a single tab indent.
  tab,
}

abstract class CherriFormatterMessageBase<T> {
  T format(CherriMessage message);
}

class CherriFormatterMessageDefault extends CherriFormatterMessageBase<String> {
  String timestampPattern;
  String costumeSplitter;
  String costumeSplitterOpen;
  String costumeSplitterClose;
  bool autoFormatTrace;
  bool autoColorize;

  /// Controls how stack trace frames are indented.
  ///
  /// - [StackTraceStyle.align] (default): frames right-aligned to the message body.
  /// - [StackTraceStyle.tab]: each frame on a new line with a single `\t` prefix.
  ///
  /// Only effective when [autoFormatTrace] is `true`.
  StackTraceStyle stackTraceStyle;

  CherriFormatterMessageDefault({
    this.timestampPattern = CherriFormatterTimeStampPattern.standardLongDateTime,
    this.costumeSplitter = '',
    this.costumeSplitterOpen = '[',
    this.costumeSplitterClose = ']',
    this.autoFormatTrace = true,
    this.autoColorize = true,
    this.stackTraceStyle = StackTraceStyle.align,
  });

  @override
  String format(CherriMessage message) {
    var timestamp = _addCostumeSplitter(CherriFormatterTimeStamp.format(message.timestamp, timestampPattern));
    var logLevel = _addCostumeSplitter(message.logLevel.abbreviation);
    var className = _addCostumeSplitter(message.className);
    var methodName = _addCostumeSplitter(message.methodName);
    var stackTrace = message.stackTrace;
    var formattedMessage = timestamp + costumeSplitter + logLevel;

    if (className != '') {
      formattedMessage += costumeSplitter + className;
    }

    if (methodName != '') {
      formattedMessage += costumeSplitter + methodName;
    }

    // NOTE: aheadLength must be computed before _colorize() below,
    // because ANSI escape codes are invisible but count toward string length.
    var aheadLength = formattedMessage.length + costumeSplitter.length;

    formattedMessage += costumeSplitter + message.message;

    if (message.error != null) {
      if (autoFormatTrace && stackTraceStyle == StackTraceStyle.tab) {
        formattedMessage += '\n\t${message.error}';
      } else {
        formattedMessage += '\n${message.error}';
      }
    }

    if (stackTrace != null) {
      final chain = Chain.forTrace(stackTrace);

      for (final trace in chain.traces) {
        // Add an async-gap separator when there are multiple traces.
        if (trace != chain.traces.first) {
          if (autoFormatTrace && stackTraceStyle == StackTraceStyle.tab) {
            formattedMessage += '\n\t<asynchronous suspension>';
          } else {
            formattedMessage += '\n${' ' * aheadLength}<asynchronous suspension>';
          }
        }

        var frames = trace.frames.toList();

        frames.removeWhere((frame) => frame.package == 'cherrilog');

        for (var frame in frames) {
          formattedMessage += '\n';
          if (autoFormatTrace) {
            if (stackTraceStyle == StackTraceStyle.tab) {
              formattedMessage += '\t';
            } else {
              formattedMessage += ' ' * aheadLength;
            }
          }
          formattedMessage += frame.toString();
        }
      }
    }

    if (autoColorize) {
      formattedMessage = _colorize(formattedMessage, message.logLevel);
    }

    return formattedMessage;
  }

  String _addCostumeSplitter(String? message) => message == null || message == '' ? '' : costumeSplitterOpen + message + costumeSplitterClose;

  String _colorize(String message, CherriLogLevel logLevel) {
    if (logLevel.ansiColor == null) return message;

    return logLevel.ansiColorTemplate.replaceFirst("@message", message);
  }
}
