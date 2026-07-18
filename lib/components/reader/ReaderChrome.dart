import 'package:flutter/material.dart';

/// One overlay bar of a fullscreen reader (top app bar or bottom controls),
/// laid over the content in a [Stack] instead of occupying a Scaffold slot, so
/// toggling it never resizes the page being read. Slides/fades in ~200 ms and
/// ignores pointers while hidden, so a hidden bar can't eat the reader's tap
/// zones.
class ReaderChrome extends StatelessWidget {
  const ReaderChrome({
    super.key,
    required this.visible,
    required this.alignment,
    required this.child,
  });

  final bool visible;

  /// [Alignment.topCenter] or [Alignment.bottomCenter]; also picks the slide
  /// direction and which side keeps its safe-area inset.
  final Alignment alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final top = alignment.y < 0;
    return Align(
      alignment: alignment,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : Offset(0, top ? -1 : 1),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: IgnorePointer(
            ignoring: !visible,
            child: SafeArea(
              top: top,
              bottom: !top,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
