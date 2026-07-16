import 'package:shared_preferences/shared_preferences.dart';

/// How a page is fitted to the viewport.
enum ComicFitMode {
  /// The whole page visible (contain).
  fitPage,

  /// The page fills the viewport width; tall pages scroll/pan vertically.
  fitWidth,
}

/// Local comic reading settings. Reading direction and fit are persisted per
/// *series* (falling back to the book for a series-less volume): right-to-left
/// is a property of the manga, not of one volume, so setting it once on volume
/// 1 makes volume 2 open correctly too.
class ComicPreferences {
  static const _kRtl = 'comic_rtl_';
  static const _kFit = 'comic_fit_';
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static Future<bool> getRightToLeft(String scopeId) async =>
      await _prefs.getBool('$_kRtl$scopeId') ?? false;

  static Future<void> setRightToLeft(String scopeId, bool value) =>
      _prefs.setBool('$_kRtl$scopeId', value);

  static Future<ComicFitMode> getFitMode(String scopeId) async {
    final name = await _prefs.getString('$_kFit$scopeId');
    return ComicFitMode.values.where((mode) => mode.name == name).firstOrNull ??
        ComicFitMode.fitPage;
  }

  static Future<void> setFitMode(String scopeId, ComicFitMode mode) =>
      _prefs.setString('$_kFit$scopeId', mode.name);
}
