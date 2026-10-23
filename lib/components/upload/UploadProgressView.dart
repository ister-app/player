import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../../pages/DownloadsPage.dart' show formatBytes;
import '../../utils/upload/UploadRunner.dart';
import '../../utils/upload/UploadThroughput.dart';
import '../SettingsSection.dart';

/// The transfer stage of a single upload: the headline, the bar, the
/// controls and a tile per file. [extras] go between the summary card and
/// the file list (the game look-up card, for one).
class UploadProgressView extends StatelessWidget {
  const UploadProgressView({
    super.key,
    required this.runner,
    required this.throughput,
    required this.onCancel,
    required this.onReset,
    this.extras = const [],
  });

  final UploadRunner runner;
  final UploadThroughput? throughput;
  final VoidCallback onCancel;
  final VoidCallback onReset;
  final List<Widget> extras;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final total = runner.totalBytes;
    final finished = runner.isFinished;
    final done = runner.items.where((i) => !i.isOpen && i.phase != UploadItemPhase.completing).length;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SettingsCard(children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(
                finished
                    ? (runner.failedCount == 0 ? loc.uploadFinished : loc.uploadFinishedWithFailures(runner.failedCount))
                    : loc.uploadProgress(formatBytes(runner.sentBytes), formatBytes(total)),
                key: const ValueKey('upload-progress-label'),
                style: theme.textTheme.titleMedium,
              ),
              if (!finished) ...[
                const SizedBox(height: 4),
                Text(
                  detailLine(loc,
                      totalBytes: total,
                      sentBytes: runner.sentBytes,
                      running: runner.isRunning,
                      throughput: throughput,
                      unitsDone: done,
                      unitsTotal: runner.items.length,
                      units: loc.uploadFilesDone),
                  key: const ValueKey('upload-progress-detail'),
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
              const SizedBox(height: 12),
              LinearProgressIndicator(value: total == 0 ? 1 : runner.sentBytes / total),
              const SizedBox(height: 12),
              OverflowBar(alignment: MainAxisAlignment.end, spacing: 8, children: [
                if (!finished) TextButton(onPressed: onCancel, child: Text(loc.uploadCancelUpload)),
                if (!finished && runner.isRunning && !runner.isPaused)
                  FilledButton.tonal(onPressed: runner.pause, child: Text(loc.pause)),
                if (!finished && !runner.isRunning) FilledButton(onPressed: runner.start, child: Text(loc.uploadResume)),
                if (!runner.isRunning && runner.failedCount > 0)
                  FilledButton.tonal(
                    onPressed: () {
                      runner.retryFailed();
                      runner.start();
                    },
                    child: Text(loc.uploadRetryFailed(runner.failedCount)),
                  ),
                if (finished) FilledButton(onPressed: onReset, child: Text(loc.uploadAnother)),
              ]),
            ]),
          ),
        ]),
        for (final extra in extras) ...[const SizedBox(height: 16), extra],
        const SizedBox(height: 16),
        SettingsCard(children: [for (final item in runner.items) itemTile(loc, theme, item)]),
      ],
    );
  }

  /// "31% · 3 of 11 files done · 74 MB/s · about 4 min left · 2 min so far",
  /// or the percentage and "Paused" while nothing is moving. [units] words
  /// the count (files, or games for a batch).
  static String detailLine(
    AppLocalizations loc, {
    required int totalBytes,
    required int sentBytes,
    required bool running,
    required UploadThroughput? throughput,
    required int unitsDone,
    required int unitsTotal,
    required String Function(int done, int total) units,
  }) {
    final parts = <String>[
      '${totalBytes == 0 ? 100 : (sentBytes * 100 ~/ totalBytes)}%',
      units(unitsDone, unitsTotal),
    ];
    if (!running) {
      parts.add(loc.uploadPaused);
    } else if (throughput != null) {
      final now = DateTime.now();
      final speed = throughput.bytesPerSecond;
      final left = throughput.remaining(totalBytes, sentBytes);
      if (speed != null) parts.add(loc.uploadSpeed(formatBytes(speed.round())));
      parts.add(left == null ? loc.uploadTimeLeftUnknown : loc.uploadTimeLeft(formatDuration(loc, left)));
      final elapsed = throughput.elapsed(now);
      if (elapsed >= const Duration(seconds: 10)) parts.add(loc.uploadElapsed(formatDuration(loc, elapsed)));
    }
    return parts.join(' · ');
  }

  static String formatDuration(AppLocalizations loc, Duration d) {
    if (d.inHours >= 1) return loc.durationHoursMinutes(d.inHours, d.inMinutes % 60);
    if (d.inMinutes >= 1) return loc.durationMinutes(d.inMinutes);
    return loc.durationSeconds(d.inSeconds);
  }

  static Widget itemTile(AppLocalizations loc, ThemeData theme, UploadItem item) {
    final size = item.state.size;
    final subtitle = switch (item.phase) {
      UploadItemPhase.queued => loc.uploadPhaseQueued,
      UploadItemPhase.uploading =>
        '${loc.uploadProgress(formatBytes(item.sentBytes), formatBytes(size))} · ${size == 0 ? 100 : item.sentBytes * 100 ~/ size}%',
      UploadItemPhase.completing => loc.uploadPhaseCompleting,
      UploadItemPhase.done => loc.uploadPhaseDone,
      UploadItemPhase.skipped => loc.uploadPhaseSkipped,
      UploadItemPhase.failed => item.error == null ? loc.uploadPhaseFailed : '${loc.uploadPhaseFailed} · ${item.error}',
    };
    return ListTile(
      dense: true,
      leading: switch (item.phase) {
        UploadItemPhase.done => Icon(Icons.check_circle_outline, color: theme.colorScheme.primary),
        UploadItemPhase.skipped => Icon(Icons.file_present_outlined, color: theme.disabledColor),
        UploadItemPhase.failed => Icon(Icons.error_outline, color: theme.colorScheme.error),
        UploadItemPhase.queued => Icon(Icons.schedule, color: theme.disabledColor),
        _ => SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 3, value: size == 0 ? null : item.sentBytes / size)),
      },
      title: Text(item.state.relativePath, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
    );
  }
}
