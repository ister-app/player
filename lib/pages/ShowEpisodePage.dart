import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/PlayQueue.dart';
import 'package:player/graphql/episodeById.graphql.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';
import '../utils/ImageTypes.dart';
import '../utils/ImageUtil.dart';
import '../utils/LoginManager.dart';
import '../utils/MetadataUtil.dart';

@RoutePage()
class ShowEpisodePage extends StatelessWidget {
  const ShowEpisodePage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('showId') required this.showId,
    @PathParam('episodeId') required this.episodeId,
    @QueryParam('playQueueId') this.playQueueId,
  });

  final String serverName;
  final String showId;
  final String episodeId;
  final String? playQueueId;

  @override
  Widget build(BuildContext context) {
    bool loadComplete = false;
    return Query(
      options: QueryOptions(
          document: documentNodeQueryepisodeById,
          // Keep track if the graphql query is done. Otherwise the player can be loaded twice.
          onComplete: (data) => loadComplete = true,
          variables: Map.of({"id": episodeId})),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        } else if (result.isLoading) {
          return Skeletonizer(
              enabled: true,
              child: getContent(
                  false, null, BoneMock.name, BoneMock.words(15), context));
        } else {
          final parsedData = Query$episodeById.fromJson(result.data!);

          Query$episodeById$episodeById? episode = parsedData.episodeById;

          if (episode == null) {
            return const Text('No Episode');
          } else {
            return getContent(
                loadComplete,
                episode,
                MetadataUtil.getTitle(episode.metadata) ??
                    AppLocalizations.of(context)!.episode(episode.number ?? 0),
                MetadataUtil.getDescription(episode.metadata) ?? "",
                context);
          }
        }
      },
    );
  }

  Column getContent(bool loadComplete, Query$episodeById$episodeById? episode,
      String title, String description, BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(color: Colors.grey),
            height: constraints.maxWidth < 800 ? 300 : 500,
            child: episode != null && loadComplete == true
                ? kIsWeb
                    ? LayoutBuilder(builder: (context, constraints) {
                        var imageUrl = ImageUtil.getImageIdByType(
                            episode.images, ImageTypes.background);
                        return Container(
                          height: constraints.maxWidth < 800 ? 300 : 500,
                          width: constraints.maxWidth,
                          decoration: BoxDecoration(color: Colors.grey),
                          child: (imageUrl != null && imageUrl != '')
                              ? Image(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    headers:
                                        LoginManager.getHeaders(serverName),
                                    '${ClientManager.getHttpOrHttps(serverName)}://$serverName/images/$imageUrl/download',
                                  ),
                                )
                              : Container(),
                        );
                      })
                    : PlayQueue(
                        serverName: serverName,
                        episode: episode,
                        playQueueId: playQueueId,
                      )
                : Container(),
          );
        },
      ),
      Container(
          padding: EdgeInsetsGeometry.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            Text(description),
          ])),
    ]);
  }
}
