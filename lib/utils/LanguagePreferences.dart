import 'package:player/utils/UserSettingsService.dart';

/// Preferred spoken and subtitle languages. These now live on the server (per user, per server) —
/// [UserSettingsService] holds the cache and does the syncing. This class stays as the small,
/// familiar surface the player and the settings page call.
///
/// Passing [serverName] is preferred; without it the last used server is assumed, which is what
/// the settings UI and single-server setups want.
class LanguagePreferences {
  // ---------- READ ----------
  static Future<List<String>> getSpokenLanguages({String? serverName}) async {
    final settings = await UserSettingsService().settingsFor(serverName);
    return settings.spokenLanguages;
  }

  static Future<List<String>> getSubtitleLanguages({String? serverName}) async {
    final settings = await UserSettingsService().settingsFor(serverName);
    return settings.subtitleLanguages;
  }

  // ---------- WRITE ----------
  static Future<void> setSpokenLanguages(List<String> list, {String? serverName}) async {
    final service = UserSettingsService();
    final current = await service.settingsFor(serverName);
    await service.save(serverName, current.copyWith(spokenLanguages: list));
  }

  static Future<void> setSubtitleLanguages(List<String> list, {String? serverName}) async {
    final service = UserSettingsService();
    final current = await service.settingsFor(serverName);
    await service.save(serverName, current.copyWith(subtitleLanguages: list));
  }
}
