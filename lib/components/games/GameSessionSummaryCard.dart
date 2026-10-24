import 'package:material_ui/material_ui.dart';
import 'package:player/utils/games/GameLabels.dart';
import 'package:player/utils/games/GameLibraryService.dart';

import '../../l10n/app_localizations.dart';

/// What the last play session did: how long, which save version went up,
/// which achievements were new — and the errors, with a way to run the sync
/// again. Stays until dismissed, so leaving the page does not lose it.
class GameSessionSummaryCard extends StatelessWidget {
  const GameSessionSummaryCard({
    super.key,
    required this.result,
    required this.onDismiss,
    this.onRetrySync,
  });

  final GameSessionResult result;
  final VoidCallback onDismiss;

  /// Offered when the session is still open because a server step failed.
  final VoidCallback? onRetrySync;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Card(
      key: const ValueKey('game-session-summary'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(loc.gameSessionSummary, style: theme.textTheme.titleSmall)),
                IconButton(
                  key: const ValueKey('game-session-summary-dismiss'),
                  icon: const Icon(Icons.close),
                  tooltip: loc.close,
                  onPressed: onDismiss,
                ),
              ],
            ),
            Text(loc.gameSessionLength(GameLabels.playTime(loc, result.duration.inMilliseconds))),
            if (result.uploadedSave != null) Text(loc.gameSaveUploaded(result.uploadedSave!.version)),
            if (result.saveUnchanged) Text(loc.gameSaveUnchanged),
            if (result.noSaveFound) Text(loc.gameSaveNotFound),
            if (result.newAchievements.isNotEmpty) ...[
              Text(loc.gameNewAchievements(result.newAchievements.length)),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final a in result.newAchievements)
                    Chip(avatar: const Icon(Icons.emoji_events_outlined, size: 16), label: Text(a.name)),
                ],
              ),
            ],
            if (result.hasErrors) ...[
              const SizedBox(height: 6),
              for (final error in result.errors)
                Text(error, style: TextStyle(color: theme.colorScheme.error)),
              if (onRetrySync != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    key: const ValueKey('game-session-retry-sync'),
                    onPressed: onRetrySync,
                    icon: const Icon(Icons.sync),
                    label: Text(loc.gameSessionRetrySync),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
