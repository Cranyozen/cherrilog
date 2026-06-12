import 'package:cherrilog/cherrilog.dart';
import 'package:stack_trace/stack_trace.dart';

/// Extracts the class name from a stack frame member string.
///
/// [Frame.member] is typically `ClassName.methodName` or just `functionName`.
String? _extractClassName(Frame frame) {
  final member = frame.member;
  if (member == null || member.isEmpty) return null;
  final dotIndex = member.indexOf('.');
  return dotIndex > 0 ? member.substring(0, dotIndex) : null;
}

/// Returns the full member signature from a stack frame.
String? _extractMethodName(Frame frame) => frame.member;

/// Finds the first caller frame outside the cherrilog package.
///
/// Always skips frames from `cherrilog` and `stack_trace` packages.
/// When [filterCoreFrames] is `true` (default), Dart core library frames
/// (`package == null`) are also skipped.
Frame _findCallerFrame({bool filterCoreFrames = true}) {
  final trace = Trace.current();
  for (final frame in trace.frames) {
    final pkg = frame.package;
    if (pkg == 'cherrilog' || pkg == 'stack_trace') continue;
    if (filterCoreFrames && pkg == null) continue;
    return frame;
  }
  return trace.frames.first;
}

void fatal(String message, {Object? error, StackTrace? stackTrace}) {
  final caller = _findCallerFrame(filterCoreFrames: CherriLog.instance?.options.filterCoreFrames ?? true);
  CherriLog.instance?.log(CherriMessage(CherriLogLevel.fatal, message, DateTime.now(),
    className: _extractClassName(caller),
    methodName: _extractMethodName(caller),
    error: error,
    stackTrace: stackTrace ?? StackTrace.current,
  ));
}

void error(String message, {Object? error, StackTrace? stackTrace}) {
  final caller = _findCallerFrame(filterCoreFrames: CherriLog.instance?.options.filterCoreFrames ?? true);
  CherriLog.instance?.log(CherriMessage(CherriLogLevel.error, message, DateTime.now(),
    className: _extractClassName(caller),
    methodName: _extractMethodName(caller),
    error: error,
    stackTrace: stackTrace ?? StackTrace.current,
  ));
}

void warning(String message, {Object? error, StackTrace? stackTrace}) {
  final caller = _findCallerFrame(filterCoreFrames: CherriLog.instance?.options.filterCoreFrames ?? true);
  CherriLog.instance?.log(CherriMessage(CherriLogLevel.warning, message, DateTime.now(),
    className: _extractClassName(caller),
    methodName: _extractMethodName(caller),
    error: error,
    stackTrace: stackTrace,
  ));
}

void info(String message, {Object? error, StackTrace? stackTrace}) {
  final caller = _findCallerFrame(filterCoreFrames: CherriLog.instance?.options.filterCoreFrames ?? true);
  CherriLog.instance?.log(CherriMessage(CherriLogLevel.info, message, DateTime.now(),
    className: _extractClassName(caller),
    methodName: _extractMethodName(caller),
    error: error,
    stackTrace: stackTrace,
  ));
}

void debug(String message, {Object? error, StackTrace? stackTrace}) {
  final caller = _findCallerFrame(filterCoreFrames: CherriLog.instance?.options.filterCoreFrames ?? true);
  CherriLog.instance?.log(CherriMessage(CherriLogLevel.debug, message, DateTime.now(),
    className: _extractClassName(caller),
    methodName: _extractMethodName(caller),
    error: error,
    stackTrace: stackTrace,
  ));
}
