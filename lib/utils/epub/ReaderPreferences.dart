import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Colour scheme of the reading surface. Deliberately independent of the app
/// theme: readers pick paper-like surfaces regardless of how the rest of the
/// app looks.
enum ReaderTheme {
  light(Color(0xFFFAFAF7), Color(0xFF1F1F1F)),
  sepia(Color(0xFFF4ECD8), Color(0xFF433422)),
  dark(Color(0xFF121212), Color(0xFFD6D6D6));

  const ReaderTheme(this.background, this.foreground);

  final Color background;
  final Color foreground;

  Brightness get brightness =>
      this == ReaderTheme.dark ? Brightness.dark : Brightness.light;
}

/// Local reading settings (they describe this device's screen, so they are not
/// synced to the server like playback settings are).
class ReaderPreferences {
  static const _kFontScale = 'reader_font_scale';
  static const _kTheme = 'reader_theme';
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static const double minFontScale = 0.8;
  static const double maxFontScale = 1.6;

  static Future<double> getFontScale() async {
    final value = await _prefs.getDouble(_kFontScale);
    return (value ?? 1.0).clamp(minFontScale, maxFontScale);
  }

  static Future<void> setFontScale(double value) =>
      _prefs.setDouble(_kFontScale, value.clamp(minFontScale, maxFontScale));

  static Future<ReaderTheme> getTheme() async {
    final name = await _prefs.getString(_kTheme);
    return ReaderTheme.values
            .where((theme) => theme.name == name)
            .firstOrNull ??
        ReaderTheme.light;
  }

  static Future<void> setTheme(ReaderTheme theme) =>
      _prefs.setString(_kTheme, theme.name);
}
