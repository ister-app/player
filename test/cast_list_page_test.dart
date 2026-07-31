import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/CastRow.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/CastListPage.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:visibility_detector/visibility_detector.dart';

const _server = 'test-server';
const _pageSize = 20;

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

MockClient _fakeGraphQL({int total = 22}) => MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      final vars = (body['variables'] as Map<String, dynamic>?) ?? {};
      if (query.contains('cast(')) {
        final page = (vars['page'] as int?) ?? 0;
        final start = page * _pageSize;
        final count = (total - start).clamp(0, _pageSize);
        return _json({
          '__typename': 'Query',
          'cast': {
            '__typename': 'CreditPage',
            'content': List.generate(count, (i) => _credit(start + i)),
            'totalPages': (total / _pageSize).ceil(),
            'totalElements': total,
            'number': page,
            'size': _pageSize,
          },
        });
      }
      return _json({'__typename': 'Query'});
    });

/// The cast row at '/', a stub in place of the real cast list page.
class _NavRouter extends RootStackRouter {
  CastListRouteArgs? pushedArgs;

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          initial: true,
          page: PageInfo('CastHostRoute',
              builder: (data) => const Scaffold(
                    body: PagedCastRow(serverName: _server, movieId: 'movie-1'),
                  )),
        ),
        AutoRoute(
          path: '/cast',
          page: PageInfo(CastListRoute.name, builder: (data) {
            pushedArgs = data.argsAs<CastListRouteArgs>();
            return const Scaffold(body: Text('cast-list-stub'));
          }),
        ),
      ];
}

Widget _wrapRouter(_NavRouter router, http.Client client) => GraphQLProvider(
      client: ValueNotifier(GraphQLClient(
        link: HttpLink('https://api.example/graphql', httpClient: client),
        cache: GraphQLCache(),
      )),
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

Widget _wrap(Widget child, http.Client client) => GraphQLProvider(
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
        home: child,
      ),
    );

Future<void> _pump(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
}

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('the cast header opens the cast list with the parent id',
      (tester) async {
    final router = _NavRouter();
    await tester.pumpWidget(_wrapRouter(router, _fakeGraphQL()));
    await _pump(tester);

    await tester.tap(find.text('Cast'));
    await _pump(tester);

    expect(find.text('cast-list-stub'), findsOneWidget);
    expect(router.pushedArgs?.movieId, 'movie-1');
    expect(router.pushedArgs?.showId, isNull);
    expect(router.pushedArgs?.episodeId, isNull);
  });

  testWidgets('the cast list pages the full cast into a vertical grid',
      (tester) async {
    await tester.pumpWidget(_wrap(
      const CastListPage(serverName: _server, movieId: 'movie-1'),
      _fakeGraphQL(total: 22),
    ));
    await _pump(tester);

    expect(find.byType(GridView), findsOneWidget);
    expect(find.text('Person 0'), findsOneWidget);

    // Scroll the page-1 skeletons into view to trigger the second fetch.
    await tester.drag(find.byType(GridView), const Offset(0, -4000));
    await _pump(tester);
    await tester.drag(find.byType(GridView), const Offset(0, -4000));
    await _pump(tester);

    expect(find.text('Person 21'), findsOneWidget);
  });
}
