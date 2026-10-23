import 'package:player/components/upload/GameUploadTarget.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/games/steam/SteamLibraryLocator.dart';

import '../GameUploadNaming.dart';
import '../UploadSource.dart';
import '../upload_source_io.dart';
import 'FileSystemView.dart';
import 'GamePlatformTable.dart';
import 'GameSourceNaming.dart';
import 'GameUploadCandidate.dart';
import 'ParamSfo.dart';
import 'SteamAppManifest.dart';

/// Finds the games on this computer that the server's scanner would accept,
/// mirroring its grammar: a platform folder (`snes/`, `ps3/`) with game folders
/// or loose ROMs in it, a PS3 dump marked by `PS3_GAME/PARAM.SFO`, and the
/// games of a Steam library. Discovery is shallow and cheap — it never lists
/// a game's tree; `GameSourceMaterialiser` does that for the ticked ones.
class GameSourceScanner {
  GameSourceScanner({
    required this.table,
    FileSystemView? fs,
    this.excludedPaths = const {},
    this.excludedSteamAppIds = const {},
    this.maxDepth = 3,
  }) : fs = fs ?? IoFileSystemView();

  final GamePlatformTable table;
  final FileSystemView fs;

  /// Folders never offered (Ister's own install root).
  final Set<String> excludedPaths;

  /// Steam games Ister itself restored into a library.
  final Set<int> excludedSteamAppIds;

  /// How deep below a source folder platform folders and PS3 dumps are looked for.
  final int maxDepth;

  static const _ps3Marker = 'PS3_GAME/PARAM.SFO';

  /// Every candidate under [roots] and in [steamLibraries], conflicts marked.
  Future<List<GameUploadCandidate>> scan(List<String> roots, List<SteamLibrary> steamLibraries) async {
    final found = <GameUploadCandidate>[];
    for (final root in roots) {
      found.addAll(await scanRoot(root));
    }
    for (final library in steamLibraries) {
      found.addAll(await scanSteamLibrary(library));
    }
    return markConflicts(found);
  }

  /// A source folder: itself a platform folder, or a tree with platform
  /// folders and PS3 dumps somewhere in its first levels.
  Future<List<GameUploadCandidate>> scanRoot(String root) async {
    if (_excluded(root) || !await fs.isDirectory(root)) return const [];
    final platform = table.byFolderName(FileSystemView.baseName(root));
    if (platform != null) return scanPlatformFolder(platform, root);
    final found = <GameUploadCandidate>[];
    await _walk(root, 0, found);
    return found;
  }

  Future<void> _walk(String dir, int depth, List<GameUploadCandidate> into) async {
    for (final entry in await fs.list(dir)) {
      if (!entry.isDirectory || entry.name.startsWith('.') || _excluded(entry.path)) continue;
      final platform = table.byFolderName(entry.name);
      if (platform != null) {
        into.addAll(await scanPlatformFolder(platform, entry.path));
        continue;
      }
      final ps3 = await _ps3Candidate(entry.path, entry.name);
      if (ps3 != null) {
        into.add(ps3);
        continue;
      }
      if (depth < maxDepth) await _walk(entry.path, depth + 1, into);
    }
  }

  /// The games directly under a platform folder: a game folder per subfolder
  /// with an entry file (or a marker), and a game per loose entry file.
  Future<List<GameUploadCandidate>> scanPlatformFolder(GamePlatformOption platform, String dir) async {
    final found = <GameUploadCandidate>[];
    final entries = await fs.list(dir);
    final files = [for (final e in entries) if (!e.isDirectory && isUploadableRelativePath(e.name)) e];
    final claimed = <String>{};
    for (final e in entries) {
      if (e.name.startsWith('.') || _excluded(e.path)) continue;
      if (e.isDirectory) {
        final candidate = GamePlatformTable.isTreePlatform(platform)
            ? await _treeCandidate(platform, e.path, e.name)
            : await _romFolderCandidate(platform, e.path, e.name);
        if (candidate != null) found.add(candidate);
      }
    }
    if (!GamePlatformTable.isTreePlatform(platform)) {
      for (final e in files) {
        if (claimed.contains(e.name)) continue;
        final extension = table.entryExtension(platform, e.name);
        if (extension == null) continue;
        final candidate = await _romFileCandidate(platform, dir, e, extension, files, claimed);
        if (candidate != null) found.add(candidate);
      }
    }
    return found;
  }

  /// A folder with the entry file(s) directly in it; the server ignores its
  /// subfolders, so only its own files go up.
  Future<GameUploadCandidate?> _romFolderCandidate(GamePlatformOption platform, String dir, String name) async {
    final entries = await fs.list(dir);
    final files = [for (final e in entries) if (!e.isDirectory && isUploadableRelativePath(e.name)) e];
    if (!files.any((f) => table.entryExtension(platform, f.name) != null)) return null;
    final parsed = GameUploadNaming.parse(name);
    final cleaned = GameSourceNaming.titleAndYear(parsed.title);
    return GameUploadCandidate(
      platform: platform.platform,
      platformFolder: platform.folder,
      title: cleaned.title,
      year: parsed.year ?? cleaned.year,
      kind: GameCandidateKind.romFolder,
      sourcePath: dir,
      files: await _sized(files),
    );
  }

  /// A loose ROM: the file itself, companions sharing its stem, and the
  /// tracks a cue sheet names. The server wraps it in `Title/`.
  Future<GameUploadCandidate?> _romFileCandidate(GamePlatformOption platform, String dir, FsEntry entry,
      String extension, List<FsEntry> siblings, Set<String> claimed) async {
    final stem = GameSourceNaming.stem(entry.name, extension);
    final members = <FsEntry>[entry];
    final wanted = <String>{};
    if (extension.toLowerCase() == 'cue') {
      try {
        wanted.addAll(GameSourceNaming.cueReferencedFiles(await fs.readString(entry.path)).map((n) => n.toLowerCase()));
      } catch (_) {
        // An unreadable cue sheet: fall back to the stem rule.
      }
    }
    for (final s in siblings) {
      if (s.name == entry.name || claimed.contains(s.name)) continue;
      final companion = table.companionExtension(platform, s.name);
      final sameStem = companion != null && GameSourceNaming.stem(s.name, companion).toLowerCase() == stem.toLowerCase();
      if (sameStem || wanted.contains(s.name.toLowerCase())) members.add(s);
    }
    claimed.addAll(members.map((m) => m.name));
    final cleaned = GameSourceNaming.titleAndYear(stem);
    return GameUploadCandidate(
      platform: platform.platform,
      platformFolder: platform.folder,
      title: cleaned.title,
      year: cleaned.year,
      kind: GameCandidateKind.romFile,
      sourcePath: entry.path,
      files: await _sized(members),
    );
  }

  Future<List<MaterialisedFile>> _sized(List<FsEntry> files) async => [
        for (final f in files) (relativePath: f.name, absolutePath: f.path, size: await fs.length(f.path)),
      ];

  /// Under a `ps3/` or `steam/` platform folder: a game folder already laid
  /// out the way the server wants it, uploaded whole.
  Future<GameUploadCandidate?> _treeCandidate(GamePlatformOption platform, String dir, String name) async {
    if (platform.platform == Enum$GamePlatform.PS3) return _ps3Candidate(dir, name, platform: platform);
    if (platform.platform == Enum$GamePlatform.STEAM) {
      final entries = await fs.list(dir);
      final manifest = entries.where((e) => !e.isDirectory && SteamAppManifest.fileName.hasMatch(e.name)).firstOrNull;
      if (manifest == null) return null;
      final parsed = SteamAppManifest.parse(await fs.readString(manifest.path));
      final named = GameUploadNaming.parse(name);
      return GameUploadCandidate(
        platform: platform.platform,
        platformFolder: platform.folder,
        title: named.title,
        year: named.year,
        kind: GameCandidateKind.tree,
        sourcePath: dir,
        steamAppId: parsed?.appId,
      );
    }
    return null;
  }

  /// A PS3 dump: `PS3_GAME/PARAM.SFO` directly in [dir] (the wrapper form —
  /// `BLUS12345/PS3_GAME/…` — is found when the walk reaches the wrapper's
  /// child). The title comes from the SFO, the year from the folder name.
  Future<GameUploadCandidate?> _ps3Candidate(String dir, String name, {GamePlatformOption? platform}) async {
    final sfoPath = fs.join(dir, _ps3Marker);
    if (!await fs.exists(sfoPath)) return null;
    final option = platform ?? table.byPlatform(Enum$GamePlatform.PS3);
    if (option == null) return null;
    String? title;
    String? titleId;
    try {
      final sfo = ParamSfo.parse(await fs.readBytes(sfoPath));
      title = sfo.title;
      titleId = sfo.titleId;
    } catch (_) {
      // A damaged SFO still marks a game; the folder name has to do.
    }
    final named = GameUploadNaming.parse(name);
    return GameUploadCandidate(
      platform: Enum$GamePlatform.PS3,
      platformFolder: option.folder,
      title: title ?? named.title,
      year: named.year,
      kind: GameCandidateKind.tree,
      sourcePath: dir,
      titleId: titleId,
    );
  }

  /// The fully installed games of one Steam library.
  Future<List<GameUploadCandidate>> scanSteamLibrary(SteamLibrary library) async {
    final option = table.byPlatform(Enum$GamePlatform.STEAM);
    if (option == null) return const [];
    final steamApps = library.steamApps.replaceAll(r'\', '/');
    if (!await fs.isDirectory(steamApps)) return const [];
    final found = <GameUploadCandidate>[];
    for (final entry in await fs.list(steamApps)) {
      if (entry.isDirectory || !SteamAppManifest.fileName.hasMatch(entry.name)) continue;
      final SteamAppManifest? manifest;
      try {
        manifest = SteamAppManifest.parse(await fs.readString(entry.path));
      } catch (_) {
        continue;
      }
      if (manifest == null || !manifest.isFullyInstalled || manifest.isRuntimeOrRedist) continue;
      if (excludedSteamAppIds.contains(manifest.appId)) continue;
      final installDir = fs.join(fs.join(steamApps, 'common'), manifest.installDir);
      if (_excluded(installDir) || !await fs.isDirectory(installDir) || (await fs.list(installDir)).isEmpty) continue;
      final cleaned = GameSourceNaming.titleAndYear(manifest.name);
      int manifestSize;
      try {
        manifestSize = await fs.length(entry.path);
      } catch (_) {
        manifestSize = 0;
      }
      found.add(GameUploadCandidate(
        platform: Enum$GamePlatform.STEAM,
        platformFolder: option.folder,
        title: cleaned.title,
        year: cleaned.year,
        kind: GameCandidateKind.steam,
        sourcePath: installDir,
        knownSize: manifest.sizeOnDisk == null ? null : manifest.sizeOnDisk! + manifestSize,
        steamAppId: manifest.appId,
        steamManifestPath: entry.path,
        steamInstallDir: installDir,
      ));
    }
    return found;
  }

  /// Two candidates that would land in the same server folder (the USA and
  /// the Europe dump of one ROM): the later one points at the earlier.
  static List<GameUploadCandidate> markConflicts(List<GameUploadCandidate> candidates) {
    final seen = <String, GameUploadCandidate>{};
    return [
      for (final c in candidates)
        () {
          final key = '${c.platform.name}|${c.rootName.toLowerCase()}';
          final earlier = seen[key];
          if (earlier == null) {
            seen[key] = c;
            return c.copyWith(clearConflict: true);
          }
          return c.copyWith(conflictWith: earlier.title);
        }(),
    ];
  }

  bool _excluded(String path) {
    final norm = path.replaceAll(r'\', '/').replaceAll(RegExp(r'/+$'), '').toLowerCase();
    for (final excluded in excludedPaths) {
      final e = excluded.replaceAll(r'\', '/').replaceAll(RegExp(r'/+$'), '').toLowerCase();
      if (norm == e || norm.startsWith('$e/')) return true;
    }
    return false;
  }
}
