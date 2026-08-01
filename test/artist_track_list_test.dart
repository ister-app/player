import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/PersonPage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/PermissionsService.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';

Map<String, dynamic> _person() => {
      '__typename': 'Person',
      'id': 'person-1',
      'name': 'Lady Gaga',
      'birthYear': 1986,
      'images': [],
      'metadata': [],
      'credits': [],
    };

Map<String, dynamic> _album() => {
      '__typename': 'Album',
      'id': 'album-1',
      'name': 'Chromatica',
      'releaseYear': 2020,
      'artist': {'__typename': 'Person', 'id': 'person-1', 'name': 'Lady Gaga'},
      'images': [],
      'metadata': [],
      'rating': null,
    };

Map<String, dynamic> _track(int number, String title,
        {int? playCount, String? lastPlayedAt, int? rating}) =>
    {
      '__typename': 'Track',
      'id': 'track-$number',
      'number': number,
      'discNumber': 1,
      'artist': {'__typename': 'Person', 'id': 'person-1', 'name': 'Lady Gaga'},
      'metadata': [
        {
          '__typename': 'Metadata',
          'id': 'meta-$number',
          'title': title,
          'description': null,
          'language': 'eng',
          'sourceUri': null,
          'source': null,
          'released': null,
          'genre': null,
        }
      ],
      'mediaFile': [
        {'__typename': 'MediaFile', 'durationInMilliseconds': 215000}
      ],
      'rating': rating,
      if (playCount != null) 'playCount': playCount,
      if (lastPlayedAt != null) 'lastPlayedAt': lastPlayedAt,
      'album': _album(),
    };

http.Response _json(Map<String, dynamic> data) => http.Response(
      json.encode({'data': data}),
      200,
      headers: {'content-type': 'application/json'},
    );

Map<String, dynamic> _emptyPage(String field) => {
      '__typename': 'Query',
      field: {
        '__typename': field == 'albums' ? 'AlbumPage' : 'BookPage',
        'content': [],
        'totalPages': 0,
        'totalElements': 0,
        'number': 0,
        'size': 0,
      },
    };

Map<String, dynamic> _personWithTracks(String field, List<Map<String, dynamic>> tracks) => {
      '__typename': 'Query',
      'personById': {
        '__typename': 'Person',
        'id': 'person-1',
        field: tracks,
      },
    };

MockClient _fakeGraphQL({
  List<Map<String, dynamic>> topPlayed = const [],
  List<Map<String, dynamic>> recentlyPlayed = const [],
  List<Map<String, dynamic>> topRated = const [],
  List<Map<String, dynamic>>? createPlayQueueRequests,
}) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String;
      if (query.contains('createPlayQueue')) {
        // Record the variables and fail the mutation, so the handler never
        // starts real playback inside the widget test.
        createPlayQueueRequests
            ?.add(body['variables'] as Map<String, dynamic>);
        return http.Response(
          json.encode({
            'errors': [
              {'message': 'queue creation stubbed out in this test'}
            ]
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }
      if (query.contains('topPlayedTracks')) {
        return _json(_personWithTracks('topPlayedTracks', topPlayed));
      }
      if (query.contains('recentlyPlayedTracks')) {
        return _json(_personWithTracks('recentlyPlayedTracks', recentlyPlayed));
      }
      if (query.contains('topRatedTracks')) {
        return _json(_personWithTracks('topRatedTracks', topRated));
      }
      if (query.contains('artistById')) {
        return _json({'__typename': 'Query', 'artistById': _person()});
      }
      if (query.contains('query albums')) {
        return _json(_emptyPage('albums'));
      }
      if (query.contains('query books')) {
        return _json(_emptyPage('books'));
      }
      return http.Response('unexpected query', 400);
    });

Widget _app(http.Client client) => GraphQLProvider(
      client: ValueNotifier(GraphQLClient(
        link: HttpLink('https://api.example/graphql', httpClient: client),
        cache: GraphQLCache(),
      )),
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
        home: PersonPage(serverName: _server, personId: 'person-1'),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // PersonPage touches MediaPlayerHandler.instance, whose singleton constructs
  // a media_kit Player; force it into existence outside any test zone.
  MediaKit.ensureInitialized();
  MediaPlayerHandler.instance;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    PermissionsService().invalidate(_server);
  });

  tearDown(() {
    ClientManager.testClientBuilder = null;
  });

  void useClient(http.Client client) {
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql', httpClient: client),
          cache: GraphQLCache(),
        );
  }

  testWidgets('shows the most played list with ranks and play counts',
      (tester) async {
    final client = _fakeGraphQL(topPlayed: [
      _track(1, 'Rain On Me', playCount: 27),
      _track(2, 'Alice', playCount: 12),
    ]);
    useClient(client);
    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();

    expect(find.text('Most played'), findsOneWidget);
    expect(find.text('Rain On Me'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('27'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    // Rank numbers of the two rows.
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    // The other two sections received no tracks and stay hidden.
    expect(find.text('Last played'), findsNothing);
    expect(find.text('Highest rated'), findsNothing);
  });

  testWidgets('shows the last played list with a relative time',
      (tester) async {
    final threeDaysAgo =
        DateTime.now().toUtc().subtract(const Duration(days: 3));
    final client = _fakeGraphQL(recentlyPlayed: [
      _track(1, 'Rain On Me', lastPlayedAt: threeDaysAgo.toIso8601String()),
    ]);
    useClient(client);
    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();

    expect(find.text('Last played'), findsOneWidget);
    expect(find.text('3 d ago'), findsOneWidget);
  });

  testWidgets('shows the highest rated list with stars and duration',
      (tester) async {
    final client = _fakeGraphQL(topRated: [
      _track(1, 'Rain On Me', rating: 9),
    ]);
    useClient(client);
    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();

    expect(find.text('Highest rated'), findsOneWidget);
    expect(find.text('3:35'), findsOneWidget);
  });

  testWidgets('switches between the track lists via tabs', (tester) async {
    final threeDaysAgo =
        DateTime.now().toUtc().subtract(const Duration(days: 3));
    final client = _fakeGraphQL(
      topPlayed: [_track(1, 'Rain On Me', playCount: 27)],
      recentlyPlayed: [
        _track(2, 'Alice', lastPlayedAt: threeDaysAgo.toIso8601String()),
      ],
    );
    useClient(client);
    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();

    // Both tabs are present; the first non-empty list is shown by default.
    expect(find.text('Most played'), findsOneWidget);
    expect(find.text('Last played'), findsOneWidget);
    expect(find.text('Rain On Me'), findsOneWidget);
    expect(find.text('Alice'), findsNothing);

    await tester.tap(find.text('Last played'));
    await tester.pumpAndSettle();

    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Rain On Me'), findsNothing);

    await tester.tap(find.text('Most played'));
    await tester.pumpAndSettle();

    expect(find.text('Rain On Me'), findsOneWidget);
    expect(find.text('Alice'), findsNothing);
  });

  testWidgets('tapping a row plays the ranked list as an ARTIST queue',
      (tester) async {
    final createRequests = <Map<String, dynamic>>[];
    final client = _fakeGraphQL(
      topPlayed: [
        _track(1, 'Rain On Me', playCount: 27),
        _track(2, 'Alice', playCount: 12),
      ],
      createPlayQueueRequests: createRequests,
    );
    useClient(client);
    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Alice'));
    await tester.pumpAndSettle();

    expect(createRequests, hasLength(1));
    final input = createRequests.single['input'] as Map<String, dynamic>;
    expect(input['sourceType'], 'ARTIST');
    expect(input['sourceId'], 'person-1');
    expect(input['rankKind'], 'MOST_PLAYED');
    expect(input['startId'], 'track-2');
  });

  testWidgets('collapses long lists behind a show-more toggle',
      (tester) async {
    final client = _fakeGraphQL(topPlayed: [
      for (var i = 1; i <= 8; i++) _track(i, 'Track $i', playCount: 20 - i),
    ]);
    useClient(client);
    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();

    expect(find.text('Track 5'), findsOneWidget);
    expect(find.text('Track 6'), findsNothing);

    final showMore = find.text('Show more');
    // The tab bar adds a nested horizontal scrollable; aim explicitly at the
    // page's vertical CustomScrollView.
    await tester.scrollUntilVisible(showMore, 100,
        scrollable: find
            .descendant(
                of: find.byType(CustomScrollView),
                matching: find.byType(Scrollable))
            .first);
    await tester.tap(showMore);
    await tester.pumpAndSettle();

    expect(find.text('Track 6'), findsOneWidget);
    expect(find.text('Track 8'), findsOneWidget);
    expect(find.text('Show less'), findsOneWidget);
  });
}
