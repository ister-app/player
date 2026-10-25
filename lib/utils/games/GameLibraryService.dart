import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/gameById.graphql.dart';
import 'package:player/graphql/recordGamePlayed.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/ScreenWakelock.dart';
import 'package:player/utils/ServerStore.dart';
import 'package:player/utils/activity/ActivityPresenceService.dart';
import 'package:player/utils/download/DownloadHttp.dart';

import 'GameApi.dart';
import 'GameInstallProgress.dart';
import 'GameInstallState.dart';
import 'GameInstallStore.dart';
import 'GameSettings.dart';
import 'LocalGameCopy.dart';
import 'ManifestDiff.dart';
import 'achievements/AchievementReport.dart';
import 'achievements/AchievementSyncService.dart';
import 'achievements/Ps3TrophyReader.dart';
import 'achievements/SteamAchievementReader.dart';
import 'launch/EmulatorRegistry.dart';
import 'launch/GameLaunchers.dart';
import 'launch/GameProcessRunner.dart';
import 'saves/SavePathResolver.dart';
import 'saves/SaveSnapshot.dart';
import 'saves/SaveSyncService.dart';
import 'steam/SteamLibraryLocator.dart';

export 'GameInstallProgress.dart' show GameInstallProgress;

/// Where the play loop is, for the game page's step indicator.
enum GamePlayPhase { idle, preparingSaves, launching, running, uploadingSaves, readingAchievements, recording }

/// A running (or detached) play session.
class GameSession {
  GameSession({required this.gameId, required this.startedAt, required this.plan, required this.install, this.restored = false});
  final String gameId;
  final DateTime startedAt;
  final LaunchPlan plan;
  final GameInstall install;

  /// Rebuilt after an app restart: no process is attached, the page offers
  /// to wrap the session up or discard it.
  final bool restored;
  bool get detached => plan.detached;
}

/// A save conflict found before launch; the UI picks one of the resolutions.
class SaveConflict {
  const SaveConflict({required this.serverHead, required this.install, required this.slots, this.localModified});
  final GameSaveInfo serverHead;
  final GameInstall install;
  final List<SaveSlot> slots;

  /// When the local saves last changed, for the dialog's "this computer" side.
  final DateTime? localModified;
}

enum SaveConflictChoice { keepLocal, useServer, cancel }

/// The outcome of a finished session, for the panel's summary.
class GameSessionResult {
  const GameSessionResult({
    required this.duration,
    this.exitCode,
    this.uploadedSave,
    this.saveUnchanged = false,
    this.noSaveFound = false,
    this.newAchievements = const [],
    this.errors = const [],
  });
  final Duration duration;
  final int? exitCode;
  final GameSaveInfo? uploadedSave;

  /// Save sync ran and found nothing to upload.
  final bool saveUnchanged;

  /// Save sync ran but the game's save locations hold no files at all: the
  /// game saved somewhere this app does not look (or never saved).
  final bool noSaveFound;
  final List<ReportedAchievement> newAchievements;
  final List<String> errors;
  String? get error => errors.isEmpty ? null : errors.join('\n');
  bool get hasErrors => errors.isNotEmpty;
}

/// The desktop game runtime: installs a game's files from the server, keeps
/// the local install bookkeeping, and runs the play loop — pull saves, launch,
/// push saves, report achievements, record the session on the server.
///
/// Installs form a queue (one game at a time, three files in parallel) that
/// continues after an app restart; the game page listens to [progressOf],
/// [sessionOf], [phaseOf] and [lastResultOf], the downloads page to
/// [revision]. One instance per app (`GameLibraryService.instance`).
class GameLibraryService {
  GameLibraryService._() : this.forTest();

  @visibleForTesting
  GameLibraryService.forTest({
    GameInstallStore? store,
    DownloadHttp? http,
    GameApi Function(String serverName)? apiFactory,
    GameProcessRunner? runner,
    EmulatorRegistry? registry,
    SteamLibraryLocator? steam,
    LocalGameCopyFinder? localCopies,
    DateTime Function()? clock,
    Future<List<String>> Function()? servers,
    Future<void> Function(String serverName, String gameId, Duration duration)? recordPlayed,
    ActivityPresenceService? presence,
    this.deviceName = '',
  })  : store = store ?? GameInstallStore(),
        _presence = presence ?? ActivityPresenceService.instance,
        _http = http ?? DownloadHttp(maxAttempts: 6, bodyTimeout: const Duration(hours: 6)),
        _apiFactory = apiFactory ?? GameApi.new,
        _runner = runner ?? GameProcessRunner(),
        registry = registry ?? EmulatorRegistry(),
        steam = steam ?? SteamLibraryLocator(),
        localCopies = localCopies ?? LocalGameCopyFinder(steam: steam),
        _clock = clock ?? DateTime.now,
        _servers = servers ?? ServerStore.list,
        _recordPlayedOverride = recordPlayed;

  static final GameLibraryService instance = GameLibraryService._();

  final GameInstallStore store;
  final EmulatorRegistry registry;
  final SteamLibraryLocator steam;

  /// Finds a game Steam or RPCS3 already has on this computer.
  final LocalGameCopyFinder localCopies;
  final DownloadHttp _http;
  final GameApi Function(String serverName) _apiFactory;
  final GameProcessRunner _runner;
  final DateTime Function() _clock;
  final Future<List<String>> Function() _servers;
  final Future<void> Function(String serverName, String gameId, Duration duration)? _recordPlayedOverride;
  final String deviceName;

  /// Now-playing presence: a running game shows up next to the playback
  /// sessions on every device that may see this user's activity.
  final ActivityPresenceService _presence;
  final Map<String, ActivityHandle> _presenceHandles = {};

  /// Bumped on every persisted change to any install: lists rebuild on it.
  final ValueNotifier<int> revision = ValueNotifier(0);

  /// Installs being downloaded or unpacked right now.
  final ValueNotifier<int> runningCount = ValueNotifier(0);

  final Map<String, ValueNotifier<GameInstallProgress?>> _progress = {};
  final Map<String, ValueNotifier<GameSession?>> _sessions = {};
  final Map<String, ValueNotifier<GamePlayPhase>> _phases = {};
  final Map<String, ValueNotifier<GameSessionResult?>> _results = {};
  final Map<String, DownloadCancelToken> _cancels = {};
  final Map<String, InstallProgressTracker> _trackers = {};

  /// `server\u0000gameId` of installs waiting for a slot, in request order.
  final List<_QueueKey> _queue = [];
  final Set<_QueueKey> _running = {};
  Timer? _ticker;
  ScreenWakelockToken? _wakelock;
  Future<void>? _starting;

  static const int _parallelFiles = 3;
  static const int _maxConcurrentInstalls = 1;

  String get _deviceName => deviceName.isEmpty ? Platform.localHostname : deviceName;

  ValueNotifier<GameInstallProgress?> progressOf(String gameId) =>
      _progress.putIfAbsent(gameId, () => ValueNotifier(null));

  ValueNotifier<GameSession?> sessionOf(String gameId) => _sessions.putIfAbsent(gameId, () => ValueNotifier(null));

  ValueNotifier<GamePlayPhase> phaseOf(String gameId) =>
      _phases.putIfAbsent(gameId, () => ValueNotifier(GamePlayPhase.idle));

  /// The summary of the last finished session, until the user dismisses it.
  ValueNotifier<GameSessionResult?> lastResultOf(String gameId) =>
      _results.putIfAbsent(gameId, () => ValueNotifier(null));

  void dismissResult(String gameId) => lastResultOf(gameId).value = null;

  Future<GameInstall?> installOf(String serverName, String gameId) => store.get(serverName, gameId);

  /// A copy of [game] Steam or RPCS3 already has on this computer, when
  /// Ister has no install of it yet.
  Future<LocalGameCopy?> findLocalCopy(String serverName, Query$gameById$gameById game) async {
    if (await store.get(serverName, game.id) != null) return null;
    try {
      return await localCopies.find(game);
    } catch (e) {
      LoggerService().logger.w('Local copy look-up for ${game.id} failed: $e');
      return null;
    }
  }

  /// Registers [copy] as the install of [game]: installed at once, nothing
  /// downloaded. Ister's own folder for the game is created for the save
  /// tmp/outbox files; the copy's files stay where they are and stay the
  /// emulator's (or Steam's). The server's current version is the baseline,
  /// so an update is only offered once the server has a newer one — and
  /// that update turns the record into an ordinary install.
  Future<GameInstall> adopt(String serverName, Query$gameById$gameById game, LocalGameCopy copy) async {
    final existing = await store.get(serverName, game.id);
    if (existing != null) return existing;
    final dir = await store.gameDir(serverName, game.id);
    final install = GameInstall(
      gameId: game.id,
      form: game.form.name,
      platform: game.platform.name,
      dir: dir.path,
      status: GameInstallStatus.installed,
      title: game.title,
      totalBytes: game.sizeBytes.toInt(),
      filesTotal: game.fileCount,
      filesDone: game.fileCount,
      installedVersion: game.version,
      entryPath: copy.entryPath,
      titleId: game.titleId,
      steamAppId: int.tryParse(game.steamAppId ?? ''),
      steamInstallDir: copy.steamInstallDir ?? game.steamInstallDir,
      steamLibrary: copy.steamLibrary,
      adoptedFrom: copy.path,
    );
    // Ister's own folder for the save zips and outbox (never under a widget
    // test's in-memory store: real file I/O does not complete there).
    if (!store.inMemory) await install.tmpDir.create(recursive: true);
    await _transitioned(serverName, install);
    return install;
  }

  GameApi api(String serverName) => _apiFactory(serverName);

  // ---- startup -------------------------------------------------------------

  /// Loads every server's installs and continues the ones an earlier run
  /// left queued, downloading or unpacking. Paused, failed and cancelled
  /// installs wait for the user.
  Future<void> ensureStarted() => _starting ??= _start();

  Future<void> _start() async {
    try {
      await store.loadAll(await _servers());
    } catch (e) {
      LoggerService().logger.w('Game installs could not be loaded: $e');
      return;
    }
    for (final (server, install) in store.all()) {
      final next = GameInstallStateMachine.next(install.status, GameInstallEvent.restart);
      if (next != null) {
        install.status = next;
        await store.put(server, install);
        _enqueue(server, install);
      }
      _publish(server, install);
    }
    revision.value++;
    _pump();
  }

  // ---- install queue -------------------------------------------------------

  /// Puts the game in the install queue (resuming a paused, failed or
  /// cancelled install where it got to). Returns once the request is
  /// persisted; the work runs in the background. Steam games land in
  /// [steamLibrary] (`steamapps/common/<installdir>`).
  Future<GameInstall> install(String serverName, Query$gameById$gameById game, {SteamLibrary? steamLibrary}) async {
    final existing = await store.get(serverName, game.id);
    final install = existing ??
        GameInstall(
          gameId: game.id,
          form: game.form.name,
          platform: game.platform.name,
          dir: (await store.gameDir(serverName, game.id)).path,
          status: GameInstallStatus.cancelled,
        );
    final next = GameInstallStateMachine.next(existing?.status, GameInstallEvent.install);
    if (next == null) return install;
    install
      ..status = next
      ..title = game.title
      ..steamLibrary = steamLibrary?.path ?? install.steamLibrary
      ..error = null
      ..queuedAt = _clock();
    if (install.totalBytes == 0) install.totalBytes = game.sizeBytes.toInt();
    await _transitioned(serverName, install, enqueue: true);
    _pump();
    return install;
  }

  /// Queues the install and waits for it to finish — for tests and the
  /// places that need the result.
  Future<GameInstall> installAndWait(String serverName, Query$gameById$gameById game,
      {SteamLibrary? steamLibrary}) async {
    await install(serverName, game, steamLibrary: steamLibrary);
    return await _settled(serverName, game.id);
  }

  Future<void> pause(String serverName, String gameId) => _userEvent(serverName, gameId, GameInstallEvent.pause);

  Future<void> resume(String serverName, String gameId) => _userEvent(serverName, gameId, GameInstallEvent.resume);

  Future<void> retry(String serverName, String gameId) => _userEvent(serverName, gameId, GameInstallEvent.retry);

  Future<void> cancel(String serverName, String gameId) => _userEvent(serverName, gameId, GameInstallEvent.cancel);

  /// Fetches the newer version the server reported ([checkForUpdate]).
  Future<void> update(String serverName, String gameId) => _userEvent(serverName, gameId, GameInstallEvent.update);

  /// Kept for the game page's old call site; same as [cancel].
  void cancelInstall(String gameId) {
    for (final (server, install) in store.all()) {
      if (install.gameId == gameId) unawaited(cancel(server, gameId));
    }
  }

  Future<void> _userEvent(String serverName, String gameId, GameInstallEvent event) async {
    final install = await store.get(serverName, gameId);
    if (install == null) return;
    final next = GameInstallStateMachine.next(install.status, event);
    if (next == null) return;
    final key = _QueueKey(serverName, gameId);
    if (next == GameInstallStatus.queued) {
      install
        ..error = null
        ..queuedAt = _clock();
      // A fresh request (retry/resume) must not keep a stale cancel token.
      _cancels.remove(gameId);
    } else {
      // Leaving the queue or stopping the running download: the worker sees
      // the token and ends with the status set here, not `cancelled`.
      _queue.remove(key);
      _cancels[gameId]?.cancel();
      _trackers[gameId]?.pause(_clock());
    }
    install.status = next;
    await _transitioned(serverName, install, enqueue: next == GameInstallStatus.queued);
    _pump();
  }

  void _enqueue(String serverName, GameInstall install) {
    final key = _QueueKey(serverName, install.gameId);
    if (_queue.contains(key) || _running.contains(key)) return;
    _queue.add(key);
    _queue.sort((a, b) => _queuedAt(a).compareTo(_queuedAt(b)));
  }

  DateTime _queuedAt(_QueueKey key) =>
      store.all().where((e) => e.$1 == key.server && e.$2.gameId == key.gameId).firstOrNull?.$2.queuedAt ??
      DateTime.fromMillisecondsSinceEpoch(0);

  void _pump() {
    while (_running.length < _maxConcurrentInstalls && _queue.isNotEmpty) {
      final key = _queue.removeAt(0);
      _running.add(key);
      unawaited(_runInstall(key).whenComplete(() {
        _running.remove(key);
        _updateActivity();
        // Queue positions moved up.
        for (final (server, install) in store.all()) {
          if (install.status == GameInstallStatus.queued) _publish(server, install);
        }
        _pump();
      }));
    }
    _updateActivity();
  }

  void _updateActivity() {
    runningCount.value = _running.length;
    if (_running.isNotEmpty) {
      _wakelock ??= ScreenWakelock.acquire();
      _ticker ??= Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    } else {
      _wakelock?.release();
      _wakelock = null;
      _ticker?.cancel();
      _ticker = null;
    }
  }

  /// Drops the ticker and the wakelock without waiting for the running
  /// installs — for tests that leave an install stalled on purpose.
  @visibleForTesting
  void stopActivity() {
    _running.clear();
    _updateActivity();
  }

  void _tick() {
    final now = _clock();
    for (final key in _running) {
      final tracker = _trackers[key.gameId];
      if (tracker == null) continue;
      tracker.tick(now);
      final install = store.all().where((e) => e.$1 == key.server && e.$2.gameId == key.gameId).firstOrNull?.$2;
      if (install != null && install.status == GameInstallStatus.downloading) _publish(key.server, install);
    }
  }

  /// Persists [install] after a status change and tells every listener;
  /// with [enqueue] it takes its place in the queue first, so the published
  /// progress carries the queue position.
  Future<void> _transitioned(String serverName, GameInstall install, {bool enqueue = false}) async {
    await store.put(serverName, install);
    if (enqueue) _enqueue(serverName, install);
    _publish(serverName, install);
    revision.value++;
  }

  void _publish(String serverName, GameInstall install) {
    final tracker = _trackers[install.gameId];
    final position = install.status == GameInstallStatus.queued
        ? _queue.indexOf(_QueueKey(serverName, install.gameId)) + 1
        : null;
    progressOf(install.gameId).value = tracker != null && install.isActive
        ? tracker.snapshot(install.status, error: install.error, queuePosition: position)
        : GameInstallProgress(
            status: install.status,
            doneBytes: install.doneBytes,
            totalBytes: install.totalBytes,
            filesDone: install.filesDone,
            filesTotal: install.filesTotal,
            queuePosition: position,
            error: install.error,
          );
  }

  Future<GameInstall> _settled(String serverName, String gameId) async {
    final notifier = progressOf(gameId);
    while (notifier.value?.isActive ?? true) {
      final completer = Completer<void>();
      void listener() => completer.complete();
      notifier.addListener(listener);
      await completer.future;
      notifier.removeListener(listener);
    }
    return (await store.get(serverName, gameId))!;
  }

  /// Downloads every file of the game (resumable), then unpacks archives.
  Future<void> _runInstall(_QueueKey key) async {
    final serverName = key.server;
    final install = await store.get(serverName, key.gameId);
    if (install == null || install.status != GameInstallStatus.queued) return;
    final cancel = DownloadCancelToken();
    _cancels[install.gameId] = cancel;
    try {
      final api = this.api(serverName);
      final manifest = await api.manifest(install.gameId);
      final steamLibrary = install.form == 'STEAM' && install.steamLibrary != null
          ? SteamLibrary(path: install.steamLibrary!, label: install.steamLibrary!)
          : null;
      final updating = install.installedVersion != null && install.installedVersion != manifest.version;
      final previous = updating ? await store.readManifest(install) : null;
      final diff = updating ? ManifestDiff.between(previous, manifest) : null;

      // The user may have paused or cancelled while the manifest was fetched.
      DownloadHttp.checkCancel(cancel);
      final started = GameInstallStateMachine.next(install.status, GameInstallEvent.start);
      if (started == null) return;
      install
        ..status = started
        ..totalBytes = manifest.totalBytes
        ..filesTotal = manifest.files.length
        ..manifestEtag = manifest.etag
        ..entryPath = manifest.entryPath ?? manifest.files.where((f) => f.entry).firstOrNull?.path
        ..titleId = manifest.titleId
        ..steamAppId = manifest.steamAppId
        ..steamInstallDir = manifest.steamInstallDir
        // From here on the files are Ister's: an adopted copy updated from the server becomes a plain install.
        ..adoptedFrom = null
        ..error = null;
      await _transitioned(serverName, install);

      final targetRoot = steamLibrary != null ? Directory(steamLibrary.steamApps) : install.filesDir;
      await targetRoot.create(recursive: true);
      if (diff != null) await _applyRemovals(targetRoot, install, diff);

      final tracker = _trackers[install.gameId] =
          InstallProgressTracker(totalBytes: manifest.totalBytes, filesTotal: manifest.files.length);
      void report() {
        install
          ..doneBytes = tracker.doneBytes
          ..filesDone = tracker.filesDone;
        _publish(serverName, install);
      }

      final forced = {for (final f in diff?.fetch ?? const <GameManifestFile>[]) f.path};
      final queue = List<GameManifestFile>.from(manifest.files);
      var persistedAt = 0;
      Future<void> worker() async {
        while (queue.isNotEmpty) {
          DownloadHttp.checkCancel(cancel);
          final file = queue.removeAt(0);
          final target = _targetFor(targetRoot, install, file);
          if (forced.contains(file.path)) {
            await DownloadHttp.tryDelete(target);
            await DownloadHttp.tryDelete(File('${target.path}.part'));
          } else if (await target.exists() && await target.length() == file.size) {
            tracker.fileDone(file.path, file.size);
            report();
            continue;
          }
          await _http.getToFile(serverName, api.fileUrl(install.gameId, file.path), target, cancel,
              timeout: const Duration(minutes: 2), resume: true, onProgress: (bytes) {
            tracker.fileProgress(file.path, bytes);
            tracker.tick(_clock());
            report();
          });
          tracker.fileDone(file.path, file.size);
          report();
          if (tracker.filesDone - persistedAt >= 25) {
            persistedAt = tracker.filesDone;
            await store.put(serverName, install);
          }
        }
      }

      tracker.tick(_clock());
      report();
      await Future.wait([for (var i = 0; i < _parallelFiles; i++) worker()]);
      DownloadHttp.checkCancel(cancel);

      install.status = GameInstallStateMachine.next(install.status, GameInstallEvent.downloaded)!;
      await _transitioned(serverName, install);
      await _postProcess(install, manifest, steamLibrary, refresh: diff?.entryChanged ?? false);

      await store.writeManifest(install, manifest);
      install
        ..status = GameInstallStateMachine.next(install.status, GameInstallEvent.completed)!
        ..installedVersion = manifest.version
        ..availableVersion = null
        ..availableBytes = null
        ..error = null;
      await _transitioned(serverName, install);
    } on DownloadCancelled {
      // pause()/cancel() already persisted the status the user chose; a
      // token cancelled for a reason we did not record counts as cancelled.
      final current = await store.get(serverName, install.gameId);
      if (current != null && current.isActive) {
        current.status = GameInstallStatus.cancelled;
        await _transitioned(serverName, current);
      } else if (current != null) {
        _publish(serverName, current);
      }
    } catch (e, stack) {
      LoggerService().logger.w('Game install failed for ${install.gameId}: $e', stackTrace: stack);
      final current = await store.get(serverName, install.gameId);
      if (current != null) {
        final next = GameInstallStateMachine.next(current.status, GameInstallEvent.fail);
        if (next != null) {
          current
            ..status = next
            ..error = _describe(e);
          await _transitioned(serverName, current);
        }
      }
    } finally {
      _cancels.remove(install.gameId);
      _trackers.remove(install.gameId);
    }
  }

  /// A short, stable error key the UI can translate (see
  /// `GameLabels.installError`); anything else is the raw message.
  static String _describe(Object e) {
    if (e is DownloadFailure) {
      if (e.noSpace) return 'no-space';
      if (e.transient) return 'unreachable';
      return e.message;
    }
    if (e is GameApiException) {
      if (e.statusCode == 404) return 'gone';
      if (e.isTransient) return 'unreachable';
      return e.toString();
    }
    if (e is SocketException || e is TimeoutException) return 'unreachable';
    return e.toString();
  }

  Future<void> _applyRemovals(Directory root, GameInstall install, ManifestDiff diff) async {
    for (final file in diff.delete) {
      await DownloadHttp.tryDelete(_targetFor(root, install, file));
    }
  }

  /// Checks a server-reported version against what is installed and marks
  /// the install when they differ. A server without versions reports null
  /// and nothing happens.
  Future<void> checkForUpdate(String serverName, String gameId, {required String? version, int? sizeBytes}) async {
    if (version == null) return;
    final install = await store.get(serverName, gameId);
    if (install == null || !install.isInstalled) return;
    if (install.installedVersion == null) {
      // Installed before the server reported versions: take this one as the
      // baseline, there is nothing to compare it with.
      install.installedVersion = version;
      await store.put(serverName, install);
      return;
    }
    if (install.status == GameInstallStatus.updateAvailable && install.availableVersion == version) return;
    if (install.installedVersion == version) {
      if (install.status == GameInstallStatus.updateAvailable) {
        // The server went back to what we have (or we just updated).
        install
          ..status = GameInstallStatus.installed
          ..availableVersion = null
          ..availableBytes = null;
        await _transitioned(serverName, install);
      }
      return;
    }
    final next = GameInstallStateMachine.next(install.status, GameInstallEvent.newerVersion);
    if (next == null) return;
    install
      ..status = next
      ..availableVersion = version
      ..availableBytes = sizeBytes;
    await _transitioned(serverName, install);
  }

  /// Removes the local files and bookkeeping, in any state; a Steam game is
  /// left to Steam's own uninstall (we only forget it). Refused while a
  /// session of the game is open.
  Future<void> uninstall(String serverName, String gameId) async {
    final install = await store.get(serverName, gameId);
    if (install == null) return;
    if (sessionOf(gameId).value != null) throw StateError('session open');
    _queue.remove(_QueueKey(serverName, gameId));
    _cancels[gameId]?.cancel();
    if (install.form != 'STEAM') {
      final dir = Directory(install.dir);
      if (await dir.exists()) await dir.delete(recursive: true);
    }
    await store.remove(serverName, gameId);
    progressOf(gameId).value = null;
    revision.value++;
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

  /// Archives are unpacked next to themselves; ROMs and PS3 trees stay as
  /// they are; a Steam tree gets its manifest written into the library.
  /// With [refresh] the unpacked tree of a changed archive is rebuilt.
  Future<void> _postProcess(GameInstall install, GameManifest manifest, SteamLibrary? steamLibrary,
      {bool refresh = false}) async {
    switch (install.form) {
      case 'PC_PORTABLE_ZIP':
      case 'PC_LINUX_PORTABLE':
        for (final file in manifest.files.where((f) => f.entry)) {
          final archive = File('${install.filesDir.path}${Platform.pathSeparator}${file.path}');
          if (!await archive.exists()) continue;
          final out = install.filesDir.path;
          if (refresh) await _deleteUnpacked(install, manifest);
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

  /// Everything in `files/` that is not one of the manifest's own files is
  /// what an archive unpacked; drop it before unpacking the new archive.
  Future<void> _deleteUnpacked(GameInstall install, GameManifest manifest) async {
    final keep = {for (final f in manifest.files) _targetFor(install.filesDir, install, f).path};
    if (!await install.filesDir.exists()) return;
    await for (final entity in install.filesDir.list(followLinks: false)) {
      if (keep.contains(entity.path)) continue;
      try {
        await entity.delete(recursive: true);
      } catch (_) {}
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
    phaseOf(game.id).value = GamePlayPhase.preparingSaves;
    try {
      var plan = await _plan(install, game);
      final sync = _sync(serverName);
      await sync.replayOutbox(install);
      if (!await GameSettings.saveSyncEnabled()) return (plan: plan, conflict: null);
      final pull = await sync.pull(install, plan.saveSlots);
      if (pull.outcome == SavePullOutcome.downloaded) {
        // The download may have created save folders this machine had not
        // seen (an RPCS3 folder named by the game): plan again so the
        // session's slots — and the "unchanged" fingerprint — include them.
        plan = await _plan(install, game);
        await sync.refreshFingerprint(install, plan.saveSlots);
      }
      if (pull.outcome == SavePullOutcome.conflict) {
        return (
          plan: plan,
          conflict: SaveConflict(
            serverHead: pull.serverHead!,
            install: install,
            slots: plan.saveSlots,
            localModified: await SaveSnapshot.newestModified(plan.saveSlots),
          )
        );
      }
      return (plan: plan, conflict: null);
    } catch (_) {
      phaseOf(game.id).value = GamePlayPhase.idle;
      rethrow;
    }
  }

  Future<LaunchPlan> _plan(GameInstall install, Query$gameById$gameById game) =>
      GameLaunchers(registry: registry, steam: steam).plan(install,
          retroArchCore: game.launcher.retroArchCore,
          savePathTemplates: [for (final p in game.savePaths) (path: p.path, os: p.os)]);

  /// The user backed out of the conflict dialog (or anything else between
  /// [prepare] and [launch]).
  void abandonLaunch(String gameId) => phaseOf(gameId).value = GamePlayPhase.idle;

  Future<void> resolveConflict(String serverName, SaveConflict conflict, SaveConflictChoice choice) async {
    final sync = _sync(serverName);
    switch (choice) {
      case SaveConflictChoice.useServer:
        await sync.applyServerHead(conflict.install, conflict.slots, conflict.serverHead);
      case SaveConflictChoice.keepLocal:
        // The local saves become the new head; the server's stays in history.
        await sync.push(conflict.install, conflict.slots, force: true, note: 'kept local over v${conflict.serverHead.version}');
      case SaveConflictChoice.cancel:
        abandonLaunch(conflict.install.gameId);
    }
  }

  /// Starts the game. Awaits the process for emulators and native games;
  /// Steam launches are detached and finished with [finishDetached]. The
  /// session is persisted so an app restart can still wrap it up.
  Future<GameSessionResult?> launch(String serverName, Query$gameById$gameById game, LaunchPlan plan) async {
    final install = (await store.get(serverName, game.id))!;
    final session = GameSession(gameId: game.id, startedAt: _clock(), plan: plan, install: install);
    install
      ..sessionStartedAt = session.startedAt
      ..sessionDetached = plan.detached;
    await store.put(serverName, install);
    sessionOf(game.id).value = session;
    phaseOf(game.id).value = GamePlayPhase.launching;
    _beginPresence(serverName, game.id);
    if (plan.detached) {
      try {
        await _runner.detach(plan.command, plan.arguments);
      } catch (e) {
        await _clearSession(serverName, install);
        return GameSessionResult(duration: Duration.zero, errors: [e.toString()]);
      }
      phaseOf(game.id).value = GamePlayPhase.running;
      return null;
    }
    try {
      phaseOf(game.id).value = GamePlayPhase.running;
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
      await _clearSession(serverName, install);
      final result = GameSessionResult(duration: _clock().difference(session.startedAt), errors: [e.toString()]);
      lastResultOf(game.id).value = result;
      return result;
    }
  }

  /// A session an earlier run of the app started and never wrapped up:
  /// rebuilds it so the page can offer to finish it. Null when there is none.
  Future<GameSession?> restoreSession(String serverName, Query$gameById$gameById game) async {
    final existing = sessionOf(game.id).value;
    if (existing != null) return existing;
    final install = await store.get(serverName, game.id);
    final startedAt = install?.sessionStartedAt;
    if (install == null || startedAt == null) return null;
    try {
      final plan = await _plan(install, game);
      final session = GameSession(gameId: game.id, startedAt: startedAt, plan: plan, install: install, restored: true);
      sessionOf(game.id).value = session;
      phaseOf(game.id).value = GamePlayPhase.running;
      // A detached (Steam) game may well still be running.
      _beginPresence(serverName, game.id);
      return session;
    } on LaunchException {
      // The emulator went away; the saves can still be pushed without a plan
      // only if slots are known — give up on the session instead.
      await _clearSession(serverName, install);
      return null;
    }
  }

  /// Forgets an unfinished session without syncing it.
  Future<void> discardSession(String serverName, String gameId) async {
    final install = await store.get(serverName, gameId);
    if (install != null) await _clearSession(serverName, install);
  }

  /// "I stopped playing": for detached (Steam) sessions, and when the app
  /// restarts with a session still open.
  Future<GameSessionResult> finishDetached(String serverName, Query$gameById$gameById game) async {
    final session = sessionOf(game.id).value;
    if (session == null) return const GameSessionResult(duration: Duration.zero);
    return _afterSession(serverName, game, session, duration: _clock().difference(session.startedAt));
  }

  /// Runs the after-session steps again for a session whose sync failed.
  Future<GameSessionResult> retrySync(String serverName, Query$gameById$gameById game) => finishDetached(serverName, game);

  Future<GameSessionResult> _afterSession(String serverName, Query$gameById$gameById game, GameSession session,
      {int? exitCode, required Duration duration, String? error}) async {
    GameSaveInfo? uploaded;
    var saveUnchanged = false;
    var noSaveFound = false;
    final errors = <String>[?error];
    if (await GameSettings.saveSyncEnabled()) {
      phaseOf(game.id).value = GamePlayPhase.uploadingSaves;
      try {
        final slots = session.plan.saveSlots;
        uploaded = await _sync(serverName).push(session.install, slots);
        if (uploaded == null) {
          noSaveFound = slots.isEmpty || await SaveSnapshot.newestModified(slots) == null;
          saveUnchanged = !noSaveFound;
        }
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
      phaseOf(game.id).value = GamePlayPhase.readingAchievements;
      try {
        newAchievements = await _syncAchievements(serverName, session.install);
      } catch (e) {
        LoggerService().logger.w('Achievement sync failed: $e');
        errors.add('achievements: $e');
      }
    }
    phaseOf(game.id).value = GamePlayPhase.recording;
    try {
      await _recordPlayed(serverName, game.id, duration);
    } catch (e) {
      errors.add('record play: $e');
    }
    final result = GameSessionResult(
      duration: duration,
      exitCode: exitCode,
      uploadedSave: uploaded,
      saveUnchanged: saveUnchanged,
      noSaveFound: noSaveFound,
      newAchievements: newAchievements,
      errors: errors,
    );
    // Only a session whose server-side steps all went through is closed;
    // otherwise it stays open so "retry sync" can run them again.
    final syncFailed = errors.any((e) => e.startsWith('save upload:') || e.startsWith('record play:'));
    if (syncFailed) {
      phaseOf(game.id).value = GamePlayPhase.running;
    } else {
      await _clearSession(serverName, session.install);
    }
    lastResultOf(game.id).value = result;
    return result;
  }

  Future<void> _clearSession(String serverName, GameInstall install) async {
    unawaited(_presenceHandles.remove(_presenceKey(serverName, install.gameId))?.end());
    install
      ..sessionStartedAt = null
      ..sessionDetached = false;
    await store.put(serverName, install);
    sessionOf(install.gameId).value = null;
    phaseOf(install.gameId).value = GamePlayPhase.idle;
  }

  static String _presenceKey(String serverName, String gameId) => '$serverName\u0000$gameId';

  void _beginPresence(String serverName, String gameId) {
    final key = _presenceKey(serverName, gameId);
    if (_presenceHandles.containsKey(key)) return;
    _presenceHandles[key] = _presence.begin(
        serverName: serverName, mediaType: Enum$MediaType.GAME, mediaId: gameId);
  }

  Future<List<ReportedAchievement>> _syncAchievements(String serverName, GameInstall install) async {
    AchievementReport? report;
    if (install.form == 'PS3_FOLDER') {
      final rpcs3 = await registry.find(EmulatorKind.rpcs3);
      final config = rpcs3?.configDir;
      if (config != null) {
        final reader = Ps3TrophyReader(rpcs3Config: Directory(config));
        // The game's own TROPDIR says which trophy set is its: an adopted
        // copy's folder, or the files Ister installed.
        final gameRoot = Directory(install.adoptedFrom ?? install.filesDir.path);
        final commIds = await Ps3TrophyReader.commIdsOf(gameRoot);
        for (final folder in await reader.foldersFor(install.titleId, commIds: commIds, title: install.title)) {
          report = await reader.read(folder);
          if (report != null) break;
        }
      }
    } else if (install.form == 'STEAM' && install.steamAppId != null) {
      final root = await steam.root();
      if (root != null) {
        report = await SteamAchievementReader(steamRoot: root, iconCacheDir: Directory('${install.dir}/achievement-icons'))
            .read(install.steamAppId!, await steam.mostRecentAccountId());
      }
    }
    if (report == null) return const [];
    return AchievementSyncService(api: api(serverName), deviceName: _deviceName).sync(install, report);
  }

  Future<void> _recordPlayed(String serverName, String gameId, Duration duration) async {
    final override = _recordPlayedOverride;
    if (override != null) return override(serverName, gameId, duration);
    final client = ClientManager.getClientForUrl(serverName).value;
    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationrecordGamePlayed,
      variables: Variables$Mutation$recordGamePlayed(gameId: gameId, durationMs: duration.inMilliseconds).toJson(),
    ));
    if (result.hasException) throw result.exception!;
  }

  SaveSyncService _sync(String serverName) =>
      SaveSyncService(api: api(serverName), store: store, serverName: serverName, deviceName: _deviceName);
}

class _QueueKey {
  const _QueueKey(this.server, this.gameId);
  final String server;
  final String gameId;

  @override
  bool operator ==(Object other) => other is _QueueKey && other.server == server && other.gameId == gameId;

  @override
  int get hashCode => Object.hash(server, gameId);
}
