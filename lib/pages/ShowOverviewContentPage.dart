import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/showById.graphql.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../utils/ClientManager.dart';
import '../utils/ImageTypes.dart';
import '../utils/ImageUtil.dart';
import '../utils/LoginManager.dart';
import '../utils/MetadataUtil.dart';

@RoutePage()
class ShowOverviewContentPage extends StatelessWidget {
  const ShowOverviewContentPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('showId') required this.showId,
  });

  final String serverName;
  final String showId;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
          // document: gql(getEpisodesRecentWatched),
          document: documentNodeQueryshowById,
          variables: Map.of({"id": showId})),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        Widget body = Text("Body");

        if (result.hasException) {
          body = Text(result.exception.toString());
        } else if (result.data == null && result.isLoading) {
          body = Skeletonizer(
              enabled: true,
              child: getContent(
                  null, null, BoneMock.name, BoneMock.words(15), context));
          // Skeletonizer(enabled: true, child: Text(BoneMock.name));
        } else {
          final parsedData = Query$showById.fromJson(result.data!);

          Query$showById$showById? show = parsedData.showById;

          if (show == null) {
            body = const Text('No show found');
          } else {
            var imageByType =
                ImageUtil.getImageByType(show.images, ImageTypes.background);
            body = getContent(
                imageByType?.id,
                imageByType?.blurHash,
                MetadataUtil.getTitle(show.metadata) ?? "",
                MetadataUtil.getDescription(show.metadata) ?? "",
                context);
          }
        }

        return body;
      },
    );
  }

  SingleChildScrollView getContent(String? imageUrl, String? blurHash,
      String title, String description, BuildContext context) {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      LayoutBuilder(builder: (context, constraints) {
        return Container(
          height: constraints.maxWidth < 800 ? 300 : 500,
          width: constraints.maxWidth,
          decoration: BoxDecoration(color: Colors.grey),
          child: (imageUrl != null && imageUrl != '')
              ? CachedNetworkImage(
                  placeholder: (context, url) => blurHash != null
                      ? BlurHash(
                          hash: blurHash,
                          optimizationMode: BlurHashOptimizationMode.standard,
                          color: Colors.grey,
                          duration: Duration.zero,
                        )
                      : Container(),
                  fit: BoxFit.cover,
                  httpHeaders: LoginManager.getHeaders(serverName),
                  imageUrl:
                      '${ClientManager.getHttpOrHttps(serverName)}://$serverName/images/$imageUrl/download',
                  fadeOutDuration: Duration.zero,
                  fadeInDuration: Duration.zero,
                )
              : Container(),
        );
      }),
      Container(
          padding: EdgeInsetsGeometry.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            Text(description),
          ])),
    ]));
  }
}
