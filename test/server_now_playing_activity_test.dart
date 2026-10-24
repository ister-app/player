import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/ServerNowPlayingPage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';

/// A session as the server's now-playing fragment serializes it.
Map<String, dynamic> _session(
  String id, {
  required String activityKind,
  String? mediaType,
  String title = 'Title',
  String playState = 'PLAYING',
  double? progressFraction,
  String? progressLabel,
  int? durationInMilliseconds,
  bool controllable = false,
}) =>
    {
      '__typename': 'PlaybackSession',
      'playQueueId': id,
      'playQueueItemId': null,
      'userId': 'user-1',
      'userName': 'Gerben',
      'mediaType': mediaType,
      'mediaId': 'media-$id',
      'title': title,
      'durationInMilliseconds': durationInMilliseconds,
      'mediaFileId': null,
      'artworkImageId': null,
      'progressInMilliseconds': 30000,
      'playState': playState,
      'nodeName': 'node-a',
      'updatedAt': '2026-10-24T12:00:00Z',
      'controllable': controllable,
      'followerCount': 0,
      'deviceId': 'device-1',
      'deviceName': 'Woonkamer',
      'anchorPositionMs': null,
      'anchorServerTimeMs': null,
      'repeatMode': null,
      'activityKind': activityKind,
      'progressFraction': progressFraction,
      'progressLabel': progressLabel,
    };

/// Answers the snapshot query with [sessions]; everything else (the stream
/// token, the me query, the subscription over plain HTTP) gets an error so the
/// page falls back to the snapshot.
MockClient _fakeGraphQL(List<Map<String, dynamic>> sessions) =>
    MockClient((request) async {
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
              'nowPlaying': sessions,
            },
          }
        };
      } else {
        payload = {
          'errors': [
            {'message': 'not in this test'}
          ]
        };
      }
      return http.Response(json.encode(payload), 200,
          headers: {'content-type': 'application/json'});
    });

Widget _app() => const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: [Locale('en')],
      home: ServerNowPlayingPage(serverName: _server),
    );

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
  });

  tearDown(() {
    ClientManager.testClientBuilder = null;
  });

  void useSessions(List<Map<String, dynamic>> sessions) {
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql', httpClient: _fakeGraphQL(sessions)),
          cache: GraphQLCache(),
        );
  }

  /// Unmounts the page and drops the stream-token retry timer its failed
  /// token fetch left behind (a static timer, so not tied to the widget).
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    StreamTokenService.resetForTest();
  }

  testWidgets('a reading session shows its progress bar, label and percentage',
      (tester) async {
    useSessions([
      _session('read-1',
          activityKind: 'READING',
          mediaType: 'BOOK',
          title: 'Dit zijn de namen',
          progressFraction: 0.4,
          progressLabel: 'Hoofdstuk 3'),
    ]);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('session-card-read-1')), findsOneWidget);
    expect(find.text('Dit zijn de namen'), findsOneWidget);
    expect(find.text('Hoofdstuk 3'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
    final bar = tester.widget<LinearProgressIndicator>(
        find.byKey(const ValueKey('activity-progress-read-1')));
    expect(bar.value, 0.4);
    expect(find.byIcon(Icons.menu_book), findsWidgets);
    // No queue: nothing to listen along with or control.
    expect(find.byIcon(Icons.headphones), findsNothing);
    expect(find.byIcon(Icons.connected_tv), findsNothing);
    await unmount(tester);
  });

  testWidgets('a game session shows the playing chip without a timeline',
      (tester) async {
    useSessions([
      _session('game-1', activityKind: 'GAME', mediaType: 'GAME', title: 'Celeste'),
    ]);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('Celeste'), findsOneWidget);
    expect(find.byIcon(Icons.sports_esports), findsWidgets);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(find.text('00:30'), findsNothing);
    expect(find.textContaining('%'), findsNothing);
    await unmount(tester);
  });

  testWidgets('a paused reading session shows the paused chip', (tester) async {
    useSessions([
      _session('read-2',
          activityKind: 'READING',
          mediaType: 'COMIC',
          playState: 'PAUSED',
          progressFraction: 0.5,
          progressLabel: 'Page 5 of 10'),
    ]);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.pause), findsOneWidget);
    expect(find.text('Page 5 of 10'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('a playback session keeps its time row', (tester) async {
    useSessions([
      _session('pq-1',
          activityKind: 'PLAYBACK',
          mediaType: 'MOVIE',
          title: 'Tiger',
          // Not controllable: a controllable card consults MediaPlayerHandler,
          // whose media_kit Player has no place in this widget test.
          durationInMilliseconds: 120000),
    ]);
    await tester.pumpWidget(_app());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Tiger'), findsOneWidget);
    expect(find.text('02:00'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    await unmount(tester);
  });
}
