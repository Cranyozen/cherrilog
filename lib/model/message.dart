import 'package:cherrilog/level/log_level.dart';

class CherriMessage {
  CherriLogLevel logLevel;
  String? className;
  String? methodName;
  String message;
  DateTime timestamp;
  StackTrace? stackTrace;

  CherriMessage(this.logLevel, this.message, this.timestamp, {this.className, this.methodName, this.stackTrace});
}
