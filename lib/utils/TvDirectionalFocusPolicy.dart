import 'package:flutter/material.dart';

/// Directional traversal policy for D-pad navigation that keeps vertical moves
/// inside the scrollable the focus is currently in.
///
/// Flutter's default directional policy picks the geometrically nearest
/// focusable in the pressed direction. With a sticky bar below a scrollable
/// page (the mini player), everything below the fold loses that contest: the
/// visible bar is always nearer than an off-screen item, so D-pad DOWN jumps
/// to the bar and the rest of the page becomes unreachable (e.g. the season
/// list on the show page, below the cast row).
///
/// This policy lets the default pick stand whenever it stays inside one of the
/// current node's enclosing vertical scrollables. When the default pick would
/// leave them (or nothing was found) while an unvisited focusable still exists
/// further along inside, that in-scrollable candidate wins instead and is
/// scrolled into view. Leaving the scrollable remains possible the moment no
/// in-scrollable candidate is left in the pressed direction — so the mini
/// player is still reached from the last row of a page.
class TvDirectionalFocusPolicy extends ReadingOrderTraversalPolicy {
  @override
  bool inDirection(FocusNode currentNode, TraversalDirection direction) {
    if (direction != TraversalDirection.up &&
        direction != TraversalDirection.down) {
      return super.inDirection(currentNode, direction);
    }
    final scrollables = _enclosingVerticalScrollables(currentNode.context);
    if (scrollables.isEmpty) return super.inDirection(currentNode, direction);

    final moved = super.inDirection(currentNode, direction);
    if (moved) {
      final landed = FocusManager.instance.primaryFocus;
      if (landed == null ||
          _enclosingVerticalScrollables(landed.context)
              .any(scrollables.contains)) {
        return true;
      }
    }

    final candidate =
        _nearestInScrollables(currentNode, direction, scrollables);
    if (candidate == null) return moved;
    candidate.requestFocus();
    final context = candidate.context;
    if (context != null) {
      // The diverted-to candidate is typically below the fold; plain focusables
      // (unlike TvFocusable) don't scroll themselves into view.
      Scrollable.ensureVisible(
        context,
        alignment: 0.5,
        duration: const Duration(milliseconds: 150),
      );
    }
    return true;
  }

  /// All vertical [ScrollableState]s enclosing [context], innermost first.
  /// More than one element is real on pages that nest a scrollable content
  /// pane inside a scrolling page (e.g. the show overview page).
  static List<ScrollableState> _enclosingVerticalScrollables(
      BuildContext? context) {
    final result = <ScrollableState>[];
    var current = context;
    while (current != null) {
      final scrollable = current.findAncestorStateOfType<ScrollableState>();
      if (scrollable == null) break;
      if (scrollable.position.axis == Axis.vertical) result.add(scrollable);
      current = scrollable.context;
    }
    return result;
  }

  /// The nearest traversable node strictly beyond [currentNode] in
  /// [direction] that lives inside one of [scrollables].
  ///
  /// Candidates come from the *root* scope, not [FocusNode.nearestScope]: the
  /// show page nests a router, so the cast row (nested route, own scope) and
  /// the season list (parent route) share a scrollable but never a scope.
  /// Covered routes stay excluded — their scopes are not focusable, so their
  /// descendants don't appear in [FocusScopeNode.traversalDescendants].
  static FocusNode? _nearestInScrollables(FocusNode currentNode,
      TraversalDirection direction, List<ScrollableState> scrollables) {
    final scope = FocusManager.instance.rootScope;
    final currentRect = currentNode.rect;
    FocusNode? best;
    double? bestDistance;
    for (final node in scope.traversalDescendants) {
      if (identical(node, currentNode)) continue;
      if (node.context == null) continue;
      if (currentNode.ancestors.contains(node) ||
          node.ancestors.contains(currentNode)) {
        continue;
      }
      final rect = node.rect;
      final double distance;
      if (direction == TraversalDirection.down) {
        if (rect.top < currentRect.bottom - 1) continue;
        distance = rect.top - currentRect.bottom;
      } else {
        if (rect.bottom > currentRect.top + 1) continue;
        distance = currentRect.top - rect.bottom;
      }
      if (!_enclosingVerticalScrollables(node.context)
          .any(scrollables.contains)) {
        continue;
      }
      // Primary sort: distance along the axis; tie-break on horizontal offset
      // so the visually aligned candidate wins within a row.
      final horizontal = (rect.center.dx - currentRect.center.dx).abs();
      final score = distance * 10000 + horizontal;
      if (bestDistance == null || score < bestDistance) {
        bestDistance = score;
        best = node;
      }
    }
    return best;
  }
}
