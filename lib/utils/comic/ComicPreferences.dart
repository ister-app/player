import 'package:shared_preferences/shared_preferences.dart';

/// How a page is fitted to the viewport.
enum ComicFitMode {
  /// The whole page visible (contain).
  fitPage,

  /// The page fills the viewport width; tall pages scroll/pan vertically.
  fitWidth,
}

/// How logical pages are grouped into spreads.
enum ComicSpreadMode {
  /// Two-up on a wide viewport, single otherwise (the size heuristic).
  auto,

  /// Always one page per spread.
  single,

  /// Always two-up (cover and wide pages still stand alone).
  double,
}

/// Local comic reading settings, persisted per *series* (falling back to the
/// book for a series-less volume): right-to-left is a property of the manga,
/// not of one volume, so setting it once on volume 1 makes volume 2 open
/// correctly too.
///
/// For volumes that belong to a server-side series the RTL key is only an
/// offline cache of `Series.readingDirection` (SeriesDirectionService writes
/// through on every fetch); for series-less volumes it stays the source of
/// truth. Fit and spread mode describe this device's screen and are
/// deliberately not synced to the server.
class ComicPreferences {
  static const _kRtl = 'comic_rtl_';
  static const _kFit = 'comic_fit_';
  static const _kSpread = 'comic_spread_';
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

  static Future<ComicSpreadMode> getSpreadMode(String scopeId) async {
    final name = await _prefs.getString('$_kSpread$scopeId');
    return ComicSpreadMode.values
            .where((mode) => mode.name == name)
            .firstOrNull ??
        ComicSpreadMode.auto;
  }

  static Future<void> setSpreadMode(String scopeId, ComicSpreadMode mode) =>
      _prefs.setString('$_kSpread$scopeId', mode.name);
}
