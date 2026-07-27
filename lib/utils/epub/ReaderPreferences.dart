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

/// Typeface of the reading surface: the book/platform default, or an explicit
/// generic family for readers with a preference.
enum ReaderFontFamily {
  standard(null),
  serif('serif'),
  sans('sans-serif');

  const ReaderFontFamily(this.fontFamily);

  /// Value for [TextStyle.fontFamily]; null keeps the default.
  final String? fontFamily;
}

/// Local reading settings (they describe this device's screen, so they are not
/// synced to the server like playback settings are).
class ReaderPreferences {
  static const _kFontScale = 'reader_font_scale';
  static const _kTheme = 'reader_theme';
  static const _kFullscreen = 'reader_fullscreen';
  static const _kLineHeight = 'reader_line_height';
  static const _kMargin = 'reader_margin';
  static const _kFontFamily = 'reader_font_family';
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static const double minFontScale = 0.8;
  static const double maxFontScale = 1.6;

  static const double minLineHeight = 1.2;
  static const double maxLineHeight = 2.2;
  static const double defaultLineHeight = 1.6;

  static const double minMargin = 8;
  static const double maxMargin = 64;
  static const double defaultMargin = 24;

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

  static Future<bool> getFullscreen() async =>
      await _prefs.getBool(_kFullscreen) ?? false;

  static Future<void> setFullscreen(bool value) =>
      _prefs.setBool(_kFullscreen, value);

  static Future<double> getLineHeight() async {
    final value = await _prefs.getDouble(_kLineHeight);
    return (value ?? defaultLineHeight).clamp(minLineHeight, maxLineHeight);
  }

  static Future<void> setLineHeight(double value) =>
      _prefs.setDouble(_kLineHeight, value.clamp(minLineHeight, maxLineHeight));

  static Future<double> getMargin() async {
    final value = await _prefs.getDouble(_kMargin);
    return (value ?? defaultMargin).clamp(minMargin, maxMargin);
  }

  static Future<void> setMargin(double value) =>
      _prefs.setDouble(_kMargin, value.clamp(minMargin, maxMargin));

  static Future<ReaderFontFamily> getFontFamily() async {
    final name = await _prefs.getString(_kFontFamily);
    return ReaderFontFamily.values
            .where((family) => family.name == name)
            .firstOrNull ??
        ReaderFontFamily.standard;
  }

  static Future<void> setFontFamily(ReaderFontFamily family) =>
      _prefs.setString(_kFontFamily, family.name);
}
