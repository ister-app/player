import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Read-only view on the native iOS audio-session / now-playing state, fed by
/// the method channel in `ios/Runner/AppDelegate.swift`. Exists because
/// missing lock screen / CarPlay controls can only be diagnosed on a real
/// device, and TestFlight builds offer no console: the About page shows this
/// instead.
class IosAudioDebug {
  static const MethodChannel _channel =
      MethodChannel('app.ister.player/audio_debug');

  static bool get isAvailable => !kIsWeb && Platform.isIOS;

  /// The effective AVAudioSession category/options, current output route and
  /// MPNowPlayingInfoCenter contents at call time. Keys are stable strings
  /// (see AppDelegate.swift); values are rendered verbatim.
  static Future<Map<String, Object?>> sessionInfo() async {
    final result =
        await _channel.invokeMethod<Map<Object?, Object?>>('audioSessionInfo');
    return result?.cast<String, Object?>() ?? <String, Object?>{};
  }
}
