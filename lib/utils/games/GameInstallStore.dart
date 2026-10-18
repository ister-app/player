import 'dart:convert';
import 'dart:io';

import 'package:player/utils/download/DownloadStore.dart' show DownloadStore;

import 'GameApi.dart';
import 'GameSettings.dart';

/// Where a local install is in its life. The transitions live in
/// `GameInstallState.dart`; this is the persisted value.
enum GameInstallStatus {
  /// Waiting for its turn (one game installs at a time).
  queued,
  downloading,

  /// Stopped by the user; the downloaded files stay and `resume` continues.
  paused,
  extracting,
  installed,

  /// Stopped by an error; `retry` continues where it got to.
  failed,

  /// Stopped by the user before it finished; the files stay for a later
  /// install, `remove` throws them away.
  cancelled,

  /// Installed, and the server has a newer version of the files.
  updateAvailable,
}

/// What this device knows about one installed (or installing) game.
class GameInstall {
  GameInstall({
    required this.gameId,
    required this.form,
    required this.platform,
    required this.dir,
    required this.status,
    this.title,
    this.totalBytes = 0,
    this.doneBytes = 0,
    this.filesTotal = 0,
    this.filesDone = 0,
    this.manifestEtag,
    this.installedVersion,
    this.availableVersion,
    this.availableBytes,
    this.entryPath,
    this.titleId,
    this.steamAppId,
    this.steamInstallDir,
    this.steamLibrary,
    this.lastSaveVersion = 0,
    this.lastSaveSha,
    this.linuxInstalled = false,
    this.error,
    this.queuedAt,
    this.sessionStartedAt,
    this.sessionDetached = false,
  });

  final String gameId;
  final String form;
  final String platform;

  /// `<gamesRoot>/<server-slug>/<gameId>`; Steam games are restored into a
  /// Steam library instead and keep only their bookkeeping here.
  final String dir;
  GameInstallStatus status;

  /// The game's title as it was when the install started, for lists that
  /// have no GraphQL game at hand (the downloads page).
  String? title;
  int totalBytes;
  int doneBytes;
  int filesTotal;
  int filesDone;
  String? manifestEtag;

  /// The manifest `version` the local files were installed from, and the
  /// newer one the server reported since (with the bytes an update fetches).
  /// Both null against a server that reports no version.
  String? installedVersion;
  String? availableVersion;
  int? availableBytes;
  String? entryPath;
  String? titleId;
  int? steamAppId;
  String? steamInstallDir;
  String? steamLibrary;

  /// The server save version the local save folders were last synced with.
  int lastSaveVersion;
  String? lastSaveSha;

  /// A Linux installer (.sh) has been run into `files/game`.
  bool linuxInstalled;
  String? error;

  /// When the install was asked for; the queue runs in this order.
  DateTime? queuedAt;

  /// A play session that has not been wrapped up yet (saves pushed, play
  /// time recorded). Survives an app restart so the session can still be
  /// finished; [sessionDetached] is a Steam launch the app cannot await.
  DateTime? sessionStartedAt;
  bool sessionDetached;

  Directory get filesDir => Directory('$dir/files');
  Directory get savesDir => Directory('$dir/saves');
  Directory get tmpDir => Directory('$dir/tmp');

  bool get isInstalled => status == GameInstallStatus.installed || status == GameInstallStatus.updateAvailable;

  /// Being worked on (or about to be): shown with a progress bar.
  bool get isActive =>
      status == GameInstallStatus.queued || status == GameInstallStatus.downloading || status == GameInstallStatus.extracting;

  /// Stopped half-way with its files kept: offer to continue.
  bool get isResumable =>
      status == GameInstallStatus.paused || status == GameInstallStatus.failed || status == GameInstallStatus.cancelled;

  bool get hasOpenSession => sessionStartedAt != null;

  /// What the install occupies on disk, as far as the bookkeeping knows.
  int get bytesOnDisk => isInstalled ? totalBytes : doneBytes;

  Map<String, dynamic> toJson() => {
        'gameId': gameId,
        'form': form,
        'platform': platform,
        'dir': dir,
        'status': status.name,
        'title': title,
        'totalBytes': totalBytes,
        'doneBytes': doneBytes,
        'filesTotal': filesTotal,
        'filesDone': filesDone,
        'manifestEtag': manifestEtag,
        'installedVersion': installedVersion,
        'availableVersion': availableVersion,
        'availableBytes': availableBytes,
        'entryPath': entryPath,
        'titleId': titleId,
        'steamAppId': steamAppId,
        'steamInstallDir': steamInstallDir,
        'steamLibrary': steamLibrary,
        'lastSaveVersion': lastSaveVersion,
        'lastSaveSha': lastSaveSha,
        'linuxInstalled': linuxInstalled,
        'error': error,
        'queuedAt': queuedAt?.toIso8601String(),
        'sessionStartedAt': sessionStartedAt?.toIso8601String(),
        'sessionDetached': sessionDetached,
      };

  factory GameInstall.fromJson(Map<String, dynamic> json) => GameInstall(
        gameId: json['gameId'] as String,
        form: json['form'] as String,
        platform: json['platform'] as String,
        dir: json['dir'] as String,
        status: GameInstallStatus.values.firstWhere((s) => s.name == json['status'],
            orElse: () => GameInstallStatus.failed),
        title: json['title'] as String?,
        totalBytes: (json['totalBytes'] as num?)?.toInt() ?? 0,
        doneBytes: (json['doneBytes'] as num?)?.toInt() ?? 0,
        filesTotal: (json['filesTotal'] as num?)?.toInt() ?? 0,
        filesDone: (json['filesDone'] as num?)?.toInt() ?? 0,
        manifestEtag: json['manifestEtag'] as String?,
        installedVersion: json['installedVersion'] as String?,
        availableVersion: json['availableVersion'] as String?,
        availableBytes: (json['availableBytes'] as num?)?.toInt(),
        entryPath: json['entryPath'] as String?,
        titleId: json['titleId'] as String?,
        steamAppId: (json['steamAppId'] as num?)?.toInt(),
        steamInstallDir: json['steamInstallDir'] as String?,
        steamLibrary: json['steamLibrary'] as String?,
        lastSaveVersion: (json['lastSaveVersion'] as num?)?.toInt() ?? 0,
        lastSaveSha: json['lastSaveSha'] as String?,
        linuxInstalled: json['linuxInstalled'] == true,
        error: json['error'] as String?,
        queuedAt: DateTime.tryParse(json['queuedAt']?.toString() ?? ''),
        sessionStartedAt: DateTime.tryParse(json['sessionStartedAt']?.toString() ?? ''),
        sessionDetached: json['sessionDetached'] == true,
      );
}

/// The per-server JSON manifest of game installs, next to the game folders
/// (`<gamesRoot>/<server-slug>/installs.json`). Kept small and rewritten
/// atomically; the game files themselves are the truth for "is it there".
class GameInstallStore {
  GameInstallStore([Directory? root, this.inMemory = false]) : _rootOverride = root;

  final Directory? _rootOverride;

  /// Skip the disk entirely (widget tests: real file I/O never completes
  /// under the test binding's fake clock).
  final bool inMemory;
  final Map<String, Map<String, GameInstall>> _byServer = {};

  Future<Directory> root() async => _rootOverride ?? await GameSettings.gamesRoot();

  Future<Directory> serverDir(String serverName) async =>
      Directory('${(await root()).path}/${DownloadStore.slug(serverName)}');

  Future<File> _manifest(String serverName) async => File('${(await serverDir(serverName)).path}/installs.json');

  /// The servers whose installs are loaded (after [load]/[loadAll]).
  Iterable<String> get loadedServers => _byServer.keys;

  /// Forget everything read so far — after the games folder moved, the
  /// installs under the old folder are not the ones under the new one.
  void invalidate() => _byServer.clear();

  Future<Map<String, GameInstall>> load(String serverName) async {
    final cached = _byServer[serverName];
    if (cached != null) return cached;
    final map = <String, GameInstall>{};
    if (inMemory) return _byServer[serverName] = map;
    final file = await _manifest(serverName);
    if (await file.exists()) {
      try {
        final decoded = jsonDecode(await file.readAsString());
        if (decoded is Map && decoded['installs'] is List) {
          for (final item in decoded['installs'] as List) {
            final install = GameInstall.fromJson((item as Map).cast<String, dynamic>());
            map[install.gameId] = install;
          }
        }
      } catch (_) {
        // A damaged manifest: the installs are rediscovered on demand.
      }
    }
    return _byServer[serverName] = map;
  }

  Future<void> loadAll(Iterable<String> servers) async {
    for (final server in servers) {
      await load(server);
    }
  }

  /// Every loaded install, newest request first.
  List<(String server, GameInstall install)> all() => [
        for (final entry in _byServer.entries)
          for (final install in entry.value.values) (entry.key, install)
      ];

  Future<GameInstall?> get(String serverName, String gameId) async => (await load(serverName))[gameId];

  Future<void> put(String serverName, GameInstall install) async {
    (await load(serverName))[install.gameId] = install;
    await _save(serverName);
  }

  Future<void> remove(String serverName, String gameId) async {
    (await load(serverName)).remove(gameId);
    await _save(serverName);
  }

  /// Writes are chained per store: two installs persisting at once would
  /// otherwise race on the same `.part` file.
  Future<void> _writing = Future.value();

  Future<void> _save(String serverName) {
    if (inMemory) return Future.value();
    final next = _writing.then((_) => _write(serverName));
    _writing = next.catchError((_) {});
    return next;
  }

  Future<void> _write(String serverName) async {
    final file = await _manifest(serverName);
    await file.parent.create(recursive: true);
    final tmp = File('${file.path}.part');
    await tmp.writeAsString(
        jsonEncode({'installs': [for (final i in (_byServer[serverName] ?? {}).values) i.toJson()]}),
        flush: true);
    await tmp.rename(file.path);
  }

  Future<Directory> gameDir(String serverName, String gameId) async =>
      Directory('${(await serverDir(serverName)).path}/$gameId');

  // ---- the manifest the files were installed from --------------------------

  File manifestFile(GameInstall install) => File('${install.dir}/manifest.json');

  /// Keeps the server's manifest next to the files, so an update can be
  /// reduced to the files that changed since.
  Future<void> writeManifest(GameInstall install, GameManifest manifest) async {
    final file = manifestFile(install);
    await file.parent.create(recursive: true);
    final tmp = File('${file.path}.part');
    await tmp.writeAsString(jsonEncode(manifest.toJson()), flush: true);
    await tmp.rename(file.path);
  }

  Future<GameManifest?> readManifest(GameInstall install) async {
    final file = manifestFile(install);
    if (!await file.exists()) return null;
    try {
      return GameManifest.fromJson((jsonDecode(await file.readAsString()) as Map).cast<String, dynamic>());
    } catch (_) {
      return null;
    }
  }
}
