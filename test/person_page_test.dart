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
import 'package:skeletonizer/skeletonizer.dart';

const _server = 'test-server';

Map<String, dynamic> _show() => {
      '__typename': 'Show',
      'id': 'show-1',
      'name': 'Tulsa King',
      'releaseYear': 2022,
      'images': [],
    };

Map<String, dynamic> _episodeCredit(int number) => {
      '__typename': 'Credit',
      'id': 'credit-e$number',
      'characterName': 'Dwight',
      'creditType': 'CAST',
      'castOrder': 0,
      'movie': null,
      'show': null,
      'episode': {
        '__typename': 'Episode',
        'id': 'episode-$number',
        'number': number,
        'images': [],
        'metadata': [],
        'season': {'__typename': 'Season', 'id': 'season-1', 'number': 1},
        'show': _show(),
      },
    };

Map<String, dynamic> _person({String? description}) => {
      '__typename': 'Person',
      'id': 'person-1',
      'name': 'Sylvester Stallone',
      'birthYear': 1946,
      'images': [],
      'metadata': [
        {
          '__typename': 'Metadata',
          'id': 'meta-1',
          'description': description,
          'language': 'eng',
          'sourceUri': null,
          'source': null,
          'title': null,
          'released': null,
          'genre': null,
        }
      ],
      'credits': [
        {
          '__typename': 'Credit',
          'id': 'credit-m1',
          'characterName': 'Ivan Drago',
          'creditType': 'CAST',
          'castOrder': 1,
          'movie': {
            '__typename': 'Movie',
            'id': 'movie-1',
            'name': 'Rocky IV',
            'releaseYear': 1985,
            'images': [],
          },
          'show': null,
          'episode': null,
        },
        _episodeCredit(1),
        _episodeCredit(2),
      ],
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

MockClient _fakeGraphQL({Map<String, dynamic>? person}) =>
    MockClient((request) async {
      final query =
          (json.decode(request.body) as Map<String, dynamic>)['query'] as String;
      if (query.contains('artistById')) {
        return _json({'__typename': 'Query', 'artistById': person});
      }
      if (query.contains('query albums')) {
        return _json(_emptyPage('albums'));
      }
      if (query.contains('query books')) {
        return _json(_emptyPage('books'));
      }
      if (query.contains('query me')) {
        return _json({
          '__typename': 'Query',
          'me': {
            '__typename': 'Me',
            'id': 'user-1',
            'name': 'Tester',
            'email': 'tester@example.org',
            'isAdmin': false,
          },
        });
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
  // PersonPage touches MediaPlayerHandler.instance (musicPlayerOpen), whose
  // singleton constructs a media_kit Player. Force the singleton into existence
  // here, outside any test's FakeAsync zone — its periodic stall-watchdog timer
  // would otherwise count as a pending timer of the first test.
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

  testWidgets('merges episode credits into one show row in the filmography',
      (tester) async {
    final client = _fakeGraphQL(person: _person());
    useClient(client);
    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();

    expect(find.text('Sylvester Stallone (1946)'), findsOneWidget);
    expect(find.text('Appears in'), findsOneWidget);
    expect(find.text('Rocky IV'), findsOneWidget);
    expect(find.text('1985 · Ivan Drago'), findsOneWidget);
    // The two episode credits collapse into a single show entry.
    expect(find.text('Tulsa King'), findsOneWidget);
    expect(find.text('2022 · 2 episodes · Dwight'), findsOneWidget);
  });

  testWidgets('tapping a show opens the episodes sheet', (tester) async {
    final client = _fakeGraphQL(person: _person());
    useClient(client);
    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tulsa King'));
    await tester.pumpAndSettle();

    expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    // Show name appears in the row and again in the sheet header.
    expect(find.text('Tulsa King'), findsNWidgets(2));
  });

  testWidgets('shows not-found instead of an eternal skeleton', (tester) async {
    final client = _fakeGraphQL(person: null);
    useClient(client);
    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();

    expect(find.text('Person not found'), findsOneWidget);
    expect(find.byType(Skeletonizer), findsNothing);
  });

  testWidgets('a long biography collapses behind a read-more toggle',
      (tester) async {
    final longBio =
        List.filled(60, 'A very long sentence about a storied career.')
            .join(' ');
    final client = _fakeGraphQL(person: _person(description: longBio));
    useClient(client);
    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();

    final readMore = find.text('Read more');
    expect(readMore, findsOneWidget);

    await tester.scrollUntilVisible(readMore, 100);
    await tester.tap(readMore);
    await tester.pumpAndSettle();

    expect(find.text('Show less'), findsOneWidget);
    expect(find.text('Read more'), findsNothing);
  });
}
