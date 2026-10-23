import 'package:player/graphql/schema.graphql.dart';

import '../GameUploadNaming.dart';
import '../upload_source_io.dart';

/// How a candidate's files are gathered for the upload.
enum GameCandidateKind {
  /// A folder with the entry file(s) directly in it; [GameUploadCandidate.files] is complete.
  romFolder,

  /// A loose entry file (plus companions) in a platform folder; [GameUploadCandidate.files] is complete.
  romFile,

  /// A folder uploaded whole (a PS3 dump, a Steam game already laid out as `acf + installdir/`).
  tree,

  /// A game in a Steam library: the manifest plus `common/<installdir>/`, listed when needed.
  steam,
}

/// A game the scanner found on this computer, as the upload page lists it.
/// Immutable; the page edits title and year through [copyWith].
class GameUploadCandidate {
  const GameUploadCandidate({
    required this.platform,
    required this.platformFolder,
    required this.title,
    required this.kind,
    required this.sourcePath,
    this.year,
    this.files,
    this.knownSize,
    this.steamAppId,
    this.steamManifestPath,
    this.steamInstallDir,
    this.titleId,
    this.treePrefix,
    this.conflictWith,
  });

  final Enum$GamePlatform platform;

  /// The folder the upload lands in (`snes`, `ps3`, `steam`).
  final String platformFolder;
  final String title;
  final String? year;
  final GameCandidateKind kind;

  /// The folder or file this came from, for the list and for the resume store.
  final String sourcePath;

  /// Complete for [GameCandidateKind.romFolder]/[GameCandidateKind.romFile];
  /// null until materialised for the tree kinds.
  final List<MaterialisedFile>? files;

  /// A size known without listing the tree (Steam's `SizeOnDisk`).
  final int? knownSize;
  final int? steamAppId;
  final String? steamManifestPath;

  /// `steamapps/common/<installdir>` of a [GameCandidateKind.steam] candidate.
  final String? steamInstallDir;
  final String? titleId;

  /// For [GameCandidateKind.tree]: put in front of every relative path —
  /// `PS3_GAME/` wraps an RPCS3 HDD game the way the server expects a PS3 folder.
  final String? treePrefix;

  /// The title of an earlier candidate that lands in the same server folder.
  final String? conflictWith;

  String get id => '${platform.name}|$sourcePath';

  /// `Title (year)`: the folder the game is scanned as.
  String get rootName => GameUploadNaming.compose(title, year);

  int? get sizeBytes {
    final list = files;
    if (list == null) return knownSize;
    var total = 0;
    for (final f in list) {
      total += f.size;
    }
    return total;
  }

  GameUploadCandidate copyWith({String? title, String? year, bool clearYear = false, String? conflictWith, bool clearConflict = false}) =>
      GameUploadCandidate(
        platform: platform,
        platformFolder: platformFolder,
        title: title ?? this.title,
        year: clearYear ? null : (year ?? this.year),
        kind: kind,
        sourcePath: sourcePath,
        files: files,
        knownSize: knownSize,
        steamAppId: steamAppId,
        steamManifestPath: steamManifestPath,
        steamInstallDir: steamInstallDir,
        titleId: titleId,
        treePrefix: treePrefix,
        conflictWith: clearConflict ? null : (conflictWith ?? this.conflictWith),
      );

  Map<String, dynamic> toJson() => {
        'platform': platform.name,
        'platformFolder': platformFolder,
        'title': title,
        'year': year,
        'kind': kind.name,
        'sourcePath': sourcePath,
        'files': files == null
            ? null
            : [for (final f in files!) {'rel': f.relativePath, 'abs': f.absolutePath, 'size': f.size}],
        'knownSize': knownSize,
        'steamAppId': steamAppId,
        'steamManifestPath': steamManifestPath,
        'steamInstallDir': steamInstallDir,
        'titleId': titleId,
        'treePrefix': treePrefix,
      };

  factory GameUploadCandidate.fromJson(Map<String, dynamic> json) => GameUploadCandidate(
        platform: Enum$GamePlatform.values.firstWhere((p) => p.name == json['platform']),
        platformFolder: json['platformFolder'] as String,
        title: json['title'] as String,
        year: json['year'] as String?,
        kind: GameCandidateKind.values.firstWhere((k) => k.name == json['kind']),
        sourcePath: json['sourcePath'] as String,
        files: json['files'] == null
            ? null
            : [
                for (final f in json['files'] as List)
                  (relativePath: f['rel'] as String, absolutePath: f['abs'] as String, size: (f['size'] as num).toInt())
              ],
        knownSize: (json['knownSize'] as num?)?.toInt(),
        steamAppId: (json['steamAppId'] as num?)?.toInt(),
        steamManifestPath: json['steamManifestPath'] as String?,
        steamInstallDir: json['steamInstallDir'] as String?,
        titleId: json['titleId'] as String?,
        treePrefix: json['treePrefix'] as String?,
      );
}
