/// The JSON shapes of the server's `/library-upload/**` endpoints.
library;

/// A library directory an upload can go to.
class UploadDirectory {
  UploadDirectory({
    required this.id,
    required this.name,
    required this.libraryId,
    required this.libraryName,
    required this.libraryType,
    required this.storageKind,
    required this.path,
    required this.nodeName,
    required this.nodeUrl,
    required this.freeBytes,
    required this.writable,
  });

  final String id;
  final String name;
  final String libraryId;
  final String libraryName;
  final String libraryType;
  final String storageKind;
  final String path;
  final String? nodeName;

  /// The node every call but the directory listing goes to: a chunk is
  /// written where it arrives, never forwarded.
  final String? nodeUrl;
  final int? freeBytes;
  final bool writable;

  factory UploadDirectory.fromJson(Map<String, dynamic> json) => UploadDirectory(
        id: json['id'] as String,
        name: json['name'] as String,
        libraryId: json['libraryId'] as String,
        libraryName: json['libraryName'] as String,
        libraryType: json['libraryType'] as String,
        storageKind: json['storageKind'] as String? ?? 'LOCAL',
        path: json['path'] as String? ?? '',
        nodeName: json['nodeName'] as String?,
        nodeUrl: json['nodeUrl'] as String?,
        freeBytes: (json['freeBytes'] as num?)?.toInt(),
        writable: json['writable'] as bool? ?? true,
      );
}

/// What the scanner's path parsers made of a file; only the fields of its
/// library type are set.
class UploadRecognition {
  UploadRecognition(this.json);
  final Map<String, dynamic> json;

  String? get kind => json['kind'] as String?;

  /// One line for the preview table: "S01E06-07", "R.E.M. · Out of Time · 1", …
  String summary() {
    final parts = <String>[];
    void add(Object? value) {
      if (value != null && '$value'.isNotEmpty) parts.add('$value');
    }

    add(json['series']);
    add(json['artist']);
    add(json['author']);
    add(json['title']);
    add(json['album']);
    add(json['book']);
    if (json['year'] != null) parts.add('(${json['year']})');
    final season = json['season'];
    final episodes = (json['episodes'] as List?)?.cast<num>();
    if (season != null && episodes != null && episodes.isNotEmpty) {
      String two(num n) => n.toInt().toString().padLeft(2, '0');
      parts.add('S${two(season as num)}E${episodes.map(two).join('-')}');
    }
    if (json['disc'] != null && (json['disc'] as num) > 1) parts.add('disc ${json['disc']}');
    if (json['track'] != null) parts.add('#${json['track']}');
    if (json['chapter'] != null) parts.add('#${json['chapter']}');
    if (json['volume'] != null) {
      final volume = json['volume'] as num;
      parts.add('vol. ${volume == volume.roundToDouble() ? volume.toInt() : volume}');
    }
    return parts.join(' · ');
  }
}

enum UploadPreviewStatus { recognised, ignored, exists, busy, invalid, duplicate }

UploadPreviewStatus _previewStatus(String? value) => switch (value) {
      'RECOGNISED' => UploadPreviewStatus.recognised,
      'EXISTS' => UploadPreviewStatus.exists,
      'BUSY' => UploadPreviewStatus.busy,
      'INVALID' => UploadPreviewStatus.invalid,
      'DUPLICATE' => UploadPreviewStatus.duplicate,
      _ => UploadPreviewStatus.ignored,
    };

class UploadPreviewEntry {
  UploadPreviewEntry({
    required this.relativePath,
    required this.targetPath,
    required this.size,
    required this.status,
    required this.ignoreReason,
    required this.detail,
    required this.recognition,
  });

  final String relativePath;
  final String? targetPath;
  final int size;
  final UploadPreviewStatus status;

  /// `UNSUPPORTED_FILE` or `FOLDER_NOT_SCANNED` (then [detail] is that folder).
  final String? ignoreReason;
  final String? detail;
  final UploadRecognition? recognition;

  factory UploadPreviewEntry.fromJson(Map<String, dynamic> json) => UploadPreviewEntry(
        relativePath: json['relativePath'] as String,
        targetPath: json['targetPath'] as String?,
        size: (json['size'] as num).toInt(),
        status: _previewStatus(json['status'] as String?),
        ignoreReason: json['ignoreReason'] as String?,
        detail: json['detail'] as String?,
        recognition: json['recognition'] == null
            ? null
            : UploadRecognition((json['recognition'] as Map).cast<String, dynamic>()),
      );
}

/// A top-level folder the upload creates or extends, and the level the
/// scanner sees it at (SHOW, MOVIE, ARTIST, ALBUM, SERIES, NONE).
class UploadPreviewRoot {
  UploadPreviewRoot({required this.name, required this.level, required this.existing});
  final String name;
  final String level;
  final bool existing;

  factory UploadPreviewRoot.fromJson(Map<String, dynamic> json) => UploadPreviewRoot(
        name: json['name'] as String,
        level: json['level'] as String,
        existing: json['existing'] as bool? ?? false,
      );
}

class UploadPreview {
  UploadPreview({
    required this.libraryType,
    required this.roots,
    required this.entries,
    required this.uploadBytes,
    required this.uploadFiles,
  });

  final String libraryType;
  final List<UploadPreviewRoot> roots;
  final List<UploadPreviewEntry> entries;
  final int uploadBytes;
  final int uploadFiles;

  factory UploadPreview.fromJson(Map<String, dynamic> json) => UploadPreview(
        libraryType: json['libraryType'] as String,
        roots: [
          for (final r in (json['roots'] as List? ?? []))
            UploadPreviewRoot.fromJson((r as Map).cast<String, dynamic>())
        ],
        entries: [
          for (final e in (json['entries'] as List? ?? []))
            UploadPreviewEntry.fromJson((e as Map).cast<String, dynamic>())
        ],
        uploadBytes: (json['uploadBytes'] as num).toInt(),
        uploadFiles: (json['uploadFiles'] as num).toInt(),
      );
}

class UploadFileState {
  UploadFileState({
    required this.fileId,
    required this.relativePath,
    required this.size,
    required this.chunkSize,
    required this.receivedBytes,
    required this.status,
    required this.completedParts,
  });

  final String fileId;
  final String relativePath;
  final int size;
  final int chunkSize;
  final int receivedBytes;

  /// PENDING, UPLOADING, COMPLETED, SKIPPED or FAILED.
  final String status;

  /// S3 directories only: the 1-based parts the server already has. Parts are
  /// addressed by number there, so a resume skips exactly these.
  final List<int> completedParts;

  bool get isActive => status == 'PENDING' || status == 'UPLOADING';

  factory UploadFileState.fromJson(Map<String, dynamic> json) => UploadFileState(
        fileId: json['fileId'] as String,
        relativePath: json['relativePath'] as String,
        size: (json['size'] as num).toInt(),
        chunkSize: (json['chunkSize'] as num).toInt(),
        receivedBytes: (json['receivedBytes'] as num).toInt(),
        status: json['status'] as String,
        completedParts: [for (final p in (json['completedParts'] as List? ?? [])) (p as num).toInt()],
      );
}

class UploadSession {
  UploadSession({required this.sessionId, required this.status, required this.files, required this.skipped});
  final String sessionId;
  final String status;
  final List<UploadFileState> files;
  final List<UploadPreviewEntry> skipped;

  factory UploadSession.fromJson(Map<String, dynamic> json) => UploadSession(
        sessionId: json['sessionId'] as String,
        status: json['status'] as String,
        files: [
          for (final f in (json['files'] as List? ?? []))
            UploadFileState.fromJson((f as Map).cast<String, dynamic>())
        ],
        skipped: [
          for (final e in (json['skipped'] as List? ?? []))
            UploadPreviewEntry.fromJson((e as Map).cast<String, dynamic>())
        ],
      );
}

/// The answer to a chunk or a complete call — and the body of a 409, which is
/// how the server says where a file really continues.
class UploadChunkResult {
  UploadChunkResult({required this.receivedBytes, required this.status});
  final int receivedBytes;
  final String status;

  factory UploadChunkResult.fromJson(Map<String, dynamic> json) => UploadChunkResult(
        receivedBytes: (json['receivedBytes'] as num).toInt(),
        status: json['status'] as String,
      );
}
