import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:audio_service/audio_service.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/AlbumPage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';
const _trackCount = 40;

Map<String, dynamic> _metadata(String id, String title) => {
      '__typename': 'Metadata',
      'id': id,
      'description': null,
      'language': 'eng',
      'sourceUri': null,
      'source': null,
      'title': title,
      'released': null,
      'genre': null,
    };

/// With [discs] = 2 the 40 tracks split 1–20 → disc 1 and 21–40 → disc 2,
/// with the track number restarting per disc; titles stay globally unique.
/// [guestTrack] gives that track a different artist than the album.
Map<String, dynamic> _album({int discs = 1, int? guestTrack}) => {
      '__typename': 'Album',
      'id': 'album-1',
      'name': 'Long Album',
      'releaseYear': 2001,
      'artist': {'__typename': 'Person', 'id': 'artist-1', 'name': 'The Band'},
      'images': [],
      'metadata': [],
      'rating': null,
      'tracks': [
        for (var n = 1; n <= _trackCount; n++)
          {
            '__typename': 'Track',
            'id': 'track-$n',
            'number': discs > 1 ? (n - 1) % 20 + 1 : n,
            'discNumber': discs > 1 ? (n - 1) ~/ 20 + 1 : 1,
            'artist': n == guestTrack
                ? {
                    '__typename': 'Person',
                    'id': 'artist-2',
                    'name': 'Guest Star'
                  }
                : {
                    '__typename': 'Person',
                    'id': 'artist-1',
                    'name': 'The Band'
                  },
            'metadata': [_metadata('track-meta-$n', 'Track $n')],
            'mediaFile': [
              {'__typename': 'MediaFile', 'durationInMilliseconds': 180000}
            ],
            'rating': null,
          },
      ],
    };

MockClient _fakeGraphQL({int discs = 1, int? guestTrack}) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String;
      Map<String, dynamic> payload;
      if (query.contains('albumById')) {
        payload = {
          'data': {
            '__typename': 'Query',
            'albumById': _album(discs: discs, guestTrack: guestTrack)
          }
        };
      } else if (query.contains('me {') || query.contains('me{')) {
        payload = {
          'data': {
            '__typename': 'Query',
            'me': {
              '__typename': 'User',
              'id': 'user-1',
              'name': 'tester',
              'email': 'tester@example.com',
              'isAdmin': false,
            }
          }
        };
      } else {
        payload = {
          'data': {'__typename': 'Query'}
        };
      }
      return http.Response(
        json.encode(payload),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

Widget _app(http.Client client, {String? trackId}) => GraphQLProvider(
      client: ValueNotifier(GraphQLClient(
        link: HttpLink('https://api.example/graphql', httpClient: client),
        cache: GraphQLCache(),
      )),
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: AlbumPage(
          serverName: _server,
          albumId: 'album-1',
          trackId: trackId,
        ),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // AlbumPage touches MediaPlayerHandler.instance (musicPlayerOpen), whose
  // singleton constructs a media_kit Player. Force the singleton into existence
  // here, outside any test's FakeAsync zone — its periodic stall-watchdog timer
  // would otherwise count as a pending timer of the first test.
  MediaKit.ensureInitialized();
  MediaPlayerHandler.instance;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql',
              httpClient: _fakeGraphQL()),
          cache: GraphQLCache(),
        );
  });

  tearDown(() {
    ClientManager.testClientBuilder = null;
  });

  testWidgets('without a trackId the list stays at the top', (tester) async {
    await tester.pumpWidget(_app(_fakeGraphQL()));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.text('Track 1')).dy,
        lessThan(tester.view.physicalSize.height));
    // A track far down the album is built but positioned below the viewport.
    final screenHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    expect(tester.getTopLeft(find.text('Track $_trackCount')).dy,
        greaterThan(screenHeight));

    // Single-disc albums get no disc headers.
    expect(find.textContaining('Disc'), findsNothing);

    // Let any short-lived timers (e.g. tooltip/ink timers) run out before the
    // strict pending-timer check at test teardown.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });

  testWidgets('the app bar offers add-album-to-queue next to add-to-session',
      (tester) async {
    await tester.pumpWidget(_app(_fakeGraphQL()));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.playlist_add), findsOneWidget);
    expect(find.byIcon(Icons.queue_music), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });

  testWidgets('a multi-disc album shows a header per disc', (tester) async {
    await tester.pumpWidget(_app(_fakeGraphQL(discs: 2)));
    await tester.pumpAndSettle();

    expect(find.text('Disc 1', skipOffstage: false), findsOneWidget);
    expect(find.text('Disc 2', skipOffstage: false), findsOneWidget);
    // Disc 1 header sits above its first track.
    expect(tester.getTopLeft(find.text('Disc 1')).dy,
        lessThan(tester.getTopLeft(find.text('Track 1')).dy));

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });

  testWidgets('a trackId under a later disc header still scrolls into view',
      (tester) async {
    await tester.pumpWidget(_app(_fakeGraphQL(discs: 2), trackId: 'track-35'));
    await tester.pumpAndSettle();

    final screenHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    final target = tester.getRect(find.text('Track 35'));
    expect(target.top, greaterThanOrEqualTo(0));
    expect(target.bottom, lessThanOrEqualTo(screenHeight));

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });

  testWidgets('only a track whose artist differs from the album gets an artist line',
      (tester) async {
    await tester.pumpWidget(_app(_fakeGraphQL(guestTrack: 2)));
    await tester.pumpAndSettle();

    // The guest artist appears under its track…
    expect(
      find.descendant(
        of: find.ancestor(
          of: find.text('Track 2'),
          matching: find.byType(ListTile),
        ),
        matching: find.text('Guest Star'),
      ),
      findsOneWidget,
    );
    // …while rows matching the album artist stay without the noise line (the
    // one "The Band" on the page is the hero header's album-artist subtitle).
    expect(
      find.descendant(
        of: find.byType(ListTile),
        matching: find.text('The Band', skipOffstage: false),
      ),
      findsNothing,
    );

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });

  testWidgets('the playing track carries the now-playing indicator',
      (tester) async {
    MediaPlayerHandler.instance.mediaItem.add(MediaItem(
      id: MediaItemId(_server, IsterMediaTypes.track, 'track-3').toString(),
      title: 'Track 3',
    ));
    addTearDown(() => MediaPlayerHandler.instance.mediaItem.add(null));

    await tester.pumpWidget(_app(_fakeGraphQL()));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.ancestor(
          of: find.text('Track 3'),
          matching: find.byType(ListTile),
        ),
        matching: find.byIcon(Icons.graphic_eq),
      ),
      findsOneWidget,
    );
    // The other rows keep their plain track number.
    expect(find.byIcon(Icons.graphic_eq), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });

  testWidgets('a trackId scrolls the requested track into view and highlights it',
      (tester) async {
    await tester.pumpWidget(_app(_fakeGraphQL(), trackId: 'track-35'));
    await tester.pumpAndSettle();

    // The requested track ended up inside the viewport…
    final screenHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    final target = tester.getRect(find.text('Track 35'));
    expect(target.top, greaterThanOrEqualTo(0));
    expect(target.bottom, lessThanOrEqualTo(screenHeight));

    // …carrying the temporary highlight, which clears again after a moment.
    ListTile targetTile() => tester.widget<ListTile>(
          find.ancestor(
            of: find.text('Track 35'),
            matching: find.byType(ListTile),
          ),
        );
    expect(targetTile().tileColor, isNotNull);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(targetTile().tileColor, isNull);
  });
}
