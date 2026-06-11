import 'package:cherrilog/cherrilog.dart';
import 'package:dart_art/dart_art.dart';
import 'package:test/test.dart';

void main() {
  group('A group of normal logs to console', () {
    setUp(() {
      CherriLog.init(
        options: CherriOptions()
          ..logLevelRange = CherriLogLevelRanges.all
          ..timeStampPattern = CherriFormatterTimeStampPattern.standardLongDateTime
          ..useBuffer = false,
      ).logTo(CherriConsole());

      expect(CherriLog.instance, isNotNull);
    });

    test('debug level', () {
      debug('You are doing something right');
    });

    test('info level', () {
      info('You are doing something');
    });

    test('warning level', () {
      warning('You are doing something wrong');
    });

    test('error level', () {
      error('You can not shutdown power');
    });

    test('fatal level', () {
      fatal('The power is off');
    });
  });

  group('A group of normal logs to file', () {
    setUp(() {
      CherriLog.init(
        options: CherriOptions()
          ..logLevelRange = CherriLogLevelRanges.all
          ..timeStampPattern = CherriFormatterTimeStampPattern.standardLongDateTime
          ..useBuffer = false,
      ).logTo(CherriFile());
    });

    test('All level log test', () {
      debug('You are doing something right');
      info('You are doing something');
      warning('You are doing something wrong');
      error('You can not shutdown power');
      fatal('The power is off');
    });

    test('Outer single file size test', () {
      (CherriLog.instance!.logger as CherriFile).singleFileSizeLimit = BinarySize.parse('256 B')!;

      for (var i = 0; i < 10; ++i) {
        info('A' * 300);
      }
    });
  });

  group('StackTraceStyle.align — frames right-aligned to message body', () {
    setUp(() {
      CherriLog.init(
        options: CherriOptions()
          ..logLevelRange = CherriLogLevelRanges.all
          ..timeStampPattern = CherriFormatterTimeStampPattern.standardLongDateTime
          ..useBuffer = false
          ..stackTraceStyle = StackTraceStyle.align,
      ).logTo(CherriConsole());

      expect(CherriLog.instance, isNotNull);
    });

    test('error with stackTrace prints frames aligned to body', () {
      // Visual output (keep for human inspection).
      error(
        'error message with align style',
        error: Exception('test error'),
        stackTrace: StackTrace.current,
      );

      // Assert: formatter output has right-aligned frames (spaces before frame text).
      final fmt = CherriFormatterMessageDefault(stackTraceStyle: StackTraceStyle.align);
      final msg = CherriMessage(CherriLogLevel.error, 'test', DateTime(2025, 1, 1),
        error: Exception('boom'),
        stackTrace: StackTrace.current,
      );
      final output = fmt.format(msg);
      final frameLines = output.split('\n').where((l) => l.contains('cherrilog_test.dart'));
      expect(frameLines.isNotEmpty, isTrue);
      // At least one frame should start with significant right-padding.
      expect(frameLines.any((l) => l.startsWith(' ' * 20)), isTrue);
    });
  });

  group('StackTraceStyle.tab — frames with tab indent on new line', () {
    setUp(() {
      CherriLog.init(
        options: CherriOptions()
          ..logLevelRange = CherriLogLevelRanges.all
          ..timeStampPattern = CherriFormatterTimeStampPattern.standardLongDateTime
          ..useBuffer = false
          ..stackTraceStyle = StackTraceStyle.tab,
      ).logTo(CherriConsole());

      expect(CherriLog.instance, isNotNull);
    });

    test('error with stackTrace prints frames with tab indent', () {
      // Visual output (keep for human inspection).
      error(
        'error message with tab style',
        error: Exception('test error'),
        stackTrace: StackTrace.current,
      );

      // Assert: formatter output has tab-indented frames.
      final fmt = CherriFormatterMessageDefault(stackTraceStyle: StackTraceStyle.tab);
      final msg = CherriMessage(CherriLogLevel.error, 'test', DateTime(2025, 1, 1),
        error: Exception('boom'),
        stackTrace: StackTrace.current,
      );
      final output = fmt.format(msg);
      final frameLines = output.split('\n').where((l) => l.contains('cherrilog_test.dart'));
      expect(frameLines.isNotEmpty, isTrue);
      // Every frame line should start with a tab.
      for (final line in frameLines) {
        expect(line, startsWith('\t'));
      }
    });
  });
}
