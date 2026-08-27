import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/AddToPlaylistSheet.dart';
import 'package:player/components/BrowseListRow.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/PlaylistPage.dart';
import 'package:media_kit/media_kit.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

const _server = 'test-server';

Map<String, dynamic> _playlist(
  String id,
  String name, {
  String type = 'MANUAL',
  String libraryType = 'MUSIC',
  int? itemCount = 0,
  List<Map<String, dynamic>>? items,
  List<Map<String, dynamic>>? coverImages,
}) =>
    {
      '__typename': 'Playlist',
      'id': id,
      'name': name,
      'type': type,
      'libraryId': 'lib-$libraryType',
      'libraryType': libraryType,
      'itemCount': type == 'MANUAL' ? itemCount : null,
      'coverImages': coverImages ?? <dynamic>[],
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
      'tagline': null,
          }
        ],
        'mediaFile': <dynamic>[],
        'rating': null,
      },
    };

/// A track as the `tracks` browse query returns it — the smart playlist body
/// renders the live filter result with the same paged widgets the library uses.
Map<String, dynamic> _browseTrack(String id, String title) => {
      '__typename': 'Track',
      'id': id,
      'number': 1,
      'discNumber': 1,
      'artist': {'__typename': 'Person', 'id': 'p1', 'name': 'The Artist'},
      'album': {
        '__typename': 'Album',
        'id': 'a1',
        'name': 'The Album',
        'releaseYear': 2020,
        'artist': {'__typename': 'Person', 'id': 'p1', 'name': 'The Artist'},
        'images': <dynamic>[],
        'metadata': <dynamic>[],
        'rating': null,
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
      'tagline': null,
        }
      ],
      'mediaFile': <dynamic>[],
      'rating': null,
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
  TestWidgetsFlutterBinding.ensureInitialized();
  // Playing from the page touches MediaPlayerHandler.instance, whose singleton
  // constructs a media_kit Player; force it into existence outside any test zone.
  // No video output plugin in a widget test: answer the texture-create call
  // with null so the handler's VideoController setup idles. The
  // MissingPluginException it throws otherwise arrives asynchronously, so it
  // lands on whichever test happens to be running and reports that one as
  // "did not complete" — a flake that moves around and never names its cause.
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('com.alexmercerind/media_kit_video'),
          (call) async => null);
  MediaKit.ensureInitialized();
  MediaPlayerHandler.instance;

  setUp(() {
    // The paged smart-playlist body schedules visibility callbacks; without
    // this they outlive the widget tree as pending timers.
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

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

    testWidgets('creates a playlist for the item when there is none yet',
        (tester) async {
      final addedIds = <String>[];
      Map<String, dynamic>? createInput;
      _mockGraphQL(MockClient((request) async {
        final body = json.decode(request.body);
        final query = body['query'] as String? ?? '';
        if (query.contains('createPlaylist')) {
          createInput = body['variables']['input'] as Map<String, dynamic>;
          return _json({
            '__typename': 'Mutation',
            'createPlaylist': _playlist('pl-new', 'Roadtrip'),
          });
        }
        if (query.contains('addPlaylistItem')) {
          addedIds.add(body['variables']['mediaId'] as String);
          return _json({
            '__typename': 'Mutation',
            'addPlaylistItem': {
              '__typename': 'Playlist',
              'id': 'pl-new',
              'itemCount': addedIds.length,
            },
          });
        }
        if (query.contains('playlists(')) {
          // Nothing to pick from: creating is the only way forward.
          return _json({'__typename': 'Query', 'playlists': <dynamic>[]});
        }
        if (query.contains('libraries {')) {
          return _json({
            '__typename': 'Query',
            'libraries': [
              {
                '__typename': 'Library',
                'id': 'lib-MUSIC',
                'name': 'music',
                'type': 'MUSIC',
                'sorting': 'NAME',
                'sortingOrder': 'ASCENDING',
              },
              // Another type: it cannot hold tracks, so it is not even offered.
              {
                '__typename': 'Library',
                'id': 'lib-MOVIE',
                'name': 'movies',
                'type': 'MOVIE',
                'sorting': 'NAME',
                'sortingOrder': 'ASCENDING',
              },
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

      await tester.tap(find.text('New playlist'));
      await tester.pump(const Duration(milliseconds: 400));
      await _pump(tester);
      await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Roadtrip');
      await tester.tap(find.text('OK'));
      await tester.pump(const Duration(milliseconds: 400));
      await _pump(tester);

      // One music library, so it is chosen without asking; the new playlist is
      // manual and the item lands in it.
      expect(createInput?['name'], 'Roadtrip');
      expect(createInput?['type'], 'MANUAL');
      expect(createInput?['libraryId'], 'lib-MUSIC');
      expect(addedIds, ['track-1']);
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
      // Manual entries render as the same artwork rows the smart body shows.
      expect(find.byType(BrowseListRow), findsNWidgets(2));
      expect(find.text('The Artist • The Album'), findsNWidgets(2));
      expect(find.byIcon(Icons.music_note), findsNWidgets(2),
          reason: 'the cover placeholder stands in for a track without artwork');
    });

    testWidgets('tapping a track of a smart playlist plays the playlist',
        (tester) async {
      final creates = <Map<String, dynamic>>[];
      _mockGraphQL(MockClient((request) async {
        final body = json.decode(request.body) as Map<String, dynamic>;
        final query = body['query'] as String? ?? '';
        if (query.contains('mutation createPlayQueue')) {
          creates.add(
              (body['variables']['input'] as Map<String, dynamic>?) ?? {});
          // Failing the creation keeps the handler out of playback (and out of
          // its heartbeat timer): this test is about which queue gets created,
          // not about playback itself.
          return http.Response(
            json.encode({
              'errors': [
                {'message': 'queue creation stops here'}
              ]
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (query.contains('playlistById')) {
          return _json({
            '__typename': 'Query',
            'playlistById': _playlist('pl-s', 'Smart Mix',
                type: 'SMART', items: <Map<String, dynamic>>[]),
          });
        }
        if (query.contains('query tracks')) {
          return _json({
            '__typename': 'Query',
            'tracks': {
              '__typename': 'TrackPage',
              'content': [
                _browseTrack('track-1', 'First Song'),
                _browseTrack('track-2', 'Second Song'),
              ],
              'totalPages': 1,
              'totalElements': 2,
              'number': 0,
              'size': 15,
            },
          });
        }
        return _json({'__typename': 'Query'});
      }));

      // The smart body browses through PagedContentView, which reads the
      // client from the widget tree rather than from ClientManager.
      await tester.pumpWidget(GraphQLProvider(
        client: ValueNotifier(ClientManager.getClientForUrl(_server).value),
        child: _wrap(
            const PlaylistPage(serverName: _server, playlistId: 'pl-s')),
      ));
      await _pump(tester);
      expect(find.text('Second Song'), findsOneWidget);

      await tester.tap(find.text('Second Song'));
      await _pump(tester);

      // The playlist itself becomes the queue — not the track's album — and
      // the tapped track goes along as the item to start at.
      expect(creates.first['sourceType'], 'PLAYLIST');
      expect(creates.first['sourceId'], 'pl-s');
      expect(creates.first['startId'], 'track-2');
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
