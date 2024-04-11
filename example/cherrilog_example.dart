import 'package:cherrilog/formatter/message.dart';
import 'package:cherrilog/model/message.dart';
import 'package:cherrilog/model/loglevel.dart';

void main() {
  var msg =
      CherriMessage(CherriLogLevel.debug, 'Hello, World!', DateTime.now(), stackTrace: StackTrace.current);
  var formatter = CherriFormatterMessageDefault(timestampPattern: 'MM-dd HH:mm:ss', costumeSplitter: ' ');
  print(formatter.format(msg));
}
