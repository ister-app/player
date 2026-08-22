import 'package:shared_preferences/shared_preferences.dart';

/// Device-local display settings for video playback on Android (phone or TV).
///
/// These are properties of the device/display combo, not of a user or server —
/// so they live in SharedPreferences, unlike [PlaybackPreferences] which the
/// server stores per user. Both settings gate the SurfaceView video path in
/// [MediaPlayerHandler]; that decision is taken when the video controller is
/// created, so a change takes effect on the next app start.
class DisplayPreferences {
  DisplayPreferences._();

  static const _kRealHdrKey = 'pref_display_real_hdr';
  static const _kMatchFrameRateKey = 'pref_display_match_frame_rate';
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static bool _realHdr = false;
  static bool _matchFrameRate = false;

  /// Warms the cached values so [realHdrSync]/[matchFrameRateSync] are usable
  /// before the video controller is created. Called from `main()`.
  static Future<void> ensureInitialized() async {
    _realHdr = await _prefs.getBool(_kRealHdrKey) ?? false;
    _matchFrameRate = await _prefs.getBool(_kMatchFrameRateKey) ?? false;
  }

  /// Render through a real SurfaceView with HDR passthrough (Vulkan/gpu-next)
  /// instead of the tone-mapped Flutter texture. Default off.
  static bool get realHdrSync => _realHdr;

  static Future<void> setRealHdr(bool value) async {
    _realHdr = value;
    await _prefs.setBool(_kRealHdrKey, value);
  }

  /// Ask Android to switch the display to the content frame rate (seamless
  /// switches only; requires the SurfaceView path). Default off.
  static bool get matchFrameRateSync => _matchFrameRate;

  static Future<void> setMatchFrameRate(bool value) async {
    _matchFrameRate = value;
    await _prefs.setBool(_kMatchFrameRateKey, value);
  }
}
