import 'package:flutter/foundation.dart';
import 'package:player/utils/PlatformService.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadStore.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Per-server settings of the automatic music cache ("keep the N most
/// recently played tracks, up to X GB").
class MusicCacheSettings {
  const MusicCacheSettings({
    this.enabled = false,
    this.maxTracks = 1000,
    required this.maxBytes,
    this.quality = DownloadAudioQuality.original,
  });

  final bool enabled;
  final int maxTracks;
  final int maxBytes;
  final DownloadAudioQuality quality;

  MusicCacheSettings copyWith({
    bool? enabled,
    int? maxTracks,
    int? maxBytes,
    DownloadAudioQuality? quality,
  }) =>
      MusicCacheSettings(
        enabled: enabled ?? this.enabled,
        maxTracks: maxTracks ?? this.maxTracks,
        maxBytes: maxBytes ?? this.maxBytes,
        quality: quality ?? this.quality,
      );
}

class MusicCachePreferences {
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  static const int gb = 1000 * 1000 * 1000;

  static String _k(String key, String serverName) =>
      'music_cache_${key}_${DownloadStore.slug(serverName)}';

  /// A TV box has little internal storage: a smaller default there.
  static int get defaultMaxBytes =>
      PlatformService.isAndroidTvSync ? 2 * gb : 10 * gb;

  static Future<MusicCacheSettings> get(String serverName) async {
    final quality = await _prefs.getString(_k('quality', serverName));
    return MusicCacheSettings(
      enabled: await _prefs.getBool(_k('enabled', serverName)) ?? false,
      maxTracks: await _prefs.getInt(_k('max_tracks', serverName)) ?? 1000,
      maxBytes:
          await _prefs.getInt(_k('max_bytes', serverName)) ?? defaultMaxBytes,
      quality: quality == null
          ? DownloadAudioQuality.original
          : DownloadAudioQuality.values.byName(quality),
    );
  }

  static Future<void> save(String serverName, MusicCacheSettings s) async {
    await _prefs.setBool(_k('enabled', serverName), s.enabled);
    await _prefs.setInt(_k('max_tracks', serverName), s.maxTracks);
    await _prefs.setInt(_k('max_bytes', serverName), s.maxBytes);
    await _prefs.setString(_k('quality', serverName), s.quality.name);
  }

  @visibleForTesting
  static Future<void> clearForTest(String serverName) async {
    for (final k in ['enabled', 'max_tracks', 'max_bytes', 'quality']) {
      await _prefs.remove(_k(k, serverName));
    }
  }
}
