library;

import 'package:cherrilog/formatter/message.dart';
import 'package:cherrilog/logger/logger.dart';
import 'package:cherrilog/model/option.dart';
import 'package:cherrilog/model/message.dart';

export 'package:cherrilog/cherrilog.dart';
export 'package:cherrilog/wrapper.dart';
export 'package:cherrilog/logger/logger.dart';

class CherriLog {
  static CherriLog? instance;

  static CherriLog init({CherriOption? option}) {
    var defaultOption = CherriOption();

    instance = CherriLog().setOption(option ?? defaultOption);

    return instance!;
  }

  late CherriOption option;

  CherriLog setOption(CherriOption option) {
    option = option;
    return this;
  }

  late CherriLogger logger;

  CherriLog setLogger(CherriLogger logger) {
    logger = logger;
    return this;
  }

  CherriLog log(CherriMessage message) {
    // TODO: Optimize here
    var formatter = CherriFormatterMessageDefault(timestampPattern: 'MM-dd HH:mm:ss', costumeSplitter: ' ');
    print(formatter.format(message));
    return this;
  }
}

extension CherriLogExtensions on CherriLog {
  CherriLog withOption(CherriOption option) {
    return setOption(option);
  }

  CherriLog logTo(CherriLogger logger) {
    return setLogger(logger);
  }
}
