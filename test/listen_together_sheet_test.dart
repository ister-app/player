import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/components/ListenTogetherSheet.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/fragmentMovie.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/fragmentServerActivity.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';
const _queueId = 'pq-follow';

Fragment$fragmentMediaFiles _mediaFile(String id) => Fragment$fragmentMediaFiles(
      id: id,
      path: '/music/$id.flac',
      size: 1,
      durationInMilliseconds: 180000,
      directory: Fragment$fragmentMediaFiles$directory(
        node: Fragment$fragmentMediaFiles$directory$node(
            url: 'http://node.example'),
      ),
    );

Fragment$fragmentPlayQueue$playQueueItems _trackItem(String id, double position) =>
    Fragment$fragmentPlayQueue$playQueueItems(
      accessible: true,
      id: id,
      position: position,
      track: Fragment$fragmentPlayQueue$playQueueItems$track(
        id: 'track-$id',
        number: 1,
        discNumber: 1,
        artist: Fragment$fragmentPlayQueue$playQueueItems$track$artist(
            id: 'artist-1', name: 'The Artist'),
        album: Fragment$fragmentPlayQueue$playQueueItems$track$album(
            id: 'album-1', name: 'The Album'),
        mediaFile: [_mediaFile('mf-$id')],
      ),
    );

Fragment$fragmentPlayQueue$playQueueItems _movieItem(String id, double position) =>
    Fragment$fragmentPlayQueue$playQueueItems(
      accessible: true,
      id: id,
      position: position,
      movie: Fragment$fragmentMovie(
        id: 'movie-$id',
        name: 'The Movie',
        releaseYear: 2020,
        mediaFile: [_mediaFile('mf-$id')],
      ),
    );

Fragment$fragmentPlayQueue _queue({List<Fragment$fragmentPlayQueue$playQueueItems>? items}) =>
    Fragment$fragmentPlayQueue(
      id: _queueId,
      currentItemId: 'item-1',
      progressInMilliseconds: 30000,
      shuffle: false,
      sourceExhausted: true,
      controlAllowedUserIds: const [],
      playQueueItems:
          items ?? [_trackItem('item-1', 1), _trackItem('item-2', 2)],
    );

Fragment$fragmentPlaybackSession _session() => Fragment$fragmentPlaybackSession(
      playQueueId: _queueId,
      playQueueItemId: 'item-1',
      userId: 'owner-1',
      userName: 'Owner',
      progressInMilliseconds: 30000,
      playState: Enum$PlayState.PLAYING,
      nodeName: 'node-1',
      updatedAt: '2026-08-02T12:00:00Z',
      controllable: true,
      followerCount: 1,
    );

Map<String, dynamic> _follower({
  String userId = 'user-2',
  String? userName = 'Anna',
  String deviceId = 'device-a',
  String? deviceName = 'Kitchen',
}) =>
    {
      '__typename': 'SessionFollower',
      'userId': userId,
      'userName': userName,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'platform': 'ANDROID',
      'since': '2026-08-05T12:00:00Z',
    };

/// GraphQL stub covering the whole sheet: the follow flow (mutation + queue
/// fetch + subscriptions, mirroring follow_mode_test) and the follower list.
MockClient _fakeGraphQL({
  Enum$FollowResult followResult = Enum$FollowResult.OK,
  List<Map<String, dynamic>>? followers,
  List<String>? operations,
  Fragment$fragmentPlayQueue? queue,
}) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      Map<String, dynamic> payload;
      if (query.contains('followPlayQueue')) {
        operations?.add('followPlayQueue');
        payload = {
          'data': {
            '__typename': 'Mutation',
            'followPlayQueue': followResult.name,
          }
        };
      } else if (query.contains('query getPlayQueue')) {
        payload = {
          'data': {
            '__typename': 'Query',
            'getPlayQueue': (queue ?? _queue()).toJson()
          }
        };
      } else if (query.contains('sessionFollowers')) {
        if (followers == null) {
          // An old server does not know the query at all.
          payload = {
            'errors': [
              {
                'message':
                    "Validation error: Field 'sessionFollowers' is undefined"
              }
            ]
          };
        } else {
          payload = {
            'data': {'__typename': 'Query', 'sessionFollowers': followers}
          };
        }
      } else if (query.contains('subscription nowPlaying')) {
        // The followed session must appear here: an emission without it makes
        // the follower conclude the session ended and stop again.
        payload = {
          'data': {
            '__typename': 'Subscription',
            'nowPlaying': [_session().toJson()],
          }
        };
      } else if (query.contains('playbackCommands')) {
        payload = {'data': null};
      } else {
        payload = {
          'data': {'__typename': 'Query'}
        };
      }
      return http.Response(json.encode(payload), 200,
          headers: {'content-type': 'application/json'});
    });

Widget _app(Widget home) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: home,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // No video output plugin in a widget test: answer the texture-create call
  // with null so the handler's VideoController setup idles. The
  // MissingPluginException it throws otherwise arrives asynchronously, so it
  // lands on whichever test happens to be running and reports that one as
  // "did not complete" — a flake that moves around and never names its cause.
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('com.alexmercerind/media_kit_video'),
          (call) async => null);
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;

  void useClient(http.Client client) {
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql', httpClient: client),
          cache: GraphQLCache(),
        );
  }

  Future<void> resetHandler() async {
    await handler.stopFollowing(notifyServer: false);
    handler.playQueue = null;
    handler.currentPlayQueueItem = null;
    handler.currentTrackId = null;
    handler.serverName = null;
    handler.graphQLClient = null;
    handler.queue.add([]);
    handler.mediaItem.add(null);
    handler.mediaLoading.value = false;
  }

  setUp(() async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    await resetHandler();
  });

  tearDown(() async {
    await resetHandler();
    ClientManager.testClientBuilder = null;
  });

  /// Opens the sheet and settles it. The embedded followers list polls, so
  /// every test must close it again (see [close]) before finishing.
  Future<void> openSheet(WidgetTester tester, {Enum$MediaType? mediaType}) async {
    await tester.pumpWidget(_app(Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () => showListenTogetherSheet(context,
              serverName: _server,
              playQueueId: _queueId,
              mediaType: mediaType),
          child: const Text('open'),
        ),
      ),
    )));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Future<void> close(WidgetTester tester) async {
    Navigator.of(tester.element(find.text('open'))).pop();
    await tester.pumpAndSettle();
  }

  testWidgets('joining flips the sheet into follower mode with sync controls',
      (tester) async {
    final operations = <String>[];
    useClient(_fakeGraphQL(followers: [], operations: operations));
    await openSheet(tester);

    // Not related to this session in any way: the sheet offers joining.
    final join = find.widgetWithText(FilledButton, 'Listen along');
    expect(join, findsOneWidget);
    expect(find.text('Stop listening along'), findsNothing);

    await tester.tap(join);
    await tester.pumpAndSettle();

    expect(operations, contains('followPlayQueue'));
    expect(handler.followMode, isTrue);
    // Same sheet, new role: stop button and the same-room sync switch.
    expect(find.text('Stop listening along'), findsOneWidget);
    expect(find.text('In sync in the same room'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Stop listening along'));
    await tester.pumpAndSettle();
    expect(handler.followMode, isFalse);
    expect(find.widgetWithText(FilledButton, 'Listen along'), findsOneWidget);

    await close(tester);
  });

  testWidgets('a denied join explains the missing library access',
      (tester) async {
    useClient(_fakeGraphQL(
        followResult: Enum$FollowResult.NO_LIBRARY_ACCESS, followers: []));
    await openSheet(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Listen along'));
    await tester.pumpAndSettle();

    expect(handler.followMode, isFalse);
    expect(
        find.text(
            "Can't listen along — you don't have access to this queue's library"),
        findsOneWidget);

    await close(tester);
  });

  testWidgets('a vanished session disables the join button', (tester) async {
    useClient(_fakeGraphQL(
        followResult: Enum$FollowResult.NOT_FOUND, followers: []));
    await openSheet(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Listen along'));
    await tester.pumpAndSettle();

    final button =
        tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Session ended'));
    expect(button.onPressed, isNull);

    await close(tester);
  });

  testWidgets('the owner manages listeners, devices and sharing',
      (tester) async {
    useClient(_fakeGraphQL(followers: [_follower()]));
    // This device's own live playback of the queue.
    handler.serverName = _server;
    handler.playQueue = _queue();
    await openSheet(tester);

    expect(find.text('Anna'), findsOneWidget);
    expect(find.byIcon(Icons.person_remove), findsOneWidget);
    expect(find.text('Listen along on device…'), findsOneWidget);
    expect(find.text('Move playback to device…'), findsOneWidget);
    expect(find.text('Share this session'), findsOneWidget);
    // No join button for your own session.
    expect(find.widgetWithText(FilledButton, 'Listen along'), findsNothing);

    await close(tester);
  });

  testWidgets('a movie session speaks of watching along', (tester) async {
    final queue = _queue(items: [_movieItem('item-1', 1)]);
    useClient(_fakeGraphQL(followers: [], queue: queue));
    await openSheet(tester, mediaType: Enum$MediaType.MOVIE);

    // Viewer wording comes from the session's media type.
    expect(find.text('Watch together'), findsOneWidget);
    final join = find.widgetWithText(FilledButton, 'Watch along');
    expect(join, findsOneWidget);

    // After joining, the live movie queue keeps the watch wording.
    await tester.tap(join);
    await tester.pumpAndSettle();
    expect(handler.followMode, isTrue);
    expect(find.text('Watching along'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Stop watching along'),
        findsOneWidget);

    // Leave follow mode inside the test, or its subscriptions outlive it.
    await tester.tap(find.widgetWithText(FilledButton, 'Stop watching along'));
    await tester.pumpAndSettle();
    await close(tester);
  });

  testWidgets('an old server without the followers query hides the list',
      (tester) async {
    useClient(_fakeGraphQL(followers: null));
    await openSheet(tester);

    expect(find.widgetWithText(FilledButton, 'Listen along'), findsOneWidget);
    expect(find.text('Could not load the listeners'), findsNothing);
    expect(find.text('Nobody is listening along right now'), findsNothing);

    await close(tester);
  });
}
