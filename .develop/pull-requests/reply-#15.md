# Copilot Review Replies for PR #15

---

### Suggestion 1–5 (wrapper.dart — auto stackTrace on every log)

**Copilot concern:** `StackTrace.current` is captured for every log level, causing noise and performance overhead.

**Fix:**

- `fatal()` and `error()` retain `stackTrace ?? StackTrace.current` fallback — errors deserve full context.
- `warning()`, `info()`, `debug()` removed the fallback — they now pass `stackTrace` directly. No stack trace is captured unless the caller explicitly provides one.
- Users can still opt in at any level by passing `stackTrace: StackTrace.current`.

**Files:** `lib/wrapper.dart`

---

### Suggestion 6 (message.dart — error line misaligned in align mode)

**Copilot concern:** In `StackTraceStyle.align` mode the error line is emitted without the same right-padding as stack frames.

**Fix:**

- Added `else if (autoFormatTrace)` branch: error line now aligned with `' ' * aheadLength` in align mode, matching stack frame indentation.
- Full three-way: `tab` → `\t`, `align` → right-padded spaces, otherwise → no indent.

**Files:** `lib/formatter/message.dart`

---

### Suggestion 7 & 8 (template.dart — manual JSON construction)

**Copilot concern:** JSON is hand-built with a custom escape function, which risks invalid JSON. `stackTrace` is also omitted from JSON output.

**Fix:**

- Replaced `_formatJson()` and `_escapeJson()` with `dart:convert`'s `jsonEncode()` on a `Map<String, String>`.
- Added `stackTrace` to the JSON output via `_formatStackTrace()`.
- Guarantees correct escaping, shorter code, and no missing fields.

**Files:** `lib/formatter/template.dart`

---

### Suggestion 9 (template.dart — `stackTraceStyle.align` behaves like no-indent)

**Copilot concern:** In template mode, `StackTraceStyle.align` produces no indentation at all, making the option effectively ignored outside `tab`.

**Fix:**

- `align` mode now uses a 4-space indent (`'    '`) in template formatter.
- `tab` mode continues to use `\t`.
- When `autoFormatTrace` is false, no indent (as before).

**Files:** `lib/formatter/template.dart`

---

### Suggestion 10 (options.dart — unresolved doc reference)

**Copilot concern:** `[CherriFormatterMessageTemplate]` in the doc comment references a symbol not imported in this file.

**Fix:**

- Added `import 'package:cherrilog/formatter/template.dart';` to `lib/model/options.dart`.

**Files:** `lib/model/options.dart`

---

### Suggestion 11 (logger_file.dart — misleading Web doc)

**Copilot concern:** The `defaultLocation` doc implies `CherriFile` works on Web, but it imports `dart:io` and cannot compile there.

**Fix:**

- Updated the doc table: Web and mobile were split into separate entries. Web is now explicitly marked **Not available**.
- Wrote a companion analysis at `.develop/suggestions/web-platform-support.md` discussing three approaches (conditional exports, dropping `web:` from platforms, sub-packages) with a recommendation.

**Files:** `lib/logger/loggers/logger_file.dart`, `.develop/suggestions/web-platform-support.md`

---

### Suggestion 12 (logger_file.dart — maxFilesCount enforced unconditionally)

**Copilot concern:** File-count capping runs regardless of `clearMode`, contradicting the doc that says cleanup is "according to the configured `clearMode`".

**Fix:**

- Added `CherriFileClearMode.maxFileCount = 4` flag.
- Wrapped the file-count cleanup block with `if ((clearMode & maxFileCount) != 0)`.
- Updated the default `clearMode` to include the new flag: `oldFiles | outSizedFiles | maxFileCount`.
- All three cleanup dimensions are now independently gated by their flags.

**Files:** `lib/logger/loggers/logger_file.dart`

---

### Suggestion 13 & 14 (tests — no assertions)

**Copilot concern:** The new `StackTraceStyle` tests only emit output without any assertions, so regressions won't be caught.

**Fix:**

- Kept the existing `error()` calls for human-visible console output.
- Added direct formatter assertions using `CherriFormatterMessageDefault`:
  - `align` test verifies at least one frame line starts with ≥20 spaces (right-padding).
  - `tab` test verifies every frame line from this test file starts with `\t`.
- `CherriMessage` was previously not publicly exported — added `export 'package:cherrilog/model/message.dart'` to `lib/cherrilog.dart`.

**Files:** `test/cherrilog_test.dart`, `lib/cherrilog.dart`

---

### Bonus cleanup

- Removed two now-redundant `import 'package:cherrilog/model/message.dart'` from `lib/logger/logger.dart` and `lib/wrapper.dart` (now provided by `cherrilog.dart` re-export).
