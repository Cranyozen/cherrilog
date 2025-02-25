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
}
