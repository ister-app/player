import 'package:player/utils/UserSettingsService.dart';

/// Direct play, transcoding and the video quality cap. Stored server-side per user (see
/// [UserSettingsService]); the quality cap also tells the server which video variants are worth
/// pre-transcoding.
class PlaybackPreferences {
  static Future<bool> getDirectPlay({String? serverName}) async {
    final settings = await UserSettingsService().settingsFor(serverName);
    return settings.directPlay;
  }

  static Future<void> setDirectPlay(bool value, {String? serverName}) async {
    final service = UserSettingsService();
    final current = await service.settingsFor(serverName);
    await service.save(serverName, current.copyWith(directPlay: value));
  }

  static Future<bool> getTranscode({String? serverName}) async {
    final settings = await UserSettingsService().settingsFor(serverName);
    return settings.transcode;
  }

  static Future<void> setTranscode(bool value, {String? serverName}) async {
    final service = UserSettingsService();
    final current = await service.settingsFor(serverName);
    await service.save(serverName, current.copyWith(transcode: value));
  }

  /// Highest video variant to play and pre-transcode (720 / 480); null means no cap.
  static Future<int?> getMaxVideoHeight({String? serverName}) async {
    final settings = await UserSettingsService().settingsFor(serverName);
    return settings.maxVideoHeight;
  }

  static Future<void> setMaxVideoHeight(int? value, {String? serverName}) async {
    final service = UserSettingsService();
    final current = await service.settingsFor(serverName);
    await service.save(
        serverName,
        current.copyWith(
            maxVideoHeight: value, clearMaxVideoHeight: value == null));
  }
}
