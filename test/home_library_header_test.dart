import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/MovieScroll.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/ServerHomeContentPage.dart';
import 'package:player/pages/ShowHomePage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LibrarySelectionNotifier.dart';
import 'package:player/utils/PermissionsService.dart';
import 'package:player/utils/TabNavigationNotifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:visibility_detector/visibility_detector.dart';

const _server = 'test-server';

http.Response _json(Map<String, dynamic> data) => http.Response(
      json.encode({'data': data}),
      200,
      headers: {'content-type': 'application/json'},
    );

MockClient _fakeGraphQL() => MockClient((request) async {
      final query = json.decode(request.body)['query'] as String? ?? '';
      if (query.contains('libraries {')) {
        return _json({
          '__typename': 'Query',
          'libraries': [
            {
              '__typename': 'Library',
              'id': 'movie-lib-1',
              'name': 'Movies',
              'type': 'MOVIE',
              'sorting': 'NAME',
              'sortingOrder': 'ASCENDING',
            }
          ],
        });
      }
      if (query.contains('movies(')) {
        return _json({
          '__typename': 'Query',
          'movies': {
            '__typename': 'MoviePage',
            'content': <dynamic>[],
            'totalPages': 0,
            'totalElements': 0,
            'number': 0,
            'size': 15,
          },
        });
      }
      return _json({'__typename': 'Query'});
    });

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
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    PermissionsService().invalidate(_server);
    pendingLibrarySelection.value = null;
    tabNavigationNotifier.value = 0;
  });

  tearDown(() {
    ClientManager.testClientBuilder = null;
    pendingLibrarySelection.value = null;
    tabNavigationNotifier.value = 0;
  });

  testWidgets(
      'tapping a home library header announces the pick and switches tabs',
      (tester) async {
    final client = _fakeGraphQL();
    await tester.pumpWidget(
        _wrap(const ServerHomeContentPage(serverName: _server), client));
    await _pump(tester);

    await tester.tap(find.text('Movies:'));

    // No ShowHomePage mounted here: the value stays pending.
    expect(pendingLibrarySelection.value?.serverName, _server);
    expect(pendingLibrarySelection.value?.libraryId, 'movie-lib-1');
    expect(pendingLibrarySelection.value?.libraryType, Enum$LibraryType.MOVIE);
    expect(tabNavigationNotifier.value, 1);
  });

  testWidgets(
      'ShowHomePage consumes a pending selection into the Browse grid and persists it',
      (tester) async {
    final client = _fakeGraphQL();
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql', httpClient: client),
          cache: GraphQLCache(),
        );
    pendingLibrarySelection.value = const PendingLibrarySelection(
      serverName: _server,
      libraryId: 'movie-lib-1',
      libraryType: Enum$LibraryType.MOVIE,
    );

    await tester
        .pumpWidget(_wrap(const ShowHomePage(serverName: _server), client));
    await _pump(tester);

    expect(pendingLibrarySelection.value, isNull);
    // Browse mode: the sortable grid, not the Discover carousels.
    expect(find.byType(MovieScroll), findsOneWidget);
    final prefs = SharedPreferencesAsync();
    expect(await prefs.getString('selected_library_id_$_server'),
        'movie-lib-1');
    expect(
        await prefs.getString('selected_library_type_$_server'), 'MOVIE');
    expect(await prefs.getString('library_view_$_server'), 'browse');
  });
}
