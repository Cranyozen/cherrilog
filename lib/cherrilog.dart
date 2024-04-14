library;

import 'package:cherrilog/logger/logger.dart';
import 'package:cherrilog/model/options.dart';
import 'package:cherrilog/model/message.dart';

export 'package:cherrilog/cherrilog.dart';
export 'package:cherrilog/wrapper.dart';
export 'package:cherrilog/formatter/timestamp.dart';
export 'package:cherrilog/logger/logger.dart';
export 'package:cherrilog/logger/loggers/logger_console.dart';
export 'package:cherrilog/level/log_level.dart';
export 'package:cherrilog/model/options.dart';

class CherriLog {
  static CherriLog? instance;

  static CherriLog init({CherriOptions? options}) {
    instance = CherriLog()..withOptions(options ?? CherriOptions());

    return instance!;
  }

  late CherriOptions options;

  void withOptions(CherriOptions options) {
    this.options = options;
  }

  late CherriLogger logger;

  void logTo(CherriLogger logger) {
    this.logger = logger..withOptions(options);
  }

  void log(CherriMessage message) {
    logger.log(message);

    if (options.useBuffer == false) {
      logger.flush();
    }

    // TODO: Implement flush interval
  }
}

extension CherriLogExtensions on CherriLog {}
