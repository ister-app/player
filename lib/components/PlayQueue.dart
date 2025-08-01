import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/IsterPlayer.dart';
import 'package:player/graphql/updatePlayQueue.graphql.dart';
import 'package:player/utils/PlayQueueService.dart';

import '../graphql/createPlayQueueForShow.graphql.dart';
import '../graphql/episodeById.graphql.dart';
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

    return Mutation(
      options: MutationOptions(
        document: documentNodeMutationcreatePlayQueueForShow,
      ),
      builder: (runMutation, result) {
        if (result == null || result.data == null) {
          runMutation(Map.of({
            "id": episode!.$show!.id,
            "episodeId": episode!.id,
          }));
          return Container(child: Text("null"));
        } else if (result.hasException) {
          return Text(result.exception.toString());
        } else if (result.isLoading) {
          return Container(child: Text("loading"));
        } else {
          final parsedData =
              Mutation$createPlayQueueForShow.fromJson(result.data!);
          final playQueueObject = parsedData.createPlayQueueForShow;
          if (playQueueObject == null) {
            return const Text("Something went wrong");
          } else {
            return IsterPlayer(
              serverName: serverName,
              mediaId: episode!.mediaFile!.first.id,
              startTimeInMilliseconds: episode!.watchStatus != null &&
                      episode!.watchStatus!.isNotEmpty &&
                      episode!.watchStatus!.first.watched == false
                  ? episode?.watchStatus?.first.progressInMilliseconds
                  : null,
              onProgressChanged: (duration) {
                playQueueService.updateProgress(graphQLClient,
                    playQueueObject.id, playQueueObject.currentItem!, duration);
              },
              onCompleted: (completed) {
                if (completed) {
                  playQueueService.playQueueChanged();
                  for (int i = 0;
                      i < playQueueObject.playQueueItems!.length;
                      i++) {
                    if (playQueueObject.playQueueItems![i].id ==
                            playQueueObject.currentItem &&
                        i + 1 < playQueueObject.playQueueItems!.length) {
                      AutoRouter.of(context).navigate(ShowEpisodeRoute(
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
}
