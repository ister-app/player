import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

/// Play/pause toggle shared by the mini player and the full music player.
///
/// Encapsulates the "spinner only while genuinely starting up" rule: a spinner
/// is shown while loading and not yet playing, but once playback has begun the
/// button stays a usable pause control even if the stream buffers mid-track.
class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    super.key,
    this.iconSize = 32,
    this.iconColor,
    this.spinnerColor,
    this.spinnerStrokeWidth = 2,
  });

  final double iconSize;
  final Color? iconColor;
  final Color? spinnerColor;
  final double spinnerStrokeWidth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: MediaPlayerHandler.instance.playbackState,
      initialData: MediaPlayerHandler.instance.playbackState.valueOrNull,
      builder: (context, snapshot) {
        final isPlaying = snapshot.data?.playing ?? false;
        final isLoading = snapshot.data?.processingState == AudioProcessingState.loading ||
            snapshot.data?.processingState == AudioProcessingState.buffering;
        final showSpinner = isLoading && !isPlaying;

        return IconButton(
          iconSize: iconSize,
          icon: SizedBox.square(
            dimension: iconSize,
            child: showSpinner
                ? Center(
                    child: SizedBox.square(
                      dimension: iconSize * 0.625,
                      child: CircularProgressIndicator(
                        strokeWidth: spinnerStrokeWidth,
                        color: spinnerColor,
                      ),
                    ),
                  )
                : Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                    size: iconSize, color: iconColor),
          ),
          // Stays tappable while the spinner shows — a paused stream that is
          // buffering must still accept a play tap.
          onPressed: () {
            if (isPlaying) {
              MediaPlayerHandler.instance.pause();
            } else {
              MediaPlayerHandler.instance.play();
            }
          },
        );
      },
    );
  }
}
