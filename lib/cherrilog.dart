library;

import 'package:cherrilog/logger/logger.dart';
import 'package:cherrilog/model/options.dart';
import 'package:cherrilog/model/message.dart';

export 'package:cherrilog/cherrilog.dart';
export 'package:cherrilog/wrapper.dart';
export 'package:cherrilog/formatter/timestamp.dart';
export 'package:cherrilog/logger/logger.dart';
export 'package:cherrilog/logger/loggers/logger_console.dart';
export 'package:cherrilog/model/options.dart';
export 'package:cherrilog/model/log_level.dart';

class CherriLog {
  static CherriLog? instance;

  static CherriLog init({CherriOptions? options}) {
    instance = CherriLog().withOptions(options ?? CherriOptions());

    return instance!;
  }

  late CherriOptions options;

  CherriLog withOptions(CherriOptions options) {
    this.options = options;
    return this;
  }

  late CherriLogger logger;

  CherriLog logTo(CherriLogger logger) {
    this.logger = logger.withOptions(options);
    return this;
  }

  CherriLog log(CherriMessage message) {
    logger.log(message);

    if (options.useBuffer == false) {
      logger.flush();
    }

    // TODO: Implement flush interval

    return this;
  }
}

extension CherriLogExtensions on CherriLog {}
