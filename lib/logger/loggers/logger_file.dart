import 'dart:io';

import 'package:cherrilog/formatter/message.dart';
import 'package:cherrilog/formatter/template.dart';
import 'package:cherrilog/logger/logger.dart';
import 'package:cherrilog/model/message.dart';
import 'package:dart_art/dart_art.dart';

class CherriFile extends CherriLogger {
  late String fileNamePattern = '@yyyy-@MM-@dd-@HH-@id.log';

  /// Returns a sensible default log directory for the current platform.
  ///
  /// | Platform | Path |
  /// |----------|------|
  /// | Linux    | `$HOME/.local/share/cherrilog/logs` |
  /// | macOS    | `$HOME/Library/Logs/cherrilog` |
  /// | Windows  | `%APPDATA%/cherrilog/logs` |
  /// | Android/iOS | `./logs` (set via `path_provider` on Flutter) |
  ///
  /// **Not available on Web** — [CherriFile] requires `dart:io`.
  /// Use [CherriConsole] for logging on Web platforms.
  static String get defaultLocation {
    if (Platform.isWindows) {
      final appData = Platform.environment['APPDATA'];
      if (appData != null) return '$appData/cherrilog/logs';
    }
    if (Platform.isMacOS) {
      final home = Platform.environment['HOME'];
      if (home != null) return '$home/Library/Logs/cherrilog';
    }
    if (Platform.isLinux) {
      final home = Platform.environment['HOME'];
      if (home != null) return '$home/.local/share/cherrilog/logs';
    }
    // Android, iOS, Fuchsia, Web — fallback.
    return './logs';
  }

  late String location = defaultLocation;

  late Duration shelfLife = const Duration(days: 20);

  late int maxFilesCount = 30;

  late BinarySize maxSizeLimit = BinarySize.parse('100 MB')!;

  late BinarySize singleFileSizeLimit = BinarySize.parse('10 MB')!;

  late int clearMode = CherriFileClearMode.oldFiles | CherriFileClearMode.outSizedFiles | CherriFileClearMode.maxFileCount;

  late int _fileId = 0;

  /// Timestamp of the last cleanup run, used to throttle directory scans.
  DateTime? _lastCleanup;

  /// Minimum interval between two cleanup passes.
  static const _cleanupThrottle = Duration(seconds: 60);

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

  CherriFormatterMessageBase<String> _buildFormatter() {
    if (options.formatTemplate != null) {
      return CherriFormatterMessageTemplate(
        options.formatTemplate!,
        timestampPattern: options.timeStampPattern,
        autoColorize: false,
        autoFormatTrace: true,
        stackTraceStyle: options.stackTraceStyle,
      );
    }
    return CherriFormatterMessageDefault(
      timestampPattern: options.timeStampPattern,
      costumeSplitter: ' ',
      autoColorize: false,
      stackTraceStyle: options.stackTraceStyle,
    );
  }

  @override
  void log(CherriMessage message) {
    var formatter = _buildFormatter();

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

    _cleanupIfNeeded();
  }

  /// Performs log file cleanup according to the configured [clearMode].
  ///
  /// Cleanup is throttled to at most once per [_cleanupThrottle] to avoid
  /// scanning the directory on every [flush] call.
  void _cleanupIfNeeded() {
    if (clearMode == 0) return;

    final now = DateTime.now();
    if (_lastCleanup != null && now.difference(_lastCleanup!) < _cleanupThrottle) {
      return;
    }
    _lastCleanup = now;

    var dir = Directory(location);
    if (!dir.existsSync()) return;

    var files = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.log'))
        .toList();

    if (files.isEmpty) return;

    // Sort oldest first.
    files.sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()));

    // 1. Remove files older than shelfLife (oldFiles mode).
    if ((clearMode & CherriFileClearMode.oldFiles) != 0) {
      final cutoff = now.subtract(shelfLife);
      files.removeWhere((f) {
        if (f.lastModifiedSync().isBefore(cutoff)) {
          f.deleteSync();
          return true;
        }
        return false;
      });
    }

    // 2. Keep only the newest maxFilesCount files (when maxFileCount flag is set).
    if ((clearMode & CherriFileClearMode.maxFileCount) != 0) {
      while (files.length > maxFilesCount) {
        files.removeAt(0).deleteSync();
      }
    }

    // 3. Remove oldest files until total size is within limit (outSizedFiles mode).
    if ((clearMode & CherriFileClearMode.outSizedFiles) != 0) {
      var totalSize = files.fold<BigInt>(
        BigInt.zero,
        (sum, f) => sum + BigInt.from(f.lengthSync()),
      );
      final limit = maxSizeLimit.bytesCount;
      while (totalSize > limit && files.isNotEmpty) {
        final removed = files.removeAt(0);
        totalSize -= BigInt.from(removed.lengthSync());
        removed.deleteSync();
      }
    }
  }
}

class CherriFileClearMode {
  static const oldFiles = 1;

  static const outSizedFiles = 2;

  static const maxFileCount = 4;
}
