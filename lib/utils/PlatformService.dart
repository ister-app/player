import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Platform capability checks shared across the app.
///
/// TV-mode detection is the important one: input is D-pad/remote/gamepad
/// based, so the UI branches on it to show focus highlights, initial focus,
/// and TV-friendly controls. It is true on Android TV (leanback), inside a
/// SteamOS game-mode session (Steam Deck / Steam Machine under gamescope,
/// where Steam Input delivers the gamepad as keyboard arrows), or when the
/// user forces it. The checks hit the platform channel / preferences once and
/// are then cached, since none of them change for the life of the process.
class PlatformService {
  PlatformService._();

  static const _kTvModeOverrideKey = 'tv_mode_override';

  static bool? _isAndroidTv;
  static bool? _tvModeOverride;
  static bool _overrideLoaded = false;

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

  /// Whether we're inside a SteamOS game-mode session (gamescope): a Steam
  /// Deck or Steam Machine launched us from game mode. The same variables are
  /// checked by the native window setup in `linux/my_application.cc`, which
  /// goes fullscreen and undecorated for this case.
  static bool get isGamescopeSession {
    if (kIsWeb || !Platform.isLinux) return false;
    final env = Platform.environment;
    return env['XDG_CURRENT_DESKTOP'] == 'gamescope' ||
        env['SteamOS'] == '1' ||
        env['SteamDeck'] == '1';
  }

  /// Whether the UI should run in controller-driven "10-foot" mode: focus
  /// highlights, directional navigation, TV video controls.
  ///
  /// Priority: `ISTER_TV_MODE=1` env (testing) > the user's settings toggle
  /// ([setTvModeOverride]) > auto-detection (Android TV or gamescope).
  static bool get isTvModeSync {
    if (isAndroidTvSync) return true;
    if (kIsWeb) return false;
    if (Platform.environment['ISTER_TV_MODE'] == '1') return true;
    return _tvModeOverride ?? isGamescopeSession;
  }

  /// Async companion of [isTvModeSync] that warms every input first.
  static Future<bool> isTvMode() async {
    await ensureInitialized();
    return isTvModeSync;
  }

  /// The user's TV-mode toggle: `true`/`false` override auto-detection, `null`
  /// means automatic. Takes full effect after an app restart (the native
  /// window chrome only reads the environment).
  static Future<bool?> getTvModeOverride() async {
    await _loadOverride();
    return _tvModeOverride;
  }

  static Future<void> setTvModeOverride(bool? value) async {
    _tvModeOverride = value;
    _overrideLoaded = true;
    final prefs = SharedPreferencesAsync();
    if (value == null) {
      await prefs.remove(_kTvModeOverrideKey);
    } else {
      await prefs.setBool(_kTvModeOverrideKey, value);
    }
  }

  static Future<void> _loadOverride() async {
    if (_overrideLoaded || kIsWeb) return;
    _tvModeOverride = await SharedPreferencesAsync().getBool(
      _kTvModeOverrideKey,
    );
    _overrideLoaded = true;
  }

  /// Warms the leanback check and the TV-mode preference so [isTvModeSync]
  /// and [isAndroidTvSync] are usable in `build`.
  static Future<void> ensureInitialized() async {
    await isAndroidTv();
    await _loadOverride();
  }

  /// Drops the cached preference so the next read hits storage again.
  @visibleForTesting
  static void resetForTesting() {
    _tvModeOverride = null;
    _overrideLoaded = false;
  }
}
