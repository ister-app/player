import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:player/components/IsterPlayer.dart';
import 'package:player/components/PlayPauseButton.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/components/TvFocusable.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/VideoSurfaceNavigator.dart';

/// The bottom bar shown while media plays and its own page isn't on screen.
/// Handles both music tracks (tap/drag opens the [MusicPlayerRoute] overlay)
/// and video (tap navigates back to the episode/movie page).
class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  /// Height of the bar body; the swipe-down gesture measures against it.
  static const double _barHeight = 66;

  double? _dragStartY;
  bool _playerOpened = false;

  /// Pixels the bar is currently dragged down; past the threshold the release
  /// ends playback (the bar then disappears on the null mediaItem).
  double _dragDown = 0;

  /// True while the bar animates back after an aborted swipe-down; during the
  /// drag itself the translation follows the finger without animation.
  bool _snapBack = false;

  @override
  void initState() {
    super.initState();
    MediaPlayerHandler.instance.openMusicPlayerRequest
        .addListener(_onOpenPlayerRequested);
    MediaPlayerHandler.instance.openVideoPageRequest
        .addListener(_onOpenVideoPageRequested);
    MediaPlayerHandler.instance.closePlaybackRequest
        .addListener(_onPlaybackClosed);
  }

  @override
  void dispose() {
    MediaPlayerHandler.instance.openMusicPlayerRequest
        .removeListener(_onOpenPlayerRequested);
    MediaPlayerHandler.instance.openVideoPageRequest
        .removeListener(_onOpenVideoPageRequested);
    MediaPlayerHandler.instance.closePlaybackRequest
        .removeListener(_onPlaybackClosed);
    super.dispose();
  }

  /// Fired when playback of a music track starts from a browse surface — open
  /// the full player directly rather than waiting for a mini-player tap.
  void _onOpenPlayerRequested() {
    if (!mounted) return;
    _openPlayerPage(context);
  }

  /// Fired when follow mode needs the current video item's page on screen
  /// (watch-along join, or the leader switching to a movie/episode).
  void _onOpenVideoPageRequested() {
    if (!mounted) return;
    // A music overlay on top would hide the video page (e.g. the session just
    // switched from a track to an episode) — slide it away first.
    if (MediaPlayerHandler.instance.musicPlayerOpen.value) {
      PlayerView.activeBackHandler?.call();
    }
    openCurrentVideoPage(context);
  }

  /// Fired when playback was torn down on this device (the watch-along leader
  /// stopped, or the queue was handed off). The bar itself disappears on the
  /// null mediaItem; what remains is closing the surfaces that were opened for
  /// the media — the music overlay and the video page.
  void _onPlaybackClosed() => unawaited(_closePlaybackSurfaces());

  Future<void> _closePlaybackSurfaces() async {
    if (!mounted) return;
    if (MediaPlayerHandler.instance.musicPlayerOpen.value) {
      PlayerView.activeBackHandler?.call();
    }
    // Fullscreen first: its route sits on the root navigator, above the video
    // page we are about to close.
    await IsterPlayer.activeFullscreenExitHandler?.call();
    if (!mounted) return;
    closeCurrentVideoPage(context);
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

  void _openVideoPage(BuildContext context) => openCurrentVideoPage(context);

  void _openPlayerPage(BuildContext context,
      {double initialControllerValue = 0.0}) {
    // Guard against a double tap pushing the player twice; the second copy's
    // dispose would clear the dismiss handler of the first.
    if (MediaPlayerHandler.instance.musicPlayerOpen.value) return;
    MediaPlayerHandler.instance.playerInitialControllerValue =
        initialControllerValue;
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
    _snapBack = false;
  }

  void _onDragUpdate(DragUpdateDetails details, {required bool isVideo}) {
    if (_playerOpened || _dragStartY == null) return;
    final draggedUp = _dragStartY! - details.globalPosition.dy;
    // Upward opens the music overlay; video has no such overlay.
    if (draggedUp > 12 && !isVideo && _dragDown == 0) {
      _playerOpened = true;
      final screenHeight = MediaQuery.of(context).size.height;
      final initialValue = (draggedUp / screenHeight).clamp(0.0, 0.4);
      _openPlayerPage(context, initialControllerValue: initialValue);
      return;
    }
    // Downward slides the bar along with the finger towards stopping.
    final draggedDown = -draggedUp;
    if (draggedDown > 0 || _dragDown > 0) {
      setState(() {
        _snapBack = false;
        _dragDown = draggedDown.clamp(0.0, _barHeight * 1.5);
      });
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_playerOpened || _dragDown == 0) return;
    final velocity = details.primaryVelocity ?? 0;
    // Same feel as dismissing the full player: past ~40% of the travel, or a
    // downward fling, ends playback; anything less springs back into place.
    if (_dragDown > _barHeight * 0.4 || velocity > 600) {
      unawaited(MediaPlayerHandler.instance.stopPlayback());
      // The bar vanishes on the null mediaItem; reset so the bar of a future
      // session starts in place instead of half-slid.
      setState(() {
        _dragDown = 0;
        _snapBack = false;
      });
    } else {
      setState(() {
        _snapBack = true;
        _dragDown = 0;
      });
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

  Widget _buildBar(BuildContext context, MediaItem item,
      {required bool isVideo}) {
    final placeholderIcon = isVideo ? Icons.movie_outlined : Icons.music_note;
    return AnimatedSlide(
      offset: Offset(0, _dragDown / _barHeight),
      duration: _snapBack ? const Duration(milliseconds: 150) : Duration.zero,
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: (1 - _dragDown / (_barHeight * 1.5)).clamp(0.0, 1.0),
        duration: _snapBack ? const Duration(milliseconds: 150) : Duration.zero,
        child: Material(
          elevation: 4,
          child: GestureDetector(
            onTap: () =>
                isVideo ? _openVideoPage(context) : _openPlayerPage(context),
            // Up opens the music overlay (music only — video has no overlay);
            // down slides the bar away and stops playback.
            onVerticalDragStart: _onDragStart,
            onVerticalDragUpdate: (d) => _onDragUpdate(d, isVideo: isVideo),
            onVerticalDragEnd: _onDragEnd,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<Duration>(
                  stream: MediaPlayerHandler.instance.positionSecondsStream,
                  initialData:
                      MediaPlayerHandler.instance.player.state.position,
                  builder: (context, posSnapshot) {
                    return StreamBuilder<Duration>(
                      stream:
                          MediaPlayerHandler.instance.player.stream.duration,
                      initialData:
                          MediaPlayerHandler.instance.player.state.duration,
                      builder: (context, durSnapshot) {
                        final position = posSnapshot.data ?? Duration.zero;
                        final duration = durSnapshot.data ?? Duration.zero;
                        final progress = duration.inMilliseconds > 0
                            ? (position.inMilliseconds /
                                    duration.inMilliseconds)
                                .clamp(0.0, 1.0)
                            : 0.0;
                        return LinearProgressIndicator(
                          value: progress,
                          minHeight: 2,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).colorScheme.primary),
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
                                          _artPlaceholder(
                                              context, placeholderIcon),
                                    )
                                  : _artPlaceholder(context, placeholderIcon),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TvFocusable(
                          onTap: () => isVideo
                              ? _openVideoPage(context)
                              : _openPlayerPage(context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // "Listening along": this device follows another
                                  // device's session (see MediaPlayerHandler).
                                  ValueListenableBuilder<bool>(
                                    valueListenable: MediaPlayerHandler
                                        .instance.followModeNotifier,
                                    builder: (context, following, _) =>
                                        following
                                            ? const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 4),
                                                child: Icon(Icons.headphones,
                                                    size: 14),
                                              )
                                            : const SizedBox.shrink(),
                                  ),
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
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
                        onPressed: () =>
                            MediaPlayerHandler.instance.skipToNext(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
