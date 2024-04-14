![poster](./art/banner.png)

# Overview

CherriLog is perhaps the simplest and most useful log library for all dart program

# Features

- Log messages directly by calling static methods
- Nice stacktrace formatter
- Custom log levels support
- Custom loggers:
  - Direct output to console with different colors

## TODOs

- [ ] Log to file (Full Platform Support)
- [ ] Highly customizable log format

## Usage

1. Add the dependency to your `pubspec.yaml` file  
   Recommend to use command line:

   With Flutter
   ```shell
   flutter pub add cherrilog
   ```

   With Dart
   ```shell
   dart pub add cherrilog
   ```

2. Import library

   ```dart
   import 'package:cherrilog/cherrilog.dart';
   ```

3. Initialize cherrilog

   ```dart
   CherriLog.init(
     options: CherriOptions()
       ..logLevelRange = CherriLogLevelRanges.all
       ..useBuffer = false,
   ).logTo(CherriConsole());
   ```

4. Call log methods

   ```dart
   debug('This is a debug message');
   info('This is an info message');
   warning('This is a warning message');
   error('Something went wrong');
   fatal('Oh oh :(');
   ```

### Log levels

Cherrilog provides a `CherriLogLevel` class to support custom level, and below is the default instances:

- `CherriLogLevel.fatal`: Fatal errors
- `CherriLogLevel.error`: Errors
- `CherriLogLevel.warning`: Warnings
- `CherriLogLevel.info`: Information messages
- `CherriLogLevel.debug`: Debug messages

And you will also see `nether` and `upperBond`, these two instances is to help with comparison, don't use them directly.

You can find some predefined log level ranges in `CherriLogLevelRanges` class.

### Timestamp Patterns

We offer some preset timestamp formats with in `formatter/timestamp.dart`.

You can also use your own format.

## Output

<pre>
<span style="color: #2472C8">[2024-04-13 18:07:28] [DBG] This is a debug message</span>
<span style="color: #0DBC79">[2024-04-13 18:07:28] [INF] This is an info message</span>
<span style="color: #E5E510">[2024-04-13 18:07:28] [WRN] This is a warning message</span>
<span style="color: #CD3131">[2024-04-13 18:07:28] [ERR] Something went wrong</span>
<span style="color: #FCA5E5">[2024-04-13 18:07:28] [FTL] Oh oh :(</span>
</pre>

*Note: The colors may vary depending on the terminal. This is probably the result on VSCode. [Reference](https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit)*
