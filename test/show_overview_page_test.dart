import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/ShowOverviewContentPage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/PermissionsService.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:visibility_detector/visibility_detector.dart';

const _server = 'test-server';

Map<String, dynamic> _metadata({String? source}) => {
      '__typename': 'Metadata',
      'id': 'meta-1',
      'description': 'A mob capo builds a crew in Tulsa.',
      'language': 'eng',
      'sourceUri': source == null ? null : 'TMDB://2734',
      'source': source,
      'title': 'Tulsa King',
      'released': null,
      'genre': null,
      'tagline': null,
    };

Map<String, dynamic> _show({String? source}) => {
      '__typename': 'Show',
      'id': 'show-1',
      'name': 'Tulsa King',
      'releaseYear': 2022,
      'images': [],
      'metadata': [_metadata(source: source)],
      'seasons': [],
      'cast': [],
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
    };

http.Response _json(Map<String, dynamic> data) => http.Response(
      json.encode({'data': data}),
      200,
      headers: {'content-type': 'application/json'},
    );

MockClient _fakeGraphQL({String? source}) => MockClient((request) async {
      final query =
          (json.decode(request.body) as Map<String, dynamic>)['query'] as String;
      if (query.contains('showById')) {
        return _json({'__typename': 'Query', 'showById': _show(source: source)});
      }
      if (query.contains('castByParent')) {
        return _json({
          '__typename': 'Query',
          'cast': {
            '__typename': 'CastPage',
            'number': 0,
            'size': 0,
            'totalElements': 0,
            'totalPages': 0,
            'content': [],
          },
        });
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
        home: Scaffold(
            body: ShowOverviewContentPage(serverName: _server, showId: 'show-1')),
      ),
    );

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
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

  testWidgets('credits TMDB under the description', (tester) async {
    final client = _fakeGraphQL(source: 'TMDB');
    useClient(client);
    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();

    expect(find.text('Tulsa King (2022)'), findsOneWidget);
    expect(find.text('A mob capo builds a crew in Tulsa.'), findsOneWidget);
    expect(find.text('Source: TMDB'), findsOneWidget);
  });

  testWidgets('shows no source line for locally sourced metadata',
      (tester) async {
    final client = _fakeGraphQL(source: null);
    useClient(client);
    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();

    expect(find.text('A mob capo builds a crew in Tulsa.'), findsOneWidget);
    expect(find.textContaining('Source:'), findsNothing);
  });
}
