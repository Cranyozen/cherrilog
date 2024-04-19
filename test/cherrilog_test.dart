import 'package:cherrilog/cherrilog.dart';
import 'package:test/test.dart';

void main() {
  group('A group of normal logs to console', () {
    setUp(() {
      CherriLog.init(
        options: CherriOptions()
          ..logLevelRange = CherriLogLevelRanges.all
          ..timeStampPattern =
              CherriFormatterTimeStampPattern.standardLongDateTime
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
}
