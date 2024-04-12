import 'package:cherrilog/cherrilog.dart';
import 'package:cherrilog/model/message.dart';

abstract class CherriLogger {
  late CherriOptions options;

  void withOptions(CherriOptions options) {
    this.options = options;
  }

  void log(CherriMessage message);

  void flush();
}
