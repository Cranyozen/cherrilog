import 'package:cherrilog/formatter/message.dart';
import 'package:cherrilog/formatter/template.dart';
import 'package:cherrilog/logger/logger.dart';
import 'package:cherrilog/model/message.dart';

class CherriConsole extends CherriLogger {
  CherriFormatterMessageBase<String> _buildFormatter() {
    if (options.formatTemplate != null) {
      return CherriFormatterMessageTemplate(
        options.formatTemplate!,
        timestampPattern: options.timeStampPattern,
        autoColorize: true,
        autoFormatTrace: true,
        stackTraceStyle: options.stackTraceStyle,
      );
    }
    return CherriFormatterMessageDefault(
      timestampPattern: options.timeStampPattern,
      costumeSplitter: ' ',
      stackTraceStyle: options.stackTraceStyle,
    );
  }

  @override
  void log(CherriMessage message) {
    var formatter = _buildFormatter();

    if (message.logLevel.inRange(options.logLevelRange)) {
      var formattedMessage = formatter.format(message).replaceAll("\r", "");

      for (var line in formattedMessage.split('\n')) {
        pushLine(line);
      }
    }
  }

  @override
  void flush() {
    print(buffer.join('\n'));
  }
}
