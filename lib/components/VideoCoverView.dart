import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import 'ArtworkImage.dart';
import '../graphql/fragmentImages.graphql.dart';
import '../l10n/app_localizations.dart';
import '../utils/ImageTypes.dart';
import '../utils/ImageUtil.dart';
import '../utils/MediaPlayerHandler.dart';
import '../utils/PlatformService.dart';
import '../utils/StreamTokenService.dart';
import '../utils/VideoLoadState.dart';
import 'TvFocusable.dart';
import 'video_controls/VideoControlButtons.dart';

/// The artwork a video surface shows when it is not (yet) playing: on the
/// episode/movie page before the user hits play (with [onPlay] set), and
/// under [VideoLoadingOverlay] while a freshly opened stream is still loading
/// — the server may still be transcoding the first HLS segment, and until
/// then the texture is black or holds the previous item's frame.
///
/// The art comes from [image] (the page's own background artwork, with its
/// blurhash) or, on surfaces that only have the handler's queue metadata,
/// from [artUri] (which is a `file:` URI for downloaded items).
class VideoCoverView extends StatelessWidget {
  const VideoCoverView({
    super.key,
    this.image,
    this.artUri,
    required this.serverName,
    this.onPlay,
  });

  /// Key of the play button, for tests that drive playback.
  static const Key playButtonKey = Key('video-play-button');

  final Fragment$fragmentImages? image;
  final Uri? artUri;
  final String? serverName;

  /// Shows a centered play button when set.
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    final art = _art(context);
    return Container(
      color: art == null
          ? Theme.of(context).colorScheme.surfaceContainerHighest
          : Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ?art,
          if (onPlay != null) Center(child: _playButton(context)),
        ],
      ),
    );
  }

  Widget? _art(BuildContext context) {
    final image = this.image;
    final serverName = this.serverName;
    if (image != null && serverName != null) {
      final url = ImageUtil.buildUrl(image,
          token: StreamTokenService.getToken(serverName));
      if (url == null) return null;
      final blurHash = image.blurHash;
      // Measured, not fixed: this cover is page-wide, from a phone in
      // portrait to a full-screen video surface on a desktop.
      return ArtworkImage(
        url: url,
        placeholder: (context) => blurHash != null
            ? BlurHash(
                hash: blurHash,
                optimizationMode: BlurHashOptimizationMode.standard,
                color: Colors.black,
                duration: Duration.zero,
              )
            : const SizedBox.shrink(),
        // An unreachable server (offline) must not show a broken-image icon.
        errorBuilder: (context) => const SizedBox.shrink(),
      );
    }
    final uri = artUri;
    if (uri == null) return null;
    if (uri.scheme == 'file' && !kIsWeb) {
      return Image.file(File.fromUri(uri),
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const SizedBox.shrink());
    }
    return ArtworkImage(
      url: uri.toString(),
      errorBuilder: (context) => const SizedBox.shrink(),
    );
  }

  Widget _playButton(BuildContext context) {
    final label = AppLocalizations.of(context)?.play ?? 'Play';
    return TvFocusable(
      onTap: onPlay,
      autofocus: PlatformService.isTvModeSync,
      borderRadius: const BorderRadius.all(Radius.circular(48)),
      child: Semantics(
        button: true,
        label: label,
        child: Material(
          color: Colors.black45,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            key: playButtonKey,
            onTap: onPlay,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Icon(Icons.play_arrow, size: 56, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

/// [VideoCoverView] in loading mode over the video texture, shown while
/// [MediaPlayerHandler.videoStreamReady] is false. Lives in the controls
/// layer so the embedded view, media_kit's fullscreen copy, the downloads
/// player and a follower's surface all get it.
///
/// A cold start can take a minute (the server transcodes the first segments
/// on demand), so the spinner comes with [MediaPlayerHandler.videoLoad]'s
/// step, owns up to a slow start, and gives way to [VideoLoadFailedPanel]
/// when the load failed — a bare spinner read as a frozen app in both cases.
class VideoLoadingOverlay extends StatelessWidget {
  const VideoLoadingOverlay({super.key});

  static const Key stepKey = Key('video-load-step');
  static const Key slowKey = Key('video-load-slow');

  @override
  Widget build(BuildContext context) {
    final handler = MediaPlayerHandler.instance;
    return ValueListenableBuilder<bool>(
      valueListenable: handler.videoStreamReady,
      builder: (context, ready, _) {
        if (ready) return const SizedBox.shrink();
        // episode/movie are set synchronously at the start of every queue
        // switch; mediaItem (and its artUri) is only published at the end of
        // the open and would still show the previous item.
        final images = handler.episode?.images ?? handler.movie?.images;
        return IgnorePointer(
          child: Stack(
            fit: StackFit.expand,
            children: [
              VideoCoverView(
                image: ImageUtil.getImageByType(images, ImageTypes.background),
                artUri: handler.mediaItem.valueOrNull?.artUri,
                serverName: handler.serverName,
              ),
              // The art is arbitrary; the status has to read on all of it.
              const ColoredBox(color: Colors.black54),
              const _VideoLoadStatus(),
            ],
          ),
        );
      },
    );
  }
}

/// Spinner plus the current step of [MediaPlayerHandler.videoLoad]. Ticks once
/// a second while loading, only to notice the start turning slow.
class _VideoLoadStatus extends StatefulWidget {
  const _VideoLoadStatus();

  @override
  State<_VideoLoadStatus> createState() => _VideoLoadStatusState();
}

class _VideoLoadStatusState extends State<_VideoLoadStatus> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final load = MediaPlayerHandler.instance.videoLoad.value;
      if (mounted && load != null && !load.failed) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  static String _stepLabel(AppLocalizations loc, VideoLoadState load) {
    if (load.attempt > 0) return loc.videoLoadRetrying(load.attempt + 1);
    switch (load.phase) {
      case VideoLoadPhase.preparing:
        return loc.videoLoadPreparing;
      case VideoLoadPhase.connecting:
        return loc.videoLoadConnecting;
      case VideoLoadPhase.buffering:
      case VideoLoadPhase.failed:
        return loc.videoLoadBuffering;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoLoadState?>(
      valueListenable: MediaPlayerHandler.instance.videoLoad,
      builder: (context, load, _) {
        // The failure is drawn by VideoLoadFailedPanel, on top of the controls.
        if (load != null && load.failed) return const SizedBox.shrink();
        final loc = AppLocalizations.of(context);
        final textTheme = Theme.of(context).textTheme;
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: videoAccentOf(context)),
                if (loc != null && load != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _stepLabel(loc, load),
                    key: VideoLoadingOverlay.stepKey,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                  if (load.isSlow(DateTime.now())) ...[
                    const SizedBox(height: 6),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Text(
                        loc.videoLoadSlow,
                        key: VideoLoadingOverlay.slowKey,
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall
                            ?.copyWith(color: Colors.white70),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// What the video surface shows when [MediaPlayerHandler.videoLoad] ended in
/// a failure: that it failed, the player's own error when there is one, and a
/// retry. Sits *above* the controls (the loading overlay is below them and
/// takes no pointer events); only as big as its content, so the top bar's
/// stop/back stay reachable.
class VideoLoadFailedPanel extends StatelessWidget {
  const VideoLoadFailedPanel({super.key, this.showRetry = true});

  static const Key panelKey = Key('video-load-failed');
  static const Key retryKey = Key('video-load-retry');

  /// False where the surface itself is one big tap target (embedded on TV).
  final bool showRetry;

  @override
  Widget build(BuildContext context) {
    final handler = MediaPlayerHandler.instance;
    return ValueListenableBuilder<VideoLoadState?>(
      valueListenable: handler.videoLoad,
      builder: (context, load, _) {
        if (load == null || !load.failed) return const SizedBox.shrink();
        final loc = AppLocalizations.of(context);
        if (loc == null) return const SizedBox.shrink();
        final textTheme = Theme.of(context).textTheme;
        final detail = load.lastError;
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: ConstrainedBox(
              key: panelKey,
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      size: 40, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    loc.videoLoadFailedTitle,
                    textAlign: TextAlign.center,
                    style:
                        textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loc.videoLoadFailedBody,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
                  if (detail != null && detail.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      detail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style:
                          textTheme.labelSmall?.copyWith(color: Colors.white54),
                    ),
                  ],
                  if (showRetry) ...[
                    const SizedBox(height: 12),
                    TvFocusable(
                      onTap: handler.retryVideoLoad,
                      autofocus: PlatformService.isTvModeSync,
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      child: FilledButton.icon(
                        key: retryKey,
                        onPressed: handler.retryVideoLoad,
                        icon: const Icon(Icons.refresh),
                        label: Text(loc.retry),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
