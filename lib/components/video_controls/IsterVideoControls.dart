import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/MediaPlayerHandler.dart';
import '../../utils/PlatformService.dart';
import '../WatchTogetherButton.dart';
import 'SegmentOverlayButtons.dart';
import 'TrackMenuButton.dart';
import 'TrackSelectionController.dart';
import 'VideoControlButtons.dart';
import 'VideoGestureLayer.dart';
import 'VideoSeekBar.dart';

/// The app's own video controls overlay, replacing media_kit's stock
/// `MaterialVideoControls`/`MaterialDesktopVideoControls`.
///
/// One adaptive widget serves all platforms: pointer devices (desktop/web) get
/// a hover-driven bottom bar with a volume slider and keyboard shortcuts,
/// touch gets tap-to-toggle with big center transport buttons, and TV gets the
/// same bar made D-pad reachable. All transport actions go through
/// [MediaPlayerHandler] so follow-mode forwarding, progress sync and the
/// subtitle-aware seek path apply to the in-video controls too. Volume is the
/// deliberate exception: device-local, straight to the player.
class IsterVideoControls extends StatefulWidget {
  const IsterVideoControls({super.key, required this.state});

  final VideoState state;

  @override
  State<IsterVideoControls> createState() => _IsterVideoControlsState();
}

class _IsterVideoControlsState extends State<IsterVideoControls> {
  static const _hideDelay = Duration(seconds: 3);
  static const _fadeDuration = Duration(milliseconds: 300);

  final MediaPlayerHandler _handler = MediaPlayerHandler.instance;
  late final TrackSelectionController _tracks = TrackSelectionController();
  final FocusNode _shortcutsFocusNode = FocusNode();

  /// TV only: holds focus while the controls are hidden (the buttons are made
  /// unfocusable then, so a focused-but-invisible button can never be
  /// activated by the select key) and hands it back to play/pause on reveal.
  final FocusNode _tvRootNode = FocusNode(skipTraversal: true);
  final FocusNode _tvPlayPauseNode = FocusNode();

  StreamSubscription<bool>? _playingSub;
  Timer? _hideTimer;
  bool _visible = true;
  bool _menuOpen = false;
  bool _seekDragging = false;

  Player get _player => widget.state.widget.controller.player;

  bool get _isTv => PlatformService.isAndroidTvSync;

  bool get _pointerDevice {
    if (_isTv) return false;
    if (kIsWeb) return true;
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return false;
      default:
        return true;
    }
  }

  @override
  void initState() {
    super.initState();
    _playingSub = _player.stream.playing.listen((playing) {
      // Pausing keeps the controls up (the user is clearly interacting);
      // resuming restarts the hide countdown.
      if (playing) {
        _scheduleHide();
      } else {
        _show();
      }
    });
    _scheduleHide();
  }

  @override
  void dispose() {
    // Don't drop an accumulated keyboard seek on teardown.
    if (_seekDebounce != null) _firePendingSeek();
    _seekPreview.dispose();
    _hideTimer?.cancel();
    _playingSub?.cancel();
    _tracks.dispose();
    _shortcutsFocusNode.dispose();
    _tvRootNode.dispose();
    _tvPlayPauseNode.dispose();
    super.dispose();
  }

  bool get _mayHide =>
      _player.state.playing && !_menuOpen && !_seekDragging;

  void _hide() {
    setState(() => _visible = false);
    if (_isTv) _tvRootNode.requestFocus();
  }

  void _scheduleHide() {
    _hideTimer?.cancel();
    _hideTimer = Timer(_hideDelay, () {
      if (mounted && _mayHide) _hide();
    });
  }

  void _show() {
    if (!_visible) setState(() => _visible = true);
    _scheduleHide();
  }

  void _toggle() {
    if (_visible && _mayHide) {
      _hideTimer?.cancel();
      _hide();
    } else {
      _show();
    }
  }

  void _setMenuOpen(bool open) {
    _menuOpen = open;
    if (open) {
      _hideTimer?.cancel();
      _show();
    } else {
      _scheduleHide();
    }
  }

  void _setSeekDragging(bool dragging) {
    _seekDragging = dragging;
    dragging ? _hideTimer?.cancel() : _scheduleHide();
  }

  void _togglePlayPause() {
    unawaited(_player.state.playing ? _handler.pause() : _handler.play());
  }

  /// Debounced keyboard seeking: rapid arrow presses accumulate into one
  /// target and fire a single handler.seek after a short quiet period — a
  /// backward seek can re-open the HLS stream (see seekAware), which must not
  /// happen per keypress. The pending target shows on the seek bar as a
  /// preview via [_seekPreview].
  final ValueNotifier<Duration?> _seekPreview = ValueNotifier(null);
  Timer? _seekDebounce;

  void _seekRelative(Duration delta) {
    final duration = _player.state.duration;
    var target = (_seekPreview.value ?? _player.state.position) + delta;
    if (target < Duration.zero) target = Duration.zero;
    if (duration > Duration.zero && target > duration) target = duration;
    _seekPreview.value = target;
    _show();
    _seekDebounce?.cancel();
    _seekDebounce = Timer(const Duration(milliseconds: 300), _firePendingSeek);
  }

  void _firePendingSeek() {
    _seekDebounce?.cancel();
    _seekDebounce = null;
    final target = _seekPreview.value;
    _seekPreview.value = null;
    if (target != null) unawaited(_handler.seek(target));
  }

  void _changeVolume(double delta) {
    final v = (_player.state.volume + delta).clamp(0.0, 100.0);
    unawaited(_player.setVolume(v));
  }

  void _toggleFullscreen() {
    unawaited(isFullscreen(context)
        ? exitFullscreen(context)
        : enterFullscreen(context));
  }

  Map<ShortcutActivator, VoidCallback> get _shortcuts => {
        const SingleActivator(LogicalKeyboardKey.space): _togglePlayPause,
        const SingleActivator(LogicalKeyboardKey.mediaPlayPause):
            _togglePlayPause,
        const SingleActivator(LogicalKeyboardKey.mediaPlay): _handler.play,
        const SingleActivator(LogicalKeyboardKey.mediaPause): _handler.pause,
        const SingleActivator(LogicalKeyboardKey.mediaTrackNext):
            _handler.skipToNext,
        const SingleActivator(LogicalKeyboardKey.mediaTrackPrevious):
            _handler.skipToPrevious,
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () =>
            _seekRelative(const Duration(seconds: -2)),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () =>
            _seekRelative(const Duration(seconds: 2)),
        const SingleActivator(LogicalKeyboardKey.keyJ): () =>
            _seekRelative(const Duration(seconds: -10)),
        const SingleActivator(LogicalKeyboardKey.keyI): () =>
            _seekRelative(const Duration(seconds: 10)),
        const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
            _changeVolume(5),
        const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
            _changeVolume(-5),
        const SingleActivator(LogicalKeyboardKey.keyF): _toggleFullscreen,
        const SingleActivator(LogicalKeyboardKey.escape): () {
          if (isFullscreen(context)) unawaited(exitFullscreen(context));
        },
      };

  /// On TV a key press while hidden only reveals the controls (and puts focus
  /// back on play/pause); while visible it restarts the hide countdown and
  /// lets focus traversal proceed.
  KeyEventResult _onTvKeyEvent(FocusNode node, KeyEvent event) {
    if (!_visible) {
      if (event is KeyDownEvent) {
        _show();
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _tvPlayPauseNode.requestFocus());
      }
      // Swallow the up event of the revealing press too.
      return KeyEventResult.handled;
    }
    if (event is KeyDownEvent) _scheduleHide();
    return KeyEventResult.ignored;
  }

  List<Widget> _topBarChildren(AppLocalizations loc) => [
        const Spacer(),
        const WatchingAlongChip(),
        const SizedBox(width: 8),
        const WatchTogetherButton(color: Colors.white),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.stop_circle_outlined, color: Colors.white),
          style: videoControlButtonStyle(context),
          tooltip: loc.stopPlayback,
          // Ends the session; fullscreen exit and closing the video page follow
          // through the handler's closePlaybackRequest (see MiniPlayer).
          onPressed: () => unawaited(_handler.stopPlayback()),
        ),
      ];

  Widget _scrim({required bool top}) {
    return IgnorePointer(
      child: Container(
        height: top ? 96 : 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: top ? Alignment.topCenter : Alignment.bottomCenter,
            end: top ? Alignment.bottomCenter : Alignment.topCenter,
            colors: [
              Colors.black.withValues(alpha: 0.6),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _bufferingIndicator() {
    return StreamBuilder<bool>(
      stream: _player.stream.buffering,
      initialData: _player.state.buffering,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox.shrink();
        return IgnorePointer(
          child: Center(
            child: CircularProgressIndicator(
              color: videoAccentOf(context),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final fullscreen = isFullscreen(context);
    final pointer = _pointerDevice;
    final touch = !pointer && !_isTv;
    // Touch gets big center transport buttons instead of duplicating them in
    // the bottom bar.
    final centerTransport = touch;

    // TV buttons are a step larger so they read from across the room.
    final iconScale = _isTv ? 1.25 : 1.0;
    final bottomBar = Row(
      children: [
        if (!centerTransport) ...[
          SkipButtons(
              iconSize: 24 * iconScale, side: SkipButtonSide.previous),
          PlayPauseButton(
            iconSize: 32 * iconScale,
            focusNode: _isTv ? _tvPlayPauseNode : null,
            autofocus: _isTv,
          ),
          SkipButtons(iconSize: 24 * iconScale, side: SkipButtonSide.next),
        ],
        if (pointer) const VolumeButton(),
        const SizedBox(width: 8),
        const PositionText(),
        const Spacer(),
        ZoomToggleButton(state: widget.state),
        TrackMenuButton(controller: _tracks, onMenuOpenChanged: _setMenuOpen),
        if (!_isTv) const FullscreenToggleButton(),
      ],
    );

    final overlay = AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: _fadeDuration,
      child: IgnorePointer(
        ignoring: !_visible,
        child: Stack(
          children: [
            Align(alignment: Alignment.topCenter, child: _scrim(top: true)),
            Align(
                alignment: Alignment.bottomCenter, child: _scrim(top: false)),
            Positioned(
              top: 0,
              left: 8,
              right: 8,
              child: Row(children: _topBarChildren(loc)),
            ),
            if (centerTransport)
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SkipButtons(iconSize: 36, side: SkipButtonSide.previous),
                    SizedBox(width: 24),
                    PlayPauseButton(iconSize: 56),
                    SizedBox(width: 24),
                    SkipButtons(iconSize: 36, side: SkipButtonSide.next),
                  ],
                ),
              ),
            Positioned(
              left: 12,
              right: 12,
              bottom: fullscreen && touch ? 24 : 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VideoSeekBar(
                    onDragActive: _setSeekDragging,
                    previewPosition: _seekPreview,
                  ),
                  bottomBar,
                ],
              ),
            ),
          ],
        ),
      ),
    );

    Widget result = Stack(
      fit: StackFit.expand,
      children: [
        // Show/hide layer: hover on pointer devices, tap-toggle on touch.
        if (pointer)
          MouseRegion(
            onEnter: (_) => _show(),
            onHover: (_) => _show(),
            opaque: false,
            hitTestBehavior: HitTestBehavior.translucent,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onDoubleTap: _toggleFullscreen,
              onTap: () {},
            ),
          )
        else if (touch && fullscreen)
          VideoGestureLayer(
            onToggleControls: _toggle,
            onSeekDragActive: _setSeekDragging,
          )
        else
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _toggle,
          ),
        overlay,
        // Outside the auto-hiding overlay on purpose: the skip-intro /
        // next-episode prompt must stay visible while the chrome is hidden.
        // Sits above the seek bar; on TV it is only reachable while the
        // controls are revealed (descendantsAreFocusable gates the D-pad).
        Positioned(
          right: 24,
          bottom: fullscreen && touch ? 110 : 84,
          child: const SegmentOverlayButtons(),
        ),
        _bufferingIndicator(),
      ],
    );

    if (pointer) {
      // Keyboard shortcuts. Autofocus only in fullscreen — embedded, the page
      // may hold focus elsewhere; hovering the video claims it.
      result = CallbackShortcuts(
        bindings: _shortcuts,
        child: Focus(
          focusNode: _shortcutsFocusNode,
          autofocus: fullscreen,
          child: MouseRegion(
            opaque: false,
            hitTestBehavior: HitTestBehavior.translucent,
            onEnter: (_) => _shortcutsFocusNode.requestFocus(),
            child: result,
          ),
        ),
      );
    } else if (_isTv) {
      // The root node keeps focus inside the overlay while hidden;
      // descendants only participate in traversal while visible, so the
      // revealing key press can never activate an invisible button.
      result = FocusTraversalGroup(
        child: Focus(
          focusNode: _tvRootNode,
          onKeyEvent: _onTvKeyEvent,
          descendantsAreFocusable: _visible,
          child: result,
        ),
      );
    }
    return result;
  }
}
