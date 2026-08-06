import 'package:flutter/material.dart';
import 'package:player/components/ListenTogetherSheet.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

/// Watch-together entry point for the video surfaces (movie/episode app bars
/// and the fullscreen video controls): opens the listen-together sheet for the
/// handler's live queue — own playback and watching along both count. Renders
/// nothing unless the current item is a movie/episode that [matches] this
/// surface, so it can sit unconditionally in an AppBar's actions.
///
/// Server and queue are resolved from the handler, never from the browsed
/// route — the playing video can belong to a different server.
class WatchTogetherButton extends StatelessWidget {
  const WatchTogetherButton({super.key, this.matches, this.color});

  /// Restricts the button to the page hosting the playing item (e.g. "this
  /// movie page shows the playing movie"). Null: any current video item.
  final bool Function(MediaPlayerHandler handler)? matches;

  /// Base icon colour, for surfaces with their own chrome (the dark video
  /// overlay). Defaults to the ambient icon colour; while following, an
  /// accent tint marks the active session unless a colour is forced.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final handler = MediaPlayerHandler.instance;
    return ValueListenableBuilder<bool>(
      valueListenable: handler.followModeNotifier,
      builder: (context, following, _) => StreamBuilder<Object?>(
        stream: handler.mediaItem,
        builder: (context, _) {
          final loc = AppLocalizations.of(context)!;
          final serverName = handler.serverName;
          final playQueueId = handler.playQueue?.id;
          if (serverName == null ||
              playQueueId == null ||
              (handler.movie == null && handler.episode == null) ||
              (matches != null && !matches!(handler))) {
            return const SizedBox.shrink();
          }
          return IconButton(
            icon: const Icon(Icons.connected_tv),
            color: color ??
                (following ? Theme.of(context).colorScheme.primary : null),
            tooltip: loc.watchTogetherTitle,
            onPressed: () => showListenTogetherSheet(
              context,
              serverName: serverName,
              playQueueId: playQueueId,
              mediaType: handler.movie != null
                  ? Enum$MediaType.MOVIE
                  : Enum$MediaType.EPISODE,
            ),
          );
        },
      ),
    );
  }
}

/// Small "Watching along" chip for the video surfaces, where the mini player
/// (and thus its follow badge) is hidden. Renders nothing unless following.
class WatchingAlongChip extends StatelessWidget {
  const WatchingAlongChip({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: MediaPlayerHandler.instance.followModeNotifier,
      builder: (context, following, _) {
        if (!following) return const SizedBox.shrink();
        final loc = AppLocalizations.of(context)!;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.connected_tv, color: Colors.white70, size: 14),
              const SizedBox(width: 6),
              Text(loc.watchingBadge,
                  style:
                      const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        );
      },
    );
  }
}
