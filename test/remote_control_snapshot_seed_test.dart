import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/RemoteControlPage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';
const _queueId = 'queue-1';

Map<String, dynamic> _session() => {
      '__typename': 'PlaybackSession',
      'playQueueId': _queueId,
      'playQueueItemId': null,
      'userId': 'user-1',
      'userName': 'Gerben',
      'mediaType': 'TRACK',
      'mediaId': 'track-1',
      'title': 'Zomerhit',
      'durationInMilliseconds': 180000,
      'artworkImageId': null,
      'progressInMilliseconds': 42000,
      'playState': 'PAUSED',
      'nodeName': 'node-1',
      'updatedAt': '2026-08-06T12:00:00Z',
      'controllable': true,
      'followerCount': 0,
      'deviceId': null,
      'deviceName': null,
      'anchorPositionMs': null,
      'anchorServerTimeMs': null,
      'repeatMode': 'NONE',
    };

/// The wedged-websocket scenario: the nowPlaying/playbackCommands
/// subscriptions never produce data, only the HTTP snapshot answers.
MockClient _fakeGraphQL() => MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      Map<String, dynamic> payload;
      if (query.contains('serverActivitySnapshot')) {
        payload = {
          'data': {
            '__typename': 'Query',
            'serverActivitySnapshot': {
              '__typename': 'ServerActivitySnapshot',
              'nodes': [],
              'queueStats': [],
              'recentFailures': [],
              'transcodes': [],
              'nowPlaying': [_session()],
            },
          },
        };
      } else if (query.contains('createStreamToken')) {
        payload = {
          'data': {
            '__typename': 'Mutation',
            'createStreamToken': {
              '__typename': 'StreamToken',
              'token': 'stream-token',
              'expiresAt': '2036-01-01T00:00:00Z',
            },
          },
        };
      } else {
        // Subscriptions and the queue fetch stay silent, like a dead socket.
        payload = {'data': null};
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
  // The listen-along banner reads the handler's follow state; instantiate it
  // up front like the other player-page tests do.
  MediaPlayerHandler.instance;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    ClientManager.testClientBuilder = (url) => GraphQLClient(
          link: HttpLink('http://$url/graphql', httpClient: _fakeGraphQL()),
          cache: GraphQLCache(store: InMemoryStore()),
        );
  });

  tearDown(() {
    ClientManager.testClientBuilder = null;
    ClientManager.clients.clear();
    StreamTokenService.invalidateToken(_server);
  });

  testWidgets(
      'remote control renders the session from the HTTP snapshot when the '
      'subscription never emits', (tester) async {
    await tester.pumpWidget(_app(const RemoteControlPage(
      serverName: _server,
      playQueueId: _queueId,
    )));

    // Fixed pumps rather than pumpAndSettle: the player's background gradient
    // and slide-up animation run long, and ResilientSubscription keeps a
    // retry timer pending by design.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Zomerhit'), findsWidgets);

    // Tear the page down so the controller cancels its retry timers, and drop
    // the stream token before the pending-timer check: its refresh timer runs
    // until the (far-future) expiry.
    await tester.pumpWidget(const SizedBox());
    StreamTokenService.invalidateToken(_server);
  });
}
