import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'UploadApi.dart';
import 'UploadModels.dart';
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
    this.title,
  });

  final String sessionId;
  final String nodeUrl;
  final bool s3;

  /// What is being uploaded, as the user named it (the root folder or the
  /// game), so a reminder can say more than "an upload"; null for entries
  /// written before this was stored.
  final String? title;

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
        'title': title,
      };

  /// Whether the upload can go on without asking for the folder again.
  bool get resumesWithoutPicking => batch != null || sourcePath != null;

  /// The name to show for it: the stored title, else the game in flight.
  String? get displayTitle => title ?? batch?.current?.rootName ?? batch?.queue.firstOrNull?.rootName;

  /// Reads the v2 shape and the first one (`{sessionId, nodeUrl, s3}`).
  factory StoredUpload.fromJson(Map<String, dynamic> json) => StoredUpload(
        sessionId: json['sessionId'] as String,
        nodeUrl: json['nodeUrl'] as String,
        s3: json['s3'] == true,
        sourcePath: json['sourcePath'] as String?,
        batch: json['batch'] == null ? null : StoredBatch.fromJson((json['batch'] as Map).cast()),
        title: json['title'] as String?,
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

  /// The remembered upload if there is still something to do: the server
  /// holds its session open, or a batch has games left. Anything else is
  /// forgotten here and now, so no page keeps offering a finished upload.
  Future<StoredUpload?> loadUnfinished(UploadApi api) async {
    final stored = await load();
    if (stored == null) return null;
    UploadSession? session;
    try {
      session = await api.session(stored.nodeUrl, stored.sessionId);
    } catch (_) {
      // gone, or the server is unreachable: a batch still has its queue
    }
    final active = session != null && session.status == 'ACTIVE' && session.files.any((f) => f.isActive);
    final batchLeft = stored.batch != null && stored.batch!.queue.isNotEmpty;
    if (active || batchLeft) return stored;
    await clear();
    return null;
  }

  Future<void> save(StoredUpload upload) => _prefs.setString(_key, jsonEncode(upload.toJson()));

  Future<void> clear() => _prefs.remove(_key);
}
