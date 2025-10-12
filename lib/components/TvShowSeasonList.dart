import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/seasonById.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';
import '../utils/ImageTypes.dart';
import '../utils/ImageUtil.dart';
import '../utils/LoginManager.dart';

class TvShowSeasonList extends StatelessWidget {
  final String serverName;
  final String seasonId;
  final bool expanded;

  const TvShowSeasonList(
      {super.key,
      required this.seasonId,
      required this.expanded,
      required this.serverName});

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return Query(
        options: QueryOptions(
            document: documentNodeQueryseasonById,
            variables: Map.of({
              "id": seasonId,
            })),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            var list = List<Widget>.of([Divider()]);
            list.addAll(ListTile.divideTiles(
                    context: context,
                    tiles: List.filled(7, BoneMock.title).map((e) {
                      return getListTile(context, e, BoneMock.paragraph, false,
                          1, "1", "1", null, null, null);
                    }).toList())
                .toList());
            return Skeletonizer(enabled: true, child: Column(children: list));
          } else {
            final parsedData = Query$seasonById.fromJson(result.data!);

            Query$seasonById$seasonById? season = parsedData.seasonById;

            if (season == null) {
              return const Text('No season');
            } else {
              var list = List<Widget>.of([Divider()]);
              list.addAll(ListTile.divideTiles(
                      context: context,
                      tiles: season.episodes!.map((episode) {
                        var imageByType = ImageUtil.getImageByType(
                            episode.images, ImageTypes.background);
                        return getListTile(
                            context,
                            MetadataUtil.getTitle(episode.metadata) ??
                                AppLocalizations.of(context)!
                                    .episode(episode.number ?? 0),
                            MetadataUtil.getDescription(episode.metadata) ?? "",
                            isWatched(episode),
                            episode.number ?? 0,
                            episode.$show!.id,
                            episode.id,
                            imageByType?.id,
                            imageByType?.blurHash,
                            episode.watchStatus != null &&
                                    episode.watchStatus!.isNotEmpty &&
                                    episode.watchStatus!.first.watched !=
                                        true &&
                                    episode.mediaFile != null &&
                                    episode.mediaFile!.isNotEmpty
                                ? episode.watchStatus!.first
                                        .progressInMilliseconds /
                                    episode.mediaFile!.first!
                                        .durationInMilliseconds!
                                : null);
                      }).toList())
                  .toList());
              return Column(children: list);
            }
          }
        },
      );
    } else {
      return Container();
    }
  }

  ListTile getListTile(
      BuildContext context,
      String title,
      String description,
      bool isWatched,
      int episodeNumber,
      String showId,
      String episodeId,
      String? imageUrl,
      String? blurHash,
      double? progress) {
    return ListTile(
        contentPadding: EdgeInsets.all(0),
        subtitle: Row(children: [
          Expanded(
              child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        Text(description,
                            maxLines: 3,
                            style: Theme.of(context).textTheme.bodyMedium)
                      ]))),
          Stack(alignment: AlignmentDirectional.topEnd, children: <Widget>[
            Container(
                height: 80,
                width: 120,
                decoration: BoxDecoration(color: Colors.grey),
                child: OverflowBox(
                  child: (imageUrl != null && imageUrl != '')
                      ? CachedNetworkImage(
                          placeholder: (context, url) => blurHash != null
                              ? BlurHash(
                                  hash: blurHash,
                                  optimizationMode:
                                      BlurHashOptimizationMode.standard,
                                  color: Colors.grey,
                                  duration: Duration.zero,
                                )
                              : Container(),
                          fit: BoxFit.fitHeight,
                          imageUrl:
                              '${ClientManager.getHttpOrHttps(serverName)}://$serverName/images/$imageUrl/download',
                          httpHeaders: LoginManager.getHeaders(serverName),
                          fadeOutDuration: Duration.zero,
                          fadeInDuration: Duration.zero,
                        )
                      : Container(),
                )),
            Opacity(
                opacity: 0.8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  color: Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "${isWatched ? "✓ " : ""}${AppLocalizations.of(context)!.episodePrefix(episodeNumber)}",
                        overflow: TextOverflow.clip,
                        softWrap: false,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                )),
            progress != null
                ? Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      value: progress,
                    ))
                : Container(),
          ]),
        ]),
        onTap: () => AutoRouter.innerRouterOf(context, ShowOverviewRoute.name)
            ?.navigate(ShowEpisodeRoute(showId: showId, episodeId: episodeId))
        // .pushPath('shows/${e.$show!.id}/episodes/${e.id}')
        // onTap: () => AutoRouter.of(context).navigate(ShowEpisodeRoute(showId: e.$show!.id, episodeId: e.id, serverName: 'servername')),
        );
  }

  static bool isWatched(Query$seasonById$seasonById$episodes episode) {
    return episode.watchStatus != null
        ? episode.watchStatus!.any((element) {
            return element.watched == true;
          })
        : false;
  }
}
