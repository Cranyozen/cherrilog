import 'package:cherrilog/formatter/message.dart';
import 'package:cherrilog/logger/logger.dart';
import 'package:cherrilog/model/message.dart';

class CherriConsole extends CherriLogger {
  @override
  CherriLogger log(CherriMessage message) {
    var formatter = CherriFormatterMessageDefault(
      timestampPattern: options.timeStampPattern,
      costumeSplitter: ' ',
    );

    var le = message.logLevel.index <= options.maximumLevel.index;

    var be = message.logLevel.index >= options.minimumLevel.index;

    if (le && be) {
      print(formatter.format(message));
    }

    return this;
  }

  @override
  CherriLogger flush() {
    return this;
  }
}
