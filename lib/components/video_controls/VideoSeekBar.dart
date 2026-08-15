import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/MediaPlayerHandler.dart';
import '../../utils/PlatformService.dart';
import 'VideoControlButtons.dart';

/// The seek bar of the custom video controls: track, buffered range and played
/// range, with a thumb that appears on hover/drag/focus.
///
/// Dragging shows a local preview and issues a single [MediaPlayerHandler.seek]
/// on release — important because a backward seek with active subtitles
/// re-opens the HLS stream (see `seekAware`), which must not happen per drag
/// tick. On TV the bar is focusable: D-pad left/right seeks ±10s, select
/// toggles play/pause.
class VideoSeekBar extends StatefulWidget {
  const VideoSeekBar({super.key, this.onDragActive, this.focusNode});

  /// Reports drag begin/end so the controls shell can suspend auto-hide.
  final ValueChanged<bool>? onDragActive;

  /// Focus node supplied by the shell on TV for traversal ordering.
  final FocusNode? focusNode;

  @override
  State<VideoSeekBar> createState() => _VideoSeekBarState();
}

class _VideoSeekBarState extends State<VideoSeekBar> {
  final MediaPlayerHandler _handler = MediaPlayerHandler.instance;

  late Duration _position;
  late Duration _duration;
  late Duration _buffer;
  final List<StreamSubscription> _subs = [];

  bool _hovered = false;
  bool _focused = false;
  bool _dragging = false;
  double _dragFraction = 0;

  @override
  void initState() {
    super.initState();
    final player = _handler.player;
    _position = player.state.position;
    _duration = player.state.duration;
    _buffer = player.state.buffer;
    _subs.add(_handler.positionSecondsStream.listen((p) {
      if (!_dragging) setState(() => _position = p);
    }));
    _subs.add(player.stream.duration.listen((d) => setState(() => _duration = d)));
    _subs.add(player.stream.buffer.listen((b) => setState(() => _buffer = b)));
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }

  double get _fraction {
    if (_dragging) return _dragFraction;
    if (_duration.inMilliseconds <= 0) return 0;
    return (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0);
  }

  double get _bufferFraction {
    if (_duration.inMilliseconds <= 0) return 0;
    return (_buffer.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0);
  }

  void _startDrag(double fraction) {
    setState(() {
      _dragging = true;
      _dragFraction = fraction;
    });
    widget.onDragActive?.call(true);
  }

  void _endDrag() {
    final target = Duration(
        milliseconds: (_dragFraction * _duration.inMilliseconds).round());
    setState(() {
      _dragging = false;
      // Keep the bar at the target until the next position event so it doesn't
      // jump back while the (possibly stream-reopening) seek is in flight.
      _position = target;
    });
    widget.onDragActive?.call(false);
    unawaited(_handler.seek(target));
  }

  void _seekRelative(Duration delta) {
    final target = _position + delta;
    final clamped = target < Duration.zero
        ? Duration.zero
        : (target > _duration ? _duration : target);
    setState(() => _position = clamped);
    unawaited(_handler.seek(clamped));
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _seekRelative(const Duration(seconds: -10));
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _seekRelative(const Duration(seconds: 10));
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.select ||
        event.logicalKey == LogicalKeyboardKey.enter) {
      if (_handler.player.state.playing) {
        _handler.pause();
      } else {
        _handler.play();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final accent = videoAccentOf(context);
    final focusGlow = Theme.of(context).colorScheme.primary;
    final active = _hovered || _dragging || _focused;
    final barHeight = active ? 6.0 : 4.0;

    Widget bar = LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      double fractionAt(Offset local) => width <= 0
          ? 0
          : (local.dx / width).clamp(0.0, 1.0);

      return MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) => _startDrag(fractionAt(d.localPosition)),
          onTapUp: (_) => _endDrag(),
          onTapCancel: () {
            setState(() => _dragging = false);
            widget.onDragActive?.call(false);
          },
          onHorizontalDragStart: (d) => _startDrag(fractionAt(d.localPosition)),
          onHorizontalDragUpdate: (d) =>
              setState(() => _dragFraction = fractionAt(d.localPosition)),
          onHorizontalDragEnd: (_) => _endDrag(),
          onHorizontalDragCancel: () {
            setState(() => _dragging = false);
            widget.onDragActive?.call(false);
          },
          child: SizedBox(
            height: 24,
            child: Stack(
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.none,
              children: [
                _bar(width, barHeight, Colors.white.withValues(alpha: 0.25)),
                _bar(width * _bufferFraction, barHeight,
                    Colors.white.withValues(alpha: 0.35)),
                _bar(width * _fraction, barHeight, accent),
                if (active)
                  Positioned(
                    left: (width * _fraction) - 6,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });

    if (PlatformService.isAndroidTvSync) {
      // The bar seeks with left/right itself, so it handles its own key events
      // rather than going through TvFocusable's activate-only mapping. The
      // focus glow matches the TvFocusable style.
      bar = Focus(
        focusNode: widget.focusNode,
        onKeyEvent: _onKeyEvent,
        onFocusChange: (f) => setState(() => _focused = f),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: _focused
                ? [
                    BoxShadow(
                      color: focusGlow.withValues(alpha: 0.6),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: bar,
        ),
      );
    }
    return bar;
  }

  Widget _bar(double width, double height, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: width < 0 ? 0 : width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}
