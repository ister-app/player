import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

/// The four D-pad directions, input-source agnostic.
enum TvDirection { up, down, left, right }

/// The shared behaviour sinks for TV-mode input.
///
/// Keyboard input (a remote, or Steam Input's keyboard-style layout) reaches
/// these behaviours through Flutter's own key pipeline — default shortcuts,
/// [TvBackKeyHandler], the video controls' key handler. A native gamepad
/// bypasses that pipeline entirely, so [GamepadNavigationService] calls these
/// methods instead; both paths converge on the same intents and handler calls
/// and can never drift apart.
class TvInputCommands {
  TvInputCommands._();

  /// Registered by the TV video controls while mounted: return `true` to
  /// consume the command (the controls were hidden and the press only reveals
  /// them — mirroring how their key handler swallows the revealing press).
  /// Transport commands ([playPause], [next], [previous]) bypass this on
  /// purpose: they act on global playback, not on the focused widget.
  static bool Function()? videoControlsInterceptor;

  /// Registered alongside [videoControlsInterceptor]: called for every
  /// non-consumed command so visible controls restart their hide countdown,
  /// like any key press does.
  static VoidCallback? videoControlsActivity;

  /// The root back action, wired in `_MainState.initState` to the router
  /// delegate's popRoute — the same sink [TvBackKeyHandler] uses, so the
  /// music-player overlay keeps its slide-down dismissal on a gamepad too.
  static VoidCallback? onBack;

  static bool _intercepted() {
    if (videoControlsInterceptor?.call() ?? false) return true;
    videoControlsActivity?.call();
    return false;
  }

  static void direction(TvDirection direction) {
    if (_intercepted()) return;
    final context = primaryFocus?.context;
    if (context == null) return;
    Actions.maybeInvoke(
      context,
      DirectionalFocusIntent(switch (direction) {
        TvDirection.up => TraversalDirection.up,
        TvDirection.down => TraversalDirection.down,
        TvDirection.left => TraversalDirection.left,
        TvDirection.right => TraversalDirection.right,
      }),
    );
  }

  static void activate() {
    if (_intercepted()) return;
    final context = primaryFocus?.context;
    if (context == null) return;
    // ActivateIntent is the one intent TvFocusable handles (and what the
    // default Enter/Select shortcuts produce), so a gamepad A press behaves
    // exactly like the select key.
    Actions.maybeInvoke(context, const ActivateIntent());
  }

  static void back() {
    if (_intercepted()) return;
    onBack?.call();
  }

  static void playPause() {
    videoControlsActivity?.call();
    final handler = MediaPlayerHandler.instance;
    unawaited(
      handler.playbackState.value.playing ? handler.pause() : handler.play(),
    );
  }

  static void next() {
    videoControlsActivity?.call();
    unawaited(MediaPlayerHandler.instance.skipToNext());
  }

  static void previous() {
    videoControlsActivity?.call();
    unawaited(MediaPlayerHandler.instance.skipToPrevious());
  }
}
