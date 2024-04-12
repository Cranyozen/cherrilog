import 'package:cherrilog/cherrilog.dart';
import 'package:test/test.dart';

void main() {
  group('A group of normal logs', () {
    setUp(() {
      CherriLog.init();

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
