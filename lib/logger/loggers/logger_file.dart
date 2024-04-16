import 'package:cherrilog/formatter/message.dart';
import 'package:cherrilog/logger/logger.dart';
import 'package:cherrilog/model/message.dart';
import 'package:dart_art/dart_art.dart';

class CherriFile extends CherriLogger {
  late String fileNamePattern = '@yyyy-@MM-@dd-@HH-@mm-@ss-@id.log';

  late String location = './logs/';

  late Duration shelfLife = const Duration(days: 20);

  late int maxFilesCount = 30;

  late BinarySize maxSizeLimit = BinarySize.parse('100 MB')!;

  late BinarySize singleFileSizeLimit = BinarySize.parse('10 MB')!;

  late int clearMode = CherriFileClearMode.oldFiles | CherriFileClearMode.outSizedFiles;

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
  void flush() {}
}

class CherriFileClearMode {
  static const oldFiles = 1;

  static const outSizedFiles = 2;
}
