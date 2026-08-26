import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/pages/ShowOverviewContentPage.dart';
import 'package:player/pages/ShowOverviewPage.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/TvDirectionalFocusPolicy.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// On the TV the show page stacks: hero, description, cast row (all in the
/// nested content route) and the season list (parent route) below the fold.
/// D-pad DOWN from the cast row must reach the season list — with the default
/// directional policy it never does, because the season tiles live in a
/// different navigator FocusScope and lose the geometric contest to whatever
/// is still visible.
const _server = 'test-server';

Map<String, dynamic> _credit(int i) => {
      '__typename': 'Credit',
      'id': 'credit-$i',
      'characterName': 'Character $i',
      'creditType': 'CAST',
      'castOrder': i,
      'person': {
        '__typename': 'Person',
        'id': 'person-$i',
        'name': 'Person $i',
        'images': <dynamic>[],
      },
    };

http.Response _json(Map<String, dynamic> data) => http.Response(
      json.encode({'data': data}),
      200,
      headers: {'content-type': 'application/json'},
    );

MockClient _fakeGraphQL() => MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      // Before the showById branch: the related query selects showById too, and
      // answering it with the full show payload would leave `related` missing.
      if (query.contains('query relatedShows')) {
        return _json({
          '__typename': 'Query',
          'showById': {
            '__typename': 'Show',
            'id': 'show-1',
            'related': <dynamic>[],
          },
        });
      }
      if (query.contains('showById(')) {
        return _json({
          '__typename': 'Query',
          'showById': {
            '__typename': 'Show',
            'id': 'show-1',
            'images': <dynamic>[],
            'name': 'Test Show',
            'releaseYear': 2001,
            'metadata': [
              {
                '__typename': 'Metadata',
                'description': 'A show used to test D-pad traversal.',
                'id': 'meta-1',
                'language': 'en',
                'sourceUri': null,
                'source': null,
                'title': 'Test Show',
                'released': null,
                'genre': null,
      'tagline': null,
              }
            ],
            'seasons': [
              {'__typename': 'Season', 'id': 'season-1', 'number': 1},
              {'__typename': 'Season', 'id': 'season-2', 'number': 2},
            ],
            'cast': List.generate(3, _credit),
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
          },
        });
      }
      if (query.contains('cast(')) {
        return _json({
          '__typename': 'Query',
          'cast': {
            '__typename': 'CreditPage',
            'content': List.generate(3, _credit),
            'totalPages': 1,
            'totalElements': 3,
            'number': 0,
            'size': 20,
          },
        });
      }
      return _json({'__typename': 'Query'});
    });

/// The real show overview page with its real nested content route.
class _ShowRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          initial: true,
          page: PageInfo(ShowOverviewRoute.name,
              builder: (_) => const ShowOverviewPage(
                  serverName: _server, showId: 'show-1')),
          children: [
            AutoRoute(
              path: 'overview',
              initial: true,
              page: PageInfo(ShowOverviewContentRoute.name,
                  builder: (_) => const ShowOverviewContentPage(
                      serverName: _server, showId: 'show-1')),
            ),
          ],
        ),
      ];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.empty();
  // Create the handler singleton (WatchTogetherButton touches it) outside the
  // test zone, so its periodic stall-watchdog timer isn't a fake test timer.
  MediaPlayerHandler.instance;

  testWidgets('D-pad DOWN from the cast row reaches the season list',
      (tester) async {
    // The TV: 1080p panel at xhdpi → logical 960x540, stacked wrap layout.
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final client = _fakeGraphQL();
    // PermissionsService goes through ClientManager rather than the provider.
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql', httpClient: client),
          cache: GraphQLCache(),
        );
    addTearDown(() => ClientManager.testClientBuilder = null);

    final router = _ShowRouter();
    await tester.pumpWidget(GraphQLProvider(
      client: ValueNotifier(GraphQLClient(
        link: HttpLink('https://api.example/graphql', httpClient: client),
        cache: GraphQLCache(),
      )),
      child: MaterialApp.router(
        routerConfig: router.config(),
        builder: (context, child) => FocusTraversalGroup(
          policy: TvDirectionalFocusPolicy(),
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(navigationMode: NavigationMode.directional),
            child: child ?? const SizedBox.shrink(),
          ),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
      ),
    ));
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.text('Person 2'), findsWidgets);

    // Focus the last cast tile, like D-pad navigation would have.
    Focus.of(tester.element(find.text('Person 2').first)).requestFocus();
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();

    final seasonTile = find.widgetWithText(ListTile, 'Season 1');
    expect(seasonTile, findsOneWidget);
    final tileRect = tester.getRect(seasonTile);
    expect(FocusManager.instance.primaryFocus?.rect, tileRect,
        reason: 'DOWN from the cast row must land on the season list');
    // ensureVisible must have scrolled the tile into the viewport.
    expect(tileRect.bottom, lessThanOrEqualTo(540));
  });
}
