import 'package:cherrilog/level/log_level.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:cherrilog/formatter/timestamp.dart';
import 'package:cherrilog/model/message.dart';

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
    this.timestampPattern = CherriFormatterTimeStampPattern.standardLongDateTime,
    this.costumeSplitter = '',
    this.costumeSplitterOpen = '[',
    this.costumeSplitterClose = ']',
    this.autoFormatTrace = true,
    this.autoColorize = true,
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
    if (logLevel.ansiColor == null) return message;

    return logLevel.ansiColorTemplate.replaceFirst("@message", message);
  }
}
