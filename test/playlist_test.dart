import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/AddToPlaylistSheet.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/PlaylistPage.dart';
import 'package:player/utils/ClientManager.dart';

const _server = 'test-server';

Map<String, dynamic> _playlist(
  String id,
  String name, {
  String type = 'MANUAL',
  String libraryType = 'MUSIC',
  int? itemCount = 0,
  List<Map<String, dynamic>>? items,
}) =>
    {
      '__typename': 'Playlist',
      'id': id,
      'name': name,
      'type': type,
      'libraryId': 'lib-$libraryType',
      'libraryType': libraryType,
      'itemCount': type == 'MANUAL' ? itemCount : null,
      'filterKind': type == 'SMART' ? 'TRACK' : null,
      'sorting': null,
      'sortingOrder': null,
      'filter': type == 'SMART'
          ? {
              '__typename': 'FilterGroup',
              'match': 'ALL',
              'limit': null,
              'conditions': <dynamic>[],
              'groups': <dynamic>[],
            }
          : null,
      if (items != null) 'items': items,
    };

Map<String, dynamic> _trackItem(String id, String title) => {
      '__typename': 'PlaylistItem',
      'id': id,
      'position': 1000.0,
      'type': 'TRACK',
      'episode': null,
      'movie': null,
      'book': null,
      'podcastEpisode': null,
      'track': {
        '__typename': 'Track',
        'id': 'track-$id',
        'number': 1,
        'discNumber': 1,
        'artist': {'__typename': 'Person', 'id': 'p1', 'name': 'The Artist'},
        'album': {
          '__typename': 'Album',
          'id': 'a1',
          'name': 'The Album',
          'images': <dynamic>[],
        },
        'metadata': [
          {
            '__typename': 'Metadata',
            'id': 'm-$id',
            'sourceUri': null,
            'source': null,
            'language': null,
            'title': title,
            'description': null,
            'released': null,
            'genre': null,
          }
        ],
        'mediaFile': <dynamic>[],
        'rating': null,
      },
    };

http.Response _json(Map<String, dynamic> data) => http.Response(
      json.encode({'data': data}),
      200,
      headers: {'content-type': 'application/json'},
    );

Widget _wrap(Widget child) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: child,
    );

void _mockGraphQL(http.Client client) {
  ClientManager.testClientBuilder = (_) => GraphQLClient(
        link: HttpLink('https://api.example/graphql', httpClient: client),
        cache: GraphQLCache(),
      );
}

Future<void> _pump(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
}

void main() {
  tearDown(() {
    ClientManager.testClientBuilder = null;
    ClientManager.clients.clear();
  });

  group('AddToPlaylistSheet', () {
    testWidgets('offers only manual playlists that can hold the item kind',
        (tester) async {
      _mockGraphQL(MockClient((request) async {
        final query = json.decode(request.body)['query'] as String? ?? '';
        if (query.contains('playlists(')) {
          return _json({
            '__typename': 'Query',
            'playlists': [
              _playlist('pl-1', 'Music Mix', itemCount: 3),
              _playlist('pl-2', 'Smart Music', type: 'SMART'),
              _playlist('pl-3', 'Movie Night', libraryType: 'MOVIE'),
            ],
          });
        }
        return _json({'__typename': 'Query'});
      }));

      await tester.pumpWidget(_wrap(Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => showAddToPlaylistSheet(
                context,
                serverName: _server,
                mediaType: Enum$MediaType.TRACK,
                loadItemIds: (_) async => ['track-1'],
              ),
              child: const Text('open'),
            ),
          ),
        ),
      )));
      await tester.tap(find.text('open'));
      await _pump(tester);

      expect(find.text('Music Mix'), findsOneWidget);
      expect(find.text('3 items'), findsOneWidget);
      // Smart playlists cannot take manual items; movie playlists no tracks.
      expect(find.text('Smart Music'), findsNothing);
      expect(find.text('Movie Night'), findsNothing);
    });

    testWidgets('adding reports success and calls the mutation per item',
        (tester) async {
      final addedIds = <String>[];
      _mockGraphQL(MockClient((request) async {
        final body = json.decode(request.body);
        final query = body['query'] as String? ?? '';
        if (query.contains('addPlaylistItem')) {
          addedIds.add(body['variables']['mediaId'] as String);
          return _json({
            '__typename': 'Mutation',
            'addPlaylistItem': {
              '__typename': 'Playlist',
              'id': 'pl-1',
              'itemCount': addedIds.length,
            },
          });
        }
        if (query.contains('playlists(')) {
          return _json({
            '__typename': 'Query',
            'playlists': [_playlist('pl-1', 'Music Mix')],
          });
        }
        return _json({'__typename': 'Query'});
      }));

      await tester.pumpWidget(_wrap(Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => showAddToPlaylistSheet(
                context,
                serverName: _server,
                mediaType: Enum$MediaType.TRACK,
                loadItemIds: (_) async => ['track-1', 'track-2'],
              ),
              child: const Text('open'),
            ),
          ),
        ),
      )));
      await tester.tap(find.text('open'));
      await _pump(tester);
      await tester.tap(find.text('Music Mix'));
      await _pump(tester);

      expect(addedIds, ['track-1', 'track-2']);
      expect(find.text('Added to playlist'), findsOneWidget);
    });
  });

  group('PlaylistPage', () {
    testWidgets('renders a manual playlist with its items and actions',
        (tester) async {
      _mockGraphQL(MockClient((request) async {
        final query = json.decode(request.body)['query'] as String? ?? '';
        if (query.contains('playlistById')) {
          return _json({
            '__typename': 'Query',
            'playlistById': _playlist('pl-1', 'Road Trip', itemCount: 2, items: [
              _trackItem('i1', 'First Song'),
              _trackItem('i2', 'Second Song'),
            ]),
          });
        }
        return _json({'__typename': 'Query'});
      }));

      await tester.pumpWidget(_wrap(
          const PlaylistPage(serverName: _server, playlistId: 'pl-1')));
      await _pump(tester);

      expect(find.text('Road Trip'), findsOneWidget);
      expect(find.text('First Song'), findsOneWidget);
      expect(find.text('Second Song'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byIcon(Icons.shuffle), findsOneWidget);
    });

    testWidgets('hides shuffle for a book playlist', (tester) async {
      _mockGraphQL(MockClient((request) async {
        final query = json.decode(request.body)['query'] as String? ?? '';
        if (query.contains('playlistById')) {
          return _json({
            '__typename': 'Query',
            'playlistById': _playlist('pl-b', 'Reading List',
                libraryType: 'BOOK', itemCount: 0, items: []),
          });
        }
        return _json({'__typename': 'Query'});
      }));

      await tester.pumpWidget(_wrap(
          const PlaylistPage(serverName: _server, playlistId: 'pl-b')));
      await _pump(tester);

      expect(find.text('Reading List'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byIcon(Icons.shuffle), findsNothing);
    });
  });
}
