import 'package:shared_preferences/shared_preferences.dart';

class LanguagePreferences {
  static const _kSpokenKey = 'pref_spoken_languages';
  static const _kSubtitleKey = 'pref_subtitle_languages';

  // ---------- READ ----------
  static Future<List<String>> getSpokenLanguages() async {
    final prefs = SharedPreferencesAsync();
    return await prefs.getStringList(_kSpokenKey) ?? [];
  }

  static Future<List<String>> getSubtitleLanguages() async {
    final prefs = SharedPreferencesAsync();
    return await prefs.getStringList(_kSubtitleKey) ?? [];
  }

  // ---------- WRITE ----------
  static Future<void> setSpokenLanguages(List<String> list) async {
    final prefs = SharedPreferencesAsync();
    await prefs.setStringList(_kSpokenKey, list);
  }

  static Future<void> setSubtitleLanguages(List<String> list) async {
    final prefs = SharedPreferencesAsync();
    await prefs.setStringList(_kSubtitleKey, list);
  }
}
