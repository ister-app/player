import 'package:flutter/foundation.dart';
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

  /// Only automatic (music cache) downloads honour this.
  static Future<bool> getUnmeteredOnly(String serverName) async =>
      await _prefs.getBool(_k('unmetered_only', serverName)) ?? true;

  static Future<void> setUnmeteredOnly(String serverName, bool v) =>
      _prefs.setBool(_k('unmetered_only', serverName), v);

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
      'unmetered_only',
      'concurrent',
      'next_count'
    ]) {
      await _prefs.remove(_k(k, serverName));
    }
  }
}
