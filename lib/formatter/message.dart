import 'package:stack_trace/stack_trace.dart';

import 'timestamp.dart';
import '../model/message.dart';
import '../model/loglevel.dart';

/// Formatter message base class.
/// T is the return type of the `format` method.
abstract class CherriFormatterMessageBase<T> {
  T format(CherriMessage message);
}

/// Default formatter message.
/// This formatter will format the message in the following format:
/// `[timestamp] [logLevel] [className] [methodName] message`
/// If the `stackTrace` is not null, it will be appended to the message.
/// The message will be colorized based on the log level, if `autoColorize` is true.
class CherriFormatterMessageDefault extends CherriFormatterMessageBase<String> {
  String timestampPattern;
  String costumeSplitter;
  String costumeSplitterOpen;
  String costumeSplitterClose;
  bool autoFormatTrace;
  bool autoColorize;

  // CherriFormatterMessageDefault();
  CherriFormatterMessageDefault({
    this.timestampPattern = CherriFormatterTimestampPattern.dateTimeFormat1,
    this.costumeSplitter = '',
    this.costumeSplitterOpen = '[',
    this.costumeSplitterClose = ']',
    this.autoFormatTrace = true,
    this.autoColorize = true,
  });

  @override
  String format(CherriMessage message) {
    // Get message parts.
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
      // Filter out the stack frames from the current file.
      frames.removeWhere((frame) => frame.package == 'cherrilog');

      for (var frame in frames) {
        formattedMessage += '\n';
        if (autoFormatTrace) {
          formattedMessage += ' ' * aheadLength;
        }
        // formattedMessage += frame.toString();
        formattedMessage += frame.toString();
      }
    }

    // Colorize the message.
    if (autoColorize) {
      formattedMessage = _colorize(formattedMessage, message.logLevel);
    }

    return formattedMessage;
  }

  String _addCostumeSplitter(String? message) =>
      message == null || message == '' ? '' : costumeSplitterOpen + message + costumeSplitterClose;

  String _colorize(String message, CherriLogLevel logLevel) {
    if (logLevel == CherriLogLevel.error) {
      return '\x1B[31m$message\x1B[0m';
    } else if (logLevel == CherriLogLevel.warning) {
      return '\x1B[33m$message\x1B[0m';
    } else if (logLevel == CherriLogLevel.info) {
      return '\x1B[32m$message\x1B[0m';
    } else if (logLevel == CherriLogLevel.debug) {
      return '\x1B[34m$message\x1B[0m';
    } else {
      return message;
    }
  }
}
