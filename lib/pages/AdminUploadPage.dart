import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import '../components/SettingsSection.dart';
import '../components/upload/GameFoundTile.dart';
import '../components/upload/GameTitleYearFields.dart';
import '../components/upload/GameUploadBatchView.dart';
import '../components/upload/GameUploadTarget.dart';
import '../components/upload/UploadProgressView.dart';
import '../l10n/app_localizations.dart';
import '../routes/AppRouter.gr.dart';
import '../utils/LoggerService.dart';
import '../utils/ScreenWakelock.dart';
import '../utils/WellKnownService.dart';
import '../utils/games/GameLabels.dart';
import '../utils/games/GamePlatformSupport.dart';
import '../utils/upload/GameFoundProbe.dart';
import '../utils/upload/GameUploadNaming.dart';
import '../utils/upload/UploadApi.dart';
import '../utils/upload/UploadModels.dart';
import '../utils/upload/UploadResumeStore.dart';
import '../utils/upload/UploadRunner.dart';
import '../utils/upload/UploadSource.dart';
import '../utils/upload/UploadThroughput.dart';
import '../utils/upload/games/GameLibraryIndex.dart';
import '../utils/upload/games/GameSourceMaterialiser.dart';
import '../utils/upload/games/GameUploadBatch.dart';
import '../utils/upload/games/GameUploadCandidate.dart';
import 'DownloadsPage.dart' show formatBytes;
import 'GameUploadCandidatesPage.dart';

/// Admin-only: upload a folder of media into a library directory. Three
/// stages on one page — where and what, the server's preview of how every
/// file will be recognised, and the transfer itself.
///
/// The server decides everything that matters (where a file lands, whether
/// the scanner picks it up, whether it exists); this page only shows it and
/// moves the bytes.
///
/// A GAME library gets a guided target: the platform folder from the
/// server's platform table instead of a free text field, the game folder
/// composed as `Title (year)`, the marker-file verdicts explained, and after
/// the upload a look-up of the game in the library (with whether its saves
/// will sync). On desktop it also offers the games the scanner finds on this
/// computer, ticked and sent as one batch (`GameUploadBatch`).
@RoutePage()
class AdminUploadPage extends StatefulWidget {
  final String serverName;

  /// Test seams.
  final UploadApi? api;
  final Future<UploadSourceFolder?> Function()? pickFolder;
  final Future<List<GamePlatformOption>> Function()? loadPlatforms;
  final GameLookup? findGame;
  final Duration gameProbeInterval;
  final Duration gameProbePatience;
  final Future<GameUploadSelection?> Function(UploadDirectory directory, List<GamePlatformOption> platforms)? pickCandidates;
  final GameLibraryIndexLoader? indexLoader;
  final GameUploadRunnerFactory? runnerFactory;
  final GameSourceMaterialiser? materialiser;
  final Future<UploadSourceFolder?> Function(String path)? reopenFolder;

  const AdminUploadPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    this.api,
    this.pickFolder,
    this.loadPlatforms,
    this.findGame,
    this.gameProbeInterval = const Duration(seconds: 5),
    this.gameProbePatience = const Duration(minutes: 2),
    this.pickCandidates,
    this.indexLoader,
    this.runnerFactory,
    this.materialiser,
    this.reopenFolder,
  });

  @override
  State<AdminUploadPage> createState() => _AdminUploadPageState();
}

class _AdminUploadPageState extends State<AdminUploadPage> {
  late final UploadApi _api = widget.api ?? UploadApi(widget.serverName);
  late final UploadResumeStore _store = UploadResumeStore(widget.serverName);
  final _targetParent = TextEditingController();
  final _rootName = TextEditingController();
  final _gameTitle = TextEditingController();
  final _gameYear = TextEditingController();
  Timer? _previewDebounce;

  /// Game libraries: the server's platform table and the picked platform.
  List<GamePlatformOption>? _platforms;
  GamePlatformOption? _platform;
  bool _platformsLoading = false;
  String? _platformsError;

  /// After a finished game upload: the look-up of the game in the library.
  bool _gameProbing = false;
  FoundGame? _gameFound;
  bool _gameProbeTimedOut = false;
  int _gameProbeGeneration = 0;

  /// Games ticked on the candidates page, waiting for "Start upload".
  List<GameUploadCandidate>? _selection;
  GameUploadBatch? _batch;

  List<UploadDirectory>? _directories;
  Object? _loadError;
  String? _libraryId;
  UploadDirectory? _directory;
  UploadSourceFolder? _folder;
  bool _keepFolder = true;
  bool _overwrite = false;
  bool _onlyProblems = false;

  UploadPreview? _preview;
  bool _previewing = false;
  String? _previewError;
  int _previewGeneration = 0;

  UploadRunner? _runner;
  bool _starting = false;

  /// Speed and time left of the transfer; ticked once a second while it
  /// runs so a stall shows as a falling speed instead of a frozen number.
  UploadThroughput? _throughput;
  Timer? _ticker;

  /// Held while bytes are moving: a phone that dims and suspends the app stops
  /// the upload. Nothing is lost then — it resumes — but it should not happen
  /// merely because nobody touched the screen.
  ScreenWakelockToken? _wakelock;

  /// An upload from an earlier run of the app that the server still holds open.
  StoredUpload? _unfinished;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _previewDebounce?.cancel();
    _ticker?.cancel();
    _runner?.removeListener(_onRunnerChanged);
    _runner?.pause();
    _batch?.removeListener(_onBatchChanged);
    _batch?.pause();
    _batch?.dispose();
    _wakelock?.release();
    _targetParent.dispose();
    _rootName.dispose();
    _gameTitle.dispose();
    _gameYear.dispose();
    _gameProbeGeneration++;
    super.dispose();
  }

  bool get _isGameLibrary => _directory?.libraryType == 'GAME';

  /// The scan of this computer needs a file system: desktop only.
  bool get _canScanGames => widget.pickCandidates != null || (!kIsWeb && kGamesSupported);

  Future<void> _load() async {
    try {
      final info = WellKnownService.getCached(widget.serverName) ?? await WellKnownService.lastKnown(widget.serverName);
      final directories = await _api.directories(info?.serverUrl ?? widget.serverName);
      await _loadUnfinished();
      if (!mounted) return;
      setState(() {
        _directories = directories ?? const [];
        _loadError = null;
        final libraries = _libraries();
        if (libraries.length == 1) _selectLibrary(libraries.first.libraryId);
      });
    } catch (e) {
      LoggerService().logger.e('Upload directories failed: $e');
      if (mounted) setState(() => _loadError = e);
    }
  }

  Future<void> _loadUnfinished() async {
    final stored = await _store.load();
    if (stored == null) return;
    UploadSession? session;
    try {
      session = await _api.session(stored.nodeUrl, stored.sessionId);
    } catch (e) {
      LoggerService().logger.w('Stored upload session is gone: $e');
    }
    final active = session != null && session.status == 'ACTIVE' && session.files.any((f) => f.isActive);
    // A batch whose game in flight finished (or was lost) still has the rest to do.
    final batchLeft = stored.batch != null && stored.batch!.queue.isNotEmpty;
    if (active || batchLeft) {
      _unfinished = stored;
      return;
    }
    await _store.clear();
  }

  Future<void> _remember(String sessionId, String nodeUrl, bool s3, String? sourcePath) =>
      _store.save(StoredUpload(sessionId: sessionId, nodeUrl: nodeUrl, s3: s3, sourcePath: sourcePath));

  Future<void> _forget() => _store.clear();

  /// One entry per library, in the order the server listed the directories.
  List<UploadDirectory> _libraries() {
    final seen = <String>{};
    return [
      for (final d in _directories ?? const <UploadDirectory>[])
        if (seen.add(d.libraryId)) d
    ];
  }

  void _selectLibrary(String? libraryId) {
    _libraryId = libraryId;
    final candidates = (_directories ?? []).where((d) => d.libraryId == libraryId && d.writable).toList();
    _directory = candidates.length == 1 ? candidates.first : null;
    _onDirectoryChanged();
  }

  /// A game library gets its platform table; another kind drops it.
  void _onDirectoryChanged() {
    _selection = null;
    if (_isGameLibrary) {
      _keepFolder = true;
      if (_platforms == null && !_platformsLoading) unawaited(_loadPlatforms());
      _targetParent.text = _platform?.folder ?? '';
      _syncGameRootName();
    }
    _schedulePreview();
  }

  Future<void> _loadPlatforms() async {
    setState(() {
      _platformsLoading = true;
      _platformsError = null;
    });
    try {
      final platforms = await (widget.loadPlatforms ?? () => GamePlatformOption.load(widget.serverName))();
      if (!mounted) return;
      setState(() {
        _platforms = platforms;
        _platformsLoading = false;
      });
    } catch (e) {
      LoggerService().logger.w('Game platforms failed: $e');
      if (mounted) {
        setState(() {
          _platformsLoading = false;
          _platformsError = e.toString();
        });
      }
    }
  }

  void _selectPlatform(GamePlatformOption? platform) {
    setState(() {
      _platform = platform;
      _targetParent.text = platform?.folder ?? '';
    });
    _schedulePreview();
  }

  /// The game folder is `Title (year)` from the two fields.
  void _syncGameRootName() {
    _rootName.text = GameUploadNaming.compose(_gameTitle.text, _gameYear.text);
  }

  // ---- preview ----------------------------------------------------------------------------------

  List<({String relativePath, int size})> _entries() =>
      [for (final f in _folder?.files ?? const <UploadSourceFile>[]) (relativePath: f.relativePath, size: f.size)];

  String? get _effectiveRootName => _keepFolder ? _rootName.text.trim() : null;

  void _schedulePreview() {
    _previewDebounce?.cancel();
    _previewDebounce = Timer(const Duration(milliseconds: 400), _runPreview);
  }

  Future<void> _runPreview() async {
    final directory = _directory;
    final folder = _folder;
    if (directory == null || folder == null || directory.nodeUrl == null) {
      setState(() => _preview = null);
      return;
    }
    final generation = ++_previewGeneration;
    setState(() {
      _previewing = true;
      _previewError = null;
    });
    try {
      final preview = await _api.preview(directory.nodeUrl!,
          directoryId: directory.id,
          targetParent: _targetParent.text.trim(),
          rootName: _effectiveRootName,
          overwrite: _overwrite,
          entries: _entries());
      if (!mounted || generation != _previewGeneration) return;
      setState(() {
        _preview = preview;
        _previewing = false;
      });
    } catch (e) {
      if (!mounted || generation != _previewGeneration) return;
      setState(() {
        _preview = null;
        _previewing = false;
        _previewError = e is UploadApiException ? e.message : e.toString();
      });
    }
  }

  Future<void> _pickFolder() async {
    final folder = await (widget.pickFolder ?? pickUploadFolder)();
    if (folder == null || !mounted) return;
    setState(() {
      _folder = folder;
      _selection = null;
      _rootName.text = folder.name;
      if (_isGameLibrary) {
        final parsed = GameUploadNaming.parse(folder.name);
        _gameTitle.text = parsed.title;
        _gameYear.text = parsed.year ?? '';
        _syncGameRootName();
      }
    });
    _runPreview();
  }

  /// Desktop game libraries: the candidates page returns the ticked games.
  Future<void> _pickCandidates() async {
    final directory = _directory;
    final platforms = _platforms;
    if (directory == null || platforms == null) return;
    final selection = await (widget.pickCandidates ?? _pushCandidates)(directory, platforms);
    if (selection == null || !mounted) return;
    setState(() {
      _selection = selection.candidates;
      _folder = null;
      _preview = null;
    });
  }

  Future<GameUploadSelection?> _pushCandidates(UploadDirectory directory, List<GamePlatformOption> platforms) =>
      AutoRouter.of(context).push<GameUploadSelection>(
          GameUploadCandidatesRoute(directory: directory, platforms: platforms, platform: _platform?.platform));

  // ---- transfer ---------------------------------------------------------------------------------

  Future<void> _start() async {
    final directory = _directory!;
    final folder = _folder!;
    setState(() => _starting = true);
    try {
      final session = await _api.createSession(directory.nodeUrl!,
          directoryId: directory.id,
          targetParent: _targetParent.text.trim(),
          rootName: _effectiveRootName,
          overwrite: _overwrite,
          entries: _entries());
      final s3 = directory.storageKind == 'S3';
      await _remember(session.sessionId, directory.nodeUrl!, s3, folder.path);
      _run(session, directory.nodeUrl!, s3, folder);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e is UploadApiException ? e.message : e.toString())));
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  void _run(UploadSession session, String nodeUrl, bool s3, UploadSourceFolder folder) {
    final runner = UploadRunner(
      api: _api,
      nodeUrl: nodeUrl,
      session: session,
      // path AND size: after a restart the admin may pick a folder that merely looks alike
      sources: {
        for (final f in folder.files)
          if (session.files.any((s) => s.relativePath == f.relativePath && s.size == f.size)) f.relativePath: f
      },
      partsAddressedByNumber: s3,
    )..addListener(_onRunnerChanged);
    setState(() {
      _runner = runner;
      _throughput = UploadThroughput();
      _unfinished = null;
    });
    runner.start();
  }

  /// The ticked games, one session each, driven by [GameUploadBatch].
  void _startBatch() {
    final directory = _directory!;
    final selection = _selection!;
    _runBatch(_newBatch(directory, selection, const []));
  }

  GameUploadBatch _newBatch(UploadDirectory directory, List<GameUploadCandidate> candidates, List<String> done) => GameUploadBatch(
        api: _api,
        directory: directory,
        candidates: candidates,
        overwrite: _overwrite,
        store: _store,
        runnerFactory: widget.runnerFactory,
        materialiser: widget.materialiser,
        indexLoader: widget.indexLoader ?? (id) => GameLibraryIndex.load(widget.serverName, id),
        probeInterval: widget.gameProbeInterval,
        probePatience: widget.gameProbePatience,
        alreadyDone: done,
      );

  void _runBatch(GameUploadBatch batch) {
    batch.addListener(_onBatchChanged);
    setState(() {
      _batch = batch;
      _selection = null;
      _throughput = UploadThroughput();
      _unfinished = null;
    });
    unawaited(batch.start());
  }

  void _tick() {
    if (!mounted) return;
    final sent = _runner?.sentBytes ?? _batch?.sentBytes;
    if (sent != null) _throughput?.sample(sent, DateTime.now());
    setState(() {});
  }

  void _onRunnerChanged() {
    if (!mounted) return;
    final runner = _runner;
    if (runner != null && runner.isFinished && runner.failedCount == 0) {
      _forget();
      if (_isGameLibrary && !_gameProbing && _gameFound == null && !_gameProbeTimedOut) unawaited(_probeGame());
    }
    _moving(runner != null && runner.isRunning, runner?.sentBytes ?? 0);
    setState(() {});
  }

  void _onBatchChanged() {
    if (!mounted) return;
    final batch = _batch!;
    _moving(batch.isRunning && !batch.isPaused, batch.sentBytes);
    setState(() {});
  }

  /// Wakelock, throughput sampling and the ticker follow whether bytes move.
  void _moving(bool running, int sentBytes) {
    if (running) {
      _wakelock ??= ScreenWakelock.acquire();
      _throughput?.sample(sentBytes, DateTime.now());
      _ticker ??= Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    } else {
      _wakelock?.release();
      _wakelock = null;
      _throughput?.pause(DateTime.now());
      _ticker?.cancel();
      _ticker = null;
    }
  }

  Future<void> _resumeUnfinished() async {
    final unfinished = _unfinished!;
    final batch = unfinished.batch;
    if (batch != null) return _resumeBatch(unfinished, batch);
    UploadSourceFolder? folder;
    final path = unfinished.sourcePath;
    if (path != null) folder = await (widget.reopenFolder ?? reopenUploadFolder)(path);
    folder ??= await (widget.pickFolder ?? pickUploadFolder)();
    if (folder == null || !mounted) return;
    try {
      final session = await _api.session(unfinished.nodeUrl, unfinished.sessionId);
      _run(session, unfinished.nodeUrl, unfinished.s3, folder);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  /// The stored game in flight gets its open session back; the queue follows.
  Future<void> _resumeBatch(StoredUpload unfinished, StoredBatch stored) async {
    final directory = (_directories ?? const <UploadDirectory>[]).where((d) => d.id == stored.directoryId).firstOrNull;
    if (directory == null) {
      await _forget();
      if (mounted) setState(() => _unfinished = null);
      return;
    }
    _overwrite = stored.overwrite;
    final current = stored.current;
    final candidates = [?current, ...stored.queue];
    final batch = _newBatch(directory, candidates, stored.done);
    if (current != null) {
      try {
        final session = await _api.session(unfinished.nodeUrl, unfinished.sessionId);
        if (session.status == 'ACTIVE' && session.files.any((f) => f.isActive)) batch.resumeWith(session);
      } catch (e) {
        LoggerService().logger.w('Stored batch session is gone, starting the game afresh: $e');
      }
    }
    if (!mounted) return;
    setState(() => _directory = directory);
    _runBatch(batch);
  }

  Future<void> _cancelUnfinished() async {
    final unfinished = _unfinished!;
    try {
      await _api.abort(unfinished.nodeUrl, unfinished.sessionId);
    } catch (e) {
      LoggerService().logger.w('Abort of stored upload failed: $e');
    }
    await _forget();
    if (mounted) setState(() => _unfinished = null);
  }

  Future<void> _confirmCancel() async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(loc.uploadCancelConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(loc.cancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(loc.uploadCancelUpload)),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _runner?.cancel();
      await _batch?.cancel();
    } catch (e) {
      LoggerService().logger.w('Upload cancel failed: $e');
    }
    await _forget();
  }

  /// Looks the uploaded game up until the scanner lists it. The title is
  /// the folder's title without the year, which is what the scanner names
  /// the game after.
  Future<void> _probeGame() async {
    final libraryId = _directory?.libraryId;
    if (libraryId == null) return;
    final title = _gameTitle.text.trim().isEmpty ? GameUploadNaming.parse(_rootName.text).title : _gameTitle.text.trim();
    if (title.isEmpty) return;
    final generation = ++_gameProbeGeneration;
    setState(() {
      _gameProbing = true;
      _gameFound = null;
      _gameProbeTimedOut = false;
    });
    final probe = GameFoundProbe(
      lookup: widget.findGame ?? GameFoundProbe.graphQL(widget.serverName),
      interval: widget.gameProbeInterval,
      patience: widget.gameProbePatience,
    );
    final found = await probe.run(libraryId, title, cancelled: () => generation != _gameProbeGeneration);
    if (!mounted || generation != _gameProbeGeneration) return;
    setState(() {
      _gameProbing = false;
      _gameFound = found;
      _gameProbeTimedOut = found == null;
    });
  }

  void _reset() {
    _runner?.removeListener(_onRunnerChanged);
    _batch?.removeListener(_onBatchChanged);
    _batch?.dispose();
    _ticker?.cancel();
    _ticker = null;
    _gameProbeGeneration++;
    setState(() {
      _runner = null;
      _batch = null;
      _selection = null;
      _throughput = null;
      _folder = null;
      _preview = null;
      _rootName.clear();
      _gameTitle.clear();
      _gameYear.clear();
      _gameProbing = false;
      _gameFound = null;
      _gameProbeTimedOut = false;
    });
    _load();
  }

  // ---- build ------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.uploadMedia)),
      body: _body(loc),
    );
  }

  Widget _body(AppLocalizations loc) {
    if (!uploadSourceSupported && widget.pickFolder == null) {
      return SettingsEmptyState(icon: Icons.upload_outlined, title: loc.uploadMedia, message: loc.uploadNotSupportedHere);
    }
    if (_loadError != null) {
      return SettingsErrorState(
          message: loc.couldNotLoad, detailsLabel: loc.errorDetails, details: _loadError.toString());
    }
    if (_directories == null) return const Center(child: CircularProgressIndicator());
    if (_batch != null) {
      return GameUploadBatchView(
        batch: _batch!,
        throughput: _throughput,
        onCancel: _confirmCancel,
        onReset: _reset,
        onOpenGame: (id) => AutoRouter.of(context).push(GameRoute(gameId: id)),
      );
    }
    if (_runner != null) {
      return UploadProgressView(
        runner: _runner!,
        throughput: _throughput,
        onCancel: _confirmCancel,
        onReset: _reset,
        extras: [if (_runner!.isFinished && _runner!.failedCount == 0 && _isGameLibrary) _gameFoundCard(loc)],
      );
    }
    if (_directories!.isEmpty) {
      return SettingsEmptyState(icon: Icons.folder_off_outlined, title: loc.uploadNoDirectories);
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SettingsIntro(loc.uploadIntro),
        if (_unfinished != null) _unfinishedCard(loc),
        _targetCard(loc),
        const SizedBox(height: 16),
        _sourceCard(loc),
        if (_selection != null && _directory != null) ...[
          const SizedBox(height: 16),
          _selectionCard(loc),
        ],
        if (_folder != null && _directory != null) ...[
          const SizedBox(height: 16),
          _previewCard(loc),
        ],
      ],
    );
  }

  Widget _unfinishedCard(AppLocalizations loc) {
    final batch = _unfinished!.batch;
    final current = batch?.current;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SettingsCard(children: [
        ListTile(
          key: const ValueKey('upload-unfinished'),
          leading: const Icon(Icons.history),
          title: Text(batch == null ? loc.uploadUnfinishedTitle : loc.uploadGamesResumeTitle),
          subtitle: Text(batch == null
              ? loc.uploadUnfinishedBody
              : loc.uploadGamesResumeBody(current?.rootName ?? batch.queue.first.rootName, batch.queue.length - (current == null ? 1 : 0))),
        ),
        OverflowBar(alignment: MainAxisAlignment.end, children: [
          TextButton(onPressed: _cancelUnfinished, child: Text(loc.uploadCancelUpload)),
          FilledButton.tonal(
            key: const ValueKey('upload-resume'),
            onPressed: _resumeUnfinished,
            child: Text(batch != null || _unfinished!.sourcePath != null ? loc.uploadResumeNow : loc.uploadPickFolder),
          ),
          const SizedBox(width: 8),
        ]),
      ]),
    );
  }

  Widget _targetCard(AppLocalizations loc) {
    final libraries = _libraries();
    final directories = _directories!.where((d) => d.libraryId == _libraryId).toList();
    return SettingsCard(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: DropdownButtonFormField<String>(
          key: const ValueKey('upload-library'),
          initialValue: _libraryId,
          decoration: InputDecoration(labelText: loc.uploadLibrary),
          items: [for (final l in libraries) DropdownMenuItem(value: l.libraryId, child: Text(l.libraryName))],
          onChanged: (value) => setState(() => _selectLibrary(value)),
        ),
      ),
      if (_libraryId != null)
        RadioGroup<String>(
          groupValue: _directory?.id,
          onChanged: (id) => setState(() {
            _directory = directories.firstWhere((d) => d.id == id);
            _onDirectoryChanged();
          }),
          child: Column(children: [
            for (final d in directories)
              RadioListTile<String>(
                key: ValueKey('upload-directory-${d.name}'),
                value: d.id,
                enabled: d.writable,
                title: Text(d.name),
                subtitle: Text(d.writable
                    ? (d.freeBytes == null
                        ? '${d.storageKind} · ${d.nodeName ?? ''}'
                        : loc.uploadDirectoryFree(formatBytes(d.freeBytes!), d.nodeName ?? ''))
                    : loc.uploadDirectoryNotWritable),
              ),
          ]),
        ),
      if (_directory != null && _isGameLibrary && _selection == null)
        GameUploadTarget(
          platforms: _platforms ?? const [],
          selected: _platform,
          loading: _platformsLoading,
          error: _platformsError,
          onChanged: _selectPlatform,
        )
      else if (_directory != null && !_isGameLibrary)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: TextField(
            key: const ValueKey('upload-target-parent'),
            controller: _targetParent,
            decoration: InputDecoration(labelText: loc.uploadTargetParent, helperText: loc.uploadTargetParentHint, helperMaxLines: 2),
            onChanged: (_) => _schedulePreview(),
          ),
        ),
    ]);
  }

  Widget _sourceCard(AppLocalizations loc) {
    final folder = _folder;
    return SettingsCard(children: [
      if (_isGameLibrary && _canScanGames)
        ListTile(
          key: const ValueKey('upload-scan-games'),
          leading: const Icon(Icons.travel_explore_outlined),
          title: Text(loc.uploadGamesScanTitle),
          subtitle: Text(loc.uploadGamesScanSubtitle),
          trailing: const Icon(Icons.chevron_right),
          enabled: _directory != null && _platforms != null,
          onTap: _pickCandidates,
        ),
      ListTile(
        key: const ValueKey('upload-pick-folder'),
        leading: const Icon(Icons.folder_open_outlined),
        title: Text(folder == null
            ? loc.uploadPickFolder
            : loc.uploadPickedFolder(folder.name, folder.files.length, formatBytes(folder.totalBytes))),
        trailing: const Icon(Icons.chevron_right),
        enabled: _directory != null,
        onTap: _pickFolder,
      ),
      if (folder != null && _isGameLibrary) _gameNameFields(loc),
      if (folder != null && !_isGameLibrary) ...[
        SwitchListTile(
          key: const ValueKey('upload-keep-folder'),
          title: Text(loc.uploadKeepFolder),
          subtitle: Text(loc.uploadKeepFolderSubtitle),
          value: _keepFolder,
          onChanged: (value) => setState(() {
            _keepFolder = value;
            _schedulePreview();
          }),
        ),
        if (_keepFolder)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              key: const ValueKey('upload-root-name'),
              controller: _rootName,
              decoration: InputDecoration(labelText: loc.uploadFolderName),
              onChanged: (_) => _schedulePreview(),
            ),
          ),
      ],
      if (folder != null || _selection != null) ...[
        SwitchListTile(
          key: const ValueKey('upload-overwrite'),
          title: Text(loc.uploadOverwrite),
          subtitle: Text(loc.uploadOverwriteSubtitle),
          value: _overwrite,
          onChanged: (value) => setState(() {
            _overwrite = value;
            _schedulePreview();
          }),
        ),
      ],
    ]);
  }

  /// A game is one folder named `Title (year)`: two fields compose it, and
  /// the line under them shows where it lands.
  Widget _gameNameFields(AppLocalizations loc) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: GameTitleYearFields(
          title: _gameTitle,
          year: _gameYear,
          platformFolder: _platform?.folder,
          onChanged: () => setState(() {
            _syncGameRootName();
            _schedulePreview();
          }),
        ),
      );

  /// The ticked games, with the start button.
  Widget _selectionCard(AppLocalizations loc) {
    final theme = Theme.of(context);
    final selection = _selection!;
    final known = selection.map((c) => c.sizeBytes).whereType<int>().fold(0, (a, b) => a + b);
    final partial = selection.any((c) => c.sizeBytes == null);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SettingsSectionLabel(loc.uploadPreviewTitle),
      SettingsCard(children: [
        ListTile(
          key: const ValueKey('upload-selection-summary'),
          title: Text(loc.uploadGamesSelected(selection.length, '${formatBytes(known)}${partial ? '+' : ''}')),
          trailing: TextButton(key: const ValueKey('upload-selection-change'), onPressed: _pickCandidates, child: Text(loc.uploadGamesChange)),
        ),
        for (final c in selection)
          ListTile(
            dense: true,
            leading: const Icon(Icons.videogame_asset_outlined),
            title: Text('${c.platformFolder}/${c.rootName}', maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text('${GameLabels.platform(c.platform)} · ${c.sourcePath}', maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text(c.sizeBytes == null ? '' : formatBytes(c.sizeBytes!), style: theme.textTheme.bodySmall),
          ),
      ]),
      const SizedBox(height: 12),
      FilledButton.icon(
        key: const ValueKey('upload-start'),
        onPressed: selection.isEmpty ? null : _startBatch,
        icon: const Icon(Icons.upload),
        label: Text(loc.uploadStart),
      ),
    ]);
  }

  Widget _previewCard(AppLocalizations loc) {
    final theme = Theme.of(context);
    final preview = _preview;
    if (_previewError != null) {
      return SettingsCard(children: [
        ListTile(leading: Icon(Icons.error_outline, color: theme.colorScheme.error), title: Text(_previewError!)),
      ]);
    }
    if (preview == null) {
      return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
    }
    final entries = _onlyProblems
        ? preview.entries.where((e) => !_willUpload(e)).toList()
        : preview.entries;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SettingsSectionLabel(loc.uploadPreviewTitle),
      SettingsCard(children: [
        for (final root in preview.roots) _rootTile(loc, theme, root),
        ListTile(
          key: const ValueKey('upload-preview-summary'),
          title: Text(preview.uploadFiles == 0
              ? loc.uploadNothingToUpload
              : loc.uploadPreviewSummary(preview.uploadFiles, formatBytes(preview.uploadBytes))),
          trailing: _previewing ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : null,
        ),
        SwitchListTile(
          dense: true,
          title: Text(loc.uploadShowOnlyProblems),
          value: _onlyProblems,
          onChanged: (value) => setState(() => _onlyProblems = value),
        ),
      ]),
      const SizedBox(height: 12),
      FilledButton.icon(
        key: const ValueKey('upload-start'),
        onPressed: preview.uploadFiles == 0 || _starting || _previewing ? null : _start,
        icon: const Icon(Icons.upload),
        label: Text(loc.uploadStart),
      ),
      const SizedBox(height: 12),
      SettingsCard(children: [for (final entry in entries) _previewTile(loc, theme, entry)]),
    ]);
  }

  Widget _rootTile(AppLocalizations loc, ThemeData theme, UploadPreviewRoot root) {
    final game = _isGameLibrary;
    final warn = root.level == 'NONE' || (game && root.level == 'GAME_PLATFORM');
    final text = switch (root.level) {
      'NONE' when game => loc.uploadRootNotGame(root.name),
      'NONE' => loc.uploadRootLevelNone(root.name),
      'GAME_PLATFORM' => loc.uploadRootPlatformFolder(root.name),
      'GAME' => loc.uploadRootGame(root.name),
      _ => loc.uploadRootLevel(root.name, root.level),
    };
    return ListTile(
      dense: true,
      leading: Icon(warn ? Icons.warning_amber_outlined : Icons.folder_outlined, color: warn ? theme.colorScheme.error : null),
      title: Text(text),
    );
  }

  bool _willUpload(UploadPreviewEntry entry) =>
      entry.status == UploadPreviewStatus.recognised || (entry.status == UploadPreviewStatus.exists && _overwrite);

  Widget _previewTile(AppLocalizations loc, ThemeData theme, UploadPreviewEntry entry) {
    final (IconData icon, Color color, String label) = switch (entry.status) {
      UploadPreviewStatus.recognised => (Icons.check_circle_outline, theme.colorScheme.primary, loc.uploadStatusRecognised),
      UploadPreviewStatus.exists => _overwrite
          ? (Icons.published_with_changes, theme.colorScheme.tertiary, loc.uploadStatusWillOverwrite)
          : (Icons.file_present_outlined, theme.disabledColor, loc.uploadStatusExists),
      UploadPreviewStatus.busy => (Icons.hourglass_empty, theme.disabledColor, loc.uploadStatusBusy),
      UploadPreviewStatus.invalid => (Icons.error_outline, theme.colorScheme.error, loc.uploadStatusInvalid),
      UploadPreviewStatus.duplicate => (Icons.copy_all_outlined, theme.disabledColor, loc.uploadStatusDuplicate),
      UploadPreviewStatus.ignored => (Icons.block, theme.disabledColor, loc.uploadStatusIgnored),
    };
    final detail = switch (entry.status) {
      UploadPreviewStatus.recognised || UploadPreviewStatus.exists => _recognitionLine(loc, entry.recognition),
      UploadPreviewStatus.ignored => switch (entry.ignoreReason) {
          'FOLDER_NOT_SCANNED' => loc.uploadIgnoredFolder(entry.detail ?? ''),
          'GAME_INCOMPLETE' => loc.uploadIgnoredGameIncomplete(entry.detail ?? ''),
          _ => loc.uploadIgnoredUnsupported,
        },
      UploadPreviewStatus.invalid => entry.detail ?? '',
      _ => '',
    };
    return ListTile(
      dense: true,
      leading: Icon(icon, color: color),
      title: Text(entry.relativePath, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(detail.isEmpty ? label : '$label · $detail', maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: Text(formatBytes(entry.size), style: theme.textTheme.bodySmall),
    );
  }

  /// The recognition summary, with a game's platform and form spelled out.
  String _recognitionLine(AppLocalizations loc, UploadRecognition? recognition) {
    if (recognition == null) return '';
    final parts = <String>[recognition.summary()];
    final platform = recognition.json['platform'] as String?;
    final form = recognition.json['form'] as String?;
    if (platform != null) parts.add(GameLabels.platformName(platform));
    if (form != null) parts.add(GameLabels.formName(loc, form));
    return parts.where((p) => p.isNotEmpty).join(' · ');
  }

  /// After a game upload: whether the library lists the game yet, and
  /// whether its saves will sync.
  Widget _gameFoundCard(AppLocalizations loc) {
    final found = _gameFound;
    if (_gameProbing) {
      return SettingsCard(children: [
        ListTile(
          key: const ValueKey('upload-game-probing'),
          leading: const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
          title: Text(loc.uploadGameLookingUp),
        ),
      ]);
    }
    if (found == null) {
      return SettingsCard(children: [
        ListTile(
          key: const ValueKey('upload-game-not-found'),
          leading: const Icon(Icons.hourglass_bottom),
          title: Text(loc.uploadGameNotYetFound),
        ),
      ]);
    }
    return SettingsCard(children: [
      GameFoundTile(found: found, onOpen: () => AutoRouter.of(context).push(GameRoute(gameId: found.id))),
    ]);
  }
}
