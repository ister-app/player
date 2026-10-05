import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/MediaPlayerHandler.dart';
import 'VideoControlButtons.dart';

/// What the segment overlay should offer right now. [countdown] is the whole
/// number of seconds left before an armed auto-skip fires (null when no
/// auto-skip is pending), shown inside the skip-intro button; [nextCountdown]
/// is the same for the automatic move to the next episode during the credits.
typedef SegmentActions = ({
  bool skipIntro,
  bool nextEpisode,
  int? countdown,
  int? nextCountdown,
});

/// Netflix-style overlay actions driven by the server-detected segments of the
/// playing episode: "Skip intro" during the intro, "Next episode" during the
/// closing credits — the latter counting down to an automatic advance. Either
/// countdown (intro auto-skip, next episode) is called off by revealing the
/// controls (moving the mouse, tapping, the remote): it stops and the button
/// stays for a manual skip.
///
/// Lives *outside* the auto-hiding controls overlay: a prompt shows on its own
/// for [promptGrace] after it comes up and for as long as something counts
/// down, then retires with the chrome and returns whenever that is revealed.
class SegmentOverlayButtons extends StatefulWidget {
  const SegmentOverlayButtons(
      {super.key, this.controlsVisible = true, this.positionStream});

  /// Whether the auto-hiding controls are currently revealed.
  final bool controlsVisible;

  /// Test seam: the widget tests inject a position stream because the real
  /// [MediaPlayerHandler.positionSecondsStream] never emits without a playing
  /// mpv instance.
  @visibleForTesting
  final Stream<Duration>? positionStream;

  /// How long a freshly appeared prompt stays up while the chrome is hidden.
  static const Duration promptGrace = Duration(seconds: 8);

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
  /// ([MediaPlayerHandler.autoSkipIntroDeadlineMs]) and [autoNextAtMs] the
  /// moment the credits give way to the next episode
  /// ([MediaPlayerHandler.autoNextDeadlineMs]) — both for surfaces that drive
  /// a local player; null on remote surfaces, where the leader does it.
  static SegmentActions visibilityFor({
    required int posMs,
    required ({int startMs, int endMs})? intro,
    required ({int startMs, int endMs})? outro,
    required bool hasNext,
    int? autoSkipAtMs,
    int? autoNextAtMs,
  }) {
    final skipIntro = intro != null &&
        posMs >= intro.startMs - skipIntroLeadMs &&
        posMs < intro.endMs - 1000;
    final nextEpisode =
        !skipIntro && outro != null && hasNext && posMs >= outro.startMs;
    final countdown = skipIntro && autoSkipAtMs != null && posMs < autoSkipAtMs
        ? ((autoSkipAtMs - posMs) / 1000).ceil()
        : null;
    final nextCountdown =
        nextEpisode && autoNextAtMs != null && posMs < autoNextAtMs
            ? ((autoNextAtMs - posMs) / 1000).ceil()
            : null;
    return (
      skipIntro: skipIntro,
      nextEpisode: nextEpisode,
      countdown: countdown,
      nextCountdown: nextCountdown,
    );
  }

  @override
  State<SegmentOverlayButtons> createState() => _SegmentOverlayButtonsState();
}

enum _Prompt { none, skipIntro, nextEpisode }

class _SegmentOverlayButtonsState extends State<SegmentOverlayButtons> {
  static const SegmentActions _noActions = (
    skipIntro: false,
    nextEpisode: false,
    countdown: null,
    nextCountdown: null,
  );

  final _handler = MediaPlayerHandler.instance;
  StreamSubscription<void>? _subscription;
  Duration _position = Duration.zero;
  SegmentActions _actions = _noActions;
  _Prompt _prompt = _Prompt.none;
  bool _inGrace = false;

  /// A countdown was running for the current prompt and has not been called
  /// off: the prompt then stays up until it is replaced, so it does not blink
  /// out for the moment between the deadline and the seek or the next stream
  /// actually landing.
  bool _countedDown = false;
  Timer? _graceTimer;

  @override
  void initState() {
    super.initState();
    _subscription = CombineLatestStream.combine3(
      widget.positionStream ?? _handler.positionSecondsStream,
      _handler.queue,
      _handler.playbackState,
      (Duration pos, List<MediaItem> _, PlaybackState _) => pos,
    ).listen((pos) {
      _position = pos;
      _refresh();
    });
  }

  @override
  void didUpdateWidget(SegmentOverlayButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Calling up the controls means the viewer is here and may want the
    // intro or the credits: stop the countdown and leave the jump to the
    // button. Only the reveal counts — chrome that was already up when the
    // countdown started says nothing.
    if (!widget.controlsVisible || oldWidget.controlsVisible) return;
    if (_actions.countdown != null) {
      _handler.cancelAutoSkipIntro();
    } else if (_actions.nextCountdown != null) {
      _handler.cancelAutoNext();
    } else {
      return;
    }
    _countedDown = false;
    _refresh();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _graceTimer?.cancel();
    super.dispose();
  }

  /// Re-derives the prompt from the handler; also called right after a
  /// countdown was called off, so the button doesn't lag a position tick behind.
  void _refresh() {
    if (!mounted) return;
    final state = _handler.playbackState.value;
    final actions = SegmentOverlayButtons.visibilityFor(
      posMs: _position.inMilliseconds,
      intro: _handler.currentIntroBounds,
      outro: _handler.currentOutroBounds,
      hasNext: SkipButtons.availabilityFor(
        queueIndex: state.queueIndex,
        queueLength: _handler.queue.value.length,
        repeatMode: state.repeatMode,
      ).hasNext,
      autoSkipAtMs: _handler.autoSkipIntroDeadlineMs,
      autoNextAtMs: _handler.autoNextDeadlineMs,
    );
    final prompt = actions.skipIntro
        ? _Prompt.skipIntro
        : actions.nextEpisode
            ? _Prompt.nextEpisode
            : _Prompt.none;
    setState(() {
      _actions = actions;
      final counting =
          actions.countdown != null || actions.nextCountdown != null;
      if (prompt == _prompt) {
        _countedDown = _countedDown || counting;
        return;
      }
      _prompt = prompt;
      _countedDown = counting;
      _graceTimer?.cancel();
      _inGrace = prompt != _Prompt.none;
      if (_inGrace) {
        _graceTimer = Timer(SegmentOverlayButtons.promptGrace, () {
          if (mounted) setState(() => _inGrace = false);
        });
      }
    });
  }

  bool get _shown =>
      _inGrace ||
      widget.controlsVisible ||
      _countedDown;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final actions = _actions;
    final Widget button;
    switch (_prompt) {
      case _Prompt.none:
        return const SizedBox.shrink();
      case _Prompt.skipIntro:
        button = _button(
          context,
          icon: Icons.fast_forward,
          label: actions.countdown != null
              ? loc.skipIntroCountdown(actions.countdown!)
              : loc.skipIntro,
          onPressed: () {
            final intro = _handler.currentIntroBounds;
            if (intro == null) return;
            unawaited(_handler.seek(Duration(milliseconds: intro.endMs)));
          },
        );
      case _Prompt.nextEpisode:
        final countdown = actions.nextCountdown;
        button = _button(
          context,
          icon: Icons.skip_next,
          label: loc.nextEpisode,
          // Where the fill should be one position tick (1 s) from now; full
          // while the next episode is being opened.
          fill: countdown == null
              ? (_countedDown ? 1 : null)
              : 1 - (countdown - 1) * 1000 / MediaPlayerHandler.autoNextDelayMs,
          onPressed: () => unawaited(_handler.skipToNext()),
        );
    }
    return IgnorePointer(
      ignoring: !_shown,
      child: AnimatedOpacity(
        opacity: _shown ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: button,
      ),
    );
  }

  /// [fill] (0–1) paints a progress fill into the button, left to right: the
  /// countdown to the automatic next episode.
  Widget _button(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed,
      double? fill}) {
    return FilledButton.icon(
      clipBehavior: Clip.antiAlias,
      style: FilledButton.styleFrom(
        backgroundColor: Colors.black.withValues(alpha: 0.6),
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.7)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        backgroundBuilder: fill == null
            ? null
            : (context, states, child) => TweenAnimationBuilder<double>(
                  tween: Tween(end: fill.clamp(0.0, 1.0)),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) => DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.35),
                          Colors.white.withValues(alpha: 0.35),
                          Colors.transparent,
                          Colors.transparent,
                        ],
                        stops: [0, value, value, 1],
                      ),
                    ),
                    child: child,
                  ),
                  child: child,
                ),
      ).merge(videoControlButtonStyle(context)),
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
    );
  }
}
