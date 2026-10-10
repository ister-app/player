import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/PlatformService.dart';
import '../utils/QueueEnd.dart';
import 'TvFocusable.dart';

/// The ended state of the full music player, in the banner slot above the
/// artwork: the queue played out — play it again, close the player, and
/// (when [suggestions] is given) what could follow it.
class QueueEndedBanner extends StatelessWidget {
  const QueueEndedBanner({
    super.key,
    required this.info,
    required this.onPlayAgain,
    required this.onDismiss,
    this.suggestions,
  });

  static const Key bannerKey = Key('queue-ended-banner');
  static const Key playAgainKey = Key('queue-ended-play-again');
  static const Key dismissKey = Key('queue-ended-dismiss');

  final QueueEndedInfo info;
  final VoidCallback onPlayAgain;
  final VoidCallback onDismiss;

  /// What to play next, rendered under the actions; null or collapsed when
  /// there is nothing to suggest.
  final Widget? suggestions;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final tv = PlatformService.isTvModeSync;
    return Container(
      key: bannerKey,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(loc.queueEndedTitle,
                    style: const TextStyle(color: Colors.white, fontSize: 13)),
              ),
              TvFocusable(
                onTap: onPlayAgain,
                autofocus: tv,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: FilledButton.tonalIcon(
                  key: playAgainKey,
                  onPressed: onPlayAgain,
                  icon: const Icon(Icons.replay, size: 18),
                  label: Text(loc.playAgain),
                ),
              ),
              const SizedBox(width: 4),
              TvFocusable(
                onTap: onDismiss,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: IconButton(
                  key: dismissKey,
                  onPressed: onDismiss,
                  tooltip: loc.close,
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          ),
          ?suggestions,
        ],
      ),
    );
  }
}
