import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/gameById.graphql.dart';
import 'package:player/graphql/recordGamePlayed.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/download/DownloadHttp.dart';

import 'GameApi.dart';
import 'GameInstallStore.dart';
import 'GameSettings.dart';
import 'achievements/AchievementReport.dart';
import 'achievements/AchievementSyncService.dart';
import 'achievements/Ps3TrophyReader.dart';
import 'achievements/SteamAchievementReader.dart';
import 'launch/EmulatorRegistry.dart';
import 'launch/GameLaunchers.dart';
import 'launch/GameProcessRunner.dart';
import 'saves/SavePathResolver.dart';
import 'saves/SaveSyncService.dart';
import 'steam/SteamLibraryLocator.dart';

/// Progress of one install, for the game page.
class GameInstallProgress {
  const GameInstallProgress({required this.status, required this.doneBytes, required this.totalBytes, required this.filesDone, required this.filesTotal, this.error});
  final GameInstallStatus status;
  final int doneBytes;
  final int totalBytes;
  final int filesDone;
  final int filesTotal;
  final String? error;
  double? get fraction => totalBytes <= 0 ? null : (doneBytes / totalBytes).clamp(0.0, 1.0);
}

/// A running (or detached) play session.
class GameSession {
  GameSession({required this.gameId, required this.startedAt, required this.plan, required this.install});
  final String gameId;
  final DateTime startedAt;
  final LaunchPlan plan;
  final GameInstall install;
}

/// A save conflict found before launch; the UI picks one of the resolutions.
class SaveConflict {
  const SaveConflict({required this.serverHead, required this.install, required this.slots});
  final GameSaveInfo serverHead;
  final GameInstall install;
  final List<SaveSlot> slots;
}

enum SaveConflictChoice { keepLocal, useServer, cancel }

/// The outcome of a finished session, for the panel's summary.
class GameSessionResult {
  const GameSessionResult({required this.duration, this.exitCode, this.uploadedSave, this.newAchievements = const [], this.error});
  final Duration duration;
  final int? exitCode;
  final GameSaveInfo? uploadedSave;
  final List<ReportedAchievement> newAchievements;
  final String? error;
}

/// The desktop game runtime: installs a game's files from the server, keeps
/// the local install bookkeeping, and runs the play loop — pull saves, launch,
/// push saves, report achievements, record the session on the server.
/// One instance per app (`GameLibraryService.instance`); the game page
/// listens to [progressOf] and [sessionOf].
class GameLibraryService {
  GameLibraryService._();

  static final GameLibraryService instance = GameLibraryService._();

  final GameInstallStore store = GameInstallStore();
  final EmulatorRegistry registry = EmulatorRegistry();
  final SteamLibraryLocator steam = SteamLibraryLocator();
  final DownloadHttp _http = DownloadHttp(maxAttempts: 6, bodyTimeout: const Duration(hours: 6));
  final GameProcessRunner _runner = GameProcessRunner();

  final Map<String, ValueNotifier<GameInstallProgress?>> _progress = {};
  final Map<String, ValueNotifier<GameSession?>> _sessions = {};
  final Map<String, DownloadCancelToken> _cancels = {};

  static const int _parallelFiles = 3;

  String get deviceName => Platform.localHostname;

  ValueNotifier<GameInstallProgress?> progressOf(String gameId) =>
      _progress.putIfAbsent(gameId, () => ValueNotifier(null));

  ValueNotifier<GameSession?> sessionOf(String gameId) => _sessions.putIfAbsent(gameId, () => ValueNotifier(null));

  Future<GameInstall?> installOf(String serverName, String gameId) => store.get(serverName, gameId);

  GameApi api(String serverName) => GameApi(serverName);

  // ---- install -----------------------------------------------------------

  /// Downloads every file of the game (resumable), then unpacks archives.
  /// Steam games land in [steamLibrary] (`steamapps/common/<installdir>`).
  Future<GameInstall> install(String serverName, Query$gameById$gameById game, {SteamLibrary? steamLibrary}) async {
    final api = this.api(serverName);
    final manifest = await api.manifest(game.id);
    final gameDir = await store.gameDir(serverName, game.id);
    final existing = await store.get(serverName, game.id);
    final install = existing ??
        GameInstall(gameId: game.id, form: game.form.name, platform: game.platform.name, dir: gameDir.path, status: GameInstallStatus.downloading);
    install
      ..status = GameInstallStatus.downloading
      ..totalBytes = manifest.totalBytes
      ..filesTotal = manifest.files.length
      ..manifestEtag = manifest.etag
      ..entryPath = manifest.entryPath ?? manifest.files.where((f) => f.entry).firstOrNull?.path
      ..titleId = manifest.titleId
      ..steamAppId = manifest.steamAppId
      ..steamInstallDir = manifest.steamInstallDir
      ..steamLibrary = steamLibrary?.path ?? install.steamLibrary
      ..error = null;
    await store.put(serverName, install);

    final cancel = DownloadCancelToken();
    _cancels[game.id] = cancel;
    final notifier = progressOf(game.id);
    void report() {
      notifier.value = GameInstallProgress(
          status: install.status, doneBytes: install.doneBytes, totalBytes: install.totalBytes, filesDone: install.filesDone, filesTotal: install.filesTotal, error: install.error);
    }

    final targetRoot = install.form == 'STEAM' && steamLibrary != null ? Directory(steamLibrary.steamApps) : install.filesDir;
    await targetRoot.create(recursive: true);
    await _ensureSpace(targetRoot, manifest.totalBytes - await _bytesPresent(targetRoot, manifest, install));
    try {
      install.doneBytes = 0;
      install.filesDone = 0;
      final queue = List<GameManifestFile>.from(manifest.files);
      Future<void> worker() async {
        while (queue.isNotEmpty) {
          DownloadHttp.checkCancel(cancel);
          final file = queue.removeAt(0);
          final target = _targetFor(targetRoot, install, file);
          if (await target.exists() && await target.length() == file.size) {
            install.doneBytes += file.size;
            install.filesDone++;
            report();
            continue;
          }
          await _http.getToFile(serverName, api.fileUrl(game.id, file.path), target, cancel,
              timeout: const Duration(minutes: 2), resume: true);
          install.doneBytes += file.size;
          install.filesDone++;
          if (install.filesDone % 25 == 0) await store.put(serverName, install);
          report();
        }
      }
      report();
      await Future.wait([for (var i = 0; i < _parallelFiles; i++) worker()]);

      install.status = GameInstallStatus.extracting;
      report();
      await _postProcess(install, manifest, steamLibrary);

      install.status = GameInstallStatus.installed;
      install.error = null;
      await store.put(serverName, install);
      report();
      return install;
    } on DownloadCancelled {
      install.status = GameInstallStatus.failed;
      install.error = 'cancelled';
      await store.put(serverName, install);
      report();
      rethrow;
    } catch (e) {
      install.status = GameInstallStatus.failed;
      install.error = e.toString();
      await store.put(serverName, install);
      report();
      rethrow;
    } finally {
      _cancels.remove(game.id);
    }
  }

  void cancelInstall(String gameId) => _cancels[gameId]?.cancel();

  /// Removes the local files and bookkeeping; a Steam game is left to Steam's
  /// own uninstall (we only forget it).
  Future<void> uninstall(String serverName, String gameId) async {
    final install = await store.get(serverName, gameId);
    if (install == null) return;
    cancelInstall(gameId);
    if (install.form != 'STEAM') {
      final dir = Directory(install.dir);
      if (await dir.exists()) await dir.delete(recursive: true);
    }
    await store.remove(serverName, gameId);
    progressOf(gameId).value = null;
  }

  File _targetFor(Directory root, GameInstall install, GameManifestFile file) {
    final relative = file.path.replaceAll('/', Platform.pathSeparator);
    if (install.form == 'STEAM' && install.steamLibrary != null) {
      // appmanifest_<id>.acf lands in steamapps/, the tree in steamapps/common/<installdir>/.
      if (!file.path.contains('/')) return File('${root.path}${Platform.pathSeparator}$relative');
      return File('${root.path}${Platform.pathSeparator}common${Platform.pathSeparator}$relative');
    }
    return File('${root.path}${Platform.pathSeparator}$relative');
  }

  Future<int> _bytesPresent(Directory root, GameManifest manifest, GameInstall install) async {
    var present = 0;
    for (final file in manifest.files) {
      final target = _targetFor(root, install, file);
      if (await target.exists()) present += await target.length();
    }
    return present;
  }

  Future<void> _ensureSpace(Directory dir, int needed) async {
    if (needed <= 0) return;
    // Dart has no portable free-space API; `df`/`fsutil` would do but are
    // fragile. The write fails with ENOSPC when it must, and DownloadHttp
    // reports noSpace.
  }

  /// Archives are unpacked next to themselves; ROMs and PS3 trees stay as
  /// they are; a Steam tree gets its manifest written into the library.
  Future<void> _postProcess(GameInstall install, GameManifest manifest, SteamLibrary? steamLibrary) async {
    switch (install.form) {
      case 'PC_PORTABLE_ZIP':
      case 'PC_LINUX_PORTABLE':
        for (final file in manifest.files.where((f) => f.entry)) {
          final archive = File('${install.filesDir.path}${Platform.pathSeparator}${file.path}');
          if (!await archive.exists()) continue;
          final out = install.filesDir.path;
          await Isolate.run(() => extractFileToDisk(archive.path, out));
          // Keep the archive: it is what a re-download compares sizes against.
        }
        if (!Platform.isWindows) await _markExecutables(install.filesDir);
      case 'STEAM':
        if (steamLibrary != null) {
          final acf = manifest.files.where((f) => f.path.toLowerCase().endsWith('.acf')).firstOrNull;
          await GameLaunchers.writeSteamManifest(steamLibrary, install,
              acfSource: acf == null ? null : File('${steamLibrary.steamApps}${Platform.pathSeparator}${acf.path}'));
        }
      default:
        break;
    }
  }

  Future<void> _markExecutables(Directory dir) async {
    if (!await dir.exists()) return;
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        final name = entity.uri.pathSegments.last.toLowerCase();
        if (name.endsWith('.sh') || name.endsWith('.x86_64') || name.endsWith('.x86') || !name.contains('.')) {
          await Process.run('chmod', ['+x', entity.path]);
        }
      }
    }
  }

  // ---- play --------------------------------------------------------------

  /// Prepares the launch and syncs saves down. Returns a [SaveConflict] when
  /// the user has to choose, else null (the caller then calls [launch]).
  Future<({LaunchPlan plan, SaveConflict? conflict})> prepare(String serverName, Query$gameById$gameById game) async {
    final install = await store.get(serverName, game.id);
    if (install == null || !install.isInstalled) throw LaunchException(LaunchProblem.entryMissing, 'not installed');
    final launchers = GameLaunchers(registry: registry, steam: steam);
    final plan = await launchers.plan(install,
        retroArchCore: game.launcher.retroArchCore,
        savePathTemplates: [for (final p in game.savePaths) (path: p.path, os: p.os)]);
    final sync = _sync(serverName);
    await sync.replayOutbox(install);
    if (!await GameSettings.saveSyncEnabled()) return (plan: plan, conflict: null);
    final pull = await sync.pull(install, plan.saveSlots);
    if (pull.outcome == SavePullOutcome.conflict) {
      return (plan: plan, conflict: SaveConflict(serverHead: pull.serverHead!, install: install, slots: plan.saveSlots));
    }
    return (plan: plan, conflict: null);
  }

  Future<void> resolveConflict(String serverName, SaveConflict conflict, SaveConflictChoice choice) async {
    final sync = _sync(serverName);
    switch (choice) {
      case SaveConflictChoice.useServer:
        await sync.applyServerHead(conflict.install, conflict.slots, conflict.serverHead);
      case SaveConflictChoice.keepLocal:
        // The local saves become the new head; the server's stays in history.
        await sync.push(conflict.install, conflict.slots, force: true, note: 'kept local over v${conflict.serverHead.version}');
      case SaveConflictChoice.cancel:
        break;
    }
  }

  /// Starts the game. Awaits the process for emulators and native games;
  /// Steam launches are detached and finished with [finishDetached].
  Future<GameSessionResult?> launch(String serverName, Query$gameById$gameById game, LaunchPlan plan) async {
    final install = (await store.get(serverName, game.id))!;
    final session = GameSession(gameId: game.id, startedAt: DateTime.now(), plan: plan, install: install);
    sessionOf(game.id).value = session;
    if (plan.detached) {
      await _runner.detach(plan.command, plan.arguments);
      return null;
    }
    try {
      final result = await _runner.run(plan.command, plan.arguments,
          workingDirectory: plan.workingDirectory, environment: plan.environment);
      if (install.form == 'PC_LINUX_INSTALLER' && !install.linuxInstalled) {
        // The first run was the installer; the next launch starts the game.
        install.linuxInstalled = result.exitCode == 0;
        await store.put(serverName, install);
      }
      return await _afterSession(serverName, game, session, exitCode: result.exitCode, duration: result.duration,
          error: result.exitCode != 0 && result.stderrTail.isNotEmpty ? result.stderrTail : null);
    } catch (e) {
      sessionOf(game.id).value = null;
      return GameSessionResult(duration: DateTime.now().difference(session.startedAt), error: e.toString());
    }
  }

  /// "I stopped playing": for detached (Steam) sessions, and when the app
  /// restarts with a session still open.
  Future<GameSessionResult> finishDetached(String serverName, Query$gameById$gameById game) async {
    final session = sessionOf(game.id).value;
    if (session == null) return const GameSessionResult(duration: Duration.zero);
    return _afterSession(serverName, game, session, duration: DateTime.now().difference(session.startedAt));
  }

  Future<GameSessionResult> _afterSession(String serverName, Query$gameById$gameById game, GameSession session,
      {int? exitCode, required Duration duration, String? error}) async {
    sessionOf(game.id).value = null;
    GameSaveInfo? uploaded;
    final errors = <String>[?error];
    if (await GameSettings.saveSyncEnabled()) {
      try {
        uploaded = await _sync(serverName).push(session.install, session.plan.saveSlots);
      } on GameSaveConflict catch (c) {
        // Someone played elsewhere while this session ran: keep ours as the
        // head (history keeps theirs) rather than lose a just-finished session.
        try {
          uploaded = await _sync(serverName).push(session.install, session.plan.saveSlots, force: true, note: 'after conflict with v${c.latestVersion}');
        } catch (e) {
          errors.add('save upload: $e');
        }
      } catch (e) {
        errors.add('save upload: $e');
      }
    }
    var newAchievements = const <ReportedAchievement>[];
    if (await GameSettings.achievementSyncEnabled()) {
      try {
        newAchievements = await _syncAchievements(serverName, session.install);
      } catch (e) {
        LoggerService().logger.w('Achievement sync failed: $e');
      }
    }
    try {
      await _recordPlayed(serverName, game.id, duration);
    } catch (e) {
      errors.add('record play: $e');
    }
    return GameSessionResult(
      duration: duration,
      exitCode: exitCode,
      uploadedSave: uploaded,
      newAchievements: newAchievements,
      error: errors.isEmpty ? null : errors.join('\n'),
    );
  }

  Future<List<ReportedAchievement>> _syncAchievements(String serverName, GameInstall install) async {
    AchievementReport? report;
    if (install.form == 'PS3_FOLDER') {
      final rpcs3 = await registry.find(EmulatorKind.rpcs3);
      final config = rpcs3?.configDir;
      if (config != null) {
        final reader = Ps3TrophyReader(rpcs3Config: Directory(config));
        for (final folder in await reader.foldersFor(install.titleId)) {
          report = await reader.read(folder);
          if (report != null) break;
        }
      }
    } else if (install.form == 'STEAM' && install.steamAppId != null) {
      final root = await steam.root();
      if (root != null) {
        report = await SteamAchievementReader(steamRoot: root).read(install.steamAppId!, await steam.mostRecentAccountId());
      }
    }
    if (report == null) return const [];
    return AchievementSyncService(api: api(serverName), deviceName: deviceName).sync(install, report);
  }

  Future<void> _recordPlayed(String serverName, String gameId, Duration duration) async {
    final client = ClientManager.getClientForUrl(serverName).value;
    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationrecordGamePlayed,
      variables: Variables$Mutation$recordGamePlayed(gameId: gameId, durationMs: duration.inMilliseconds).toJson(),
    ));
    if (result.hasException) throw result.exception!;
  }

  SaveSyncService _sync(String serverName) =>
      SaveSyncService(api: api(serverName), store: store, serverName: serverName, deviceName: deviceName);
}
