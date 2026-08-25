import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/download/AutoNextPreferences.dart';
import 'package:player/utils/download/AutoNextService.dart';
import 'package:player/utils/download/DownloadLoaders.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadService.dart';
import 'package:player/utils/download/DownloadStore.dart';
import 'package:player/utils/download/HlsDownloader.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'localhost:8080/api';
const _showId = 'show-1';

const _master = '''
#EXTM3U
#EXT-X-STREAM-INF:BANDWIDTH=256000,CODECS="avc1.4d401f"
stream_video_0_copy.m3u8?token=t
''';
const _playlist = '''
#EXTM3U
#EXTINF:5,
seg_video_0_copy_00000.ts?token=t
#EXT-X-ENDLIST
''';

/// One episode as seasonById returns it — the shape both [NextUnwatched] and
/// the download snapshot are built from.
Map<String, dynamic> _episode(int n, {bool watched = false, int progress = 0}) => {
      '__typename': 'Episode',
      'id': 'e$n',
      'number': n,
      'runtime': null,
      'voteAverage': null,
      'voteCount': null,
      'metadata': null,
      'images': null,
      'show': {'__typename': 'Show', 'id': _showId},
      'watchStatus': watched || progress > 0
          ? [
              {
                '__typename': 'WatchStatus',
                'id': 'w$n',
                'playQueueItemId': 'p$n',
                'progressInMilliseconds': progress,
                'watched': watched,
              }
            ]
          : <Map<String, dynamic>>[],
      'mediaFile': [
        Fragment$fragmentMediaFiles(
          id: 'mf-e$n',
          path: '/tv/e$n.mkv',
          size: 1,
          durationInMilliseconds: 1200000,
          directory: Fragment$fragmentMediaFiles$directory(
            node: Fragment$fragmentMediaFiles$directory$node(
                url: 'https://node.example'),
          ),
          mediaFileStreams: [
            Fragment$fragmentMediaFiles$mediaFileStreams(
                codecName: 'h264',
                codecType: 'VIDEO',
                height: 1080,
                width: 1920,
                id: 'v0',
                path: '',
                streamIndex: 0),
          ],
        ).toJson()
      ],
      'mediaFileParts': <Map<String, dynamic>>[],
    };

/// The same episode as episodeById returns it: the full fragment a download
/// snapshot is built from (season, cast and rating on top of the above).
Map<String, dynamic> _fullEpisode(int n, {bool watched = false}) => {
      ..._episode(n, watched: watched),
      'season': {'__typename': 'Season', 'id': 'season-1'},
      'cast': <Map<String, dynamic>>[],
      'rating': null,
    };

http.Response _json(Map<String, dynamic> data) => http.Response(
      json.encode({'data': data}),
      200,
      headers: {'content-type': 'application/json'},
    );

/// A GraphQL endpoint serving one show of [episodes], read fresh on every
/// query so a test can flip a watch status between runs.
MockClient _graphQL(List<Map<String, dynamic>> Function() episodes) =>
    MockClient((request) async {
      final query =
          (json.decode(request.body) as Map<String, dynamic>)['query'] as String;
      if (query.contains('query showById')) {
        return _json({
          '__typename': 'Query',
          'showById': {
            '__typename': 'Show',
            'id': _showId,
            'name': 'The Show',
            'releaseYear': 2020,
            'images': <Map<String, dynamic>>[],
            'metadata': <Map<String, dynamic>>[],
            'seasons': [
              {'__typename': 'Season', 'id': 'season-1', 'number': 1}
            ],
            'cast': <Map<String, dynamic>>[],
            'rating': null,
            'tmdbId': null,
            'imdbId': null,
            'voteAverage': null,
            'voteCount': null,
            'contentRating': null,
            'status': null,
            'homepage': null,
            'networks': null,
            'studios': null,
            'originCountry': null,
            'keywords': null,
            'trailerKey': null,
            'trailerSite': null,
          },
        });
      }
      if (query.contains('query episodeById')) {
        final id = ((json.decode(request.body)
                as Map<String, dynamic>)['variables'] as Map)['id'] as String;
        final episode = episodes().firstWhere((e) => e['id'] == id);
        return _json({
          '__typename': 'Query',
          'episodeById': _fullEpisode(episode['number'] as int,
              watched: (episode['watchStatus'] as List).isNotEmpty),
        });
      }
      if (query.contains('query seasonById')) {
        return _json({
          '__typename': 'Query',
          'seasonById': {
            '__typename': 'Season',
            'episodes': episodes(),
          },
        });
      }
      return http.Response('unexpected query: $query', 400);
    });

Future<void> _waitFor(bool Function() done, String what) async {
  final end = DateTime.now().add(const Duration(seconds: 10));
  while (!done()) {
    if (DateTime.now().isAfter(end)) fail('timed out: $what');
    await Future.delayed(const Duration(milliseconds: 20));
  }
}

void main() {
  late Directory root;
  late DownloadService downloads;
  late AutoNextService service;
  late List<Map<String, dynamic>> episodes;

  String key(String episodeId) =>
      DownloadEntry.keyFor(DownloadKind.episode, episodeId);

  setUp(() async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    root = await Directory.systemTemp.createTemp('autonext');
    episodes = [for (var n = 1; n <= 5; n++) _episode(n)];
    downloads = DownloadService(
      store: DownloadStore(rootOverride: root),
      downloader: HlsDownloader(
          httpClient: MockClient((req) async {
            final name = req.url.pathSegments.last;
            if (name == 'master.m3u8') return http.Response(_master, 200);
            if (name.endsWith('.m3u8')) return http.Response(_playlist, 200);
            if (name.endsWith('.ts')) return http.Response('x' * 100, 200);
            return http.Response('', 404);
          }),
          tokenProvider: (_) async => 'tok',
          backoff: (_) => const Duration(milliseconds: 1)),
    );
    DownloadService.instance = downloads;
    GraphQLClient client(String _) => GraphQLClient(
          link: HttpLink('https://api.example/graphql',
              httpClient: _graphQL(() => episodes)),
          cache: GraphQLCache(),
        );
    // The service resolves its client through ClientManager in production;
    // installing the seam here also tells the download service that there is
    // no OIDC session to wait for.
    ClientManager.clients.clear();
    ClientManager.testClientBuilder = client;
    service = AutoNextService(downloads: downloads)..clientBuilder = client;
  });

  tearDown(() async {
    ClientManager.testClientBuilder = null;
    ClientManager.clients.clear();
    service.resetForTest();
    // A download still running when the fixture directory disappears writes
    // its failure into a manifest that is no longer there.
    await downloads.pauseAll();
    await _waitFor(() => downloads.runningCount.value == 0, 'downloads to stop');
    await root.delete(recursive: true);
  });

  test('following a show downloads the next unwatched episodes', () async {
    final result = await service.follow(_server, _showId,
        title: 'The Show', count: 2);
    expect(result.following, isTrue);
    expect(result.queued, 2);
    expect(downloads.entryFor(_server, key('e1'))?.autoNext, isTrue);
    expect(downloads.entryFor(_server, key('e2')), isNotNull);
    expect(downloads.entryFor(_server, key('e3')), isNull);
    await _waitFor(
        () => downloads.entryFor(_server, key('e1'))?.isComplete ?? false,
        'e1 to download');
  });

  test('watching an episode drops it and fetches the next one', () async {
    await service.follow(_server, _showId, title: 'The Show', count: 2);
    await _waitFor(
        () => downloads.entryFor(_server, key('e1'))?.isComplete ?? false,
        'e1 to download');
    final dir = Directory(downloads.store.itemDirPathSync(_server, 'mf-e1')!);
    expect(dir.existsSync(), isTrue);

    // The server now reports e1 as watched.
    episodes[0] = _episode(1, watched: true);
    final result = await service.run(_server, _showId);

    expect(result.removed, 1, reason: 'the watched episode is dropped');
    expect(downloads.entryFor(_server, key('e1')), isNull);
    expect(dir.existsSync(), isFalse, reason: 'its files are deleted');
    // Two ahead again: the one already there plus the newly picked one.
    expect(downloads.entryFor(_server, key('e2')), isNotNull);
    expect(downloads.entryFor(_server, key('e3')), isNotNull);
  });

  test('a manual download of a watched episode is never removed', () async {
    await downloads.enqueueAll(_server, [
      DownloadLoaders.episodeRequest(_fullEpisode(1), 'e1', 1,
          groupTitle: 'The Show', seasonNumber: 1)
    ]);
    expect(downloads.entryFor(_server, key('e1'))!.autoNext, isFalse);

    episodes[0] = _episode(1, watched: true);
    await service.follow(_server, _showId, title: 'The Show', count: 1);
    final result = await service.run(_server, _showId);

    expect(result.removed, 0);
    expect(downloads.entryFor(_server, key('e1')), isNotNull);
    expect(downloads.entryFor(_server, key('e2')), isNotNull,
        reason: 'the next unwatched one is still fetched');
  });

  test('unfollowing stops the top-up and keeps the files', () async {
    await service.follow(_server, _showId, title: 'The Show', count: 1);
    await _waitFor(
        () => downloads.entryFor(_server, key('e1'))?.isComplete ?? false,
        'e1 to download');

    await service.unfollow(_server, _showId);
    expect(await AutoNextPreferences.get(_server, _showId), isNull);

    episodes[0] = _episode(1, watched: true);
    final result = await service.run(_server, _showId);
    expect(result.following, isFalse);
    expect(downloads.entryFor(_server, key('e1')), isNotNull);
  });

  test('a follow survives a restart and the manifest keeps the flag', () async {
    await service.follow(_server, _showId, title: 'The Show', count: 1);
    await _waitFor(
        () => downloads.entryFor(_server, key('e1'))?.isComplete ?? false,
        'e1 to download');

    final follows = await AutoNextPreferences.all(_server);
    expect(follows[_showId]?.count, 1);
    expect(follows[_showId]?.title, 'The Show');

    final again = DownloadService(
        store: DownloadStore(rootOverride: root),
        downloader: HlsDownloader(
            httpClient: MockClient((_) async => http.Response('', 404))));
    await again.ensureStarted();
    expect(again.entryFor(_server, key('e1'))?.autoNext, isTrue);
  });
}
