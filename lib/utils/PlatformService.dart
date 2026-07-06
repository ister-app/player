import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

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

  /// Warms up the leanback check so [isAndroidTvSync] is usable in `build`.
  static Future<void> ensureInitialized() => isAndroidTv();
}
