import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/SearchPage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';

http.Response _json(Map<String, dynamic> data) => http.Response(
      json.encode({'data': data}),
      200,
      headers: {'content-type': 'application/json'},
    );

MockClient _fakeGraphQL() => MockClient((request) async {
      final query = json.decode(request.body)['query'] as String? ?? '';
      if (query.contains('search(')) {
        return _json({
          '__typename': 'Query',
          'search': [
            {
              '__typename': 'Episode',
              'id': 'ep-1',
              'number': 3,
              'show': {'__typename': 'Show', 'id': 'show-1', 'name': 'Dragons'},
              'season': {'__typename': 'Season', 'id': 'season-1', 'number': 1},
              'images': <dynamic>[],
              'metadata': <dynamic>[],
            },
            {
              '__typename': 'Movie',
              'id': 'movie-1',
              'name': 'Dragon Movie',
              'releaseYear': 2020,
              'images': <dynamic>[],
              'metadata': <dynamic>[],
            },
            {
              '__typename': 'Show',
              'id': 'show-1',
              'name': 'Dragons',
              'releaseYear': 2019,
              'images': <dynamic>[],
              'metadata': <dynamic>[],
            },
          ],
        });
      }
      return _json({'__typename': 'Query'});
    });

GraphQLClient _client(http.Client httpClient) => GraphQLClient(
      link: HttpLink('https://api.example/graphql', httpClient: httpClient),
      cache: GraphQLCache(),
    );

/// Hosts the real SearchPage as root; the navigation targets are stubs matched
/// by route NAME, so a tap only "lands" when the pushed route resolves — a
/// direct push of the nested ShowEpisodeRoute would fail and render nothing.
class _StubRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          initial: true,
          page: PageInfo('SearchHostRoute',
              builder: (data) =>
                  const SearchPage(serverName: _server, query: 'dragon')),
        ),
        AutoRoute(
          path: '/shows/:showId',
          page: PageInfo('ShowOverviewRoute',
              builder: (data) => const Scaffold(body: AutoRouter())),
          children: [
            AutoRoute(
              path: 'overview',
              initial: true,
              page: PageInfo('ShowOverviewContentRoute',
                  builder: (data) => const Text('show-overview-stub')),
            ),
            AutoRoute(
              path: 'episodes/:episodeId',
              page: PageInfo('ShowEpisodeRoute',
                  builder: (data) => Text(
                      'episode-stub ${data.params.getString('showId')}/${data.params.getString('episodeId')}')),
            ),
          ],
        ),
        AutoRoute(
          path: '/movies/:movieId',
          page: PageInfo('MovieRoute',
              builder: (data) => Text(
                  'movie-stub ${data.params.getString('movieId')}')),
        ),
      ];
}

Widget _wrap(_StubRouter router, http.Client client) => GraphQLProvider(
      client: ValueNotifier(_client(client)),
      child: MaterialApp.router(
        routerConfig: router.config(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
      ),
    );

Future<void> _pump(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // SearchPage touches MediaPlayerHandler.instance (musicPlayerOpen), whose
  // singleton constructs a media_kit Player; force it into existence once.
  MediaKit.ensureInitialized();
  MediaPlayerHandler.instance;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
  });

  tearDown(() {
    ClientManager.testClientBuilder = null;
  });

  testWidgets('tapping an episode result opens the episode inside its show',
      (tester) async {
    final client = _fakeGraphQL();
    ClientManager.testClientBuilder = (_) => _client(client);
    final router = _StubRouter();
    await tester.pumpWidget(_wrap(router, client));
    await _pump(tester);

    await tester.tap(find.text('Episode 3'));
    await _pump(tester);

    expect(find.text('episode-stub show-1/ep-1'), findsOneWidget);
  });

  testWidgets('tapping a movie result opens the movie page', (tester) async {
    final client = _fakeGraphQL();
    ClientManager.testClientBuilder = (_) => _client(client);
    final router = _StubRouter();
    await tester.pumpWidget(_wrap(router, client));
    await _pump(tester);

    await tester.tap(find.text('Dragon Movie'));
    await _pump(tester);

    expect(find.text('movie-stub movie-1'), findsOneWidget);
  });
}
