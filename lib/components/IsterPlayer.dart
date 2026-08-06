import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../utils/MediaPlayerHandler.dart';
import '../utils/PlatformService.dart';
import 'TvFocusable.dart';
import 'WatchTogetherButton.dart';

/// The video surface for an episode/movie page.
///
/// On a normal device the video plays both embedded and fullscreen, with the
/// standard media_kit controls (including a fullscreen toggle) shown in both;
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

  @override
  State<IsterPlayer> createState() => _IsterPlayerState();
}

class _IsterPlayerState extends State<IsterPlayer> {
  final MediaPlayerHandler _handler = MediaPlayerHandler.instance;

  @override
  Widget build(BuildContext context) {
    return Video(
      controller: _handler.videoController,
      controls: (state) => _IsterVideoControls(state: state),
      onEnterFullscreen: () async {
        _handler.videoFullscreen = true;
        await defaultEnterNativeFullscreen();
      },
      onExitFullscreen: () async {
        _handler.videoFullscreen = false;
        await defaultExitNativeFullscreen();
        // On TV, fullscreen is the only playback surface, so leaving it (e.g.
        // the back button) pauses right away. Elsewhere the embedded view keeps
        // playing. While watching along, pause would halt the *whole* session
        // (it becomes a remote command) and the leader's sync would restart
        // playback anyway — backing out means leaving the watch party instead.
        if (PlatformService.isAndroidTvSync) {
          if (_handler.followMode) {
            _handler.stopFollowing();
          } else {
            _handler.pause();
          }
        }
      },
    );
  }
}

/// Controls for [IsterPlayer]. In fullscreen it shows the normal media_kit
/// controls (desktop/D-pad ones on TV). Embedded on a normal device it shows
/// the standard controls too (with a fullscreen toggle); on TV it's just a tap
/// target that enters fullscreen, and it auto-enters once playback becomes
/// active.
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
    super.dispose();
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

  /// Wraps [controls] in the media_kit control themes so a top button bar with
  /// the watch-together entry point (and the "watching along" chip while
  /// following) appears — crucial in fullscreen, the only playback surface on
  /// TV, where the page's app bar is unreachable.
  Widget _withTopBar(Widget controls) {
    final topButtonBar = <Widget>[
      const Spacer(),
      const WatchingAlongChip(),
      const SizedBox(width: 8),
      const WatchTogetherButton(color: Colors.white),
    ];
    return MaterialDesktopVideoControlsTheme(
      normal: kDefaultMaterialDesktopVideoControlsThemeData.copyWith(
          topButtonBar: topButtonBar),
      fullscreen: kDefaultMaterialDesktopVideoControlsThemeDataFullscreen
          .copyWith(topButtonBar: topButtonBar),
      child: MaterialVideoControlsTheme(
        normal: kDefaultMaterialVideoControlsThemeData.copyWith(
            topButtonBar: topButtonBar),
        fullscreen: kDefaultMaterialVideoControlsThemeDataFullscreen.copyWith(
            topButtonBar: topButtonBar),
        child: controls,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isFullscreen(context)) {
      return _withTopBar(PlatformService.isAndroidTvSync
          ? MaterialDesktopVideoControls(widget.state)
          : AdaptiveVideoControls(widget.state));
    }
    // Embedded on a normal device: the standard controls, which include a
    // fullscreen button so the user can go fullscreen (and come back) at will.
    if (!PlatformService.isAndroidTvSync) {
      return _withTopBar(AdaptiveVideoControls(widget.state));
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
          children: [
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
