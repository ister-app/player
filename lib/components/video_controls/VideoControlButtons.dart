import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:rxdart/rxdart.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/MediaPlayerHandler.dart';
import '../../utils/PlatformService.dart';
import '../../utils/SleepTimerService.dart';
import '../AppModalSheet.dart';
import '../SleepTimerSheet.dart';

/// The accent colour for the video chrome (seek bar, spinner, sliders). The
/// overlay always sits on dark video/scrim, but in the light theme
/// `colorScheme.primary` is a *dark* tone — invisible on black — so there the
/// light-on-dark counterpart `inversePrimary` is used instead.
Color videoAccentOf(BuildContext context) {
  final theme = Theme.of(context);
  return theme.brightness == Brightness.dark
      ? theme.colorScheme.primary
      : theme.colorScheme.inversePrimary;
}

/// Focus styling for the overlay's icon buttons on TV: the D-pad highlight
/// must read from across the room, so a focused button gets the same
/// primary-tinted fill the app's [TvFocusable] draws. Null elsewhere —
/// pointer/touch devices keep the default (invisible) button chrome.
ButtonStyle? videoControlButtonStyle(BuildContext context) {
  if (!PlatformService.isTvModeSync) return null;
  final scheme = Theme.of(context).colorScheme;
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.focused)
          ? scheme.primary.withValues(alpha: 0.35)
          : null,
    ),
  );
}

/// Play/pause toggle routed through [MediaPlayerHandler] (follow-mode
/// forwarding, `_intendsToPlay`, progress sync — none of which the raw
/// `player.playOrPause()` of the stock controls did).
class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    super.key,
    this.iconSize = 32,
    this.focusNode,
    this.autofocus = false,
  });

  final double iconSize;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final handler = MediaPlayerHandler.instance;
    final loc = AppLocalizations.of(context)!;
    return StreamBuilder<bool>(
      stream: handler.player.stream.playing,
      initialData: handler.player.state.playing,
      builder: (context, snapshot) {
        final playing = snapshot.data ?? false;
        return IconButton(
          iconSize: iconSize,
          color: Colors.white,
          focusNode: focusNode,
          autofocus: autofocus,
          style: videoControlButtonStyle(context),
          tooltip: playing ? loc.pause : loc.play,
          icon: Icon(playing ? Icons.pause : Icons.play_arrow),
          onPressed: () =>
              unawaited(playing ? handler.pause() : handler.play()),
        );
      },
    );
  }
}

/// What the queue allows right now; drives the skip buttons' visibility.
typedef SkipAvailability = ({bool hasPrevious, bool hasNext});

/// Which of the two skip buttons a [SkipButtons] instance renders. The
/// transport places play/pause *between* previous and next, so each side is
/// mounted separately; both sides share the same availability rule and thus
/// appear and disappear together.
enum SkipButtonSide { previous, next, both }

/// Previous/next buttons wired to the handler's play queue. The stock skip
/// buttons never appeared: they watch mpv's playlist, which always holds a
/// single `Media` — queue advance lives entirely in [MediaPlayerHandler].
class SkipButtons extends StatelessWidget {
  const SkipButtons({
    super.key,
    this.iconSize = 24,
    this.side = SkipButtonSide.both,
  });

  final double iconSize;

  /// Renders only the previous or only the next button when set, so the
  /// caller can wrap them around play/pause.
  final SkipButtonSide side;

  /// Visibility rules, kept static and pure so they can be unit tested: a
  /// manual next/previous wraps only in repeat-all (matching `skipToNext`);
  /// an unknown index means we cannot know what "next" is.
  static SkipAvailability availabilityFor({
    required int? queueIndex,
    required int queueLength,
    required AudioServiceRepeatMode repeatMode,
  }) {
    if (queueIndex == null) return (hasPrevious: false, hasNext: false);
    final wraps =
        repeatMode == AudioServiceRepeatMode.all && queueLength > 1;
    return (
      hasPrevious: queueIndex > 0 || wraps,
      hasNext: queueIndex + 1 < queueLength || wraps,
    );
  }

  @override
  Widget build(BuildContext context) {
    final handler = MediaPlayerHandler.instance;
    final loc = AppLocalizations.of(context)!;
    return StreamBuilder<SkipAvailability>(
      stream: CombineLatestStream.combine2(
        handler.queue,
        handler.playbackState,
        (List<MediaItem> queue, PlaybackState state) => availabilityFor(
          queueIndex: state.queueIndex,
          queueLength: queue.length,
          repeatMode: state.repeatMode,
        ),
      ),
      initialData: availabilityFor(
        queueIndex: handler.playbackState.value.queueIndex,
        queueLength: handler.queue.value.length,
        repeatMode: handler.playbackState.value.repeatMode,
      ),
      builder: (context, snapshot) {
        final skip = snapshot.data!;
        if (!skip.hasPrevious && !skip.hasNext) {
          return const SizedBox.shrink();
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (side != SkipButtonSide.next)
              IconButton(
                iconSize: iconSize,
                color: Colors.white,
                style: videoControlButtonStyle(context),
                tooltip: loc.skipPrevious,
                icon: const Icon(Icons.skip_previous),
                onPressed: skip.hasPrevious
                    ? () => unawaited(handler.skipToPrevious())
                    : null,
              ),
            if (side != SkipButtonSide.previous)
              IconButton(
                iconSize: iconSize,
                color: Colors.white,
                style: videoControlButtonStyle(context),
                tooltip: loc.skipNext,
                icon: const Icon(Icons.skip_next),
                onPressed: skip.hasNext
                    ? () => unawaited(handler.skipToNext())
                    : null,
              ),
          ],
        );
      },
    );
  }
}

/// "position / duration" text, sampled at whole seconds.
class PositionText extends StatelessWidget {
  const PositionText({super.key});

  static String format(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final player = MediaPlayerHandler.instance.player;
    return StreamBuilder<Duration>(
      stream: MediaPlayerHandler.instance.positionSecondsStream,
      initialData: player.state.position,
      builder: (context, positionSnapshot) {
        final position = positionSnapshot.data ?? Duration.zero;
        return StreamBuilder<Duration>(
          stream: player.stream.duration,
          initialData: player.state.duration,
          builder: (context, durationSnapshot) {
            final duration = durationSnapshot.data ?? Duration.zero;
            return Text(
              '${format(position)} / ${format(duration)}',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Colors.white),
            );
          },
        );
      },
    );
  }
}

/// Mute toggle with a hover-expanding volume slider (desktop/web only).
/// Volume deliberately talks to the player directly — it is device-local and
/// takes no part in follow-mode/progress sync.
class VolumeButton extends StatefulWidget {
  const VolumeButton({super.key});

  @override
  State<VolumeButton> createState() => _VolumeButtonState();
}

class _VolumeButtonState extends State<VolumeButton> {
  bool _hovered = false;
  double _lastNonZeroVolume = 100;

  @override
  Widget build(BuildContext context) {
    final player = MediaPlayerHandler.instance.player;
    final loc = AppLocalizations.of(context)!;
    final accent = videoAccentOf(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: StreamBuilder<double>(
        stream: player.stream.volume,
        initialData: player.state.volume,
        builder: (context, snapshot) {
          final volume = snapshot.data ?? 100;
          final muted = volume <= 0;
          if (!muted) _lastNonZeroVolume = volume;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                color: Colors.white,
                tooltip: muted ? loc.unmute : loc.mute,
                icon: Icon(muted
                    ? Icons.volume_off
                    : volume < 50
                        ? Icons.volume_down
                        : Icons.volume_up),
                onPressed: () => unawaited(
                    player.setVolume(muted ? _lastNonZeroVolume : 0)),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                child: SizedBox(
                  width: _hovered ? 84 : 0,
                  child: _hovered
                      ? SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 3,
                            activeTrackColor: accent,
                            inactiveTrackColor:
                                Colors.white.withValues(alpha: 0.3),
                            thumbColor: accent,
                            overlayShape: SliderComponentShape.noOverlay,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6),
                          ),
                          child: Slider(
                            value: volume.clamp(0.0, 100.0),
                            max: 100,
                            onChanged: (v) => unawaited(player.setVolume(v)),
                          ),
                        )
                      : null,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Zoom-to-fill toggle: crops the video to fill the surface (BoxFit.cover)
/// instead of letterboxing it (BoxFit.contain). Pure Flutter — works on every
/// platform including web — and carries into/out of fullscreen because the
/// fullscreen route shares the same view parameters. Session-sticky via
/// [MediaPlayerHandler.videoZoomToFill].
class ZoomToggleButton extends StatelessWidget {
  const ZoomToggleButton({super.key, required this.state});

  final VideoState state;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ValueListenableBuilder(
      valueListenable: state.videoViewParametersNotifier,
      builder: (context, params, _) {
        final filling = params.fit == BoxFit.cover;
        return IconButton(
          color: Colors.white,
          style: videoControlButtonStyle(context),
          tooltip: filling ? loc.zoomToFit : loc.zoomToFill,
          icon: Icon(filling ? Icons.fit_screen_outlined : Icons.fit_screen),
          onPressed: () {
            MediaPlayerHandler.videoZoomToFill = !filling;
            state.update(fit: filling ? BoxFit.contain : BoxFit.cover);
          },
        );
      },
    );
  }
}

/// Sleep timer for the video overlay — the same [SleepTimerSheet] the music
/// player opens, so a film or episode can be stopped after a duration or a
/// number of items just as well. Outlined and white while inactive, tinted
/// with the video accent and followed by a compact countdown while armed.
class SleepTimerButton extends StatelessWidget {
  const SleepTimerButton({super.key, this.onMenuOpenChanged});

  /// Lets the controls shell suspend auto-hide while the sheet is open — the
  /// overlay must not fade out from under the sheet.
  final ValueChanged<bool>? onMenuOpenChanged;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final accent = videoAccentOf(context);
    return ValueListenableBuilder<Duration?>(
      valueListenable: SleepTimerService.instance.remaining,
      builder: (context, remaining, _) => ValueListenableBuilder<int?>(
        valueListenable: SleepTimerService.instance.remainingItems,
        builder: (context, items, _) {
          // Either a countdown or an item count is armed, never both.
          final active = remaining != null || items != null;
          final label = remaining != null
              ? shortSleepCountdown(remaining)
              : items != null
                  ? loc.sleepTimerItemsShort(items)
                  : null;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                color: active ? accent : Colors.white,
                style: videoControlButtonStyle(context),
                tooltip: loc.sleepTimer,
                icon: Icon(active ? Icons.bedtime : Icons.bedtime_outlined),
                onPressed: () async {
                  onMenuOpenChanged?.call(true);
                  await showAppSheet<void>(
                    context,
                    builder: (_) => const SleepTimerSheet(),
                  );
                  onMenuOpenChanged?.call(false);
                },
              ),
              if (label != null)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    label,
                    style: TextStyle(color: accent, fontSize: 12),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Enter/exit fullscreen for the surrounding media_kit `Video`.
class FullscreenToggleButton extends StatelessWidget {
  const FullscreenToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final fullscreen = isFullscreen(context);
    return IconButton(
      color: Colors.white,
      tooltip: fullscreen ? loc.exitFullscreen : loc.enterFullscreen,
      icon: Icon(fullscreen ? Icons.fullscreen_exit : Icons.fullscreen),
      onPressed: () => unawaited(
          fullscreen ? exitFullscreen(context) : enterFullscreen(context)),
    );
  }
}
