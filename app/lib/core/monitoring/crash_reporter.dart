import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Crash / error reporting seam. No vendor is wired yet (M6).
abstract class CrashReporter {
  void recordError(Object error, StackTrace stackTrace, {bool fatal = false});

  void log(String message);
}

/// Debug-only logging; no-op in release until a vendor is chosen.
@LazySingleton(as: CrashReporter)
class NoOpCrashReporter implements CrashReporter {
  const NoOpCrashReporter();

  @override
  void recordError(Object error, StackTrace stackTrace, {bool fatal = false}) {
    if (kDebugMode) {
      developer.log(
        error.toString(),
        name: 'CrashReporter',
        error: error,
        stackTrace: stackTrace,
        level: fatal ? 1000 : 900,
      );
    }
  }

  @override
  void log(String message) {
    if (kDebugMode) {
      developer.log(message, name: 'CrashReporter');
    }
  }
}
