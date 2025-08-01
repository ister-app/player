import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql/updatePlayQueue.graphql.dart';

class PlayQueueService {
  PlayQueueService._privateConstructor();
  static final PlayQueueService _instance = PlayQueueService._privateConstructor();

  factory PlayQueueService() {
    return _instance;
  }

  final StreamController<DateTime> playQueueChanges = StreamController<DateTime>.broadcast();

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
