import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:material_ui/material_ui.dart';
import 'package:player/graphql/schema.graphql.dart';

import '../components/SettingsSection.dart';
import '../components/upload/GameCandidateTile.dart';
import '../components/upload/GameTitleYearFields.dart';
import '../components/upload/GameUploadTarget.dart';
import '../l10n/app_localizations.dart';
import '../routes/AppRouter.gr.dart';
import '../utils/LoggerService.dart';
import '../utils/games/GameLabels.dart';
import '../utils/games/GameLibraryService.dart';
import '../utils/games/GameSettings.dart';
import '../utils/games/steam/SteamLibraryLocator.dart';
import '../utils/upload/GameUploadNaming.dart';
import '../utils/upload/UploadModels.dart';
import '../utils/upload/UploadSource.dart';
import '../utils/upload/games/GameLibraryIndex.dart';
import '../utils/upload/games/GamePlatformTable.dart';
import '../utils/upload/games/GameSourceScanner.dart';
import '../utils/upload/games/GameUploadCandidate.dart';
import 'DownloadsPage.dart' show formatBytes;

/// What the admin ticked, back to the upload page.
class GameUploadSelection {
  const GameUploadSelection(this.candidates);
  final List<GameUploadCandidate> candidates;
}

/// Finds the scanner's candidates on this computer and the games a library
/// knows: the lists the admin ticks games from, one tile per game. The
/// scan itself is injectable (tests feed candidates; no real I/O runs under
/// a widget test).
typedef GameCandidateScan = Future<List<GameUploadCandidate>> Function(List<GamePlatformOption> platforms);

/// The games on this computer a game library can take, grouped by platform
/// with the ones already in the library unticked. Pops with a
/// [GameUploadSelection].
@RoutePage()
class GameUploadCandidatesPage extends StatefulWidget {
  const GameUploadCandidatesPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    required this.directory,
    required this.platforms,
    this.scan,
    this.indexLoader,
    this.pickFolder,
  });

  final String serverName;
  final UploadDirectory directory;
  final List<GamePlatformOption> platforms;

  /// Test seams.
  final GameCandidateScan? scan;
  final GameLibraryIndexLoader? indexLoader;
  final Future<UploadSourceFolder?> Function()? pickFolder;

  @override
  State<GameUploadCandidatesPage> createState() => _GameUploadCandidatesPageState();

  /// The real scan: the configured (or default) folders and the Steam
  /// libraries, minus Ister's own install root and the Steam games it
  /// restored itself.
  static Future<List<GameUploadCandidate>> scanThisComputer(String serverName, List<GamePlatformOption> platforms) async {
    final roots = await GameSettings.effectiveUploadSourceFolders();
    final gamesRoot = (await GameSettings.gamesRoot()).path;
    final installs = await GameLibraryService.instance.store.load(serverName);
    final scanner = GameSourceScanner(
      table: GamePlatformTable(platforms),
      excludedPaths: {gamesRoot},
      excludedSteamAppIds: {for (final i in installs.values) if (i.steamAppId != null) i.steamAppId!},
    );
    return scanner.scan(roots, await SteamLibraryLocator().libraries());
  }
}

class _GameUploadCandidatesPageState extends State<GameUploadCandidatesPage> {
  List<GameUploadCandidate>? _candidates;
  Object? _scanError;
  GameLibraryIndex? _index;
  final Set<String> _selected = {};
  List<String> _folders = const [];

  @override
  void initState() {
    super.initState();
    unawaited(_load());
    unawaited(_loadIndex());
  }

  Future<void> _load() async {
    setState(() {
      _candidates = null;
      _scanError = null;
    });
    try {
      final folders = await GameSettings.effectiveUploadSourceFolders();
      final candidates = await (widget.scan ?? (p) => GameUploadCandidatesPage.scanThisComputer(widget.serverName, p))(widget.platforms);
      if (!mounted) return;
      setState(() {
        _folders = folders;
        _candidates = candidates;
        _selected
          ..clear()
          ..addAll([for (final c in candidates) if (!_inLibrary(c) && c.conflictWith == null) c.id]);
      });
    } catch (e) {
      LoggerService().logger.w('Game scan failed: $e');
      if (mounted) setState(() => _scanError = e);
    }
  }

  Future<void> _loadIndex() async {
    try {
      final index = await (widget.indexLoader ?? (id) => GameLibraryIndex.load(widget.serverName, id))(widget.directory.libraryId);
      if (!mounted) return;
      setState(() {
        _index = index;
        // The index may land after the scan: untick what the library has.
        _selected.removeWhere((id) {
          final c = _candidates?.where((c) => c.id == id).firstOrNull;
          return c != null && _inLibrary(c);
        });
      });
    } catch (e) {
      LoggerService().logger.w('Game library index failed: $e');
    }
  }

  bool _inLibrary(GameUploadCandidate c) => _index?.contains(c.platform, c.title) ?? false;

  Future<void> _edit(GameUploadCandidate candidate) async {
    final edited = await showGameTitleYearDialog(context, title: candidate.title, year: candidate.year, platformFolder: candidate.platformFolder);
    if (edited == null || !mounted) return;
    setState(() {
      final list = _candidates!;
      final i = list.indexWhere((c) => c.id == candidate.id);
      list[i] = candidate.copyWith(title: edited.title, year: edited.year, clearYear: edited.year == null);
      _candidates = GameSourceScanner.markConflicts(list);
    });
  }

  /// The old route: a folder picked by hand, as one candidate of the first
  /// platform in the list (the admin fixes the platform in the title dialog
  /// — no: the platform is the folder's; so it is asked here).
  Future<void> _pickOther() async {
    final folder = await (widget.pickFolder ?? pickUploadFolder)();
    if (folder == null || !mounted) return;
    final platform = await _askPlatform();
    if (platform == null || !mounted) return;
    final named = GameUploadNaming.parse(folder.name);
    final candidate = GameUploadCandidate(
      platform: platform.platform,
      platformFolder: platform.folder,
      title: named.title,
      year: named.year,
      kind: GameCandidateKind.tree,
      sourcePath: folder.path ?? folder.name,
      files: folder.path == null
          ? [for (final f in folder.files) (relativePath: f.relativePath, absolutePath: '', size: f.size)]
          : null,
    );
    setState(() {
      _candidates = GameSourceScanner.markConflicts([...?_candidates, candidate]);
      _selected.add(candidate.id);
    });
  }

  Future<GamePlatformOption?> _askPlatform() => showDialog<GamePlatformOption>(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(AppLocalizations.of(context)!.uploadGamePlatform),
          children: [
            for (final p in widget.platforms)
              SimpleDialogOption(
                key: ValueKey('upload-game-platform-${p.platform.name}'),
                onPressed: () => Navigator.of(context).pop(p),
                child: Text('${GameLabels.platform(p.platform)}  ·  ${p.folder}/'),
              ),
          ],
        ),
      );

  List<GameUploadCandidate> get _selection => [for (final c in _candidates ?? const <GameUploadCandidate>[]) if (_selected.contains(c.id)) c];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final selection = _selection;
    final sizes = selection.map((c) => c.sizeBytes);
    final knownSize = sizes.whereType<int>().fold(0, (a, b) => a + b);
    final sizeLabel = selection.isEmpty || knownSize == 0 ? '' : ' · ${formatBytes(knownSize)}${sizes.contains(null) ? '+' : ''}';
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.uploadGamesCandidatesTitle),
        actions: [
          IconButton(key: const ValueKey('game-candidates-rescan'), tooltip: loc.uploadGamesRescan, icon: const Icon(Icons.refresh), onPressed: _load),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'pick') unawaited(_pickOther());
              if (value == 'settings') AutoRouter.of(context).push(GameSettingsRoute());
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'pick', key: const ValueKey('game-candidates-pick'), child: Text(loc.uploadGamesOtherFolder)),
              PopupMenuItem(value: 'settings', child: Text(loc.uploadGamesSettings)),
            ],
          ),
        ],
      ),
      body: _body(loc),
      floatingActionButton: selection.isEmpty
          ? null
          : FloatingActionButton.extended(
              key: const ValueKey('game-candidates-upload'),
              icon: const Icon(Icons.upload),
              label: Text(loc.uploadGamesUpload(selection.length, sizeLabel)),
              onPressed: () => Navigator.of(context).maybePop(GameUploadSelection(selection)),
            ),
    );
  }

  Widget _body(AppLocalizations loc) {
    final theme = Theme.of(context);
    final candidates = _candidates;
    if (_scanError != null) {
      return SettingsErrorState(message: loc.couldNotLoad, detailsLabel: loc.errorDetails, details: _scanError.toString());
    }
    if (candidates == null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(loc.uploadGamesScanning, key: const ValueKey('game-candidates-scanning')),
        ]),
      );
    }
    if (candidates.isEmpty) {
      return SettingsEmptyState(
        icon: Icons.videogame_asset_off_outlined,
        title: loc.uploadGamesCandidatesTitle,
        message: _folders.isEmpty ? loc.uploadGamesNoFolders : loc.uploadGamesNoneFound(_folders.join(', ')),
      );
    }
    final groups = <Enum$GamePlatform, List<GameUploadCandidate>>{};
    for (final c in candidates) {
      groups.putIfAbsent(c.platform, () => []).add(c);
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        for (final entry in groups.entries) ...[
          Row(children: [
            Expanded(child: SettingsSectionLabel('${GameLabels.platform(entry.key)} (${entry.value.length})')),
            TextButton(
              key: ValueKey('game-candidates-all-${entry.key.name}'),
              onPressed: () => setState(() {
                final all = entry.value.every((c) => _selected.contains(c.id));
                for (final c in entry.value) {
                  all ? _selected.remove(c.id) : _selected.add(c.id);
                }
              }),
              child: Text(entry.value.every((c) => _selected.contains(c.id)) ? loc.uploadGamesSelectNone : loc.uploadGamesSelectAll,
                  style: theme.textTheme.labelMedium),
            ),
          ]),
          SettingsCard(children: [
            for (final c in entry.value)
              GameCandidateTile(
                candidate: c,
                selected: _selected.contains(c.id),
                inLibrary: _inLibrary(c),
                onSelected: (value) => setState(() => value ? _selected.add(c.id) : _selected.remove(c.id)),
                onEdit: () => unawaited(_edit(c)),
              ),
          ]),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
