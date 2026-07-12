import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:flutter/material.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';

import '../graphql/fragmentPodcast.graphql.dart';
import 'CarouselItemView.dart';

/// A podcast cover for a carousel or grid: tap opens the podcast. Shared by
/// [PodcastSlide] and [PodcastScroll].
class PodcastCarouselTile extends StatelessWidget {
  const PodcastCarouselTile({
    super.key,
    required this.serverName,
    required this.podcast,
  });

  final String serverName;
  final Fragment$fragmentPodcast podcast;

  @override
  Widget build(BuildContext context) {
    final img = ImageUtil.getImageByType(podcast.images, ImageTypes.cover);
    return CarouselItemView(
      serverName: serverName,
      title: MetadataUtil.getTitle(podcast.metadata) ?? podcast.title,
      subTitle: podcast.author ?? '',
      imageUrl: ImageUtil.buildUrl(img,
          token: StreamTokenService.getToken(serverName)),
      blurHash: img?.blurHash,
      placeholderIcon: Icons.podcasts,
      onTap: () =>
          AutoRouter.of(context).push(PodcastRoute(podcastId: podcast.id)),
    );
  }
}
