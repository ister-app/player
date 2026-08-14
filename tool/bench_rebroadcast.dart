// Temporary benchmark: cost of a normalized-cache write + rebroadcast with
// several watched queries alive, using the app's real generated documents.
// Run: dart run tool/bench_rebroadcast.dart
import 'dart:async';

import 'package:gql_exec/gql_exec.dart';
import 'package:gql_link/gql_link.dart';
import 'package:graphql/client.dart';
import 'package:player/graphql/showsRecentAdded.graphql.dart';

Map<String, dynamic> showJson(int i, int episodes) => {
      '__typename': 'Show',
      'id': 'show-$i',
      'releaseYear': 2000 + (i % 25),
      'name': 'Show number $i with a reasonably long title',
      'images': List.generate(
          4,
          (j) => {
                '__typename': 'Image',
                'type': j.isEven ? 'BACKGROUND' : 'COVER',
                'id': 'img-$i-$j',
                'language': j < 2 ? 'en' : 'nl',
                'source': 'TMDB',
                'blurHash': 'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                'directory': {
                  '__typename': 'Directory',
                  'node': {
                    '__typename': 'Node',
                    'url': 'https://node.example.com/media',
                  },
                },
              }),
      'episodes': List.generate(
          episodes,
          (j) => {
                '__typename': 'Episode',
                'number': j + 1,
              }),
      'metadata': List.generate(
          2,
          (j) => {
                '__typename': 'Metadata',
                'description':
                    'A fairly long description of show $i in language $j. ' *
                        4,
                'id': 'meta-$i-$j',
                'language': j == 0 ? 'en' : 'nl',
                'sourceUri': 'tmdb://show/$i',
                'source': 'TMDB',
                'title': 'Show number $i',
                'released': '2020-01-0${(i % 9) + 1}',
                'genre': 'Drama',
              }),
    };

Map<String, dynamic> pageJson(int page, int size, int episodes, int total) => {
      '__typename': 'Query',
      'shows': {
        '__typename': 'ShowPage',
        'number': page,
        'size': size,
        'totalElements': total,
        'totalPages': (total / size).ceil(),
        'content':
            List.generate(size, (i) => showJson(page * size + i, episodes)),
      }
    };

/// Answers every request with a canned shows page.
class CannedLink extends Link {
  CannedLink(this.data);
  final Map<String, dynamic> data;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    yield Response(data: data, response: const {}, context: const Context());
  }
}

Future<void> main() async {
  for (final optimized in [false, true]) {
    for (final episodes in [12, 100]) {
      for (final watchers in [4, 8, 16]) {
      final data = pageJson(0, 15, episodes, 400);
      final client = GraphQLClient(
        link: CannedLink(data),
        cache: GraphQLCache(store: InMemoryStore()),
        deepEquals: optimized ? optimizedDeepEquals : null,
      );

      final subs = <StreamSubscription>[];
      for (var k = 0; k < watchers; k++) {
        final oq = client.watchQuery(WatchQueryOptions(
          document: documentNodeQueryshows,
          variables: {'page': 0, 'size': 15, 'libraryId': 'lib-$k'},
          fetchPolicy: FetchPolicy.cacheAndNetwork,
          eagerlyFetchResults: true,
        ));
        subs.add(oq.stream.listen((_) {}));
      }
      // Let the eager fetches resolve and write into the cache.
      await Future.delayed(const Duration(milliseconds: 300));

      // Simulate what one incoming network response does: a cache write for
      // one request, then the full rebroadcast pass over every watcher.
      final req = QueryOptions(
        document: documentNodeQueryshows,
        variables: const {'page': 0, 'size': 15, 'libraryId': 'lib-0'},
      ).asRequest;

      // Warm-up.
      client.cache.writeQuery(req, data: data);
      await client.queryManager.maybeRebroadcastQueriesAsync(force: true);

      const iters = 20;
      final swWrite = Stopwatch();
      final swBroadcast = Stopwatch();
      for (var i = 0; i < iters; i++) {
        swWrite.start();
        client.cache.writeQuery(req, data: data);
        swWrite.stop();
        swBroadcast.start();
        await client.queryManager.maybeRebroadcastQueriesAsync(force: true);
        swBroadcast.stop();
      }

      // Split: how much of the rebroadcast is the per-watcher readQuery
      // (denormalize) alone?
      final swRead = Stopwatch()..start();
      for (var i = 0; i < iters; i++) {
        client.cache.readQuery(req);
      }
      swRead.stop();

      print('optimizedEquals=$optimized episodes/show=$episodes watchers=$watchers  '
          'write=${(swWrite.elapsedMicroseconds / iters / 1000).toStringAsFixed(1)}ms  '
          'rebroadcast=${(swBroadcast.elapsedMicroseconds / iters / 1000).toStringAsFixed(1)}ms  '
          'readQuery(1x)=${(swRead.elapsedMicroseconds / iters / 1000).toStringAsFixed(1)}ms');

      for (final s in subs) {
        await s.cancel();
      }
      }
    }
  }
}
