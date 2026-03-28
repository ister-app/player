import 'package:shared_preferences/shared_preferences.dart';

class PlaybackPreferences {
  static const _kDirectPlayKey = 'pref_direct_play';
  static const _kTranscodeKey = 'pref_transcode';
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static Future<bool> getDirectPlay() async {
    return await _prefs.getBool(_kDirectPlayKey) ?? true;
  }

  static Future<void> setDirectPlay(bool value) async {
    await _prefs.setBool(_kDirectPlayKey, value);
  }

  static Future<bool> getTranscode() async {
    return await _prefs.getBool(_kTranscodeKey) ?? true;
  }

  static Future<void> setTranscode(bool value) async {
    await _prefs.setBool(_kTranscodeKey, value);
  }
}
