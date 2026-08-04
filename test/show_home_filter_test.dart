import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/filter/FilterSheet.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/ShowHomePage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/PermissionsService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:visibility_detector/visibility_detector.dart';

const _server = 'test-server';

Map<String, dynamic> _album(String id, String name) => {
      '__typename': 'Album',
      'id': id,
      'name': name,
      'releaseYear': 2020,
      'artist': {'__typename': 'Person', 'id': 'artist-1', 'name': 'The Band'},
      'images': <dynamic>[],
      'metadata': <dynamic>[],
      'rating': null,
    };

Map<String, dynamic> _page(String rootField, String pageTypename,
        List<Map<String, dynamic>> content) =>
    {
      '__typename': 'Query',
      rootField: {
        '__typename': pageTypename,
        'content': content,
        'totalPages': 1,
        'totalElements': content.length,
        'number': 0,
        'size': 15,
      },
    };

Map<String, dynamic> _libraries() => {
      '__typename': 'Query',
      'libraries': [
        {
          '__typename': 'Library',
          'id': 'music-lib-1',
          'name': 'music',
          'type': 'MUSIC',
          'sorting': 'NAME',
          'sortingOrder': 'ASCENDING',
        },
      ],
    };

http.Response _json(Map<String, dynamic> data) => http.Response(
      json.encode({'data': data}),
      200,
      headers: {'content-type': 'application/json'},
    );

/// Routes on the query text and records the variables of every albums query,
/// so the tests can assert what filter (if any) went to the server.
MockClient _fakeGraphQL(
  List<Map<String, dynamic>> albumVariables, {
  List<Map<String, dynamic>>? playlistVariables,
}) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      if (query.contains('createPlaylist(')) {
        final variables =
            (body['variables'] as Map<String, dynamic>?) ?? const {};
        playlistVariables?.add(variables);
        final input = variables['input'] as Map<String, dynamic>? ?? const {};
        return _json(_createdPlaylist(input['name'] as String? ?? ''));
      }
      if (query.contains('albums(')) {
        albumVariables
            .add((body['variables'] as Map<String, dynamic>?) ?? const {});
        return _json(_page('albums', 'AlbumPage',
            [_album('album-1', 'First Album')]));
      }
      if (query.contains('tracks(')) {
        return _json(_page('tracks', 'TrackPage', [
          _track('track-1', 'Opening Song'),
        ]));
      }
      if (query.contains('playlists(')) {
        return _json({'__typename': 'Query', 'playlists': <dynamic>[]});
      }
      if (query.contains('savedViews(')) {
        return _json({'__typename': 'Query', 'savedViews': <dynamic>[]});
      }
      if (query.contains('libraries {')) {
        return _json(_libraries());
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
  // Avoid pumpAndSettle: token/queue services run self-refreshing timers.
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
}

Future<void> _mountBrowse(WidgetTester tester, http.Client client) async {
  await SharedPreferencesAsync()
      .setString('selected_library_id_$_server', 'music-lib-1');
  await SharedPreferencesAsync().setString('library_view_$_server', 'browse');
  ClientManager.testClientBuilder = (_) => GraphQLClient(
        link: HttpLink('https://api.example/graphql', httpClient: client),
        cache: GraphQLCache(),
      );
  await tester
      .pumpWidget(_wrap(const ShowHomePage(serverName: _server), client));
  await _pump(tester);
}

void main() {
  setUpAll(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  setUp(() async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    await SharedPreferencesAsync().clear();
    ClientManager.clients.clear();
    PermissionsService().invalidate(_server);
  });

  tearDown(() {
    ClientManager.testClientBuilder = null;
  });

  group('ShowHomePage custom filter', () {
    testWidgets(
        'building a filter re-queries the grid with the filter variable and '
        'shows a clearable chip', (tester) async {
      final albumVariables = <Map<String, dynamic>>[];
      final client = _fakeGraphQL(albumVariables);
      await _mountBrowse(tester, client);

      // Unfiltered browse: no filter variable on the initial query.
      expect(albumVariables, isNotEmpty);
      expect(albumVariables.last.containsKey('filter'), isFalse);

      // Open the builder: one default condition row (Title contains …).
      await tester.tap(find.byIcon(Icons.filter_alt_outlined));
      // Let the bottom-sheet slide-in animation finish before hit-testing.
      await tester.pump(const Duration(milliseconds: 400));
      await _pump(tester);
      expect(find.byType(FilterSheet), findsOneWidget);
      expect(find.text('Match all of the following'), findsOneWidget);

      await tester.ensureVisible(find.widgetWithText(TextField, 'Value'));
      await tester.enterText(
          find.widgetWithText(TextField, 'Value'), 'glass');
      await tester.ensureVisible(find.text('Apply'));
      await tester.tap(find.text('Apply'));
      await tester.pump(const Duration(milliseconds: 400));
      await _pump(tester);
      expect(find.byType(FilterSheet), findsNothing,
          reason: 'apply should close the sheet');

      // The grid re-queried with the filter tree as a variable.
      final filtered = albumVariables.last['filter'] as Map<String, dynamic>;
      expect(filtered['match'], 'ALL');
      final condition =
          (filtered['conditions'] as List<dynamic>).single as Map<String, dynamic>;
      expect(condition['field'], 'TITLE');
      expect(condition['operator'], 'CONTAINS');
      expect(condition['value'], 'glass');

      // The active filter shows as a chip; albums are not playable, so no
      // play/shuffle actions appear in the filter row.
      expect(find.text('Filter (1)'), findsOneWidget);
      expect(find.byIcon(Icons.filter_alt), findsWidgets);
      expect(find.byIcon(Icons.play_arrow), findsNothing);

      // Clearing the chip drops the filter variable again.
      await tester.tap(find.byIcon(Icons.clear));
      await _pump(tester);
      expect(find.text('Filter (1)'), findsNothing);
      expect(albumVariables.last.containsKey('filter'), isFalse);
    });

    testWidgets('a URL-supplied filter is applied to the first query',
        (tester) async {
      final albumVariables = <Map<String, dynamic>>[];
      final client = _fakeGraphQL(albumVariables);
      await SharedPreferencesAsync()
          .setString('library_view_$_server', 'browse');
      ClientManager.testClientBuilder = (_) => GraphQLClient(
            link: HttpLink('https://api.example/graphql', httpClient: client),
            cache: GraphQLCache(),
          );
      const urlFilter =
          '{"match":"ANY","conditions":[{"field":"RELEASE_YEAR","operator":"LESS_THAN","value":"2010"}]}';
      await tester.pumpWidget(_wrap(
          const ShowHomePage(
            serverName: _server,
            libraryId: 'music-lib-1',
            view: 'browse',
            filter: urlFilter,
          ),
          client));
      await _pump(tester);

      final filtered = albumVariables.last['filter'] as Map<String, dynamic>;
      expect(filtered['match'], 'ANY');
      expect(find.text('Filter (1)'), findsOneWidget);
    });

    testWidgets(
        'saving the filter of a playable kind creates a smart playlist',
        (tester) async {
      final albumVariables = <Map<String, dynamic>>[];
      final playlistVariables = <Map<String, dynamic>>[];
      final client =
          _fakeGraphQL(albumVariables, playlistVariables: playlistVariables);
      await _mountBrowse(tester, client);

      // Albums are not playable; tracks are, so the playlist action only
      // shows up after switching kind.
      await tester.tap(find.text('Tracks'));
      await _pump(tester);

      await tester.tap(find.byIcon(Icons.filter_alt_outlined));
      await tester.pump(const Duration(milliseconds: 400));
      await _pump(tester);
      await tester.ensureVisible(find.widgetWithText(TextField, 'Value'));
      await tester.enterText(find.widgetWithText(TextField, 'Value'), 'glass');
      await tester.ensureVisible(find.text('Apply'));
      await tester.tap(find.text('Apply'));
      await tester.pump(const Duration(milliseconds: 400));
      await _pump(tester);

      expect(find.byIcon(Icons.playlist_add), findsOneWidget);
      await tester.tap(find.byIcon(Icons.playlist_add));
      await tester.pump(const Duration(milliseconds: 400));
      await _pump(tester);
      await tester.enterText(
          find.widgetWithText(TextField, 'Name'), 'Glassy tracks');
      await tester.tap(find.text('OK'));
      await tester.pump(const Duration(milliseconds: 400));
      await _pump(tester);

      final input = playlistVariables.single['input'] as Map<String, dynamic>;
      expect(input['name'], 'Glassy tracks');
      expect(input['type'], 'SMART');
      expect(input['libraryId'], 'music-lib-1');
      expect(input['filterKind'], 'TRACK');
      final filter = input['filter'] as Map<String, dynamic>;
      final condition =
          (filter['conditions'] as List<dynamic>).single as Map<String, dynamic>;
      expect(condition['field'], 'TITLE');
      expect(condition['value'], 'glass');
      expect(find.text('Playlist "Glassy tracks" created'), findsOneWidget);
    });

    testWidgets('switching the browse kind clears the filter', (tester) async {
      final albumVariables = <Map<String, dynamic>>[];
      final client = _fakeGraphQL(albumVariables);
      await _mountBrowse(tester, client);

      await tester.tap(find.byIcon(Icons.filter_alt_outlined));
      // Let the bottom-sheet slide-in animation finish before hit-testing.
      await tester.pump(const Duration(milliseconds: 400));
      await _pump(tester);
      await tester.ensureVisible(find.widgetWithText(TextField, 'Value'));
      await tester.enterText(
          find.widgetWithText(TextField, 'Value'), 'glass');
      await tester.ensureVisible(find.text('Apply'));
      await tester.tap(find.text('Apply'));
      await tester.pump(const Duration(milliseconds: 400));
      await _pump(tester);
      expect(find.text('Filter (1)'), findsOneWidget);

      await tester.tap(find.text('Tracks'));
      await _pump(tester);
      expect(find.text('Filter (1)'), findsNothing,
          reason: 'a filter is field-typed per kind and cannot carry over');
    });
  });
}
