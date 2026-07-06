import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../utils/MediaPlayerHandler.dart';
import '../utils/PlatformService.dart';
import 'TvFocusable.dart';

/// The video surface for an episode/movie page. Video always plays fullscreen:
/// when playback starts the embedded view auto-enters fullscreen, the back
/// button leaves fullscreen and pauses, and tapping the embedded view (the
/// paused frame) re-enters fullscreen and resumes.
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
        // Leaving fullscreen (e.g. the back button) pauses right away.
        _handler.pause();
      },
    );
  }
}

/// Controls for [IsterPlayer]. In fullscreen it shows the normal media_kit
/// controls (desktop/D-pad ones on TV); embedded it's just a tap target that
/// enters fullscreen, and it auto-enters once playback becomes active.
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
    // Only the embedded instance drives auto-fullscreen; the fullscreen copy of
    // these controls just renders the playback UI.
    if (_initialised || isFullscreen(context)) return;
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
  /// shown, so a video that starts playing goes fullscreen on its own.
  void _maybeAutoEnter(bool playing) {
    if (_autoEnterDone || !playing || !mounted) return;
    _autoEnterDone = true;
    _enterFullscreen();
  }

  void _enterFullscreen() {
    if (_handler.videoFullscreen) return;
    // Set the guard synchronously so a burst of playing-events can't push the
    // fullscreen route more than once.
    _handler.videoFullscreen = true;
    // Defer the route push out of the build/dependency phase (the initial
    // auto-enter can fire while dependencies are being resolved).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        enterFullscreen(context);
      } else {
        _handler.videoFullscreen = false;
      }
    });
  }

  void _onTapEmbedded() {
    _handler.play();
    _enterFullscreen();
  }

  @override
  Widget build(BuildContext context) {
    if (isFullscreen(context)) {
      return PlatformService.isAndroidTvSync
          ? MaterialDesktopVideoControls(widget.state)
          : AdaptiveVideoControls(widget.state);
    }
    // Embedded: transparent tap target over the (paused) video frame, with a
    // hint icon. Focusable so a TV remote can select it.
    return TvFocusable(
      onTap: _onTapEmbedded,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTapEmbedded,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.black45,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.fullscreen, size: 40, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
