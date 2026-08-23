import 'package:player/graphql/fragmentPlayQueue.graphql.dart';

/// The five playable kinds a download can hold — the same discriminator as a
/// play-queue item's non-null field.
enum DownloadKind { track, chapter, podcastEpisode, movie, episode, book }

/// The file formats a `DownloadKind.book` entry can hold.
enum BookFormat { epub, cbz, pdf }

BookFormat? bookFormatFrom(String? serverFormat) => switch (serverFormat?.toUpperCase()) {
      'EPUB' => BookFormat.epub,
      'CBZ' => BookFormat.cbz,
      'PDF' => BookFormat.pdf,
      _ => null,
    };

enum DownloadStatus { queued, downloading, paused, complete, failed }

/// Which HLS variant a video download mirrors. `original` is the server's
/// stream-copy variant (`direct=true`), the others its re-encoded ones.
enum DownloadVideoQuality { original, p720, p480 }

/// For audio-only files: `original` keeps the source codec when MPEG-TS can
/// carry it (else AAC 192k); `compact` always takes the 192k transcode.
enum DownloadAudioQuality { original, compact }

/// One downloaded (or downloading) media file plus everything the app needs
/// to show and play it without the server: the play-queue item snapshot, the
/// artwork file and the chosen renditions.
class DownloadEntry {
  const DownloadEntry({
    required this.kind,
    required this.mediaId,
    required this.mediaFileId,
    required this.nodeUrl,
    required this.groupId,
    required this.groupTitle,
    required this.title,
    this.queueItemJson,
    required this.createdAt,
    this.subtitle,
    this.sortKey = 0,
    this.durationMs = 0,
    this.artworkFile,
    this.status = DownloadStatus.queued,
    this.error,
    this.bytes = 0,
    this.segmentsDone = 0,
    this.segmentsTotal = 0,
    this.pinned = true,
    this.lastPlayedAt,
    this.downloadedAt,
    this.videoQuality,
    this.audioQuality = DownloadAudioQuality.original,
    this.audioStreamIndexes = const [],
    this.subtitleStreamIds = const [],
    this.format,
    this.mediaOverlays = false,
    this.pageCount,
    this.artworkUrl,
  });

  static String keyFor(DownloadKind kind, String mediaId) =>
      '${kind.name}:$mediaId';

  String get key => keyFor(kind, mediaId);

  final DownloadKind kind;
  final String mediaId;
  final String mediaFileId;
  final String nodeUrl;

  /// Album / book / podcast / show id the item belongs to (a movie is its own
  /// group) — the Downloads page groups on this.
  final String groupId;
  final String groupTitle;
  final String title;

  /// Artist, author, "S2 E5", published date — kind-specific second line.
  final String? subtitle;

  /// Order within the group: disc*1000+track, season*1000+episode, chapter
  /// number, publication order.
  final int sortKey;
  final int durationMs;

  /// `Fragment$fragmentPlayQueue$playQueueItems.toJson()` — rebuilt with
  /// `fromJson` for offline playback so every queue consumer keeps working.
  /// Null for a reading entry (an epub/comic has no queue item).
  final Map<String, dynamic>? queueItemJson;

  /// Reading entries only: the file format, whether it is a read-aloud
  /// edition, its page count, and the cover URL to (re)fetch.
  final BookFormat? format;
  final bool mediaOverlays;
  final int? pageCount;
  final String? artworkUrl;

  /// File name inside the item directory, when the cover was fetched.
  final String? artworkFile;
  final DownloadStatus status;
  final String? error;

  /// Bytes on disk so far (segments + playlists + sidecars).
  final int bytes;
  final int segmentsDone;
  final int segmentsTotal;

  /// Manual download (never evicted) versus a music-cache entry.
  final bool pinned;
  final DateTime? lastPlayedAt;
  final DateTime? downloadedAt;
  final DateTime createdAt;
  final DownloadVideoQuality? videoQuality;
  final DownloadAudioQuality audioQuality;
  final List<int> audioStreamIndexes;
  final List<String> subtitleStreamIds;

  bool get isComplete => status == DownloadStatus.complete;

  /// An epub/comic file: read, not played.
  bool get isReading => kind == DownloadKind.book;
  bool get isActive =>
      status == DownloadStatus.queued || status == DownloadStatus.downloading;

  Fragment$fragmentPlayQueue$playQueueItems get queueItem {
    final json = queueItemJson;
    if (json == null) throw StateError('reading entry $key has no queue item');
    return Fragment$fragmentPlayQueue$playQueueItems.fromJson(json);
  }

  double? get progress =>
      segmentsTotal == 0 ? null : segmentsDone / segmentsTotal;

  DownloadEntry copyWith({
    String? groupTitle,
    String? title,
    String? subtitle,
    int? sortKey,
    int? durationMs,
    Map<String, dynamic>? queueItemJson,
    String? artworkFile,
    DownloadStatus? status,
    String? error,
    bool clearError = false,
    int? bytes,
    int? segmentsDone,
    int? segmentsTotal,
    bool? pinned,
    DateTime? lastPlayedAt,
    DateTime? downloadedAt,
    DownloadVideoQuality? videoQuality,
    DownloadAudioQuality? audioQuality,
    List<int>? audioStreamIndexes,
    List<String>? subtitleStreamIds,
    int? pageCount,
  }) =>
      DownloadEntry(
        kind: kind,
        mediaId: mediaId,
        mediaFileId: mediaFileId,
        nodeUrl: nodeUrl,
        groupId: groupId,
        groupTitle: groupTitle ?? this.groupTitle,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        sortKey: sortKey ?? this.sortKey,
        durationMs: durationMs ?? this.durationMs,
        queueItemJson: queueItemJson ?? this.queueItemJson,
        artworkFile: artworkFile ?? this.artworkFile,
        status: status ?? this.status,
        error: clearError ? null : (error ?? this.error),
        bytes: bytes ?? this.bytes,
        segmentsDone: segmentsDone ?? this.segmentsDone,
        segmentsTotal: segmentsTotal ?? this.segmentsTotal,
        pinned: pinned ?? this.pinned,
        lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
        downloadedAt: downloadedAt ?? this.downloadedAt,
        createdAt: createdAt,
        videoQuality: videoQuality ?? this.videoQuality,
        audioQuality: audioQuality ?? this.audioQuality,
        audioStreamIndexes: audioStreamIndexes ?? this.audioStreamIndexes,
        subtitleStreamIds: subtitleStreamIds ?? this.subtitleStreamIds,
        format: format,
        mediaOverlays: mediaOverlays,
        pageCount: pageCount ?? this.pageCount,
        artworkUrl: artworkUrl,
      );

  Map<String, dynamic> toJson() => {
        'kind': kind.name,
        'mediaId': mediaId,
        'mediaFileId': mediaFileId,
        'nodeUrl': nodeUrl,
        'groupId': groupId,
        'groupTitle': groupTitle,
        'title': title,
        'subtitle': subtitle,
        'sortKey': sortKey,
        'durationMs': durationMs,
        'queueItem': queueItemJson,
        'artworkFile': artworkFile,
        'status': status.name,
        'error': error,
        'bytes': bytes,
        'segmentsDone': segmentsDone,
        'segmentsTotal': segmentsTotal,
        'pinned': pinned,
        'lastPlayedAt': lastPlayedAt?.toIso8601String(),
        'downloadedAt': downloadedAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'videoQuality': videoQuality?.name,
        'audioQuality': audioQuality.name,
        'audioStreamIndexes': audioStreamIndexes,
        'subtitleStreamIds': subtitleStreamIds,
        'format': format?.name,
        'mediaOverlays': mediaOverlays,
        'pageCount': pageCount,
        'artworkUrl': artworkUrl,
      };

  static DownloadEntry fromJson(Map<String, dynamic> json) => DownloadEntry(
        kind: DownloadKind.values.byName(json['kind'] as String),
        mediaId: json['mediaId'] as String,
        mediaFileId: json['mediaFileId'] as String,
        nodeUrl: json['nodeUrl'] as String,
        groupId: json['groupId'] as String,
        groupTitle: json['groupTitle'] as String,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String?,
        sortKey: (json['sortKey'] as num?)?.toInt() ?? 0,
        durationMs: (json['durationMs'] as num?)?.toInt() ?? 0,
        queueItemJson: json['queueItem'] == null
            ? null
            : Map<String, dynamic>.from(json['queueItem'] as Map),
        artworkFile: json['artworkFile'] as String?,
        status: DownloadStatus.values.byName(json['status'] as String),
        error: json['error'] as String?,
        bytes: (json['bytes'] as num?)?.toInt() ?? 0,
        segmentsDone: (json['segmentsDone'] as num?)?.toInt() ?? 0,
        segmentsTotal: (json['segmentsTotal'] as num?)?.toInt() ?? 0,
        pinned: json['pinned'] as bool? ?? true,
        lastPlayedAt: _date(json['lastPlayedAt']),
        downloadedAt: _date(json['downloadedAt']),
        createdAt: _date(json['createdAt']) ?? DateTime.now(),
        videoQuality: json['videoQuality'] == null
            ? null
            : DownloadVideoQuality.values
                .byName(json['videoQuality'] as String),
        audioQuality: json['audioQuality'] == null
            ? DownloadAudioQuality.original
            : DownloadAudioQuality.values
                .byName(json['audioQuality'] as String),
        audioStreamIndexes: (json['audioStreamIndexes'] as List? ?? const [])
            .map((e) => (e as num).toInt())
            .toList(),
        subtitleStreamIds: (json['subtitleStreamIds'] as List? ?? const [])
            .map((e) => e as String)
            .toList(),
        format: json['format'] == null
            ? null
            : BookFormat.values.byName(json['format'] as String),
        mediaOverlays: json['mediaOverlays'] as bool? ?? false,
        pageCount: (json['pageCount'] as num?)?.toInt(),
        artworkUrl: json['artworkUrl'] as String?,
      );

  static DateTime? _date(Object? v) =>
      v is String ? DateTime.tryParse(v) : null;
}

/// Bytes on disk for [entries], counting a media file shared by several
/// entries (a multi-episode file) once.
int sumUniqueBytes(Iterable<DownloadEntry> entries) {
  final seen = <String>{};
  var total = 0;
  for (final e in entries) {
    if (seen.add(e.mediaFileId)) total += e.bytes;
  }
  return total;
}

/// Live progress of one running download, published by the service.
class DownloadProgress {
  const DownloadProgress({
    required this.bytes,
    required this.segmentsDone,
    required this.segmentsTotal,
  });

  final int bytes;
  final int segmentsDone;
  final int segmentsTotal;

  double? get fraction =>
      segmentsTotal == 0 ? null : segmentsDone / segmentsTotal;
}
