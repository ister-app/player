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
import 'TvFocusable.dart';
import 'video_controls/VideoControlButtons.dart';

/// The artwork a video surface shows when it is not (yet) playing: on the
/// episode/movie page before the user hits play (with [onPlay] set), and over
/// the video texture while a freshly opened stream is still loading
/// ([loading]) — the server may still be transcoding the first HLS segment,
/// and until then the texture is black or holds the previous item's frame.
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
    this.loading = false,
  });

  /// Key of the play button, for tests that drive playback.
  static const Key playButtonKey = Key('video-play-button');

  final Fragment$fragmentImages? image;
  final Uri? artUri;
  final String? serverName;

  /// Shows a centered play button when set.
  final VoidCallback? onPlay;

  /// Shows a spinner over the art.
  final bool loading;

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
          if (loading)
            IgnorePointer(
              child: Center(
                child: CircularProgressIndicator(color: videoAccentOf(context)),
              ),
            ),
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
class VideoLoadingOverlay extends StatelessWidget {
  const VideoLoadingOverlay({super.key});

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
          child: VideoCoverView(
            image: ImageUtil.getImageByType(images, ImageTypes.background),
            artUri: handler.mediaItem.valueOrNull?.artUri,
            serverName: handler.serverName,
            loading: true,
          ),
        );
      },
    );
  }
}
