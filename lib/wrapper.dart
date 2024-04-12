import 'package:cherrilog/cherrilog.dart';
import 'package:cherrilog/model/log_level.dart';
import 'package:cherrilog/model/message.dart';

void fatal(String message, {Object? error, StackTrace? stackTrace}) {
  CherriLog.instance?.log(CherriMessage(CherriLogLevel.fatal, message, DateTime.now()));
}

void error(String message, {Object? error, StackTrace? stackTrace}) {
  CherriLog.instance?.log(CherriMessage(CherriLogLevel.error, message, DateTime.now()));
}

void warning(String message, {Object? error, StackTrace? stackTrace}) {
  CherriLog.instance?.log(CherriMessage(CherriLogLevel.warning, message, DateTime.now()));
}

void info(String message, {Object? error, StackTrace? stackTrace}) {
  CherriLog.instance?.log(CherriMessage(CherriLogLevel.info, message, DateTime.now()));
}

void debug(String message, {Object? error, StackTrace? stackTrace}) {
  CherriLog.instance?.log(CherriMessage(CherriLogLevel.debug, message, DateTime.now()));
}
