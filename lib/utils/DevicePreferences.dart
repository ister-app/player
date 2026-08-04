import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/PlatformService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io' show Platform;

/// A stable, randomly generated install id for this app installation, plus the user-facing
/// device name and platform reported to the server. The server uses the id to tell two devices
/// of the same user apart (follow mode, device registry); it never leaves the Ister servers and
/// identifies the installation, not the hardware.
class DevicePreferences {
  static const _kDeviceIdKey = 'device_install_id';
  static const _kDeviceNameKey = 'device_name';
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  static String? _cached;
  static String? _cachedName;

  static Future<String> getDeviceId() async {
    final cached = _cached;
    if (cached != null) return cached;
    var id = await _prefs.getString(_kDeviceIdKey);
    if (id == null) {
      id = _randomUuidV4();
      await _prefs.setString(_kDeviceIdKey, id);
    }
    _cached = id;
    return id;
  }

  /// The device name: the user-chosen one when set, else a platform default
  /// (Android model name, desktop hostname, "Web browser"). Only seeds the
  /// server registration — a server-side rename wins over this.
  static Future<String> getDeviceName() async {
    final cached = _cachedName;
    if (cached != null) return cached;
    var name = await _prefs.getString(_kDeviceNameKey);
    name ??= await _defaultDeviceName();
    _cachedName = name;
    return name;
  }

  static Future<void> setDeviceName(String name) async {
    _cachedName = name;
    await _prefs.setString(_kDeviceNameKey, name);
  }

  static Future<String> _defaultDeviceName() async {
    try {
      if (kIsWeb) return 'Web browser';
      if (Platform.isAndroid) {
        final info = await DeviceInfoPlugin().androidInfo;
        return info.model;
      }
      return Platform.localHostname;
    } catch (_) {
      return 'Ister player';
    }
  }

  /// The platform this install runs on, for the server-side device registry.
  static Future<Enum$DevicePlatform> getPlatform() async {
    if (kIsWeb) return Enum$DevicePlatform.WEB;
    if (Platform.isAndroid) {
      return await PlatformService.isAndroidTv()
          ? Enum$DevicePlatform.ANDROID_TV
          : Enum$DevicePlatform.ANDROID;
    }
    if (Platform.isIOS) return Enum$DevicePlatform.IOS;
    if (Platform.isLinux) return Enum$DevicePlatform.LINUX;
    if (Platform.isMacOS) return Enum$DevicePlatform.MACOS;
    if (Platform.isWindows) return Enum$DevicePlatform.WINDOWS;
    return Enum$DevicePlatform.OTHER;
  }

  static String _randomUuidV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}
