import 'package:cherrilog/cherrilog.dart';
import 'package:cherrilog/model/message.dart';

abstract class CherriLogger {
  late CherriOptions options;

  void withOptions(CherriOptions options) {
    this.options = options;
  }

  final buffer = <String>[];

  void pushLine(String line) {
    buffer.add(line);

    if (options.useBuffer == false || buffer.length >= options.bufferLineLength) {
      flush();

      buffer.clear();
    }
  }

  void log(CherriMessage message);

  void flush();
}
