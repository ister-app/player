import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/MediaPlayerHandler.dart';
import 'VideoControlButtons.dart';

/// Touch gestures for the fullscreen video surface (mobile only):
///
/// * double-tap on the left/right third seeks −/+10s;
/// * a horizontal drag scrubs (preview only; one [MediaPlayerHandler.seek] on
///   release, since a backward seek with subtitles re-opens the HLS stream);
/// * a vertical drag on the right half adjusts the player volume.
///
/// Brightness is deliberately not handled: the media_kit fork stripped the
/// system-brightness plugin, so the stock controls' brightness gesture was
/// already a no-op in this app, and player volume needs no extra plugin.
class VideoGestureLayer extends StatefulWidget {
  const VideoGestureLayer({
    super.key,
    required this.onToggleControls,
    required this.onSeekDragActive,
  });

  final VoidCallback onToggleControls;

  /// Reports scrub begin/end so the controls shell suspends auto-hide.
  final ValueChanged<bool> onSeekDragActive;

  @override
  State<VideoGestureLayer> createState() => _VideoGestureLayerState();
}

class _VideoGestureLayerState extends State<VideoGestureLayer> {
  static const _doubleTapSeek = Duration(seconds: 10);

  /// Dragging across the full width scrubs this far.
  static const _fullWidthDrag = Duration(seconds: 90);

  final MediaPlayerHandler _handler = MediaPlayerHandler.instance;

  Timer? _feedbackTimer;
  String? _feedback;

  bool _seekDragging = false;
  Duration _seekStart = Duration.zero;
  Duration _seekTarget = Duration.zero;

  bool _volumeDragging = false;
  double _volumeStart = 0;

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    super.dispose();
  }

  void _flash(String text) {
    setState(() => _feedback = text);
    _feedbackTimer?.cancel();
    _feedbackTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _feedback = null);
    });
  }

  Duration _clampToMedia(Duration d) {
    final duration = _handler.player.state.duration;
    if (d < Duration.zero) return Duration.zero;
    if (duration > Duration.zero && d > duration) return duration;
    return d;
  }

  void _onDoubleTapDown(TapDownDetails details, double width) {
    final third = width / 3;
    final dx = details.localPosition.dx;
    if (dx < third) {
      final target =
          _clampToMedia(_handler.player.state.position - _doubleTapSeek);
      _flash('−10s');
      unawaited(_handler.seek(target));
    } else if (dx > width - third) {
      final target =
          _clampToMedia(_handler.player.state.position + _doubleTapSeek);
      _flash('+10s');
      unawaited(_handler.seek(target));
    }
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    _seekDragging = true;
    _seekStart = _handler.player.state.position;
    _seekTarget = _seekStart;
    widget.onSeekDragActive(true);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details, double width) {
    if (!_seekDragging) return;
    final deltaMs =
        (details.primaryDelta ?? 0) / width * _fullWidthDrag.inMilliseconds;
    _seekTarget =
        _clampToMedia(_seekTarget + Duration(milliseconds: deltaMs.round()));
    final offset = _seekTarget - _seekStart;
    final sign = offset.isNegative ? '−' : '+';
    setState(() => _feedback =
        '$sign${offset.abs().inSeconds}s (${PositionText.format(_seekTarget)})');
  }

  void _onHorizontalDragEnd() {
    if (!_seekDragging) return;
    _seekDragging = false;
    widget.onSeekDragActive(false);
    _feedbackTimer?.cancel();
    _feedbackTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _feedback = null);
    });
    unawaited(_handler.seek(_seekTarget));
  }

  void _onVerticalDragStart(DragStartDetails details, double width) {
    // Volume rides on the right half only, matching the stock layout (the
    // left half was brightness there).
    if (details.localPosition.dx < width / 2) return;
    _volumeDragging = true;
    _volumeStart = _handler.player.state.volume;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details, double height) {
    if (!_volumeDragging) return;
    // Dragging the full height sweeps the whole volume range.
    _volumeStart = (_volumeStart -
            (details.primaryDelta ?? 0) / height * 100)
        .clamp(0.0, 100.0);
    unawaited(_handler.player.setVolume(_volumeStart));
    setState(() => _feedback = '${_volumeStart.round()}%');
  }

  void _onVerticalDragEnd() {
    if (!_volumeDragging) return;
    _volumeDragging = false;
    _feedbackTimer?.cancel();
    _feedbackTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _feedback = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final height = constraints.maxHeight;
      return Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: widget.onToggleControls,
            onDoubleTapDown: (d) => _onDoubleTapDown(d, width),
            // GestureDetector needs onDoubleTap non-null for onDoubleTapDown
            // to fire.
            onDoubleTap: () {},
            onHorizontalDragStart: _onHorizontalDragStart,
            onHorizontalDragUpdate: (d) => _onHorizontalDragUpdate(d, width),
            onHorizontalDragEnd: (_) => _onHorizontalDragEnd(),
            onHorizontalDragCancel: _onHorizontalDragEnd,
            onVerticalDragStart: (d) => _onVerticalDragStart(d, width),
            onVerticalDragUpdate: (d) => _onVerticalDragUpdate(d, height),
            onVerticalDragEnd: (_) => _onVerticalDragEnd(),
            onVerticalDragCancel: _onVerticalDragEnd,
          ),
          if (_feedback != null)
            IgnorePointer(
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    _feedback!,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
