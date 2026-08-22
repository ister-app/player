import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Platform capability checks shared across the app.
///
/// Android TV detection is the important one: input is D-pad/remote based, so
/// the UI branches on it to show focus highlights, initial focus, and
/// TV-friendly controls. The leanback check hits the platform channel once and
/// is then cached, since it never changes for the life of the process.
class PlatformService {
  PlatformService._();

  static bool? _isAndroidTv;

  /// Whether we're running on an Android TV / leanback device.
  ///
  /// Cached after the first call. Prefer [isAndroidTv] in async contexts; use
  /// [isAndroidTvSync] in `build` methods after it has been warmed up (call
  /// [ensureInitialized] at startup).
  static Future<bool> isAndroidTv() async {
    if (_isAndroidTv != null) return _isAndroidTv!;
    if (kIsWeb || !Platform.isAndroid) {
      return _isAndroidTv = false;
    }
    final info = await DeviceInfoPlugin().androidInfo;
    return _isAndroidTv =
        info.systemFeatures.contains('android.software.leanback');
  }

  /// Synchronous view of [isAndroidTv]. Returns `false` until the async check
  /// has completed at least once (see [ensureInitialized]).
  static bool get isAndroidTvSync => _isAndroidTv ?? false;

  static bool? _isHdrDisplay;

  /// Whether the current display reports HDR support (Android only).
  ///
  /// Answered by MainActivity over a platform channel, so this is `false` in
  /// headless audio-service starts — fine, since video playback implies UI.
  static Future<bool> isHdrDisplay() async {
    if (_isHdrDisplay != null) return _isHdrDisplay!;
    if (kIsWeb || !Platform.isAndroid) {
      return _isHdrDisplay = false;
    }
    try {
      final capabilities = await const MethodChannel('app.ister.player/display')
          .invokeMethod<Map>('getHdrCapabilities');
      return _isHdrDisplay = capabilities?['isHdr'] == true;
    } catch (_) {
      return _isHdrDisplay = false;
    }
  }

  /// Synchronous view of [isHdrDisplay]; `false` until warmed up.
  static bool get isHdrDisplaySync => _isHdrDisplay ?? false;

  /// Warms up the platform checks so the `Sync` getters are usable in `build`
  /// resp. the [MediaPlayerHandler] constructor.
  static Future<void> ensureInitialized() async {
    await isAndroidTv();
    await isHdrDisplay();
  }
}
