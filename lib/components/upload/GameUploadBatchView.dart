import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../../pages/DownloadsPage.dart' show formatBytes;
import '../../utils/games/GameLabels.dart';
import '../../utils/upload/UploadThroughput.dart';
import '../../utils/upload/games/GameUploadBatch.dart';
import '../SettingsSection.dart';
import 'GameFoundTile.dart';
import 'UploadProgressView.dart';

/// The transfer stage of a game batch: one bar over all games, the game in
/// flight, a tile per game with its outcome, and after the batch which of
/// them the library lists.
class GameUploadBatchView extends StatelessWidget {
  const GameUploadBatchView({
    super.key,
    required this.batch,
    required this.throughput,
    required this.onCancel,
    required this.onReset,
    required this.onOpenGame,
  });

  final GameUploadBatch batch;
  final UploadThroughput? throughput;
  final VoidCallback onCancel;
  final VoidCallback onReset;
  final ValueChanged<String> onOpenGame;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final finished = batch.isFinished;
    final total = batch.totalBytes;
    final count = batch.items.length + batch.doneBefore.length;
    final rest = <String>[
      if (batch.skippedCount > 0) loc.uploadGamesSkippedN(batch.skippedCount),
      if (batch.failedCount > 0) loc.uploadGamesFailedN(batch.failedCount),
    ];
    final found = batch.items.where((i) => i.found != null).length;
    final uploaded = batch.items.where((i) => i.phase == GameUploadPhase.done).length;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SettingsCard(children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(
                finished
                    ? loc.uploadGamesBatchFinished(batch.doneCount, rest.isEmpty ? '' : ', ${rest.join(', ')}')
                    : loc.uploadGamesBatchProgress(batch.doneCount, count),
                key: const ValueKey('upload-batch-label'),
                style: theme.textTheme.titleMedium,
              ),
              if (!finished) ...[
                const SizedBox(height: 4),
                Text(
                  _detail(loc),
                  key: const ValueKey('upload-batch-detail'),
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
              const SizedBox(height: 12),
              LinearProgressIndicator(value: total == 0 ? (finished ? 1 : null) : batch.sentBytes / total),
              const SizedBox(height: 12),
              OverflowBar(alignment: MainAxisAlignment.end, spacing: 8, children: [
                if (!finished) TextButton(key: const ValueKey('upload-batch-cancel'), onPressed: onCancel, child: Text(loc.uploadCancelUpload)),
                if (!finished && batch.isRunning && !batch.isPaused)
                  FilledButton.tonal(onPressed: batch.pause, child: Text(loc.pause)),
                if (!finished && batch.isPaused) FilledButton(onPressed: batch.resume, child: Text(loc.uploadResume)),
                if (!batch.isRunning && batch.failedCount > 0)
                  FilledButton.tonal(
                    key: const ValueKey('upload-batch-retry'),
                    onPressed: batch.retryFailed,
                    child: Text(loc.uploadRetryFailed(batch.failedCount)),
                  ),
                if (finished) FilledButton(key: const ValueKey('upload-batch-more'), onPressed: onReset, child: Text(loc.uploadGamesUploadMore)),
              ]),
            ]),
          ),
        ]),
        if (finished && uploaded > 0) ...[
          const SizedBox(height: 16),
          SettingsCard(children: [
            ListTile(
              key: const ValueKey('upload-batch-found'),
              leading: batch.isProbing
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(found == uploaded ? Icons.check_circle_outline : Icons.hourglass_bottom,
                      color: found == uploaded ? theme.colorScheme.primary : null),
              title: Text(batch.isProbing && found == 0 ? loc.uploadGamesLookingUp : loc.uploadGamesFoundCount(found, uploaded)),
            ),
          ]),
        ],
        const SizedBox(height: 16),
        SettingsCard(children: [
          for (final title in batch.doneBefore)
            ListTile(
              dense: true,
              leading: Icon(Icons.check_circle_outline, color: theme.colorScheme.primary),
              title: Text(title),
              subtitle: Text(loc.uploadGamesPhaseDone),
            ),
          for (final item in batch.items) _itemTile(loc, theme, item),
        ]),
      ],
    );
  }

  String _detail(AppLocalizations loc) {
    final current = batch.current;
    final line = UploadProgressView.detailLine(loc,
        totalBytes: batch.totalBytes,
        sentBytes: batch.sentBytes,
        running: batch.isRunning && !batch.isPaused,
        throughput: throughput,
        unitsDone: batch.doneCount,
        unitsTotal: batch.items.length + batch.doneBefore.length,
        units: loc.uploadGamesBatchProgress);
    return current == null ? line : '${current.candidate.rootName} · $line';
  }

  Widget _itemTile(AppLocalizations loc, ThemeData theme, GameUploadItem item) {
    final candidate = item.candidate;
    final found = item.found;
    if (item.phase == GameUploadPhase.done && found != null) {
      return GameFoundTile(key: ValueKey('upload-batch-item-${candidate.id}'), found: found, dense: true, onOpen: () => onOpenGame(found.id));
    }
    final runner = item.runner;
    final size = item.totalBytes;
    final subtitle = switch (item.phase) {
      GameUploadPhase.queued => loc.uploadGamesPhaseQueued,
      GameUploadPhase.preparing => item.message == null ? loc.uploadGamesPhasePreparing : loc.uploadGamesWaitingServer,
      GameUploadPhase.uploading => runner == null
          ? ''
          : '${loc.uploadProgress(formatBytes(runner.sentBytes), formatBytes(size))} · ${size == 0 ? 100 : runner.sentBytes * 100 ~/ size}%',
      GameUploadPhase.done => batch.isFinished && !batch.isProbing ? loc.uploadGamesNotListed : loc.uploadGamesPhaseDone,
      GameUploadPhase.skipped => item.message == null ? loc.uploadGamesPhaseSkipped : '${loc.uploadGamesPhaseSkipped} · ${item.message}',
      GameUploadPhase.failed => item.message == null ? loc.uploadGamesPhaseFailed : '${loc.uploadGamesPhaseFailed} · ${item.message}',
      GameUploadPhase.cancelled => loc.uploadGamesPhaseCancelled,
    };
    return ListTile(
      key: ValueKey('upload-batch-item-${candidate.id}'),
      dense: true,
      leading: switch (item.phase) {
        GameUploadPhase.done => Icon(Icons.check_circle_outline, color: theme.colorScheme.primary),
        GameUploadPhase.skipped => Icon(Icons.file_present_outlined, color: theme.disabledColor),
        GameUploadPhase.failed => Icon(Icons.error_outline, color: theme.colorScheme.error),
        GameUploadPhase.cancelled => Icon(Icons.block, color: theme.disabledColor),
        GameUploadPhase.queued => Icon(Icons.schedule, color: theme.disabledColor),
        _ => SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 3, value: runner == null || size == 0 ? null : runner.sentBytes / size)),
      },
      title: Text('${candidate.platformFolder}/${candidate.rootName}', maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text('${GameLabels.platform(candidate.platform)} · $subtitle', maxLines: 2, overflow: TextOverflow.ellipsis),
    );
  }
}
