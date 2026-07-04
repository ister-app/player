import 'package:shared_preferences/shared_preferences.dart';

/// The music library the Android Auto browse tree opens into by default.
class AutoLibrary {
  final String serverName;
  final String libraryId;

  const AutoLibrary({required this.serverName, required this.libraryId});
}

/// The last played track, used to rebuild the Android Auto "recent" tile
/// after the app process was killed.
class AutoLastPlayed {
  final String serverName;
  final String albumId;
  final String trackId;

  const AutoLastPlayed({
    required this.serverName,
    required this.albumId,
    required this.trackId,
  });
}

/// Persisted state for the Android Auto browse tree. Lives outside the UI so
/// the audio-service handler can read it on a cold start in the car, before
/// (or without) the app UI ever opening.
class AutoPreferences {
  static const _kServerKey = 'auto_default_server';
  static const _kLibraryKey = 'auto_default_library';
  static const _kLastServerKey = 'auto_last_server';
  static const _kLastAlbumKey = 'auto_last_album';
  static const _kLastTrackKey = 'auto_last_track';
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static Future<AutoLibrary?> getDefaultLibrary() async {
    final server = await _prefs.getString(_kServerKey);
    final library = await _prefs.getString(_kLibraryKey);
    if (server == null || library == null) return null;
    return AutoLibrary(serverName: server, libraryId: library);
  }

  static Future<void> setDefaultLibrary(
      String serverName, String libraryId) async {
    await _prefs.setString(_kServerKey, serverName);
    await _prefs.setString(_kLibraryKey, libraryId);
  }

  static Future<void> clearDefaultLibrary() async {
    await _prefs.remove(_kServerKey);
    await _prefs.remove(_kLibraryKey);
  }

  static Future<AutoLastPlayed?> getLastPlayed() async {
    final server = await _prefs.getString(_kLastServerKey);
    final album = await _prefs.getString(_kLastAlbumKey);
    final track = await _prefs.getString(_kLastTrackKey);
    if (server == null || album == null || track == null) return null;
    return AutoLastPlayed(serverName: server, albumId: album, trackId: track);
  }

  static Future<void> setLastPlayed(
      String serverName, String albumId, String trackId) async {
    await _prefs.setString(_kLastServerKey, serverName);
    await _prefs.setString(_kLastAlbumKey, albumId);
    await _prefs.setString(_kLastTrackKey, trackId);
  }
}
