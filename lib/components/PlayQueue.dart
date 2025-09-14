import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/IsterPlayer.dart';
import 'package:player/utils/PlayQueueService.dart';

import '../graphql/episodeById.graphql.dart';
import '../graphql/fragmentPlayQueue.graphql.dart';
import '../routes/AppRouter.gr.dart';

class PlayQueue extends StatefulWidget {
  final String serverName;
  final Query$episodeById$episodeById? episode;
  final String? playQueueId;

  const PlayQueue({
    super.key,
    required this.episode,
    required this.serverName,
    this.playQueueId,
  });

  @override
  _PlayQueueState createState() => _PlayQueueState();
}

class _PlayQueueState extends State<PlayQueue> {
  late Future<Fragment$fragmentPlayQueue?> _playQueueFuture;
  final PlayQueueService _playQueueService = PlayQueueService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateFuture();
  }

  @override
  void didUpdateWidget(PlayQueue oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.episode!.id != widget.episode!.id || oldWidget.serverName != oldWidget.serverName) {
      updateFuture();
    }
  }

  void updateFuture() {
    _playQueueFuture = _playQueueService.getOrCreatePlayQueue(
      GraphQLProvider.of(context).value,
      widget.playQueueId,
      widget.episode!.id,
      widget.episode!.$show!.id,
      getStartTimeInMilliseconds(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.episode == null || widget.episode!.$show == null) {
      return const Text("episode null");
    }

    return FutureBuilder<Fragment$fragmentPlayQueue?>(
      future: _playQueueFuture,
      builder: (BuildContext context,
          AsyncSnapshot<Fragment$fragmentPlayQueue?> snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Text("Something went wrong");
        } else {
          final playQueueObject = snapshot.data!;
          return IsterPlayer(
            serverName: widget.serverName,
            mediaId: widget.episode!.mediaFile!.first.id,
            startTimeInMilliseconds: getStartTimeInMilliseconds(),
            onProgressChanged: (duration) {
              var playQueueItemId = _playQueueService.getPlayQueueItemId(
                  playQueueObject, widget.episode!.id);
              if (playQueueItemId != null) {
                _playQueueService.updateProgress(
                  GraphQLProvider.of(context).value,
                  playQueueObject.id,
                  playQueueItemId,
                  duration,
                );
              }
            },
            onCompleted: (completed) {
              if (completed) {
                _playQueueService.playQueueChanged();
                for (int i = 0;
                    i < playQueueObject.playQueueItems!.length;
                    i++) {
                  if (playQueueObject.playQueueItems![i].itemId ==
                          widget.episode!.id &&
                      i + 1 < playQueueObject.playQueueItems!.length) {
                    AutoRouter.of(context).navigate(ShowEpisodeRoute(
                      playQueueId: playQueueObject.id,
                      showId: widget.episode!.$show!.id,
                      episodeId: playQueueObject.playQueueItems![i + 1].itemId,
                    ));
                    return;
                  }
                }
              }
            },
          );
        }
      },
    );
  }

  int? getStartTimeInMilliseconds() {
    return widget.episode!.watchStatus != null &&
            widget.episode!.watchStatus!.isNotEmpty &&
            widget.episode!.watchStatus!.first.watched == false
        ? widget.episode?.watchStatus?.first.progressInMilliseconds
        : null;
  }
}
