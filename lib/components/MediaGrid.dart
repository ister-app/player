import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:player/components/CarouselItemView.dart';

/// Grid delegate for media tile grids, replacing the old
/// `SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 300,
/// childAspectRatio: art)` pattern now that tiles carry a caption below the
/// artwork. [artAspectRatio] is the artwork's width/height — the old
/// childAspectRatio values, which described the art because the caption used
/// to overlay it.
///
/// Wide layouts keep the old column count (ceil(width / 300)); below 600dp at
/// least three columns are forced so phones show three tiles per row. The
/// cell height is fixed (art at its aspect ratio plus the caption) rather
/// than ratio-derived — see CastRow for the precedent.
SliverGridDelegate mediaGridDelegate(
  BuildContext context,
  double maxWidth, {
  required double artAspectRatio,
}) {
  var columns = (maxWidth / 300).ceil().clamp(1, 100);
  if (maxWidth < 600) columns = math.max(columns, 3);
  final tileWidth = maxWidth / columns;
  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: columns,
    mainAxisExtent:
        tileWidth / artAspectRatio + CarouselItemView.captionHeightOf(context),
  );
}
