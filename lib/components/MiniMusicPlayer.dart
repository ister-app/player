import 'package:audio_service/audio_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:player/components/PlayPauseButton.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

class MiniMusicPlayer extends StatefulWidget {
  const MiniMusicPlayer({super.key});

  @override
  State<MiniMusicPlayer> createState() => _MiniMusicPlayerState();
}

class _MiniMusicPlayerState extends State<MiniMusicPlayer> {
  double? _dragStartY;
  bool _playerOpened = false;

  void _openAlbumPage(BuildContext context) {
    final handler = MediaPlayerHandler.instance;
    final album = handler.album;
    final playingServer = handler.serverName;
    if (album == null || playingServer == null) return;
    // The music can come from a different server than the one currently being
    // browsed; AlbumRoute inherits :serverName from the route tree, so only a
    // same-server album may be pushed in place.
    final currentServer =
        context.routeData.inheritedPathParams.optString('serverName');
    if (currentServer == playingServer) {
      AutoRouter.of(context).push(AlbumRoute(albumId: album.id));
    } else {
      AutoRouter.of(context).root.navigate(ServerHomeRoute(
          serverName: playingServer,
          children: [AlbumRoute(albumId: album.id)]));
    }
  }

  void _openPlayerPage(BuildContext context, {double initialControllerValue = 0.0}) {
    // Guard against a double tap pushing the player twice; the second copy's
    // dispose would clear the dismiss handler of the first.
    if (MediaPlayerHandler.instance.musicPlayerOpen.value) return;
    MediaPlayerHandler.instance.playerInitialControllerValue = initialControllerValue;
    AutoRouter.of(context).root.push(const MusicPlayerRoute());
  }

  Widget _artPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(Icons.music_note,
          size: 28, color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }

  void _onDragStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
    _playerOpened = false;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_playerOpened || _dragStartY == null) return;
    final draggedUp = _dragStartY! - details.globalPosition.dy;
    if (draggedUp > 12) {
      _playerOpened = true;
      final screenHeight = MediaQuery.of(context).size.height;
      final initialValue = (draggedUp / screenHeight).clamp(0.0, 0.4);
      _openPlayerPage(context, initialControllerValue: initialValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: MediaPlayerHandler.instance.mediaItem,
      initialData: MediaPlayerHandler.instance.mediaItem.valueOrNull,
      builder: (context, mediaSnapshot) {
        final item = mediaSnapshot.data;
        if (item == null) return const SizedBox.shrink();

        final id = MediaItemId.byStringId(item.id);
        if (id.isterMediaType != IsterMediaTypes.track) return const SizedBox.shrink();

        return Material(
              elevation: 4,
              child: GestureDetector(
                onTap: () => _openPlayerPage(context),
                onVerticalDragStart: _onDragStart,
                onVerticalDragUpdate: _onDragUpdate,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StreamBuilder<Duration>(
                      stream: MediaPlayerHandler.instance.positionSecondsStream,
                      initialData: MediaPlayerHandler.instance.player.state.position,
                      builder: (context, posSnapshot) {
                        return StreamBuilder<Duration>(
                          stream: MediaPlayerHandler.instance.player.stream.duration,
                          initialData: MediaPlayerHandler.instance.player.state.duration,
                          builder: (context, durSnapshot) {
                            final position = posSnapshot.data ?? Duration.zero;
                            final duration = durSnapshot.data ?? Duration.zero;
                            final progress = duration.inMilliseconds > 0
                                ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
                                : 0.0;
                            return LinearProgressIndicator(
                              value: progress,
                              minHeight: 2,
                              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
                            );
                          },
                        );
                      },
                    ),
                    Container(
                      height: 64,
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => _openAlbumPage(context),
                            behavior: HitTestBehavior.opaque,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: SizedBox(
                                width: 44,
                                height: 44,
                                child: item.artUri != null
                                    ? CachedNetworkImage(
                                        imageUrl: item.artUri.toString(),
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            _artPlaceholder(context),
                                      )
                                    : _artPlaceholder(context),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                if (item.artist != null)
                                  Text(
                                    item.artist!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                              ],
                            ),
                          ),
                          const PlayPauseButton(iconSize: 32),
                          IconButton(
                            icon: const Icon(Icons.skip_next),
                            iconSize: 32,
                            onPressed: () => MediaPlayerHandler.instance.skipToNext(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
      },
    );
  }
}
