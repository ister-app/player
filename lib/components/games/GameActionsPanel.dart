import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:player/graphql/gameById.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/games/GameInstallStore.dart';
import 'package:player/utils/games/GameLabels.dart';
import 'package:player/utils/games/GameLibraryService.dart';
import 'package:player/utils/games/launch/GameLaunchers.dart';
import 'package:player/utils/games/steam/SteamLibraryLocator.dart';

import '../../l10n/app_localizations.dart';

/// The install / play controls of a game on a desktop build: install (with
/// progress and cancel), play (pull saves → launch → push saves), the
/// "finished playing" step for Steam launches, and uninstall. Problems a user
/// can fix (no emulator, missing core, missing PS3 firmware) are spelled out.
class GameActionsPanel extends StatefulWidget {
  const GameActionsPanel({
    super.key,
    required this.serverName,
    required this.game,
    this.onPlayed,
  });

  final String serverName;
  final Query$gameById$gameById game;
  final VoidCallback? onPlayed;

  @override
  State<GameActionsPanel> createState() => _GameActionsPanelState();
}

class _GameActionsPanelState extends State<GameActionsPanel> {
  final GameLibraryService _service = GameLibraryService.instance;
  GameInstall? _install;
  bool _busy = false;
  String? _message;
  GameSessionResult? _lastResult;

  @override
  void initState() {
    super.initState();
    unawaited(_refreshInstall());
  }

  Future<void> _refreshInstall() async {
    final install = await _service.installOf(widget.serverName, widget.game.id);
    if (mounted) setState(() => _install = install);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ValueListenableBuilder<GameInstallProgress?>(
      valueListenable: _service.progressOf(widget.game.id),
      builder: (context, progress, _) {
        return ValueListenableBuilder<GameSession?>(
          valueListenable: _service.sessionOf(widget.game.id),
          builder: (context, session, _) {
            final installing = progress != null &&
                (progress.status == GameInstallStatus.downloading || progress.status == GameInstallStatus.extracting);
            final installed = _install?.isInstalled == true && !installing;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (session != null)
                      FilledButton.icon(
                        key: const ValueKey('game-finish-playing'),
                        onPressed: _busy || !session.plan.detached ? null : () => unawaited(_finish()),
                        icon: const Icon(Icons.stop_circle_outlined),
                        label: Text(session.plan.detached ? loc.gameFinishedPlaying : loc.gameRunning),
                      )
                    else if (installed)
                      FilledButton.icon(
                        key: const ValueKey('game-play'),
                        onPressed: _busy ? null : () => unawaited(_play()),
                        icon: const Icon(Icons.play_arrow),
                        label: Text(loc.gamePlay),
                      )
                    else if (installing)
                      OutlinedButton.icon(
                        key: const ValueKey('game-cancel-install'),
                        onPressed: () => _service.cancelInstall(widget.game.id),
                        icon: const Icon(Icons.close),
                        label: Text(loc.cancel),
                      )
                    else
                      FilledButton.icon(
                        key: const ValueKey('game-install'),
                        onPressed: _busy ? null : () => unawaited(_installGame()),
                        icon: const Icon(Icons.download_outlined),
                        label: Text(widget.game.form == Enum$GameForm.STEAM
                            ? loc.gameInstallIntoSteam
                            : loc.gameInstall(GameLabels.bytes(widget.game.sizeBytes))),
                      ),
                    if (installed && session == null)
                      TextButton.icon(
                        key: const ValueKey('game-uninstall'),
                        onPressed: _busy ? null : () => unawaited(_uninstall()),
                        icon: const Icon(Icons.delete_outline),
                        label: Text(loc.gameUninstall),
                      ),
                  ],
                ),
                if (installing) ...[
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: progress.fraction),
                  const SizedBox(height: 4),
                  Text(
                    progress.status == GameInstallStatus.extracting
                        ? loc.gameExtracting
                        : loc.gameDownloadingProgress(
                            GameLabels.bytes(progress.doneBytes),
                            GameLabels.bytes(progress.totalBytes),
                            progress.filesDone,
                            progress.filesTotal),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                if (progress?.status == GameInstallStatus.failed && progress?.error != null && progress?.error != 'cancelled')
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(loc.gameInstallFailed(progress!.error!),
                        style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ),
                if (_message != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(_message!, key: const ValueKey('game-message')),
                  ),
                if (_lastResult != null) ...[
                  const SizedBox(height: 8),
                  _sessionSummary(loc, _lastResult!),
                ],
              ],
            );
          },
        );
      },
    );
  }

  Widget _sessionSummary(AppLocalizations loc, GameSessionResult result) {
    final lines = <String>[
      loc.gameSessionLength(GameLabels.playTime(loc, result.duration.inMilliseconds)),
      if (result.uploadedSave != null) loc.gameSaveUploaded(result.uploadedSave!.version),
      if (result.newAchievements.isNotEmpty) loc.gameNewAchievements(result.newAchievements.length),
      if (result.error != null) result.error!,
    ];
    return Text(lines.join('\n'), style: Theme.of(context).textTheme.bodySmall);
  }

  Future<void> _installGame() async {
    final loc = AppLocalizations.of(context)!;
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      SteamLibrary? library;
      if (widget.game.form == Enum$GameForm.STEAM) {
        library = await _pickSteamLibrary();
        if (library == null) return;
      }
      await _service.install(widget.serverName, widget.game, steamLibrary: library);
      await _refreshInstall();
      if (mounted && widget.game.form == Enum$GameForm.STEAM) {
        setState(() => _message = loc.gameSteamRestartHint);
      }
    } catch (e) {
      if (mounted) setState(() => _message = loc.gameInstallFailed(e.toString()));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<SteamLibrary?> _pickSteamLibrary() async {
    final loc = AppLocalizations.of(context)!;
    final libraries = await _service.steam.libraries();
    if (!mounted) return null;
    if (libraries.isEmpty) {
      // No Steam found: let the user point at a library folder by hand.
      final picked = await FilePicker.getDirectoryPath(dialogTitle: loc.gamePickSteamLibrary);
      if (picked == null) return null;
      return SteamLibrary(path: picked, label: picked);
    }
    if (libraries.length == 1) return libraries.first;
    return showDialog<SteamLibrary>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(loc.gamePickSteamLibrary),
        children: [
          for (final library in libraries)
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(library),
              child: Text(library.path),
            ),
        ],
      ),
    );
  }

  Future<void> _play() async {
    final loc = AppLocalizations.of(context)!;
    setState(() {
      _busy = true;
      _message = null;
      _lastResult = null;
    });
    try {
      final prepared = await _service.prepare(widget.serverName, widget.game);
      var plan = prepared.plan;
      final conflict = prepared.conflict;
      if (conflict != null) {
        if (!mounted) return;
        final choice = await _askConflict(conflict);
        if (choice == null || choice == SaveConflictChoice.cancel) return;
        await _service.resolveConflict(widget.serverName, conflict, choice);
      }
      if (plan.detached && mounted) setState(() => _message = loc.gameSteamLaunched);
      final result = await _service.launch(widget.serverName, widget.game, plan);
      if (!mounted) return;
      if (result != null) {
        setState(() => _lastResult = result);
        widget.onPlayed?.call();
      }
    } on LaunchException catch (e) {
      if (mounted) setState(() => _message = _problemText(loc, e));
    } catch (e) {
      if (mounted) setState(() => _message = loc.gameLaunchFailed(e.toString()));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _finish() async {
    setState(() => _busy = true);
    try {
      final result = await _service.finishDetached(widget.serverName, widget.game);
      if (mounted) setState(() => _lastResult = result);
      widget.onPlayed?.call();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _uninstall() async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.gameUninstall),
        content: Text(loc.gameUninstallConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(loc.cancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(loc.gameUninstall)),
        ],
      ),
    );
    if (confirmed != true) return;
    await _service.uninstall(widget.serverName, widget.game.id);
    await _refreshInstall();
  }

  Future<SaveConflictChoice?> _askConflict(SaveConflict conflict) {
    final loc = AppLocalizations.of(context)!;
    return showDialog<SaveConflictChoice>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.gameSaveConflictTitle),
        content: Text(loc.gameSaveConflictBody(
            conflict.serverHead.version, conflict.serverHead.deviceName ?? '?', conflict.serverHead.createdAt?.toLocal().toString() ?? '')),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(SaveConflictChoice.cancel), child: Text(loc.cancel)),
          TextButton(onPressed: () => Navigator.of(context).pop(SaveConflictChoice.keepLocal), child: Text(loc.gameSaveConflictKeepLocal)),
          FilledButton(onPressed: () => Navigator.of(context).pop(SaveConflictChoice.useServer), child: Text(loc.gameSaveConflictUseServer)),
        ],
      ),
    );
  }

  String _problemText(AppLocalizations loc, LaunchException e) {
    switch (e.problem) {
      case LaunchProblem.emulatorMissing:
        return loc.gameEmulatorMissing(e.detail ?? '');
      case LaunchProblem.coreMissing:
        return loc.gameCoreMissing(e.detail ?? '');
      case LaunchProblem.entryMissing:
        return loc.gameEntryMissing;
      case LaunchProblem.steamMissing:
        return loc.gameEmulatorMissing('Steam');
      case LaunchProblem.firmwareMissing:
        return loc.gamePs3FirmwareMissing;
    }
  }
}
