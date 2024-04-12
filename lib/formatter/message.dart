import 'package:stack_trace/stack_trace.dart';
import 'package:cherrilog/formatter/timestamp.dart';
import 'package:cherrilog/model/message.dart';
import 'package:cherrilog/model/log_level.dart';

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

  CherriFormatterMessageDefault({
    this.timestampPattern = CherriFormatterTimestampPattern.standardLongDateTime,
    this.costumeSplitter = '',
    this.costumeSplitterOpen = '[',
    this.costumeSplitterClose = ']',
    this.autoFormatTrace = true,
    this.autoColorize = true,
  });

  @override
  String format(CherriMessage message) {
    var timestamp = _addCostumeSplitter(CherriFormatterTimestamp.format(message.timestamp, timestampPattern));
    var logLevel = _addCostumeSplitter(message.logLevel.name);
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

    var aheadLength = formattedMessage.length + costumeSplitter.length;

    formattedMessage += costumeSplitter + message.message;

    if (stackTrace != null) {
      var frames = Trace.from(stackTrace).frames.toList();

      frames.removeWhere((frame) => frame.package == 'cherrilog');

      for (var frame in frames) {
        formattedMessage += '\n';
        if (autoFormatTrace) {
          formattedMessage += ' ' * aheadLength;
        }
        formattedMessage += frame.toString();
      }
    }

    if (autoColorize) {
      formattedMessage = _colorize(formattedMessage, message.logLevel);
    }

    return formattedMessage;
  }

  String _addCostumeSplitter(String? message) => message == null || message == '' ? '' : costumeSplitterOpen + message + costumeSplitterClose;

  String _colorize(String message, CherriLogLevel logLevel) {
    switch (logLevel) {
      case CherriLogLevel.fatal:
        return '\x1B[91m$message\x1B[0m';
      case CherriLogLevel.error:
        return '\x1B[31m$message\x1B[0m';
      case CherriLogLevel.warning:
        return '\x1B[33m$message\x1B[0m';
      case CherriLogLevel.info:
        return '\x1B[32m$message\x1B[0m';
      case CherriLogLevel.debug:
        return '\x1B[34m$message\x1B[0m';
      default:
        return message;
    }
  }
}
