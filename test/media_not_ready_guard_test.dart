import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/graphql/fragmentEpisode.graphql.dart';
import 'package:player/graphql/fragmentMovie.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';

/// An episode that exists in metadata but whose media file has not been
/// scanned/analyzed yet — the "not ready" state that used to crash playback
/// on mediaFile!.first.
final _pendingEpisode = Fragment$fragmentEpisode(
  id: 'ep-pending',
  number: 1,
  $show: Fragment$fragmentEpisode$show(id: 'show-1'),
  mediaFile: null,
);

final _pendingMovie = Fragment$fragmentMovie(
  id: 'mv-pending',
  name: 'Pending Movie',
  releaseYear: 2024,
  mediaFile: const [],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;

  /// Mutations the mock server received.
  final mutations = <String>[];

  MockClient fakeGraphQL() => MockClient((request) async {
        final body = json.decode(request.body) as Map<String, dynamic>;
        final query = body['query'] as String? ?? '';
        if (query.contains('mutation')) mutations.add(query);
        return http.Response(
            json.encode({
              'data': {'__typename': 'Query'}
            }),
            200,
            headers: {'content-type': 'application/json'});
      });

  GraphQLClient client() => GraphQLClient(
        link:
            HttpLink('https://api.example/graphql', httpClient: fakeGraphQL()),
        cache: GraphQLCache(),
      );

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    ClientManager.testClientBuilder = (_) => client();
    mutations.clear();
  });

  tearDown(() {
    handler.playQueue = null;
  });

  test('startPlayQueue with a not-ready episode is a safe no-op', () async {
    await handler.startPlayQueue(client(), null, _pendingEpisode, _server);
    expect(mutations, isEmpty,
        reason: 'no play queue should be created for an unplayable episode');
    expect(handler.playQueue, isNull);
  });

  test('startPlayQueueForMovie with a not-ready movie is a safe no-op',
      () async {
    await handler.startPlayQueueForMovie(
        client(), null, _pendingMovie, _server);
    expect(mutations, isEmpty,
        reason: 'no play queue should be created for an unplayable movie');
    expect(handler.playQueue, isNull);
  });
}
