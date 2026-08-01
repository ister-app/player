import 'package:shared_preferences/shared_preferences.dart';

/// The play queue that was last playing music, so a fresh app start can
/// re-load it paused into the mini player. Only the queue's identity is stored
/// locally — the current item and position live on the server
/// (`PlayQueue.currentItemId` / `progressInMilliseconds`).
class LastMusicQueue {
  final String serverName;
  final String playQueueId;

  const LastMusicQueue({required this.serverName, required this.playQueueId});
}

/// Persists which play queue last played music. Written by the media handler
/// whenever a queue item opens: saved for tracks, cleared for anything else,
/// so only a queue that was *last* used for music ever gets restored.
class LastMusicQueuePreferences {
  static const _kServerKey = 'last_music_queue_server';
  static const _kQueueKey = 'last_music_queue_id';
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static Future<LastMusicQueue?> get() async {
    final server = await _prefs.getString(_kServerKey);
    final queue = await _prefs.getString(_kQueueKey);
    if (server == null || queue == null) return null;
    return LastMusicQueue(serverName: server, playQueueId: queue);
  }

  static Future<void> save(String serverName, String playQueueId) async {
    await _prefs.setString(_kServerKey, serverName);
    await _prefs.setString(_kQueueKey, playQueueId);
  }

  static Future<void> clear() async {
    await _prefs.remove(_kServerKey);
    await _prefs.remove(_kQueueKey);
  }
}
