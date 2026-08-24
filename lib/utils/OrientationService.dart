import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Forces the fullscreen video orientation on Android.
///
/// media_kit's [defaultEnterNativeFullscreen] already requests
/// `[landscapeLeft, landscapeRight]`, but Flutter maps that pair to Android's
/// USER_LANDSCAPE, which respects the system rotation lock — with auto-rotate
/// off the video never flips 180° to the other landscape side. SENSOR_LANDSCAPE
/// (video-player behaviour) is not expressible through [SystemChrome], hence
/// this small platform channel into MainActivity.
class OrientationService {
  static const MethodChannel _channel =
      MethodChannel('app.ister.player/orientation');

  static bool get _supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Follow the sensor between both landscape orientations, ignoring the
  /// system rotation lock. Call after entering native fullscreen so it
  /// overrides the USER_LANDSCAPE that media_kit just requested.
  static Future<void> lockSensorLandscape() => _invoke('lockSensorLandscape');

  /// Drop the orientation override, back to the system/sensor default.
  static Future<void> unlock() => _invoke('unlock');

  static Future<void> _invoke(String method) async {
    if (!_supported) return;
    try {
      await _channel.invokeMethod<void>(method);
    } on PlatformException {
      // Never let an orientation nicety break playback (e.g. an activity
      // without the channel handler).
    } on MissingPluginException {
      // Same: headless audio-service engine has no activity.
    }
  }
}
