import 'dart:io';

import 'package:cherrilog/formatter/message.dart';
import 'package:cherrilog/logger/logger.dart';
import 'package:cherrilog/model/message.dart';
import 'package:dart_art/dart_art.dart';

class CherriFile extends CherriLogger {
  late String fileNamePattern = '@yyyy-@MM-@dd-@HH-@id.log';

  late String location = './logs';

  late Duration shelfLife = const Duration(days: 20);

  late int maxFilesCount = 30;

  late BinarySize maxSizeLimit = BinarySize.parse('100 MB')!;

  late BinarySize singleFileSizeLimit = BinarySize.parse('10 MB')!;

  late int clearMode = CherriFileClearMode.oldFiles | CherriFileClearMode.outSizedFiles;

  late int _fileId = 0;

  CherriFile() {
    _fileId = getNextId();
  }

  int getNextId() {
    var lastIdFile = File('$location/options/last_id');
    if (lastIdFile.existsSync()) {
      var result = int.parse(lastIdFile.readAsStringSync());
      lastIdFile.writeAsStringSync((result + 1).toString());
      return result + 1;
    } else {
      lastIdFile
        ..createSync(recursive: true)
        ..writeAsStringSync('1');
      return 1;
    }
  }

  String getFileName() {
    var now = DateTime.now();

    var fileName = fileNamePattern
        .replaceAll('@yyyy', now.year.toString().padLeft(4, '0'))
        .replaceAll('@MM', now.month.toString().padLeft(2, '0'))
        .replaceAll('@dd', now.day.toString().padLeft(2, '0'))
        .replaceAll('@HH', now.hour.toString().padLeft(2, '0'))
        .replaceAll('@mm', now.minute.toString().padLeft(2, '0'))
        .replaceAll('@ss', now.second.toString().padLeft(2, '0'))
        .replaceAll('@id', _fileId.toString());

    var file = File('$location/$fileName');
    if (file.existsSync()) {
      var size = BinarySize()..bytesCount = BigInt.from(file.lengthSync());
      if (size > singleFileSizeLimit) {
        _fileId = getNextId();
        return getFileName();
      }
    }

    return fileName;
  }

  @override
  void log(CherriMessage message) {
    var formatter = CherriFormatterMessageDefault(
      timestampPattern: options.timeStampPattern,
      costumeSplitter: ' ',
      autoColorize: false,
    );

    if (message.logLevel.inRange(options.logLevelRange)) {
      var formattedMessage = formatter.format(message);

      for (var line in formattedMessage.split('\n')) {
        pushLine(line);
      }
    }
  }

  @override
  void flush() {
    var file = File('$location/${getFileName()}');
    if (file.existsSync() == false) {
      file.createSync(recursive: true);
    }

    var content = '${buffer.join('\n')}\n';
    file.writeAsStringSync(content, mode: FileMode.writeOnlyAppend);
  }
}

class CherriFileClearMode {
  static const oldFiles = 1;

  static const outSizedFiles = 2;
}
