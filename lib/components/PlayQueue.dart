import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/IsterPlayer.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/PlayQueueService.dart';

import '../graphql/episodeById.graphql.dart';
import '../graphql/fragmentPlayQueue.graphql.dart';
import '../routes/AppRouter.gr.dart';

class PlayQueue extends StatelessWidget {
  final String serverName;
  final Query$episodeById$episodeById? episode;
  final String? playQueueId;

  const PlayQueue(
      {super.key,
      required this.episode,
      required this.serverName,
      this.playQueueId});

  @override
  Widget build(BuildContext context) {
    if (episode == null || episode!.$show == null) {
      return Text("episode null");
    }
    GraphQLClient graphQLClient = GraphQLProvider.of(context).value;
    PlayQueueService playQueueService = PlayQueueService();

    return FutureBuilder<Fragment$fragmentPlayQueue?>(
      future: playQueueService.getOrCreatePlayQueue(graphQLClient, playQueueId,
          episode!.id, episode!.$show!.id, getStartTimeInMilliseconds()),
      builder: (BuildContext context,
          AsyncSnapshot<Fragment$fragmentPlayQueue?> snapshot) {
        if (snapshot.hasError == true) {
          return Text("Error");
        } else if (snapshot.hasData == false || snapshot.data == null) {
          return Container(child: Text("loading"));
        } else {
          final playQueueObject = snapshot!.data;
          if (playQueueObject == null) {
            return const Text("Something went wrong");
          } else {
            return IsterPlayer(
              serverName: serverName,
              mediaId: episode!.mediaFile!.first.id,
              startTimeInMilliseconds: getStartTimeInMilliseconds(),
              onProgressChanged: (duration) {
                var playQueueItemId = playQueueService.getPlayQueueItemId(
                    playQueueObject, episode!.id);
                if (playQueueItemId != null) {
                  playQueueService.updateProgress(graphQLClient,
                      playQueueObject.id, playQueueItemId, duration);
                }
              },
              onCompleted: (completed) {
                if (completed) {
                  playQueueService.playQueueChanged();
                  for (int i = 0;
                      i < playQueueObject.playQueueItems!.length;
                      i++) {
                    if (playQueueObject.playQueueItems![i].itemId ==
                            episode!.id &&
                        i + 1 < playQueueObject.playQueueItems!.length) {
                      AutoRouter.of(context).navigate(ShowEpisodeRoute(
                          playQueueId: playQueueObject.id,
                          showId: episode!.$show!.id,
                          episodeId:
                              playQueueObject.playQueueItems![i + 1].itemId));
                      return;
                    }
                  }
                }
              },
            );
          }
        }
      },
    );
  }

  int? getStartTimeInMilliseconds() {
    return episode!.watchStatus != null &&
            episode!.watchStatus!.isNotEmpty &&
            episode!.watchStatus!.first.watched == false
        ? episode?.watchStatus?.first.progressInMilliseconds
        : null;
  }
}
