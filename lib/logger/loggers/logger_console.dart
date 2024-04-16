import 'package:cherrilog/formatter/message.dart';
import 'package:cherrilog/logger/logger.dart';
import 'package:cherrilog/model/message.dart';

class CherriConsole extends CherriLogger {
  @override
  void log(CherriMessage message) {
    var formatter = CherriFormatterMessageDefault(
      timestampPattern: options.timeStampPattern,
      costumeSplitter: ' ',
    );

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
