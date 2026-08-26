import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Wraps [child] in an enabled [Skeletonizer], unless one is already enabled
/// higher up the tree.
///
/// Placeholder widgets are used from two positions: on their own (a slot in an
/// otherwise loaded paged list that hasn't been fetched yet) and inside a
/// page-level skeleton (a cast strip on a movie page that is itself still
/// loading). In the second position a nested `Skeletonizer(enabled: true)`
/// paints bones on top of bones, each with its own shimmer animation — use
/// this instead of hardcoding `enabled: true`.
class SkeletonPlaceholder extends StatelessWidget {
  const SkeletonPlaceholder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (Skeletonizer.maybeOf(context)?.enabled ?? false) return child;
    return Skeletonizer(enabled: true, child: child);
  }
}
