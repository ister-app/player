import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:player/graphql/gameById.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/AppMessenger.dart';
import 'package:player/utils/games/GameInstallStore.dart';
import 'package:player/utils/games/GameLabels.dart';
import 'package:player/utils/games/GameLibraryService.dart';
import 'package:player/utils/games/launch/GameLaunchers.dart';
import 'package:player/utils/games/steam/SteamLibraryLocator.dart';

import '../../l10n/app_localizations.dart';
import 'GameSessionSummaryCard.dart';
import 'SaveConflictDialog.dart';
import 'SteamLibraryPicker.dart';

/// The install / play controls of a game on a desktop build: install (queue,
/// progress with speed and time left, pause, cancel), update, play (pull
/// saves → launch → push saves, shown as steps), the "finished playing" step
/// for Steam launches, the session summary, and remove. Problems a user can
/// fix (no emulator, missing core, missing PS3 firmware) are spelled out
/// with a way to the settings.
class GameActionsPanel extends StatefulWidget {
  const GameActionsPanel({
    super.key,
    required this.serverName,
    required this.game,
    this.onPlayed,
    this.service,
  });

  final String serverName;
  final Query$gameById$gameById game;
  final VoidCallback? onPlayed;

  /// Defaults to [GameLibraryService.instance]; tests pass their own.
  final GameLibraryService? service;

  @override
  State<GameActionsPanel> createState() => _GameActionsPanelState();
}

class _GameActionsPanelState extends State<GameActionsPanel> {
  late final GameLibraryService _service = widget.service ?? GameLibraryService.instance;
  GameInstall? _install;
  bool _busy = false;
  String? _message;
  VoidCallback? _messageAction;
  String? _messageActionLabel;

  @override
  void initState() {
    super.initState();
    _service.revision.addListener(_refreshInstall);
    unawaited(_start());
  }

  @override
  void dispose() {
    _service.revision.removeListener(_refreshInstall);
    super.dispose();
  }

  Future<void> _start() async {
    await _service.ensureStarted();
    await _refreshInstall();
    await _adoptLocalCopy();
    await _service.restoreSession(widget.serverName, widget.game);
    await _service.checkForUpdate(widget.serverName, widget.game.id,
        version: widget.game.version, sizeBytes: widget.game.sizeBytes.toInt());
    await _refreshInstall();
  }

  Future<void> _refreshInstall() async {
    final install = await _service.installOf(widget.serverName, widget.game.id);
    if (mounted) setState(() => _install = install);
  }

  /// A game Steam or RPCS3 already has here is taken as installed, no
  /// download involved; "Forget on this device" undoes it.
  Future<void> _adoptLocalCopy() async {
    if (_install != null || !mounted) return;
    final copy = await _service.findLocalCopy(widget.serverName, widget.game);
    if (copy == null || !mounted) return;
    await _service.adopt(widget.serverName, widget.game, copy);
    await _refreshInstall();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final id = widget.game.id;
    return ListenableBuilder(
      listenable: Listenable.merge([
        _service.progressOf(id),
        _service.sessionOf(id),
        _service.phaseOf(id),
        _service.lastResultOf(id),
      ]),
      builder: (context, _) {
        final progress = _service.progressOf(id).value;
        final session = _service.sessionOf(id).value;
        final phase = _service.phaseOf(id).value;
        final result = _service.lastResultOf(id).value;
        final status = progress?.status ?? _install?.status;
        final playing = session != null || phase != GamePlayPhase.idle;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (session?.restored == true) _unsyncedSessionCard(loc, session!),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: playing ? _playingButtons(loc, session, phase) : _installButtons(loc, status, progress),
            ),
            if (playing && session?.restored != true) ...[
              const SizedBox(height: 12),
              _PlaySteps(phase: phase, showAchievements: _hasAchievementSource),
            ],
            if (!playing) ..._installDetail(loc, status, progress),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _notice(
                  _message!,
                  actionLabel: _messageActionLabel,
                  action: _messageAction,
                ),
              ),
            if (result != null) ...[
              const SizedBox(height: 8),
              GameSessionSummaryCard(
                result: result,
                onDismiss: () => _service.dismissResult(id),
                onRetrySync: result.hasErrors && session != null ? () => unawaited(_finish()) : null,
              ),
            ],
          ],
        );
      },
    );
  }

  bool get _hasAchievementSource =>
      widget.game.form == Enum$GameForm.PS3_FOLDER || widget.game.form == Enum$GameForm.STEAM;

  // ---- buttons -----------------------------------------------------------

  List<Widget> _playingButtons(AppLocalizations loc, GameSession? session, GamePlayPhase phase) {
    if (session != null && session.detached && session.restored != true) {
      return [
        FilledButton.icon(
          key: const ValueKey('game-finish-playing'),
          onPressed: _busy ? null : () => unawaited(_finish()),
          icon: const Icon(Icons.stop_circle_outlined),
          label: Text(loc.gameFinishedPlaying),
        ),
      ];
    }
    if (session?.restored == true) return const [];
    return [
      FilledButton.icon(
        key: const ValueKey('game-play'),
        onPressed: null,
        icon: const Icon(Icons.play_arrow),
        label: Text(phase == GamePlayPhase.running ? loc.gameRunning : loc.gamePlay),
      ),
    ];
  }

  List<Widget> _installButtons(AppLocalizations loc, GameInstallStatus? status, GameInstallProgress? progress) {
    final isSteam = widget.game.form == Enum$GameForm.STEAM;
    switch (status) {
      case null:
        return [
          FilledButton.icon(
            key: const ValueKey('game-install'),
            onPressed: _busy ? null : () => unawaited(_installGame()),
            icon: const Icon(Icons.download_outlined),
            label: Text(isSteam ? loc.gameInstallIntoSteam : loc.gameInstall(GameLabels.bytes(widget.game.sizeBytes))),
          ),
        ];
      case GameInstallStatus.queued:
        return [
          OutlinedButton.icon(
            key: const ValueKey('game-cancel-install'),
            onPressed: () => _service.cancel(widget.serverName, widget.game.id),
            icon: const Icon(Icons.close),
            label: Text(loc.cancel),
          ),
        ];
      case GameInstallStatus.downloading:
        return [
          OutlinedButton.icon(
            key: const ValueKey('game-pause-install'),
            onPressed: () => _service.pause(widget.serverName, widget.game.id),
            icon: const Icon(Icons.pause),
            label: Text(loc.gameInstallPause),
          ),
          OutlinedButton.icon(
            key: const ValueKey('game-cancel-install'),
            onPressed: () => _service.cancel(widget.serverName, widget.game.id),
            icon: const Icon(Icons.close),
            label: Text(loc.cancel),
          ),
        ];
      case GameInstallStatus.extracting:
        return [
          OutlinedButton.icon(
            key: const ValueKey('game-cancel-install'),
            onPressed: null,
            icon: const Icon(Icons.close),
            label: Text(loc.cancel),
          ),
        ];
      case GameInstallStatus.paused:
        return [
          FilledButton.icon(
            key: const ValueKey('game-resume-install'),
            onPressed: () => _service.resume(widget.serverName, widget.game.id),
            icon: const Icon(Icons.play_arrow),
            label: Text(loc.gameInstallResume),
          ),
          _removeButton(loc, loc.gameRemovePartial),
        ];
      case GameInstallStatus.failed:
        return [
          FilledButton.icon(
            key: const ValueKey('game-retry-install'),
            onPressed: () => _service.retry(widget.serverName, widget.game.id),
            icon: const Icon(Icons.refresh),
            label: Text(loc.gameInstallRetry),
          ),
          _removeButton(loc, loc.gameRemovePartial),
        ];
      case GameInstallStatus.cancelled:
        return [
          FilledButton.icon(
            key: const ValueKey('game-install'),
            onPressed: _busy ? null : () => unawaited(_installGame()),
            icon: const Icon(Icons.download_outlined),
            label: Text(isSteam ? loc.gameInstallIntoSteam : loc.gameInstall(GameLabels.bytes(widget.game.sizeBytes))),
          ),
          _removeButton(loc, loc.gameRemovePartial),
        ];
      case GameInstallStatus.installed:
      case GameInstallStatus.updateAvailable:
        return [
          FilledButton.icon(
            key: const ValueKey('game-play'),
            onPressed: _busy ? null : () => unawaited(_play()),
            icon: const Icon(Icons.play_arrow),
            label: Text(loc.gamePlay),
          ),
          if (status == GameInstallStatus.updateAvailable)
            FilledButton.tonalIcon(
              key: const ValueKey('game-update'),
              onPressed: isSteam ? null : () => _service.update(widget.serverName, widget.game.id),
              icon: const Icon(Icons.system_update_alt),
              label: Text(loc.gameUpdate),
            ),
          _removeButton(loc, _install?.isAdopted == true ? loc.gameForgetCopy : loc.gameUninstall),
        ];
    }
  }

  Widget _removeButton(AppLocalizations loc, String label) => TextButton.icon(
        key: const ValueKey('game-uninstall'),
        onPressed: _busy ? null : () => unawaited(_uninstall()),
        icon: const Icon(Icons.delete_outline),
        label: Text(label),
      );

  // ---- detail lines ------------------------------------------------------

  List<Widget> _installDetail(AppLocalizations loc, GameInstallStatus? status, GameInstallProgress? progress) {
    final theme = Theme.of(context);
    final small = theme.textTheme.bodySmall;
    final adopted = _install?.adoptedFrom;
    if (adopted != null && (status == GameInstallStatus.installed || status == GameInstallStatus.updateAvailable)) {
      final isSteam = widget.game.form == Enum$GameForm.STEAM;
      return [
        const SizedBox(height: 8),
        Text(
          key: const ValueKey('game-adopted'),
          isSteam ? loc.gameAdoptedSteam(adopted) : loc.gameAdoptedRpcs3(adopted),
          style: small,
        ),
        if (status == GameInstallStatus.updateAvailable) Text(loc.gameAdoptedUpdateHint, style: small),
      ];
    }
    switch (status) {
      case GameInstallStatus.queued:
        return [
          const SizedBox(height: 12),
          const LinearProgressIndicator(),
          const SizedBox(height: 4),
          Text(loc.gameInstallQueued(progress?.queuePosition ?? 1), style: small),
        ];
      case GameInstallStatus.downloading:
        final p = progress;
        final speed = p?.bytesPerSecond;
        final left = p?.remaining;
        return [
          const SizedBox(height: 12),
          LinearProgressIndicator(value: p?.fraction),
          const SizedBox(height: 4),
          Text(
            key: const ValueKey('game-install-progress'),
            p == null
                ? loc.gameTimeLeftUnknown
                : loc.gameDownloadingDetail(
                    GameLabels.bytes(p.doneBytes),
                    GameLabels.bytes(p.totalBytes),
                    p.filesDone,
                    p.filesTotal,
                    speed == null ? '—' : GameLabels.bytes(speed),
                    left == null ? loc.gameTimeLeftUnknown : loc.gameTimeLeft(GameLabels.duration(loc, left)),
                  ),
            style: small,
          ),
        ];
      case GameInstallStatus.extracting:
        return [
          const SizedBox(height: 12),
          const LinearProgressIndicator(),
          const SizedBox(height: 4),
          Text(loc.gameExtractingNoCancel, style: small),
        ];
      case GameInstallStatus.paused:
        final p = progress;
        return [
          const SizedBox(height: 12),
          LinearProgressIndicator(value: p?.fraction, color: theme.colorScheme.outline),
          const SizedBox(height: 4),
          Text(loc.gameInstallPaused(GameLabels.bytes(p?.doneBytes ?? 0), GameLabels.bytes(p?.totalBytes ?? 0)),
              style: small),
        ];
      case GameInstallStatus.failed:
        final error = progress?.error ?? _install?.error;
        return [
          const SizedBox(height: 8),
          Text(
            key: const ValueKey('game-install-error'),
            error == null ? loc.gameInstallFailed('?') : GameLabels.installError(loc, error),
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ];
      case GameInstallStatus.cancelled:
        return [
          const SizedBox(height: 8),
          Text(loc.gameInstallCancelled, style: small),
        ];
      case GameInstallStatus.updateAvailable:
        final bytes = _install?.availableBytes;
        return [
          const SizedBox(height: 8),
          Text(
            widget.game.form == Enum$GameForm.STEAM
                ? loc.gameUpdateSteam
                : loc.gameUpdateAvailable(GameLabels.bytes(bytes ?? widget.game.sizeBytes)),
            style: small,
          ),
        ];
      case GameInstallStatus.installed:
      case null:
        return const [];
    }
  }

  Widget _unsyncedSessionCard(AppLocalizations loc, GameSession session) {
    return Card(
      key: const ValueKey('game-session-unsynced'),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.gameSessionUnsynced(GameLabels.dateTime(session.startedAt))),
            OverflowBar(
              alignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  key: const ValueKey('game-session-discard'),
                  onPressed: _busy ? null : () => unawaited(_discardSession()),
                  child: Text(loc.gameSessionDiscard),
                ),
                FilledButton.tonal(
                  key: const ValueKey('game-session-sync'),
                  onPressed: _busy ? null : () => unawaited(_finish()),
                  child: Text(loc.gameSessionSyncNow),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _notice(String text, {String? actionLabel, VoidCallback? action}) {
    final theme = Theme.of(context);
    return Container(
      key: const ValueKey('game-message'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
          if (action != null && actionLabel != null)
            TextButton(key: const ValueKey('game-message-action'), onPressed: action, child: Text(actionLabel)),
        ],
      ),
    );
  }

  void _say(String? message, {String? actionLabel, VoidCallback? action}) {
    if (!mounted) return;
    setState(() {
      _message = message;
      _messageActionLabel = actionLabel;
      _messageAction = action;
    });
  }

  // ---- actions -----------------------------------------------------------

  Future<void> _installGame() async {
    final loc = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    _say(null);
    try {
      SteamLibrary? library;
      if (widget.game.form == Enum$GameForm.STEAM) {
        library = await _pickSteamLibrary();
        if (library == null) return;
      }
      await _service.install(widget.serverName, widget.game, steamLibrary: library);
      await _refreshInstall();
      if (widget.game.form == Enum$GameForm.STEAM) _say(loc.gameSteamRestartHint);
    } catch (e) {
      _say(GameLabels.installError(loc, e));
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
    return SteamLibraryPicker.show(context, libraries);
  }

  Future<void> _play() async {
    final loc = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    _say(null);
    _service.dismissResult(widget.game.id);
    try {
      final prepared = await _service.prepare(widget.serverName, widget.game);
      final plan = prepared.plan;
      final conflict = prepared.conflict;
      if (conflict != null) {
        if (!mounted) return;
        final choice = await SaveConflictDialog.show(context, conflict);
        await _service.resolveConflict(widget.serverName, conflict, choice);
        if (choice == SaveConflictChoice.cancel) return;
      }
      if (plan.detached) _say(loc.gameSteamLaunched);
      final result = await _service.launch(widget.serverName, widget.game, plan);
      if (!mounted) return;
      if (result != null) _announce(loc, result);
    } on LaunchException catch (e) {
      _service.abandonLaunch(widget.game.id);
      _problem(loc, e);
    } catch (e) {
      _service.abandonLaunch(widget.game.id);
      _say(loc.gameLaunchFailed(e.toString()));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _finish() async {
    final loc = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    try {
      final result = await _service.finishDetached(widget.serverName, widget.game);
      if (mounted) _announce(loc, result);
    } catch (e) {
      _say(loc.gameLaunchFailed(e.toString()));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _announce(AppLocalizations loc, GameSessionResult result) {
    widget.onPlayed?.call();
    if (result.hasErrors) return;
    final time = GameLabels.playTime(loc, result.duration.inMilliseconds);
    final save = result.uploadedSave;
    showAppSnackBar(save == null ? loc.gameSessionDoneSnack(time) : loc.gameSessionDoneSnackSaved(time, save.version));
  }

  Future<void> _discardSession() async {
    setState(() => _busy = true);
    try {
      await _service.discardSession(widget.serverName, widget.game.id);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _uninstall() async {
    final loc = AppLocalizations.of(context)!;
    final isSteam = widget.game.form == Enum$GameForm.STEAM;
    final adopted = _install?.isAdopted == true;
    final title = adopted ? loc.gameForgetCopy : loc.gameUninstall;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(adopted
            ? loc.gameForgetCopyConfirm
            : isSteam
                ? loc.gameUninstallConfirmSteam
                : loc.gameUninstallConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(loc.cancel)),
          FilledButton(
              key: const ValueKey('game-uninstall-confirm'),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(title)),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _busy = true);
    try {
      await _service.uninstall(widget.serverName, widget.game.id);
      await _refreshInstall();
      showAppSnackBar(loc.gameUninstalled);
    } on StateError {
      _say(loc.gameUninstallWhilePlaying);
    } catch (e) {
      showAppSnackBar(loc.gameUninstallFailed(e.toString()));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _problem(AppLocalizations loc, LaunchException e) {
    void openSettings() => AutoRouter.of(context).push(GameSettingsRoute());
    switch (e.problem) {
      case LaunchProblem.emulatorMissing:
        _say(loc.gameEmulatorMissing(e.detail ?? ''), actionLabel: loc.gameOpenSettings, action: openSettings);
      case LaunchProblem.steamMissing:
        _say(loc.gameEmulatorMissing('Steam'), actionLabel: loc.gameOpenSettings, action: openSettings);
      case LaunchProblem.coreMissing:
        _say(loc.gameCoreMissing(e.detail ?? ''));
      case LaunchProblem.entryMissing:
        _say(loc.gameEntryMissing);
      case LaunchProblem.firmwareMissing:
        _say(loc.gamePs3FirmwareMissing);
    }
  }
}

/// The play loop as a row of steps: saves down → start → playing → save up →
/// achievements → done, with the current one spinning.
class _PlaySteps extends StatelessWidget {
  const _PlaySteps({required this.phase, required this.showAchievements});

  final GamePlayPhase phase;
  final bool showAchievements;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final steps = <(GamePlayPhase, String)>[
      (GamePlayPhase.preparingSaves, loc.gamePhasePreparingSaves),
      (GamePlayPhase.launching, loc.gamePhaseLaunching),
      (GamePlayPhase.running, loc.gamePhaseRunning),
      (GamePlayPhase.uploadingSaves, loc.gamePhaseUploadingSaves),
      if (showAchievements) (GamePlayPhase.readingAchievements, loc.gamePhaseReadingAchievements),
      (GamePlayPhase.recording, loc.gamePhaseRecording),
    ];
    final current = steps.indexWhere((s) => s.$1 == phase);
    return Wrap(
      key: const ValueKey('game-play-steps'),
      spacing: 12,
      runSpacing: 6,
      children: [
        for (var i = 0; i < steps.length; i++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (i < current)
                Icon(Icons.check_circle, size: 16, color: theme.colorScheme.primary)
              else if (i == current)
                const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              else
                Icon(Icons.circle_outlined, size: 16, color: theme.colorScheme.outline),
              const SizedBox(width: 4),
              Text(
                steps[i].$2,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: i > current ? theme.colorScheme.outline : null,
                  fontWeight: i == current ? FontWeight.w600 : null,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
