import 'package:cherrilog/cherrilog.dart';

void main() {
  CherriLog.init(
    options: CherriOptions()
      ..logLevelRange = CherriLogLevelRanges.all
      ..useBuffer = false,
  ).logTo(CherriConsole()); // Use `CherriFile()` instead of `CherriConsole` if you want to log to file system

  debug('You are doing something right');

  info('You are doing something');

  warning('You are doing something wrong');

  error('You can not shutdown power');

  fatal('The power is off');
}
