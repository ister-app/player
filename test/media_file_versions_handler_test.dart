import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/fragmentMovie.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';

/// One movie, two files: each with its *own* stream ids, crop and size — what
/// the server's per-file analysis produces.
Fragment$fragmentMediaFiles _file(String id,
        {required int width, required int height, required double size}) =>
    Fragment$fragmentMediaFiles(
      id: id,
      path: '/movies/The Movie (2020)/$id.mkv',
      size: size,
      durationInMilliseconds: 5400000,
      directory: Fragment$fragmentMediaFiles$directory(
        servingNode: Fragment$fragmentMediaFiles$directory$servingNode(
            url: 'http://node.example'),
      ),
      mediaFileStreams: [
        Fragment$fragmentMediaFiles$mediaFileStreams(
            id: 'video-of-$id',
            codecName: 'h264',
            codecType: 'VIDEO',
            width: width,
            height: height,
            path: '',
            streamIndex: 0),
        Fragment$fragmentMediaFiles$mediaFileStreams(
            id: 'pgs-of-$id',
            codecName: 'hdmv_pgs_subtitle',
            codecType: 'SUBTITLE',
            language: 'eng',
            width: 0,
            height: 0,
            path: '',
            streamIndex: 2),
      ],
    );

// Listed worst-first on purpose: the default must not be "the first one".
final _hd = _file('mf-hd', width: 1920, height: 1080, size: 8e9);
final _uhd = _file('mf-uhd', width: 3840, height: 2160, size: 58e9);

Fragment$fragmentMovie _movie() => Fragment$fragmentMovie(
      id: 'movie-1',
      name: 'The Movie',
      releaseYear: 2020,
      mediaFile: [_hd, _uhd],
    );

http.Response _json(Map<String, dynamic> data) => http.Response(
    json.encode({'data': data}), 200,
    headers: {'content-type': 'application/json'});

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('com.alexmercerind/media_kit_video'),
          (call) async => null);
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;

  GraphQLClient client() => GraphQLClient(
        link: HttpLink('https://api.example/graphql',
            httpClient: MockClient((request) async {
              final query =
                  (json.decode(request.body) as Map)['query'] as String? ?? '';
              if (query.trimLeft().startsWith('subscription')) {
                return http.Response(
                    json.encode({
                      'errors': [
                        {'message': 'no subscriptions in test'}
                      ]
                    }),
                    200,
                    headers: {'content-type': 'application/json'});
              }
              if (query.contains('createPlayQueue')) {
                return _json({
                  '__typename': 'Mutation',
                  'createPlayQueue': {
                    '__typename': 'PlayQueue',
                    'id': 'pq-1',
                    'currentItemId': 'item-1',
                    'progressInMilliseconds': 0,
                    'shuffle': false,
                    'sourceType': 'MOVIE',
                    'sourceExhausted': true,
                    'controlScopeOverride': null,
                    'controlAllowedUserIds': <dynamic>[],
                    'playQueueItems': [
                      {
                        '__typename': 'PlayQueueItem',
                        'id': 'item-1',
                        'position': 1.0,
                        'accessible': true,
                        'episode': null,
                        'movie': _movie().toJson(),
                        'track': null,
                        'chapter': null,
                        'podcastEpisode': null,
                      }
                    ],
                  },
                });
              }
              return _json({'__typename': 'Mutation', 'updatePlayQueue': null});
            })),
        cache: GraphQLCache(),
      );

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    ClientManager.testClientBuilder = (_) => client();
  });

  tearDown(() async {
    await handler.endPlaybackLocally(flushProgress: false);
    handler.movie = null;
    ClientManager.testClientBuilder = null;
  });

  List<String?> bitmapStreamIds() =>
      handler.currentBitmapSubtitleTracks.map((t) => t.streamId).toList();

  test('the default is the best version, not the first in the list', () async {
    await handler.startPlayQueueForMovie(client(), null, _movie(), _server);

    expect(handler.currentMediaFileId.value, 'mf-uhd');
    expect(handler.currentMediaUrl, contains('/hls/mf-uhd/'));
    // Everything per-file follows the file that plays, not mediaFile.first.
    expect(bitmapStreamIds(), ['pgs-of-mf-uhd']);
    expect(handler.currentVideoFileStreams.first!.id, 'video-of-mf-uhd');
  });

  test('the version picked on the page is the one that opens', () async {
    await handler.startPlayQueueForMovie(client(), null, _movie(), _server,
        mediaFileId: 'mf-hd');

    expect(handler.currentMediaFileId.value, 'mf-hd');
    expect(handler.currentMediaUrl, contains('/hls/mf-hd/'));
    expect(bitmapStreamIds(), ['pgs-of-mf-hd']);
  });

  test('switching version re-points everything per-file and drops what '
      'belonged to the old file', () async {
    await handler.startPlayQueueForMovie(client(), null, _movie(), _server);
    await handler.selectBitmapSubtitle(handler.currentBitmapSubtitleTracks.first);
    expect(handler.bitmapSubtitle.value?.streamId, 'pgs-of-mf-uhd');

    await handler.switchMediaFile('mf-hd');

    expect(handler.currentMediaFileId.value, 'mf-hd');
    expect(handler.currentMediaUrl, contains('/hls/mf-hd/'));
    expect(bitmapStreamIds(), ['pgs-of-mf-hd']);
    // A stream id of the other file must not survive the switch.
    expect(handler.bitmapSubtitle.value, isNull);
    // Still the same item for the page.
    expect(handler.isCurrentVideo(movieId: 'movie-1', serverName: _server),
        isTrue);
  });

  test('two quick switches end on the last one, one open at a time', () async {
    await handler.startPlayQueueForMovie(client(), null, _movie(), _server);

    final first = handler.switchMediaFile('mf-hd');
    final second = handler.switchMediaFile('mf-uhd');
    await Future.wait([first, second]);

    expect(handler.currentMediaFileId.value, 'mf-uhd');
    expect(handler.currentMediaUrl, contains('/hls/mf-uhd/'));
  });

  test('a retry after a failed load keeps the chosen version', () async {
    await handler.startPlayQueueForMovie(client(), null, _movie(), _server);
    await handler.switchMediaFile('mf-hd');

    await handler.retryVideoLoad();

    expect(handler.currentMediaFileId.value, 'mf-hd');
    expect(handler.currentMediaUrl, contains('/hls/mf-hd/'));
  });

  test('an unknown version id is ignored', () async {
    await handler.startPlayQueueForMovie(client(), null, _movie(), _server);
    await handler.switchMediaFile('mf-gone');
    expect(handler.currentMediaFileId.value, 'mf-uhd');
  });

  test('sharesTimelineWithCurrent tells the menu when to ask', () async {
    await handler.startPlayQueueForMovie(client(), null, _movie(), _server);
    expect(handler.sharesTimelineWithCurrent('mf-hd'), isTrue);
  });
}
