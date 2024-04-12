import 'package:cherrilog/cherrilog.dart';
import 'package:cherrilog/model/message.dart';

abstract class CherriLogger {
  late CherriOptions options;

  CherriLogger withOptions(CherriOptions options) {
    this.options = options;
    return this;
  }

  CherriLogger log(CherriMessage message);

  CherriLogger flush();
}
