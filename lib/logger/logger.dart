import 'dart:async';

import 'package:cherrilog/cherrilog.dart';
import 'package:cherrilog/model/message.dart';

abstract class CherriLogger {
  late CherriOptions options;

  void withOptions(CherriOptions options) {
    this.options = options;
  }

  final buffer = <String>[];

  Timer? _flushTimer;

  /// Schedules a deferred flush after [CherriOptions.flushInterval].
  ///
  /// Each call resets the timer so that rapid [pushLine] calls do not
  /// trigger repeated flushes — only when the stream of writes pauses
  /// for [CherriOptions.flushInterval] will the buffer be flushed.
  void _scheduleFlush() {
    _flushTimer?.cancel();
    if (options.useBuffer) {
      _flushTimer = Timer(options.flushInterval, () {
        if (buffer.isNotEmpty) {
          flush();
          buffer.clear();
        }
      });
    }
  }

  void pushLine(String line) {
    buffer.add(line);

    if (options.useBuffer == false || buffer.length >= options.bufferLineLength) {
      _flushTimer?.cancel();
      flush();
      buffer.clear();
    } else {
      _scheduleFlush();
    }
  }

  void log(CherriMessage message);

  void flush();
}
