import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// What a vertical drag adjusts, decided by where it starts.
enum VerticalGestureZone { none, brightness, volume }

/// Pure math behind [VideoGestureLayer]'s swipes, kept widget-free so the
/// curve and zone rules are unit-testable (see test/gesture_math_test.dart).
class GestureMath {
  GestureMath._();

  /// Exponent of the seek curve: small drags stay near-linear and precise,
  /// long drags accelerate toward [maxSeekSeconds].
  static const double seekGamma = 1.8;

  /// A drag across the full usable width seeks this far.
  static const double maxSeekSeconds = 600;

  /// Gesture-free band at the left/right edges, so the system back-swipe
  /// keeps working. [minimum] is the floor for when the system reports no
  /// gesture insets (iOS, 3-button navigation, immersive fullscreen).
  static double edgeGuard(EdgeInsets systemGestureInsets,
      {double minimum = 24}) {
    return math.max(
        math.max(systemGestureInsets.left, systemGestureInsets.right),
        minimum);
  }

  /// Whether a drag starting at [startX] is ours to handle at all.
  static bool dragStartAllowed(double startX, double width, double guard) {
    return startX >= guard && startX <= width - guard;
  }

  /// Left half adjusts brightness, right half volume; the edge bands adjust
  /// nothing.
  static VerticalGestureZone verticalZone(
      double startX, double width, double guard) {
    if (!dragStartAllowed(startX, width, guard)) {
      return VerticalGestureZone.none;
    }
    return startX < width / 2
        ? VerticalGestureZone.brightness
        : VerticalGestureZone.volume;
  }

  /// Seek offset for a cumulative horizontal travel of [dx] since the drag
  /// began: `sign(dx) · maxSeek · (|dx|/usableWidth)^γ`. Cumulative rather
  /// than per-delta so reversing the finger walks back down the same curve.
  static double seekOffsetSeconds(double dx, double usableWidth,
      {double gamma = seekGamma, double maxSeek = maxSeekSeconds}) {
    if (usableWidth <= 0 || dx == 0) return 0;
    final fraction = (dx.abs() / usableWidth).clamp(0.0, 1.0);
    return dx.sign * maxSeek * math.pow(fraction, gamma);
  }

  /// One vertical drag step applied to a 0..1 level; a full-height sweep
  /// covers the whole range, dragging up (negative delta) increases.
  static double applyVerticalDelta(
      double current, double primaryDelta, double height) {
    if (height <= 0) return current.clamp(0.0, 1.0);
    return (current - primaryDelta / height).clamp(0.0, 1.0);
  }
}
