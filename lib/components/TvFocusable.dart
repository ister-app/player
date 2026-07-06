import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Intent fired by the remote/keyboard "menu" key to open a focused item's
/// context menu (the D-pad equivalent of a long-press / right-click).
class _MenuIntent extends Intent {
  const _MenuIntent();
}

/// Wraps a tappable [child] so it can be reached and activated with a D-pad /
/// remote on Android TV (and keyboard on desktop/web), and draws a visible
/// highlight while focused.
///
/// The child keeps handling pointer taps itself (its own [InkWell]/
/// [GestureDetector]); this wrapper only adds the focus node, maps the
/// select/enter key to [onTap], and shows the highlight. The highlight is
/// driven by [FocusableActionDetector.onShowFocusHighlight], so it appears only
/// during directional/keyboard navigation — touch users never see a stray ring.
class TvFocusable extends StatefulWidget {
  const TvFocusable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.autofocus = false,
    this.focusNode,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.scale = 1.0,
  });

  final Widget child;

  /// Invoked on D-pad select / Enter / Space while focused. Pointer taps are
  /// handled by [child], so this is usually the same callback the child uses.
  final VoidCallback? onTap;

  /// Invoked on the remote/keyboard "menu" key (the D-pad equivalent of a
  /// long-press). Wire this to whatever the child does on long-press so context
  /// menus are reachable without a touchscreen.
  final VoidCallback? onLongPress;
  final bool autofocus;
  final FocusNode? focusNode;
  final BorderRadius borderRadius;

  /// Amount to scale the child up while focused. Use ~1.05–1.08 for poster
  /// tiles; leave at 1.0 for full-width rows where a background tint reads
  /// better than a zoom.
  final double scale;

  @override
  State<TvFocusable> createState() => _TvFocusableState();
}

class _TvFocusableState extends State<TvFocusable> {
  bool _focused = false;

  void _setFocused(bool value) {
    if (value != _focused) setState(() => _focused = value);
    // When focus lands here via D-pad/keyboard, scroll the item into view so
    // off-screen grid/carousel items become reachable. Runs after layout so
    // the render object exists; centred so there's always a hint of the next
    // row/column to move toward.
    if (value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (Scrollable.maybeOf(context) == null) return;
        Scrollable.ensureVisible(
          context,
          alignment: 0.5,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FocusableActionDetector(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onShowFocusHighlight: _setFocused,
      mouseCursor:
          widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      shortcuts: widget.onLongPress != null
          ? const <ShortcutActivator, Intent>{
              SingleActivator(LogicalKeyboardKey.contextMenu): _MenuIntent(),
            }
          : null,
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap?.call();
            return null;
          },
        ),
        if (widget.onLongPress != null)
          _MenuIntent: CallbackAction<_MenuIntent>(
            onInvoke: (_) {
              widget.onLongPress!.call();
              return null;
            },
          ),
      },
      child: AnimatedScale(
        scale: _focused ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            color: _focused
                ? scheme.primary.withValues(alpha: 0.18)
                : Colors.transparent,
            // A soft glow so the focused item reads clearly from across a room.
            boxShadow: _focused
                ? <BoxShadow>[
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.6),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          // Border goes in the foreground so it paints over edge-to-edge
          // children (e.g. a poster image that fills the whole tile) instead of
          // being hidden behind them.
          foregroundDecoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            border: Border.all(
              color: _focused ? scheme.primary : Colors.transparent,
              width: 3,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
