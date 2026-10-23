import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'games/GameUploadCandidate.dart';

/// A game batch in flight: what is being uploaded now and what still waits,
/// so a restart carries on where it was.
class StoredBatch {
  const StoredBatch({
    required this.directoryId,
    required this.libraryId,
    required this.overwrite,
    required this.current,
    required this.queue,
    required this.done,
  });

  final String directoryId;
  final String libraryId;
  final bool overwrite;

  /// The candidate of the stored session (null when the batch is between games).
  final GameUploadCandidate? current;
  final List<GameUploadCandidate> queue;

  /// Titles that finished before the restart, for the list.
  final List<String> done;

  Map<String, dynamic> toJson() => {
        'directoryId': directoryId,
        'libraryId': libraryId,
        'overwrite': overwrite,
        'current': current?.toJson(),
        'queue': [for (final c in queue) c.toJson()],
        'done': done,
      };

  factory StoredBatch.fromJson(Map<String, dynamic> json) => StoredBatch(
        directoryId: json['directoryId'] as String,
        libraryId: json['libraryId'] as String,
        overwrite: json['overwrite'] as bool? ?? false,
        current: json['current'] == null ? null : GameUploadCandidate.fromJson((json['current'] as Map).cast()),
        queue: [for (final c in json['queue'] as List? ?? []) GameUploadCandidate.fromJson((c as Map).cast())],
        done: [for (final t in json['done'] as List? ?? []) t as String],
      );
}

/// What the page remembers about an upload the server still holds open.
class StoredUpload {
  const StoredUpload({
    required this.sessionId,
    required this.nodeUrl,
    required this.s3,
    this.sourcePath,
    this.batch,
  });

  final String sessionId;
  final String nodeUrl;
  final bool s3;

  /// The picked folder's path, when the platform can reopen it (desktop).
  final String? sourcePath;
  final StoredBatch? batch;

  Map<String, dynamic> toJson() => {
        'v': 2,
        'sessionId': sessionId,
        'nodeUrl': nodeUrl,
        's3': s3,
        'sourcePath': sourcePath,
        'batch': batch?.toJson(),
      };

  /// Reads the v2 shape and the first one (`{sessionId, nodeUrl, s3}`).
  factory StoredUpload.fromJson(Map<String, dynamic> json) => StoredUpload(
        sessionId: json['sessionId'] as String,
        nodeUrl: json['nodeUrl'] as String,
        s3: json['s3'] == true,
        sourcePath: json['sourcePath'] as String?,
        batch: json['batch'] == null ? null : StoredBatch.fromJson((json['batch'] as Map).cast()),
      );
}

/// One remembered upload per server (`upload_session_<server>`), single or
/// batch: the two never coexist.
class UploadResumeStore {
  UploadResumeStore(this.serverName, {SharedPreferencesAsync? prefs}) : _prefs = prefs ?? SharedPreferencesAsync();

  final String serverName;
  final SharedPreferencesAsync _prefs;

  String get _key => 'upload_session_$serverName';

  Future<StoredUpload?> load() async {
    final raw = await _prefs.getString(_key);
    if (raw == null) return null;
    try {
      return StoredUpload.fromJson((jsonDecode(raw) as Map).cast<String, dynamic>());
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<void> save(StoredUpload upload) => _prefs.setString(_key, jsonEncode(upload.toJson()));

  Future<void> clear() => _prefs.remove(_key);
}
