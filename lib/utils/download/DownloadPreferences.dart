import 'package:flutter/foundation.dart';
import 'package:player/utils/ServerStore.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadStore.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Device-local download settings, per server.
class DownloadPreferences {
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static String _k(String key, String serverName) =>
      'downloads_${key}_${DownloadStore.slug(serverName)}';

  static Future<DownloadVideoQuality> getVideoQuality(String serverName) async {
    final v = await _prefs.getString(_k('video_quality', serverName));
    return v == null
        ? DownloadVideoQuality.original
        : DownloadVideoQuality.values.byName(v);
  }

  static Future<void> setVideoQuality(
          String serverName, DownloadVideoQuality q) =>
      _prefs.setString(_k('video_quality', serverName), q.name);

  static Future<DownloadAudioQuality> getAudioQuality(String serverName) async {
    final v = await _prefs.getString(_k('audio_quality', serverName));
    return v == null
        ? DownloadAudioQuality.original
        : DownloadAudioQuality.values.byName(v);
  }

  static Future<void> setAudioQuality(
          String serverName, DownloadAudioQuality q) =>
      _prefs.setString(_k('audio_quality', serverName), q.name);

  static Future<bool> getDownloadSubtitles(String serverName) async =>
      await _prefs.getBool(_k('subtitles', serverName)) ?? true;

  static Future<void> setDownloadSubtitles(String serverName, bool v) =>
      _prefs.setBool(_k('subtitles', serverName), v);

  /// Which connections downloads may run over. Device-wide: the connection is
  /// the device's, not the server's.
  static const _kNetworkPolicy = 'downloads_network_policy';

  static Future<DownloadNetworkPolicy> getNetworkPolicy() async {
    final v = await _prefs.getString(_kNetworkPolicy);
    if (v == null) return DownloadNetworkPolicy.automaticUnmeteredOnly;
    try {
      return DownloadNetworkPolicy.values.byName(v);
    } catch (_) {
      return DownloadNetworkPolicy.automaticUnmeteredOnly;
    }
  }

  static Future<void> setNetworkPolicy(DownloadNetworkPolicy p) =>
      _prefs.setString(_kNetworkPolicy, p.name);

  /// One-shot upgrade from the per-server `unmetered_only` switch this setting
  /// replaced. Only "off" carried information (download over anything); both
  /// the old and the new default mean "automatic downloads wait".
  static Future<void> migrateNetworkPolicy() async {
    if (await _prefs.getString(_kNetworkPolicy) != null) return;
    var policy = DownloadNetworkPolicy.automaticUnmeteredOnly;
    for (final server in await ServerStore.list()) {
      final legacy = _k('unmetered_only', server);
      if (await _prefs.getBool(legacy) == false) {
        policy = DownloadNetworkPolicy.any;
      }
      await _prefs.remove(legacy);
    }
    await setNetworkPolicy(policy);
  }

  static Future<int> getConcurrent(String serverName) async =>
      await _prefs.getInt(_k('concurrent', serverName)) ?? 1;

  static Future<void> setConcurrent(String serverName, int v) =>
      _prefs.setInt(_k('concurrent', serverName), v);

  /// Default for the "download next N" dialogs.
  static Future<int> getDefaultNextCount(String serverName) async =>
      await _prefs.getInt(_k('next_count', serverName)) ?? 5;

  static Future<void> setDefaultNextCount(String serverName, int v) =>
      _prefs.setInt(_k('next_count', serverName), v);

  @visibleForTesting
  static Future<void> clearForTest(String serverName) async {
    for (final k in [
      'video_quality',
      'audio_quality',
      'subtitles',
      'concurrent',
      'next_count'
    ]) {
      await _prefs.remove(_k(k, serverName));
    }
    await _prefs.remove(_kNetworkPolicy);
  }
}
