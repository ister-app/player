import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/components/VideoCoverView.dart';
import 'package:player/components/IsterPlayer.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/fragmentMovie.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/MoviePage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

const _server = 'test-server';

Fragment$fragmentMovie _movie() => Fragment$fragmentMovie(
      id: 'movie-1',
      name: 'The Movie',
      releaseYear: 2020,
      mediaFile: [
        Fragment$fragmentMediaFiles(
          id: 'mf-1',
          path: '/movies/movie.mkv',
          size: 1,
          durationInMilliseconds: 5400000,
          directory: Fragment$fragmentMediaFiles$directory(
            node: Fragment$fragmentMediaFiles$directory$node(
                url: 'http://node.example'),
          ),
        ),
      ],
    );

http.Response _json(Map<String, dynamic> data) => http.Response(
    json.encode({'data': data}), 200,
    headers: {'content-type': 'application/json'});

/// Page opened from browsing: the movie loads, but nothing plays until the
/// cover's play button is tapped.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;
  final operations = <String>[];

  MockClient fakeGraphQL() => MockClient((request) async {
        final body = json.decode(request.body) as Map<String, dynamic>;
        final query = body['query'] as String? ?? '';
        final op = RegExp(r'(query|mutation)\s+(\w+)').firstMatch(query);
        if (op != null) operations.add(op.group(2)!);
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
        if (query.contains('movieById')) {
          return _json({
            '__typename': 'Query',
            'movieById': _movie().toJson(),
          });
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
        return _json({'__typename': 'Query'});
      });

  GraphQLClient client() => GraphQLClient(
        link: HttpLink('https://api.example/graphql',
            httpClient: fakeGraphQL()),
        cache: GraphQLCache(),
      );

  Widget page({GraphQLClient? shared}) => GraphQLProvider(
        client: ValueNotifier(shared ?? client()),
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: const MoviePage(serverName: _server, movieId: 'movie-1'),
        ),
      );

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  setUp(() async {
    // The cast row's visibility callbacks would otherwise outlive the tree as
    // pending timers.
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    ClientManager.testClientBuilder = (_) => client();
    operations.clear();
    // A previous test may have left an item loaded; the page would then treat
    // it as the queue that is already playing and skip the cover. Torn down
    // after the test client builder above, so it takes the no-mpv path.
    await handler.endPlaybackLocally(flushProgress: false);
  });

  testWidgets('shows the cover with a play button and does not start',
      (tester) async {
    await tester.pumpWidget(page());
    await settle(tester);

    expect(find.byKey(VideoCoverView.playButtonKey), findsOneWidget);
    expect(find.byType(IsterPlayer), findsNothing);
    expect(operations, isNot(contains('createPlayQueue')),
        reason: 'opening the page must not start playback');
    expect(handler.playQueue, isNull);
  });

  testWidgets('a cached revalidation does not flash the skeleton back',
      (tester) async {
    // One client, so the second mount reads the warm cache. `cacheAndNetwork`
    // then reports `isLoading` on top of perfectly good data — the page used
    // to skeletonize on that and flash the whole thing away.
    final shared = client();
    await tester.pumpWidget(page(shared: shared));
    await settle(tester);
    // App bar and body both carry the title.
    expect(find.text('The Movie (2020)'), findsWidgets);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(page(shared: shared));
    // The very first frame of the remount, before the network answers again.
    await tester.pump();

    expect(find.byWidgetPredicate((w) => w is Skeletonizer), findsNothing);
    expect(find.text('The Movie (2020)'), findsWidgets);

    await settle(tester);
  });

  testWidgets('tapping play starts the queue and mounts the surface',
      (tester) async {
    await tester.pumpWidget(page());
    await settle(tester);

    await tester.tap(find.byKey(VideoCoverView.playButtonKey));
    await settle(tester);

    expect(operations, contains('createPlayQueue'));
    expect(handler.playQueue?.id, 'pq-1');
    expect(handler.movie?.id, 'movie-1');
    expect(find.byKey(VideoCoverView.playButtonKey), findsNothing);
    expect(find.byType(IsterPlayer), findsOneWidget);

    // Ends the heartbeat and command subscription the start armed — they
    // would otherwise outlive the test as pending timers.
    await handler.suspendPlayback();
    await settle(tester);
  });

  testWidgets('stopping brings the cover back and play resumes where it left',
      (tester) async {
    await tester.pumpWidget(page());
    await settle(tester);

    await tester.tap(find.byKey(VideoCoverView.playButtonKey));
    await settle(tester);
    expect(find.byType(IsterPlayer), findsOneWidget);

    // Watched a while, then hit stop (the video controls' stop button, the
    // notification and the mini-player swipe all land here).
    handler.playbackState.add(handler.playbackState.value.copyWith(
        updatePosition: const Duration(minutes: 12), playing: false));
    await handler.stopPlayback();
    await settle(tester);

    expect(find.byType(IsterPlayer), findsNothing,
        reason: 'the stopped stream leaves no video surface behind');
    expect(find.byKey(VideoCoverView.playButtonKey), findsOneWidget,
        reason: 'the page stays open, showing its cover again');
    expect(handler.playQueue, isNull);

    // Playing again resumes at the stop position — the page's own movie object
    // still carries the watch status from before this viewing.
    await tester.tap(find.byKey(VideoCoverView.playButtonKey));
    await settle(tester);

    expect(find.byType(IsterPlayer), findsOneWidget);
    expect(handler.playQueue?.id, 'pq-1');
    expect(handler.lastStartTimeMs,
        const Duration(minutes: 12).inMilliseconds);

    await handler.suspendPlayback();
    await settle(tester);
  });
}
