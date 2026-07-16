import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:flutter/material.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/StreamTokenService.dart';

import '../graphql/fragmentSeries.graphql.dart';
import 'BookCarouselTile.dart';
import 'CarouselItemView.dart';

/// A comic-series cover for the library grid: tap opens the series with its
/// volumes. The cover is the series' own artwork when it has any, else the
/// server already fell back to the first volume's cover.
class SeriesCarouselTile extends StatelessWidget {
  const SeriesCarouselTile({
    super.key,
    required this.serverName,
    required this.series,
  });

  final String serverName;
  final Fragment$fragmentSeries series;

  @override
  Widget build(BuildContext context) {
    final img = series.cover ??
        ImageUtil.getImageByType(series.images, ImageTypes.cover);
    return CarouselItemView(
      serverName: serverName,
      title: series.name,
      subTitle: series.startYear > 0 ? '${series.startYear}' : '',
      imageUrl: ImageUtil.buildUrl(img,
          token: StreamTokenService.getToken(serverName)),
      blurHash: img?.blurHash,
      placeholderIcon: Icons.auto_stories,
      portraitArtwork: true,
      onTap: () =>
          AutoRouter.of(context).push(SeriesRoute(seriesId: series.id)),
    );
  }

  /// Series covers share the book cover shape.
  static const double coverAspectRatio = BookCarouselTile.coverAspectRatio;
}
