import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:player/utils/ScreenWakelock.dart';
import 'package:player/utils/download/DownloadForegroundController.dart';
import 'package:player/utils/download/DownloadService.dart';

/// Keeps downloads alive on iOS, as far as iOS allows.
///
/// There is no equivalent of the Android `dataSync` foreground service
/// ([DownloadForegroundService]): `flutter_foreground_task` falls back to
/// BGTaskScheduler there, which the system grants roughly 30 seconds every 15
/// minutes — useless for mirroring an HLS tree of hundreds of segments. The
/// downloads therefore only run while the app is in the foreground, and the
/// most this can do is stop the screen from dimming and suspending it.
///
/// Reuses [DownloadForegroundController] for the *when* — the same
/// queued/running/paused rules, already unit-tested — and ignores its
/// notification text, which has no counterpart here.
class DownloadWakelock {
  DownloadWakelock._();

  static DownloadForegroundController? _controller;
  static ScreenWakelockToken? _token;

  static bool get supported => !kIsWeb && Platform.isIOS;

  /// Visible for tests.
  @visibleForTesting
  static DownloadForegroundController? get controller => _controller;

  static Future<void> install({DownloadService? service}) async {
    if (!supported || _controller != null) return;
    _controller = DownloadForegroundController(
      service: service ?? DownloadService.instance,
      start: (_, __) async {
        _token ??= ScreenWakelock.acquire();
        return true;
      },
      update: (_, __) async {},
      stop: () async {
        _token?.release();
        _token = null;
      },
    )..attach();
  }

  @visibleForTesting
  static void reset() {
    _controller?.detach();
    _controller = null;
    _token?.release();
    _token = null;
  }
}
