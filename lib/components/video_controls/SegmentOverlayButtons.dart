import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/MediaPlayerHandler.dart';
import 'VideoControlButtons.dart';

/// What the segment overlay should offer right now. [countdown] is the whole
/// number of seconds left before an armed auto-skip fires (null when no
/// auto-skip is pending), shown inside the skip-intro button.
typedef SegmentActions = ({bool skipIntro, bool nextEpisode, int? countdown});

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

  /// How long before the detected intro starts the skip button already
  /// appears: detection lands on the first frame of the title card, and by
  /// then a viewer reaching for the button has already sat through it.
  static const int skipIntroLeadMs = 5000;

  /// Visibility rules, static and pure for unit tests. All values are in
  /// absolute file time — the same timeline the player position reports.
  /// The button appears [skipIntroLeadMs] before the intro and retires 1 s
  /// before it ends (a skip that saves less than a second is noise); the intro
  /// wins should the server ever produce overlapping segments.
  ///
  /// [autoSkipAtMs] is the pending auto-skip deadline
  /// ([MediaPlayerHandler.autoSkipIntroDeadlineMs]) for surfaces that drive a
  /// local player; null on remote surfaces, where the leader does the skipping.
  static SegmentActions visibilityFor({
    required int posMs,
    required ({int startMs, int endMs})? intro,
    required ({int startMs, int endMs})? outro,
    required bool hasNext,
    int? autoSkipAtMs,
  }) {
    final skipIntro = intro != null &&
        posMs >= intro.startMs - skipIntroLeadMs &&
        posMs < intro.endMs - 1000;
    final nextEpisode =
        !skipIntro && outro != null && hasNext && posMs >= outro.startMs;
    final countdown = skipIntro && autoSkipAtMs != null && posMs < autoSkipAtMs
        ? ((autoSkipAtMs - posMs) / 1000).ceil()
        : null;
    return (
      skipIntro: skipIntro,
      nextEpisode: nextEpisode,
      countdown: countdown
    );
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
          autoSkipAtMs: handler.autoSkipIntroDeadlineMs,
        ),
      ),
      initialData: const (skipIntro: false, nextEpisode: false, countdown: null),
      builder: (context, snapshot) {
        final actions = snapshot.data!;
        if (actions.skipIntro) {
          return _button(
            context,
            icon: Icons.fast_forward,
            label: actions.countdown != null
                ? loc.skipIntroCountdown(actions.countdown!)
                : loc.skipIntro,
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
