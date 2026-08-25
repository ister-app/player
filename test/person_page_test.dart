import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/components/ArtistTrackList.dart';
import 'package:player/components/CarouselItemView.dart';
import 'package:player/pages/PersonPage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/PermissionsService.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:skeletonizer/skeletonizer.dart';

const _server = 'test-server';

/// `Skeletonizer` is abstract with a factory constructor, so `find.byType`
/// never matches it — match on the type instead.
final _skeleton = find.byWidgetPredicate((w) => w is Skeletonizer);

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

Map<String, dynamic> _compilationAlbum() => {
      '__typename': 'Album',
      'id': 'album-comp',
      'name': 'Rocky IV: Original Motion Picture Score',
      'releaseYear': 1985,
      'artist': {
        '__typename': 'Person',
        'id': 'person-2',
        'name': 'Vince DiCola',
      },
      'images': [],
      'metadata': [],
      'rating': null,
    };

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

Map<String, dynamic> _ownAlbum() => {
      '__typename': 'Album',
      'id': 'album-own',
      'name': 'Rocky Sings',
      'releaseYear': 1990,
      'artist': {
        '__typename': 'Person',
        'id': 'person-1',
        'name': 'Sylvester Stallone',
      },
      'images': [],
      'metadata': [],
      'rating': null,
    };

Map<String, dynamic> _albumPage(List<Map<String, dynamic>> content) => {
      '__typename': 'Query',
      'albums': {
        '__typename': 'AlbumPage',
        'content': content,
        'totalPages': 1,
        'totalElements': content.length,
        'number': 0,
        'size': 200,
      },
    };

/// A ranked-track list answer for the four `*TracksByArtist` queries.
Map<String, dynamic> _trackList(String field,
        [List<Map<String, dynamic>> tracks = const []]) =>
    {
      '__typename': 'Query',
      'personById': {
        '__typename': 'Person',
        'id': 'person-1',
        field: tracks,
      },
    };

Map<String, dynamic> _playedTrack(int n) => {
      '__typename': 'Track',
      'id': 'track-$n',
      'number': n,
      'discNumber': 1,
      'artist': {
        '__typename': 'Person',
        'id': 'person-1',
        'name': 'Sylvester Stallone',
      },
      'rating': null,
      'metadata': [
        {
          '__typename': 'Metadata',
          'id': 'meta-t$n',
          'description': null,
          'language': 'eng',
          'sourceUri': null,
          'source': null,
          'title': 'Eye of the Tiger $n',
          'released': null,
          'genre': null,
        }
      ],
      'mediaFile': [
        {'__typename': 'MediaFile', 'durationInMilliseconds': 210000}
      ],
      'playCount': 12,
      'album': _ownAlbum(),
    };

MockClient _fakeGraphQL({
  Map<String, dynamic>? person,
  List<Map<String, dynamic>> appearsOn = const [],
  List<Map<String, dynamic>> albums = const [],
  List<Map<String, dynamic>> topPlayed = const [],
  // Held open, these keep the (server-side slow) ranked-track queries pending
  // so the reserved skeleton can be observed.
  Future<void>? trackGate,
  Future<void>? albumGate,
}) =>
    MockClient((request) async {
      final query =
          (json.decode(request.body) as Map<String, dynamic>)['query'] as String;
      if (query.contains('artistById')) {
        return _json({'__typename': 'Query', 'artistById': person});
      }
      if (query.contains('TracksByArtist')) {
        if (trackGate != null) await trackGate;
        if (query.contains('topPlayedTracks')) {
          return _json(_trackList('topPlayedTracks', topPlayed));
        }
        if (query.contains('recentlyPlayedTracks')) {
          return _json(_trackList('recentlyPlayedTracks'));
        }
        if (query.contains('topRatedTracks')) {
          return _json(_trackList('topRatedTracks'));
        }
        return _json(_trackList('recentlyAddedTracks'));
      }
      if (query.contains('query appearsOnAlbums')) {
        return _json({
          '__typename': 'Query',
          'albums': {
            '__typename': 'AlbumPage',
            'content': appearsOn,
            'totalPages': 1,
            'totalElements': appearsOn.length,
            'number': 0,
            'size': 200,
          },
        });
      }
      if (query.contains('query albums')) {
        if (albumGate != null) await albumGate;
        return albums.isEmpty ? _json(_emptyPage('albums')) : _json(_albumPage(albums));
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
  // No video output plugin in a widget test: answer the texture-create call
  // with null so the handler's VideoController setup idles instead of failing
  // the suite with an unhandled MissingPluginException.
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('com.alexmercerind/media_kit_video'),
          (call) async => null);
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

  testWidgets('lists compilations and guest appearances under "Appears on"',
      (tester) async {
    final client = _fakeGraphQL(
        person: _person(), appearsOn: [_compilationAlbum()]);
    useClient(client);
    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();

    expect(find.text('Appears on'), findsOneWidget);
    expect(find.text('Rocky IV: Original Motion Picture Score'), findsOneWidget);
    // The tile's subtitle names the album artist, which is what sets these
    // apart from the person's own albums.
    expect(find.text('Vince DiCola'), findsOneWidget);
    // No albums of their own: the "Albums" section stays away.
    expect(find.text('Albums'), findsNothing);
  });

  testWidgets('hides "Appears on" when the person is on no other albums',
      (tester) async {
    final client = _fakeGraphQL(person: _person());
    useClient(client);
    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();

    expect(find.text('Appears on'), findsNothing);
  });

  testWidgets('shows not-found instead of an eternal skeleton', (tester) async {
    final client = _fakeGraphQL(person: null);
    useClient(client);
    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();

    expect(find.text('Person not found'), findsOneWidget);
    expect(_skeleton, findsNothing);
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

  testWidgets('reserves the played-track section while its queries load',
      (tester) async {
    final gate = Completer<void>();
    final client = _fakeGraphQL(
      person: _person(),
      albums: [_ownAlbum()],
      topPlayed: [for (var n = 1; n <= 5; n++) _playedTrack(n)],
      trackGate: gate.future,
    );
    useClient(client);
    await tester.pumpWidget(_app(client));
    // Fixed pumps, not pumpAndSettle: the skeleton's shimmer never settles.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.byType(ArtistTrackListSkeleton), findsOneWidget);
    final reserved = tester.getRect(find.byType(ArtistTrackListSkeleton));

    gate.complete();
    await tester.pumpAndSettle();

    expect(find.byType(ArtistTrackListSkeleton), findsNothing);
    expect(find.text('Eye of the Tiger 1'), findsOneWidget);
    // The point of the whole exercise: the real list takes the same room the
    // skeleton held, so nothing below it moves when the query lands.
    final real = tester.getRect(find.byType(ArtistTrackList));
    expect(real.top, closeTo(reserved.top, 1));
    expect(real.height, closeTo(reserved.height, 8));
  });

  testWidgets('reserves no track space for a person without music',
      (tester) async {
    final gate = Completer<void>();
    final client =
        _fakeGraphQL(person: _person(), trackGate: gate.future);
    useClient(client);
    await tester.pumpWidget(_app(client));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.byType(ArtistTrackListSkeleton), findsNothing);

    gate.complete();
    await tester.pumpAndSettle();
    expect(_skeleton, findsNothing);
  });

  testWidgets('drops the track section when every ranked list is empty',
      (tester) async {
    final client = _fakeGraphQL(person: _person(), albums: [_ownAlbum()]);
    useClient(client);
    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();

    expect(find.byType(ArtistTrackListSkeleton), findsNothing);
    expect(find.text('Most played'), findsNothing);
    expect(_skeleton, findsNothing);
  });

  testWidgets('holds the albums grid open while the albums query is out',
      (tester) async {
    final gate = Completer<void>();
    final client = _fakeGraphQL(
      person: _person(),
      albums: [_ownAlbum()],
      albumGate: gate.future,
    );
    useClient(client);
    await tester.pumpWidget(_app(client));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    // Placeholder tiles stand in for the albums that are still coming.
    expect(_skeleton, findsWidgets);
    expect(find.text('Albums'), findsOneWidget);
    expect(find.byType(CarouselItemView), findsWidgets);

    gate.complete();
    await tester.pumpAndSettle();

    expect(_skeleton, findsNothing);
    expect(find.text('Rocky Sings'), findsOneWidget);
  });
}
