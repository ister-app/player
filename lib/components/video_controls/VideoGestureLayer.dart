import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/MediaPlayerHandler.dart';
import '../../utils/SystemLevels.dart';
import 'GestureMath.dart';
import 'VideoControlButtons.dart';

/// Touch gestures for the fullscreen video surface (mobile only):
///
/// * double-tap on the left/right third seeks −/+10s;
/// * a horizontal drag scrubs on a power curve — short drags stay precise,
///   a full-width drag reaches [GestureMath.maxSeekSeconds] (preview only;
///   one [MediaPlayerHandler.seek] on release, since a backward seek with
///   subtitles re-opens the HLS stream);
/// * a vertical drag on the left half adjusts window brightness, on the
///   right half the device volume (both via [SystemLevels]; on platforms
///   without those plugins volume falls back to the player's own volume);
/// * drags starting in the edge bands are ignored, so the system back-swipe
///   keeps working ([GestureMath.edgeGuard]).
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

/// What the transient overlay shows: a text pill (seek, double-tap) or a
/// YouTube-style circular level indicator (brightness/volume).
class _GestureFeedback {
  const _GestureFeedback.text(this.text)
      : icon = null,
        level = null;

  const _GestureFeedback.level(this.icon, this.level) : text = null;

  final String? text;
  final IconData? icon;
  final double? level;
}

class _VideoGestureLayerState extends State<VideoGestureLayer> {
  static const _doubleTapSeek = Duration(seconds: 10);

  final MediaPlayerHandler _handler = MediaPlayerHandler.instance;

  Timer? _feedbackTimer;
  _GestureFeedback? _feedback;

  bool _seekDragging = false;
  double _seekDragStartX = 0;
  Duration _seekStart = Duration.zero;
  Duration _seekTarget = Duration.zero;

  VerticalGestureZone _verticalZone = VerticalGestureZone.none;

  /// The level we last *requested* (0..1). Displayed instead of a re-read:
  /// Android volume only has ~15-30 steps, so reading back stair-steps.
  double _verticalLevel = 0;

  /// Set once the async base-level read completes; updates before that are
  /// dropped rather than applied to a stale base.
  bool _verticalReady = false;

  bool _brightnessTouched = false;

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    if (_brightnessTouched) {
      // Leaving fullscreen restores the system's own brightness.
      unawaited(SystemLevels.instance.resetBrightness());
    }
    super.dispose();
  }

  void _flash(_GestureFeedback feedback,
      {Duration linger = const Duration(milliseconds: 600)}) {
    setState(() => _feedback = feedback);
    _feedbackTimer?.cancel();
    _feedbackTimer = Timer(linger, () {
      if (mounted) setState(() => _feedback = null);
    });
  }

  void _clearFeedbackSoon() {
    _feedbackTimer?.cancel();
    _feedbackTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _feedback = null);
    });
  }

  double _edgeGuard(BuildContext context) =>
      GestureMath.edgeGuard(MediaQuery.systemGestureInsetsOf(context));

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
      _flash(const _GestureFeedback.text('−10s'));
      unawaited(_handler.seek(target));
    } else if (dx > width - third) {
      final target =
          _clampToMedia(_handler.player.state.position + _doubleTapSeek);
      _flash(const _GestureFeedback.text('+10s'));
      unawaited(_handler.seek(target));
    }
  }

  void _onHorizontalDragStart(DragStartDetails details, double width) {
    if (!GestureMath.dragStartAllowed(
        details.localPosition.dx, width, _edgeGuard(context))) {
      return;
    }
    _seekDragging = true;
    _seekDragStartX = details.localPosition.dx;
    _seekStart = _handler.player.state.position;
    _seekTarget = _seekStart;
    widget.onSeekDragActive(true);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details, double width) {
    if (!_seekDragging) return;
    final usableWidth = width - 2 * _edgeGuard(context);
    final offsetSeconds = GestureMath.seekOffsetSeconds(
        details.localPosition.dx - _seekDragStartX, usableWidth);
    _seekTarget = _clampToMedia(
        _seekStart + Duration(milliseconds: (offsetSeconds * 1000).round()));
    final offset = _seekTarget - _seekStart;
    final sign = offset.isNegative ? '−' : '+';
    setState(() => _feedback = _GestureFeedback.text(
        '$sign${offset.abs().inSeconds}s (${PositionText.format(_seekTarget)})'));
  }

  void _onHorizontalDragEnd() {
    if (!_seekDragging) return;
    _seekDragging = false;
    widget.onSeekDragActive(false);
    _clearFeedbackSoon();
    unawaited(_handler.seek(_seekTarget));
  }

  void _onVerticalDragStart(DragStartDetails details, double width) {
    _verticalZone = GestureMath.verticalZone(
        details.localPosition.dx, width, _edgeGuard(context));
    if (_verticalZone == VerticalGestureZone.none) return;
    _verticalReady = false;
    final zone = _verticalZone;
    unawaited(_baseLevelFor(zone).then((level) {
      if (!mounted || _verticalZone != zone) return;
      _verticalLevel = level.clamp(0.0, 1.0);
      _verticalReady = true;
    }));
  }

  Future<double> _baseLevelFor(VerticalGestureZone zone) async {
    final levels = SystemLevels.instance;
    switch (zone) {
      case VerticalGestureZone.brightness:
        return levels.isSupported ? levels.getBrightness() : 0.5;
      case VerticalGestureZone.volume:
        return levels.isSupported
            ? levels.getVolume()
            : _handler.player.state.volume / 100;
      case VerticalGestureZone.none:
        return 0;
    }
  }

  void _onVerticalDragUpdate(DragUpdateDetails details, double height) {
    if (_verticalZone == VerticalGestureZone.none || !_verticalReady) return;
    _verticalLevel = GestureMath.applyVerticalDelta(
        _verticalLevel, details.primaryDelta ?? 0, height);
    final levels = SystemLevels.instance;
    switch (_verticalZone) {
      case VerticalGestureZone.brightness:
        if (!levels.isSupported) return;
        _brightnessTouched = true;
        unawaited(levels.setBrightness(_verticalLevel));
        setState(() => _feedback =
            _GestureFeedback.level(_brightnessIcon(_verticalLevel),
                _verticalLevel));
      case VerticalGestureZone.volume:
        if (levels.isSupported) {
          unawaited(levels.setVolume(_verticalLevel));
        } else {
          unawaited(_handler.player.setVolume(_verticalLevel * 100));
        }
        setState(() => _feedback = _GestureFeedback.level(
            _volumeIcon(_verticalLevel), _verticalLevel));
      case VerticalGestureZone.none:
        break;
    }
  }

  void _onVerticalDragEnd() {
    if (_verticalZone == VerticalGestureZone.none) return;
    _verticalZone = VerticalGestureZone.none;
    _clearFeedbackSoon();
  }

  static IconData _brightnessIcon(double level) {
    if (level < 0.1) return Icons.brightness_low;
    if (level > 0.9) return Icons.brightness_high;
    return Icons.brightness_medium;
  }

  static IconData _volumeIcon(double level) {
    if (level <= 0) return Icons.volume_off;
    if (level < 0.5) return Icons.volume_down;
    return Icons.volume_up;
  }

  Widget _feedbackOverlay(_GestureFeedback feedback) {
    if (feedback.text != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          feedback.text!,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }
    // Brightness/volume: a dark disc with the icon inside and the level as
    // an arc around it.
    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 116,
            height: 116,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            width: 130,
            height: 130,
            child: CircularProgressIndicator(
              value: feedback.level,
              strokeWidth: 6,
              strokeCap: StrokeCap.round,
              color: Colors.white,
              backgroundColor: Colors.transparent,
            ),
          ),
          Icon(feedback.icon, color: Colors.white, size: 48),
        ],
      ),
    );
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
            onHorizontalDragStart: (d) => _onHorizontalDragStart(d, width),
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
              child: Center(child: _feedbackOverlay(_feedback!)),
            ),
        ],
      );
    });
  }
}
