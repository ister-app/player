import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/IsterMediaService.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/utils/ClientManager.dart';

const _server = 'test-server';
const _libraryId = 'lib-1';

Map<String, dynamic> _album(String id, String name) => {
      '__typename': 'Album',
      'id': id,
      'name': name,
      'releaseYear': 2020,
      'artist': {'__typename': 'Artist', 'id': 'artist-1', 'name': 'The Band'},
      'images': <dynamic>[],
      'metadata': <dynamic>[],
      'rating': null,
    };

Map<String, dynamic> _albumsPage(List<Map<String, dynamic>> albums) => {
      '__typename': 'Query',
      'albums': {
        '__typename': 'AlbumPage',
        'content': albums,
        'totalPages': 1,
        'totalElements': albums.length,
        'number': 0,
        'size': albums.length,
      },
    };

Map<String, dynamic> _discoverAlbums({
  List<Map<String, dynamic>> recentlyPlayed = const [],
  List<Map<String, dynamic>> mostPlayed = const [],
  List<Map<String, dynamic>> highestRated = const [],
}) =>
    {
      '__typename': 'Query',
      'libraryById': {
        '__typename': 'Library',
        'id': _libraryId,
        'recentlyPlayedAlbums': recentlyPlayed,
        'mostPlayedAlbums': mostPlayed,
        'highestRatedAlbums': highestRated,
      },
    };

Map<String, dynamic> _rankedAlbums(List<Map<String, dynamic>> albums) => {
      '__typename': 'Query',
      'libraryById': {
        '__typename': 'Library',
        'id': _libraryId,
        'rankedAlbums': {
          '__typename': 'AlbumPage',
          'content': albums,
          'totalPages': 1,
          'totalElements': albums.length,
          'number': 0,
          'size': albums.length,
        },
      },
    };

http.Response _json(Map<String, dynamic> data) => http.Response(
      json.encode({'data': data}),
      200,
      headers: {'content-type': 'application/json'},
    );

http.Response _graphQLError(String message) => http.Response(
      json.encode({
        'errors': [
          {'message': message}
        ]
      }),
      200,
      headers: {'content-type': 'application/json'},
    );

/// Routes on the query text; graphql_flutter sends no operationName. Records
/// the variables of every list query so sorting can be asserted.
MockClient _fakeGraphQL({
  Map<String, dynamic>? discover,
  bool discoverErrors = false,
  bool rankedErrors = false,
  List<Map<String, dynamic>> Function()? recentlyAddedAlbums,
  List<Map<String, dynamic>> Function()? rankedContent,
  List<Map<String, dynamic>>? recordedAlbumVariables,
}) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      if (query.contains('createStreamToken')) {
        return _json({
          '__typename': 'Mutation',
          'createStreamToken': {
            '__typename': 'StreamToken',
            'token': 'stream-token',
            'expiresAt':
                DateTime.now().add(const Duration(days: 1)).toIso8601String(),
          },
        });
      }
      if (query.contains('recentlyPlayedAlbums')) {
        if (discoverErrors) {
          return _graphQLError("Validation error: unknown field 'libraryById'");
        }
        return _json(discover ?? _discoverAlbums());
      }
      if (query.contains('rankedAlbums')) {
        if (rankedErrors) {
          return _graphQLError("Validation error: unknown field 'rankedAlbums'");
        }
        return _json(_rankedAlbums(rankedContent?.call() ?? const []));
      }
      if (query.contains('albums(')) {
        recordedAlbumVariables
            ?.add(body['variables'] as Map<String, dynamic>? ?? {});
        return _json(_albumsPage(recentlyAddedAlbums?.call() ?? const []));
      }
      return _json({'__typename': 'Query'});
    });

void _installClient(MockClient client) {
  ClientManager.testClientBuilder = (_) => GraphQLClient(
        link: HttpLink('https://api.example/graphql', httpClient: client),
        cache: GraphQLCache(),
      );
}

String? _groupOf(IsterMediaItem item) =>
    item.extras?[IsterMediaService.contentStyleGroupTitleHint] as String?;

void main() {
  setUp(() {
    ClientManager.clients.clear();
  });

  tearDown(() {
    ClientManager.testClientBuilder = null;
  });

  group('discover/ranked node ids', () {
    test('DiscoverNodeId round-trips through its id and MediaItemId', () {
      for (final kind in DiscoverKind.values) {
        final node = DiscoverNodeId(kind, _libraryId);
        expect(node.id, isNot(contains(';')));
        expect(node.id, isNot(contains('~')));

        final outer =
            MediaItemId(_server, IsterMediaTypes.list, node.id).toString();
        final parsed = DiscoverNodeId.parse(MediaItemId.byStringId(outer).id);
        expect(parsed?.kind, kind);
        expect(parsed?.libraryId, _libraryId);
      }
    });

    test('RankedNodeId round-trips every kind and rank', () {
      for (final kind in DiscoverKind.values) {
        for (final rank in DiscoverRank.values) {
          final node = RankedNodeId(kind, _libraryId, rank);
          expect(node.id, isNot(contains(';')));
          expect(node.id, isNot(contains('~')));

          final parsed = RankedNodeId.parse(node.id);
          expect(parsed?.kind, kind);
          expect(parsed?.libraryId, _libraryId);
          expect(parsed?.rank, rank);
        }
      }
    });

    test('malformed ids parse to null', () {
      expect(DiscoverNodeId.parse('discover:albums'), isNull);
      expect(DiscoverNodeId.parse('discover:movies:lib-1'), isNull);
      expect(DiscoverNodeId.parse('discover:albums:'), isNull);
      expect(DiscoverNodeId.parse('ranked:albums:lib-1:MOST_PLAYED'), isNull);
      expect(RankedNodeId.parse('ranked:albums:lib-1'), isNull);
      expect(RankedNodeId.parse('ranked:albums:lib-1:BEST'), isNull);
      expect(RankedNodeId.parse('ranked:shows:lib-1:MOST_PLAYED'), isNull);
      expect(RankedNodeId.parse('discover:albums:lib-1'), isNull);
    });

    test('only recently-added falls back to the plain list query', () {
      for (final rank in DiscoverRank.values) {
        expect(rank.rankKind == null, rank == DiscoverRank.recentlyAdded);
      }
    });
  });

  group('IsterMediaService discover tree', () {
    test('the music library categories include a Discover folder', () async {
      final categories =
          await IsterMediaService().getLibraryCategories(_server, _libraryId);
      final discover = categories.last;
      expect(discover.id, DiscoverNodeId(DiscoverKind.albums, _libraryId).id);
      expect(discover.isterMediaType, IsterMediaTypes.list);
      expect(discover.playable, isFalse);
    });

    test('a book library node starts with its Discover folder', () async {
      _installClient(_fakeGraphQL());
      final items = await IsterMediaService().getList(
          MediaItemId(_server, IsterMediaTypes.list, 'books:$_libraryId'));
      expect(
          items.first.id, DiscoverNodeId(DiscoverKind.books, _libraryId).id);
    });

    test('the discover screen groups items and closes each group with '
        'a show-all folder', () async {
      _installClient(_fakeGraphQL(
        discover: _discoverAlbums(
          recentlyPlayed: [_album('played-1', 'Played Album')],
          highestRated: [_album('rated-1', 'Rated Album')],
        ),
        recentlyAddedAlbums: () => [_album('new-1', 'New Album')],
      ));

      final items = await IsterMediaService()
          .getDiscoverGroups(_server, DiscoverNodeId(DiscoverKind.albums, _libraryId));

      // Three non-empty groups of one item + one show-all folder each; the
      // empty most-played group vanished entirely.
      expect(items, hasLength(6));
      expect(items.map(_groupOf), everyElement(isNotNull));
      expect(items.map(_groupOf).toSet(), hasLength(3));

      final played = items[0];
      expect(played.id, 'played-1');
      expect(played.isterMediaType, IsterMediaTypes.album);
      expect(_groupOf(played), _groupOf(items[1]));

      final showAllPlayed = items[1];
      expect(showAllPlayed.isterMediaType, IsterMediaTypes.list);
      expect(
          showAllPlayed.id,
          RankedNodeId(DiscoverKind.albums, _libraryId,
                  DiscoverRank.recentlyPlayed)
              .id);

      final showAllRated = items[3];
      expect(
          showAllRated.id,
          RankedNodeId(
                  DiscoverKind.albums, _libraryId, DiscoverRank.highestRated)
              .id);

      final newAlbum = items[4];
      expect(newAlbum.id, 'new-1');
      expect(
          items[5].id,
          RankedNodeId(
                  DiscoverKind.albums, _libraryId, DiscoverRank.recentlyAdded)
              .id);
    });

    test('an old server without the discover fields keeps the '
        'recently-added group', () async {
      _installClient(_fakeGraphQL(
        discoverErrors: true,
        recentlyAddedAlbums: () => [_album('new-1', 'New Album')],
      ));

      final items = await IsterMediaService().getDiscoverGroups(
          _server, DiscoverNodeId(DiscoverKind.albums, _libraryId));

      expect(items, hasLength(2));
      expect(items[0].id, 'new-1');
      expect(
          items[1].id,
          RankedNodeId(
                  DiscoverKind.albums, _libraryId, DiscoverRank.recentlyAdded)
              .id);
    });

    test('a ranked show-all list pages the ranked query', () async {
      _installClient(_fakeGraphQL(
        rankedContent: () =>
            [_album('a-1', 'First'), _album('a-2', 'Second')],
      ));

      final items = await IsterMediaService().getRankedList(
          _server,
          RankedNodeId(
              DiscoverKind.albums, _libraryId, DiscoverRank.mostPlayed));

      expect(items.map((item) => item.id), ['a-1', 'a-2']);
      expect(items.first.isterMediaType, IsterMediaTypes.album);
      expect(items.first.title, 'First');
      expect(items.first.artist, 'The Band');
    });

    test('the recently-added show-all list runs the plain query newest-first',
        () async {
      final variables = <Map<String, dynamic>>[];
      _installClient(_fakeGraphQL(
        recentlyAddedAlbums: () => [_album('new-1', 'New Album')],
        recordedAlbumVariables: variables,
      ));

      final items = await IsterMediaService().getRankedList(
          _server,
          RankedNodeId(
              DiscoverKind.albums, _libraryId, DiscoverRank.recentlyAdded));

      expect(items.map((item) => item.id), ['new-1']);
      expect(variables.single['sorting'], 'DATE_CREATED');
      expect(variables.single['sortingOrder'], 'DESCENDING');
      expect(variables.single['libraryId'], _libraryId);
    });

    test('a server without ranked queries yields an empty show-all list',
        () async {
      _installClient(_fakeGraphQL(rankedErrors: true));

      final items = await IsterMediaService().getRankedList(
          _server,
          RankedNodeId(
              DiscoverKind.albums, _libraryId, DiscoverRank.highestRated));
      expect(items, isEmpty);
    });
  });
}
