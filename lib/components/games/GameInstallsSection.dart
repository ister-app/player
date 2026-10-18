import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:material_ui/material_ui.dart';
import 'package:player/components/SettingsSection.dart';
import 'package:player/components/TvFocusable.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/AppMessenger.dart';
import 'package:player/utils/games/GameInstallStore.dart';
import 'package:player/utils/games/GameLabels.dart';
import 'package:player/utils/games/GameLibraryService.dart';

import '../../l10n/app_localizations.dart';

/// The games installed (or installing) from one server, for the downloads
/// page: one row per game with its state, a progress bar while it moves, and
/// a menu to pause, resume, cancel, retry, open or remove it.
class GameInstallsSection extends StatelessWidget {
  const GameInstallsSection({
    super.key,
    required this.serverName,
    required this.installs,
    this.inShell = false,
    this.service,
  });

  final String serverName;
  final List<GameInstall> installs;

  /// Inside the server shell the game page is reachable; from the root
  /// router it is not, so "open game" is left out there.
  final bool inShell;
  final GameLibraryService? service;

  /// Bytes the installs occupy, for the page's storage total.
  static int bytesOf(Iterable<GameInstall> installs) => installs.fold(0, (a, i) => a + i.bytesOnDisk);

  @override
  Widget build(BuildContext context) {
    if (installs.isEmpty) return const SizedBox.shrink();
    final loc = AppLocalizations.of(context)!;
    final sorted = [...installs]..sort((a, b) {
        if (a.isActive != b.isActive) return a.isActive ? -1 : 1;
        return (a.title ?? a.gameId).toLowerCase().compareTo((b.title ?? b.gameId).toLowerCase());
      });
    return Column(
      key: const ValueKey('game-installs-section'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionLabel(loc.gameInstallsStorage(GameLabels.bytes(bytesOf(installs)))),
        for (final install in sorted)
          Card(
            clipBehavior: Clip.antiAlias,
            child: _GameInstallTile(
              serverName: serverName,
              install: install,
              inShell: inShell,
              service: service ?? GameLibraryService.instance,
            ),
          ),
      ],
    );
  }
}

class _GameInstallTile extends StatelessWidget {
  const _GameInstallTile({
    required this.serverName,
    required this.install,
    required this.inShell,
    required this.service,
  });

  final String serverName;
  final GameInstall install;
  final bool inShell;
  final GameLibraryService service;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return ValueListenableBuilder<GameInstallProgress?>(
      valueListenable: service.progressOf(install.gameId),
      builder: (context, progress, _) {
        final status = progress?.status ?? install.status;
        final done = progress?.doneBytes ?? install.doneBytes;
        final total = progress?.totalBytes ?? install.totalBytes;
        final platform = GameLabels.platformName(install.platform);
        final state = switch (status) {
          GameInstallStatus.queued => loc.gameInstallQueued(progress?.queuePosition ?? 1),
          GameInstallStatus.downloading => _downloadingLine(loc, progress, done, total),
          GameInstallStatus.extracting => loc.gameInstallStatusUnpacking,
          GameInstallStatus.paused => loc.gameInstallPaused(GameLabels.bytes(done), GameLabels.bytes(total)),
          GameInstallStatus.installed => loc.gameInstallStatusInstalled,
          GameInstallStatus.updateAvailable => loc.gameUpdateAvailable(GameLabels.bytes(install.availableBytes ?? total)),
          GameInstallStatus.failed => GameLabels.installError(loc, progress?.error ?? install.error ?? '?'),
          GameInstallStatus.cancelled => loc.gameInstallStatusCancelled(GameLabels.bytes(done)),
        };
        final active = status == GameInstallStatus.queued ||
            status == GameInstallStatus.downloading ||
            status == GameInstallStatus.extracting;
        final fraction = status == GameInstallStatus.downloading || status == GameInstallStatus.paused
            ? (total > 0 ? (done / total).clamp(0.0, 1.0) : null)
            : null;
        return TvFocusable(
          onTap: inShell ? () => _open(context) : null,
          child: ListTile(
            key: ValueKey('game-install-${install.gameId}'),
            leading: SizedBox(
              width: 48,
              height: 48,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: ColoredBox(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.sports_esports),
                ),
              ),
            ),
            title: Text(install.title ?? install.gameId, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  [platform, if (!active) GameLabels.bytes(install.bytesOnDisk), state].join(' · '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: status == GameInstallStatus.failed ? TextStyle(color: theme.colorScheme.error) : null,
                ),
                if (active || status == GameInstallStatus.paused) ...[
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: status == GameInstallStatus.queued || status == GameInstallStatus.extracting ? null : fraction,
                    minHeight: 3,
                    color: status == GameInstallStatus.paused ? theme.colorScheme.outline : null,
                  ),
                ],
              ],
            ),
            isThreeLine: active || status == GameInstallStatus.paused,
            trailing: MenuAnchor(
              menuChildren: _menu(context, loc, status),
              builder: (context, controller, _) => IconButton(
                key: ValueKey('game-install-menu-${install.gameId}'),
                icon: const Icon(Icons.more_vert),
                onPressed: () => controller.isOpen ? controller.close() : controller.open(),
              ),
            ),
            onTap: inShell ? () => _open(context) : null,
          ),
        );
      },
    );
  }

  String _downloadingLine(AppLocalizations loc, GameInstallProgress? p, int done, int total) {
    final speed = p?.bytesPerSecond;
    final left = p?.remaining;
    return loc.gameDownloadingDetail(
      GameLabels.bytes(done),
      GameLabels.bytes(total),
      p?.filesDone ?? install.filesDone,
      p?.filesTotal ?? install.filesTotal,
      speed == null ? '—' : GameLabels.bytes(speed),
      left == null ? loc.gameTimeLeftUnknown : loc.gameTimeLeft(GameLabels.duration(loc, left)),
    );
  }

  List<Widget> _menu(BuildContext context, AppLocalizations loc, GameInstallStatus status) {
    MenuItemButton item(String key, IconData icon, String label, VoidCallback onPressed) => MenuItemButton(
          key: ValueKey('game-install-$key-${install.gameId}'),
          onPressed: onPressed,
          child: ListTile(leading: Icon(icon), title: Text(label)),
        );
    final id = install.gameId;
    return [
      if (inShell) item('open', Icons.sports_esports_outlined, loc.gameOpenPage, () => _open(context)),
      if (status == GameInstallStatus.queued || status == GameInstallStatus.downloading)
        item('pause', Icons.pause, loc.gameInstallPause, () => service.pause(serverName, id)),
      if (status == GameInstallStatus.paused || status == GameInstallStatus.cancelled)
        item('resume', Icons.play_arrow, loc.gameInstallResume, () => service.resume(serverName, id)),
      if (status == GameInstallStatus.failed)
        item('retry', Icons.refresh, loc.gameInstallRetry, () => service.retry(serverName, id)),
      if (status == GameInstallStatus.updateAvailable && install.form != 'STEAM')
        item('update', Icons.system_update_alt, loc.gameUpdate, () => service.update(serverName, id)),
      if (status == GameInstallStatus.queued || status == GameInstallStatus.downloading)
        item('cancel', Icons.close, loc.cancelDownload, () => service.cancel(serverName, id)),
      item('remove', Icons.delete_outline, status == GameInstallStatus.installed || status == GameInstallStatus.updateAvailable
          ? loc.gameUninstall
          : loc.gameRemovePartial, () => unawaited(_remove(context, loc))),
    ];
  }

  Future<void> _remove(BuildContext context, AppLocalizations loc) async {
    final isSteam = install.form == 'STEAM';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.gameUninstall),
        content: Text(isSteam ? loc.gameUninstallConfirmSteam : loc.gameUninstallConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(loc.cancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(loc.gameUninstall)),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await service.uninstall(serverName, install.gameId);
      showAppSnackBar(loc.gameUninstalled);
    } on StateError {
      showAppSnackBar(loc.gameUninstallWhilePlaying);
    } catch (e) {
      showAppSnackBar(loc.gameUninstallFailed(e.toString()));
    }
  }

  void _open(BuildContext context) => AutoRouter.of(context).push(GameRoute(gameId: install.gameId));
}
