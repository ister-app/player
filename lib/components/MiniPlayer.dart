import 'package:audio_service/audio_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:player/components/PlayPauseButton.dart';
import 'package:player/components/TvFocusable.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

/// The bottom bar shown while media plays and its own page isn't on screen.
/// Handles both music tracks (tap/drag opens the [MusicPlayerRoute] overlay)
/// and video (tap navigates back to the episode/movie page).
class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  double? _dragStartY;
  bool _playerOpened = false;

  @override
  void initState() {
    super.initState();
    MediaPlayerHandler.instance.openMusicPlayerRequest
        .addListener(_onOpenPlayerRequested);
  }

  @override
  void dispose() {
    MediaPlayerHandler.instance.openMusicPlayerRequest
        .removeListener(_onOpenPlayerRequested);
    super.dispose();
  }

  /// Fired when playback of a music track starts from a browse surface — open
  /// the full player directly rather than waiting for a mini-player tap.
  void _onOpenPlayerRequested() {
    if (!mounted) return;
    _openPlayerPage(context);
  }

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

  /// Navigates back to the page that hosts the currently-playing video. Unlike
  /// music, video has no separate full-screen route — the episode/movie page is
  /// the player — so we re-open that page. Playback keeps running; the page's
  /// startPlayQueue detects the same item and just resumes it.
  void _openVideoPage(BuildContext context) {
    final handler = MediaPlayerHandler.instance;
    final playingServer = handler.serverName;
    if (playingServer == null) return;

    PageRouteInfo? route;
    final episode = handler.episode;
    final movie = handler.movie;
    if (episode != null && episode.$show != null) {
      route = ShowOverviewRoute(
        showId: episode.$show!.id,
        children: [
          ShowEpisodeRoute(
            showId: episode.$show!.id,
            episodeId: episode.id,
            playQueueId: handler.playQueue?.id,
          ),
        ],
      );
    } else if (movie != null) {
      route = MovieRoute(
        movieId: movie.id,
        playQueueId: handler.playQueue?.id,
      );
    }
    if (route == null) return;

    // Same multi-server handling as _openAlbumPage: a same-server route inherits
    // :serverName in place, a cross-server one needs the full ServerHomeRoute.
    final currentServer =
        context.routeData.inheritedPathParams.optString('serverName');
    if (currentServer == playingServer) {
      AutoRouter.of(context).navigate(route);
    } else {
      AutoRouter.of(context).root.navigate(
          ServerHomeRoute(serverName: playingServer, children: [route]));
    }
  }

  void _openPlayerPage(BuildContext context, {double initialControllerValue = 0.0}) {
    // Guard against a double tap pushing the player twice; the second copy's
    // dispose would clear the dismiss handler of the first.
    if (MediaPlayerHandler.instance.musicPlayerOpen.value) return;
    MediaPlayerHandler.instance.playerInitialControllerValue = initialControllerValue;
    AutoRouter.of(context).root.push(const MusicPlayerRoute());
  }

  Widget _artPlaceholder(BuildContext context, IconData icon) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(icon,
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
    return ValueListenableBuilder<int>(
      valueListenable: MediaPlayerHandler.instance.videoPageOpen,
      builder: (context, videoPageOpen, _) {
        return StreamBuilder<MediaItem?>(
          stream: MediaPlayerHandler.instance.mediaItem,
          initialData: MediaPlayerHandler.instance.mediaItem.valueOrNull,
          builder: (context, mediaSnapshot) {
            final item = mediaSnapshot.data;
            if (item == null) return const SizedBox.shrink();

            final type = MediaItemId.byStringId(item.id).isterMediaType;
            final isVideo = type == IsterMediaTypes.episode ||
                type == IsterMediaTypes.movie;
            final isTrack = type == IsterMediaTypes.track;
            if (!isVideo && !isTrack) return const SizedBox.shrink();
            // Don't duplicate the player while the video's own page is on screen.
            if (isVideo && videoPageOpen > 0) return const SizedBox.shrink();

            return _buildBar(context, item, isVideo: isVideo);
          },
        );
      },
    );
  }

  Widget _buildBar(BuildContext context, MediaItem item, {required bool isVideo}) {
    final placeholderIcon =
        isVideo ? Icons.movie_outlined : Icons.music_note;
    return Material(
      elevation: 4,
      child: GestureDetector(
        onTap: () =>
            isVideo ? _openVideoPage(context) : _openPlayerPage(context),
        // The drag-to-expand gesture opens the music overlay; video has no such
        // overlay, so it's music-only.
        onVerticalDragStart: isVideo ? null : _onDragStart,
        onVerticalDragUpdate: isVideo ? null : _onDragUpdate,
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
                  TvFocusable(
                    onTap: () => isVideo
                        ? _openVideoPage(context)
                        : _openAlbumPage(context),
                    borderRadius: BorderRadius.circular(4),
                    child: GestureDetector(
                    onTap: () => isVideo
                        ? _openVideoPage(context)
                        : _openAlbumPage(context),
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
                                    _artPlaceholder(context, placeholderIcon),
                              )
                            : _artPlaceholder(context, placeholderIcon),
                      ),
                    ),
                  ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TvFocusable(
                    onTap: () =>
                        isVideo ? _openVideoPage(context) : _openPlayerPage(context),
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
  }
}
