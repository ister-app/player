import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../utils/MediaPlayerHandler.dart';
import '../utils/OrientationService.dart';
import '../utils/PlatformService.dart';
import 'TvFocusable.dart';
import 'VideoCoverView.dart';
import 'WatchTogetherButton.dart';
import 'video_controls/IsterVideoControls.dart';

/// The video surface for an episode/movie page.
///
/// On a normal device the video plays both embedded and fullscreen, with the
/// app's own controls overlay (including a fullscreen toggle) shown in both;
/// leaving fullscreen keeps playing.
///
/// On Android TV playback is fullscreen-only: when playback starts the embedded
/// view auto-enters fullscreen, the back button leaves fullscreen and pauses,
/// and tapping the embedded view (the paused frame) re-enters fullscreen and
/// resumes.
class IsterPlayer extends StatefulWidget {
  const IsterPlayer({
    super.key,
  });

  /// Leaves fullscreen, set by the controls instance that is *itself* showing
  /// fullscreen (only that one has the [BuildContext] media_kit's
  /// [exitFullscreen] needs). Null when no video is fullscreen. Used when
  /// playback is torn down from the outside — the watch-along leader stopped,
  /// or the queue moved to another device — so the fullscreen surface is left
  /// before the page underneath is closed.
  static Future<void> Function()? activeFullscreenExitHandler;

  @override
  State<IsterPlayer> createState() => _IsterPlayerState();
}

class _IsterPlayerState extends State<IsterPlayer> {
  final MediaPlayerHandler _handler = MediaPlayerHandler.instance;
  bool _videoPageOpenCounted = false;

  @override
  void initState() {
    super.initState();
    // Hide the mini player's video bar while a video surface is mounted (the
    // full player is right here). Counted on the surface, not the page: a
    // page that only shows the cover + play button for another episode must
    // keep the bar of the one that is playing. Post-frame: the mini player is
    // an ancestor listening to this notifier, and notifying it while this
    // widget is being mounted mid-build throws "markNeedsBuild during build".
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _handler.videoPageOpen.value++;
      _videoPageOpenCounted = true;
    });
  }

  @override
  void dispose() {
    if (_videoPageOpenCounted) {
      // Post-frame for the same reason: the listening mini player may be
      // rebuilding (or unmounting) in the same locked-tree phase.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handler.videoPageOpen.value--;
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Video(
      controller: _handler.videoController,
      fit: MediaPlayerHandler.videoZoomToFill ? BoxFit.cover : BoxFit.contain,
      // libass (inside mpv) renders the subtitles into the video texture;
      // media_kit's Flutter SubtitleView would draw the same cues a second
      // time on top, unstyled.
      subtitleViewConfiguration:
          const SubtitleViewConfiguration(visible: false),
      controls: (state) => _IsterVideoControls(state: state),
      onEnterFullscreen: () async {
        _handler.videoFullscreen = true;
        await defaultEnterNativeFullscreen();
        await OrientationService.lockSensorLandscape();
      },
      onExitFullscreen: () async {
        _handler.videoFullscreen = false;
        await defaultExitNativeFullscreen();
        await OrientationService.unlock();
        // On TV, fullscreen is the only playback surface, so leaving it (e.g.
        // the back button) pauses right away. Elsewhere the embedded view keeps
        // playing. While watching along, pause would halt the *whole* session
        // (it becomes a remote command) and the leader's sync would restart
        // playback anyway — backing out means leaving the watch party instead.
        if (PlatformService.isAndroidTvSync) {
          if (_handler.followMode) {
            // Leaving the watch party means the shared media is gone from this
            // device: end playback rather than leave a paused stream behind.
            _handler.stopFollowing(teardown: true);
          } else {
            _handler.pause();
          }
        }
      },
    );
  }
}

/// Controls for [IsterPlayer]. In fullscreen — and embedded on a normal
/// device — it shows the app's own [IsterVideoControls] overlay. Embedded on
/// TV it's just a tap target that enters fullscreen, and it auto-enters once
/// playback becomes active.
class _IsterVideoControls extends StatefulWidget {
  const _IsterVideoControls({required this.state});

  final VideoState state;

  @override
  State<_IsterVideoControls> createState() => _IsterVideoControlsState();
}

class _IsterVideoControlsState extends State<_IsterVideoControls> {
  StreamSubscription<bool>? _playingSub;
  bool _initialised = false;
  bool _autoEnterDone = false;

  MediaPlayerHandler get _handler => MediaPlayerHandler.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Register the fullscreen escape hatch from the fullscreen instance; the
    // embedded copy of these controls has no fullscreen route to pop.
    if (isFullscreen(context)) {
      IsterPlayer.activeFullscreenExitHandler = _exitFullscreen;
    }
    // Auto-fullscreen is TV-only. Elsewhere the embedded view stays embedded
    // until the user hits the fullscreen button. Only the embedded instance
    // drives it; the fullscreen copy of these controls just renders the UI.
    if (_initialised ||
        isFullscreen(context) ||
        !PlatformService.isAndroidTvSync) {
      return;
    }
    _initialised = true;
    final player = widget.state.widget.controller.player;
    _maybeAutoEnter(player.state.playing);
    _playingSub = player.stream.playing.listen(_maybeAutoEnter);
  }

  @override
  void dispose() {
    _playingSub?.cancel();
    // Tear-offs of the same method on the same instance compare equal (they
    // are not necessarily `identical`), so this only clears our own handler.
    if (IsterPlayer.activeFullscreenExitHandler == _exitFullscreen) {
      IsterPlayer.activeFullscreenExitHandler = null;
    }
    super.dispose();
  }

  Future<void> _exitFullscreen() async {
    if (!mounted || !isFullscreen(context)) return;
    await exitFullscreen(context);
  }

  /// Enter fullscreen the first time playback becomes active after this view is
  /// shown, so a video that starts playing goes fullscreen on its own. Guarded
  /// to once per mount (and skipped if we're already fullscreen, e.g. when the
  /// queue auto-advances to the next episode).
  void _maybeAutoEnter(bool playing) {
    if (_autoEnterDone || !playing || !mounted) return;
    _autoEnterDone = true;
    if (_handler.videoFullscreen) return;
    // Defer the push out of the build/dependency phase (this can first run
    // during didChangeDependencies).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_handler.videoFullscreen && !isFullscreen(context)) {
        enterFullscreen(context);
      }
    });
  }

  void _onTapEmbedded() {
    _handler.play();
    // No global-flag guard here: tapping should always re-enter, and media_kit
    // itself ignores a duplicate enter for the same view.
    if (!isFullscreen(context)) enterFullscreen(context);
  }

  @override
  Widget build(BuildContext context) {
    // Fullscreen (any device) and embedded on a normal device get the app's
    // own controls overlay — including the fullscreen toggle to go back and
    // forth, and the watch-together/stop top bar that is crucial in
    // fullscreen, where the page's app bar is unreachable.
    if (isFullscreen(context) || !PlatformService.isAndroidTvSync) {
      return IsterVideoControls(state: widget.state);
    }
    // Embedded on TV: transparent tap target over the (paused) video frame,
    // with a hint icon. Focusable so a TV remote can select it. The chip keeps
    // the follow state visible here — there are no controls to carry it.
    return TvFocusable(
      onTap: _onTapEmbedded,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTapEmbedded,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Cover + spinner until the stream plays (same as the controls).
            const VideoLoadingOverlay(),
            const Positioned(top: 8, left: 8, child: WatchingAlongChip()),
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.fullscreen, size: 40, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
