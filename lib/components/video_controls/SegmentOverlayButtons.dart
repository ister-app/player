import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/MediaPlayerHandler.dart';
import 'VideoControlButtons.dart';

/// What the segment overlay should offer right now.
typedef SegmentActions = ({bool skipIntro, bool nextEpisode});

/// Netflix-style overlay actions driven by the server-detected segments of the
/// playing episode: "Skip intro" during the intro, "Next episode" during the
/// closing credits. Lives *outside* the auto-hiding controls overlay, so it
/// stays visible (and tappable) while the chrome is hidden.
class SegmentOverlayButtons extends StatelessWidget {
  const SegmentOverlayButtons({super.key, this.positionStream});

  /// Test seam: the widget tests inject a position stream because the real
  /// [MediaPlayerHandler.positionSecondsStream] never emits without a playing
  /// mpv instance.
  @visibleForTesting
  final Stream<Duration>? positionStream;

  /// Visibility rules, static and pure for unit tests. All values are in
  /// absolute file time — the same timeline the player position reports.
  /// The skip button retires 1 s before the intro ends (a skip that saves
  /// less than a second is noise), and the intro wins should the server ever
  /// produce overlapping segments.
  static SegmentActions visibilityFor({
    required int posMs,
    required ({int startMs, int endMs})? intro,
    required ({int startMs, int endMs})? outro,
    required bool hasNext,
  }) {
    final skipIntro = intro != null &&
        posMs >= intro.startMs &&
        posMs < intro.endMs - 1000;
    final nextEpisode =
        !skipIntro && outro != null && hasNext && posMs >= outro.startMs;
    return (skipIntro: skipIntro, nextEpisode: nextEpisode);
  }

  @override
  Widget build(BuildContext context) {
    final handler = MediaPlayerHandler.instance;
    final loc = AppLocalizations.of(context)!;
    return StreamBuilder<SegmentActions>(
      stream: CombineLatestStream.combine3(
        positionStream ?? handler.positionSecondsStream,
        handler.queue,
        handler.playbackState,
        (Duration pos, List<MediaItem> queue, PlaybackState state) =>
            visibilityFor(
          posMs: pos.inMilliseconds,
          intro: handler.currentIntroBounds,
          outro: handler.currentOutroBounds,
          hasNext: SkipButtons.availabilityFor(
            queueIndex: state.queueIndex,
            queueLength: queue.length,
            repeatMode: state.repeatMode,
          ).hasNext,
        ),
      ),
      initialData: const (skipIntro: false, nextEpisode: false),
      builder: (context, snapshot) {
        final actions = snapshot.data!;
        if (actions.skipIntro) {
          return _button(
            context,
            icon: Icons.fast_forward,
            label: loc.skipIntro,
            onPressed: () {
              final intro = handler.currentIntroBounds;
              if (intro == null) return;
              unawaited(handler.seek(Duration(milliseconds: intro.endMs)));
            },
          );
        }
        if (actions.nextEpisode) {
          return _button(
            context,
            icon: Icons.skip_next,
            label: loc.nextEpisode,
            onPressed: () => unawaited(handler.skipToNext()),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _button(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.black.withValues(alpha: 0.6),
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.7)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ).merge(videoControlButtonStyle(context)),
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
    );
  }
}
