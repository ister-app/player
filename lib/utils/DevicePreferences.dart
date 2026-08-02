import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

/// A stable, randomly generated install id for this app installation. The server uses it to
/// tell two follow-mode devices of the same user apart (and to expire each independently);
/// it never leaves the Ister servers and identifies the installation, not the hardware.
class DevicePreferences {
  static const _kDeviceIdKey = 'device_install_id';
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  static String? _cached;

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
