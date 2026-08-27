import 'dart:async';

import 'package:wakelock_plus/wakelock_plus.dart';

/// Reference-counted access to the screen wakelock.
///
/// `WakelockPlus` is a single global flag, so the last caller to release wins:
/// closing a comic while a download is running would drop the download's hold
/// too. Every holder takes a token here instead, and the lock is only released
/// once the last one is gone.
///
/// Failures are swallowed on purpose — a platform without the plugin (or a
/// headless test binding) must not take a reader or a download down with it.
class ScreenWakelock {
  ScreenWakelock._();

  static int _holders = 0;

  /// Visible for tests.
  static int get holders => _holders;

  /// Take a hold; returns a token that releases exactly once.
  static ScreenWakelockToken acquire() {
    if (_holders++ == 0) {
      unawaited(WakelockPlus.enable().catchError((_) {}));
    }
    return ScreenWakelockToken._();
  }

  static void _release() {
    if (_holders == 0) return;
    if (--_holders == 0) {
      unawaited(WakelockPlus.disable().catchError((_) {}));
    }
  }
}

/// A single hold on the screen wakelock. Releasing twice is a no-op.
class ScreenWakelockToken {
  ScreenWakelockToken._();

  bool _released = false;

  void release() {
    if (_released) return;
    _released = true;
    ScreenWakelock._release();
  }
}
