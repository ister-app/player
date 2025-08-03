import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/getPlayQueue.graphql.dart';

import '../graphql/createPlayQueueForShow.graphql.dart';
import '../graphql/updatePlayQueue.graphql.dart';

class PlayQueueService {
  PlayQueueService._privateConstructor();

  static final PlayQueueService _instance =
      PlayQueueService._privateConstructor();

  factory PlayQueueService() {
    return _instance;
  }

  final StreamController<DateTime> playQueueChanges =
      StreamController<DateTime>.broadcast();

  Future<Fragment$fragmentPlayQueue?> getOrCreatePlayQueue(
      GraphQLClient graphQLClient,
      String? playQueueId,
      String episodeId,
      String showId) async {
    if (playQueueId == null) {
      return await _createPlayQueue(graphQLClient, episodeId, showId);
    } else {
      return await _getPlayQueue(graphQLClient, playQueueId);
    }
  }

  Future<Fragment$fragmentPlayQueue?> _createPlayQueue(
      GraphQLClient graphQLClient, String episodeId, String showId) async {
    final MutationOptions options = MutationOptions(
        document: documentNodeMutationcreatePlayQueueForShow,
        variables: Map.of({
          "id": showId,
          "episodeId": episodeId,
        }));
    final QueryResult result = await graphQLClient.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
      return null;
    }
    return Mutation$createPlayQueueForShow.fromJson(result.data!)
        .createPlayQueueForShow;
  }

  Future<Fragment$fragmentPlayQueue?> _getPlayQueue(
      GraphQLClient graphQLClient, String playQueueId) async {
    final QueryResult result = await graphQLClient.query(QueryOptions(
        document: documentNodeQuerygetPlayQueue,
        variables: Map.of({
          "id": playQueueId,
        })));

    if (result.hasException) {
      print(result.exception.toString());
      return null;
    }
    return Query$getPlayQueue.fromJson(result.data!).getPlayQueue;
  }

  Future<void> updateProgress(GraphQLClient graphQLClient, String playQueueId,
      String playQueueItemId, Duration duration) async {
    final MutationOptions options = MutationOptions(
        document: documentNodeMutationupdatePlayQueue,
        variables: Map.of({
          "id": playQueueId,
          "playQueueItemId": playQueueItemId,
          "progressInMilliseconds": duration.inMilliseconds
        }));
    final QueryResult result = await graphQLClient.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
      return;
    }
  }

  void playQueueChanged() {
    playQueueChanges.sink.add(DateTime.now());
  }

  Stream<DateTime> getPlayQueueChangedStream() {
    return playQueueChanges.stream;
  }

  void dispose() {
    playQueueChanges.close();
  }
}
