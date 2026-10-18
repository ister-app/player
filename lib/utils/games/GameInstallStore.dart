import 'dart:convert';
import 'dart:io';

import 'package:player/utils/download/DownloadStore.dart' show DownloadStore;

import 'GameSettings.dart';

enum GameInstallStatus { downloading, extracting, installed, failed }

/// What this device knows about one installed (or installing) game.
class GameInstall {
  GameInstall({
    required this.gameId,
    required this.form,
    required this.platform,
    required this.dir,
    required this.status,
    this.totalBytes = 0,
    this.doneBytes = 0,
    this.filesTotal = 0,
    this.filesDone = 0,
    this.manifestEtag,
    this.entryPath,
    this.titleId,
    this.steamAppId,
    this.steamInstallDir,
    this.steamLibrary,
    this.lastSaveVersion = 0,
    this.lastSaveSha,
    this.linuxInstalled = false,
    this.error,
  });

  final String gameId;
  final String form;
  final String platform;

  /// `<gamesRoot>/<server-slug>/<gameId>`; Steam games are restored into a
  /// Steam library instead and keep only their bookkeeping here.
  final String dir;
  GameInstallStatus status;
  int totalBytes;
  int doneBytes;
  int filesTotal;
  int filesDone;
  String? manifestEtag;
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

  Directory get filesDir => Directory('$dir/files');
  Directory get savesDir => Directory('$dir/saves');
  Directory get tmpDir => Directory('$dir/tmp');

  bool get isInstalled => status == GameInstallStatus.installed;

  Map<String, dynamic> toJson() => {
        'gameId': gameId,
        'form': form,
        'platform': platform,
        'dir': dir,
        'status': status.name,
        'totalBytes': totalBytes,
        'doneBytes': doneBytes,
        'filesTotal': filesTotal,
        'filesDone': filesDone,
        'manifestEtag': manifestEtag,
        'entryPath': entryPath,
        'titleId': titleId,
        'steamAppId': steamAppId,
        'steamInstallDir': steamInstallDir,
        'steamLibrary': steamLibrary,
        'lastSaveVersion': lastSaveVersion,
        'lastSaveSha': lastSaveSha,
        'linuxInstalled': linuxInstalled,
        'error': error,
      };

  factory GameInstall.fromJson(Map<String, dynamic> json) => GameInstall(
        gameId: json['gameId'] as String,
        form: json['form'] as String,
        platform: json['platform'] as String,
        dir: json['dir'] as String,
        status: GameInstallStatus.values.firstWhere((s) => s.name == json['status'],
            orElse: () => GameInstallStatus.failed),
        totalBytes: (json['totalBytes'] as num?)?.toInt() ?? 0,
        doneBytes: (json['doneBytes'] as num?)?.toInt() ?? 0,
        filesTotal: (json['filesTotal'] as num?)?.toInt() ?? 0,
        filesDone: (json['filesDone'] as num?)?.toInt() ?? 0,
        manifestEtag: json['manifestEtag'] as String?,
        entryPath: json['entryPath'] as String?,
        titleId: json['titleId'] as String?,
        steamAppId: (json['steamAppId'] as num?)?.toInt(),
        steamInstallDir: json['steamInstallDir'] as String?,
        steamLibrary: json['steamLibrary'] as String?,
        lastSaveVersion: (json['lastSaveVersion'] as num?)?.toInt() ?? 0,
        lastSaveSha: json['lastSaveSha'] as String?,
        linuxInstalled: json['linuxInstalled'] == true,
        error: json['error'] as String?,
      );
}

/// The per-server JSON manifest of game installs, next to the game folders
/// (`<gamesRoot>/<server-slug>/installs.json`). Kept small and rewritten
/// atomically; the game files themselves are the truth for "is it there".
class GameInstallStore {
  GameInstallStore([this._rootOverride]);

  final Directory? _rootOverride;
  final Map<String, Map<String, GameInstall>> _byServer = {};

  Future<Directory> root() async => _rootOverride ?? await GameSettings.gamesRoot();

  Future<Directory> serverDir(String serverName) async =>
      Directory('${(await root()).path}/${DownloadStore.slug(serverName)}');

  Future<File> _manifest(String serverName) async => File('${(await serverDir(serverName)).path}/installs.json');

  Future<Map<String, GameInstall>> load(String serverName) async {
    final cached = _byServer[serverName];
    if (cached != null) return cached;
    final map = <String, GameInstall>{};
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

  Future<GameInstall?> get(String serverName, String gameId) async => (await load(serverName))[gameId];

  Future<void> put(String serverName, GameInstall install) async {
    (await load(serverName))[install.gameId] = install;
    await _save(serverName);
  }

  Future<void> remove(String serverName, String gameId) async {
    (await load(serverName)).remove(gameId);
    await _save(serverName);
  }

  Future<void> _save(String serverName) async {
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
}
