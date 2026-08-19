import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:volume_controller/volume_controller.dart';

/// Device volume and window brightness (both 0..1) behind one seam, so the
/// fullscreen swipe gestures can be widget-tested without platform channels.
///
/// Brightness is *application-window* brightness (no WRITE_SETTINGS
/// permission; the OS restores its own level when the app exits), the
/// standard video-player approach.
abstract class SystemLevels {
  static SystemLevels instance = _PluginSystemLevels();

  @visibleForTesting
  static set testInstance(SystemLevels levels) => instance = levels;

  /// Whether the platform backs these calls; when false the caller should
  /// fall back (player volume) or skip the gesture (brightness).
  bool get isSupported;

  Future<double> getVolume();

  Future<void> setVolume(double value);

  Future<double> getBrightness();

  Future<void> setBrightness(double value);

  Future<void> resetBrightness();
}

class _PluginSystemLevels extends SystemLevels {
  _PluginSystemLevels() {
    // Our own overlay is the volume feedback; keep the OS HUD out of the way.
    if (isSupported) VolumeController.instance.showSystemUI = false;
  }

  @override
  bool get isSupported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  Future<double> getVolume() => VolumeController.instance.getVolume();

  @override
  Future<void> setVolume(double value) =>
      VolumeController.instance.setVolume(value.clamp(0.0, 1.0));

  @override
  Future<double> getBrightness() => ScreenBrightness.instance.application;

  @override
  Future<void> setBrightness(double value) => ScreenBrightness.instance
      .setApplicationScreenBrightness(value.clamp(0.0, 1.0));

  @override
  Future<void> resetBrightness() =>
      ScreenBrightness.instance.resetApplicationScreenBrightness();
}
