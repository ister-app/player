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

Map<String, dynamic> _book(String id, String title) => {
      '__typename': 'Book',
      'id': id,
      'name': title,
      'title': title,
      'releaseYear': 2020,
      'seriesIndex': null,
      'author': {'__typename': 'Person', 'id': 'author-1', 'name': 'The Author'},
      'series': null,
      'images': <dynamic>[],
      'metadata': <dynamic>[],
      'rating': null,
    };

Map<String, dynamic> _booksPage(List<Map<String, dynamic>> books) => {
      '__typename': 'Query',
      'books': {
        '__typename': 'BookPage',
        'content': books,
        'totalPages': 1,
        'totalElements': books.length,
        'number': 0,
        'size': books.length,
      },
    };

Map<String, dynamic> _discoverBooks({
  List<Map<String, dynamic>> recentlyRead = const [],
  List<Map<String, dynamic>> highestRated = const [],
}) =>
    {
      '__typename': 'Query',
      'libraryById': {
        '__typename': 'Library',
        'id': _libraryId,
        'recentlyReadBooks': recentlyRead,
        'highestRatedBooks': highestRated,
      },
    };

Map<String, dynamic> _podcast(String id, String title) => {
      '__typename': 'Podcast',
      'id': id,
      'title': title,
      'author': 'The Host',
      'feedUrl': 'https://feed.example/$id',
      'active': true,
      'images': <dynamic>[],
      'metadata': <dynamic>[],
      'rating': null,
      'episodeOrder': 'ASCENDING',
    };

Map<String, dynamic> _podcastsPage(List<Map<String, dynamic>> podcasts) => {
      '__typename': 'Query',
      'podcasts': {
        '__typename': 'PodcastPage',
        'content': podcasts,
        'totalPages': 1,
        'totalElements': podcasts.length,
        'number': 0,
        'size': podcasts.length,
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
  Map<String, dynamic>? discoverBooks,
  bool discoverErrors = false,
  bool rankedErrors = false,
  List<Map<String, dynamic>> Function()? recentlyAddedAlbums,
  List<Map<String, dynamic>> Function(Map<String, dynamic> variables)? books,
  List<Map<String, dynamic>> Function(Map<String, dynamic> variables)?
      podcasts,
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
      if (query.contains('recentlyReadBooks')) {
        if (discoverErrors) {
          return _graphQLError("Validation error: unknown field 'libraryById'");
        }
        return _json(discoverBooks ?? _discoverBooks());
      }
      if (query.contains('recentlyPlayedPodcasts')) {
        if (discoverErrors) {
          return _graphQLError("Validation error: unknown field 'libraryById'");
        }
        return _json({
          '__typename': 'Query',
          'libraryById': {
            '__typename': 'Library',
            'id': _libraryId,
            'recentlyPlayedPodcasts': <dynamic>[],
            'mostPlayedPodcasts': <dynamic>[],
            'highestRatedPodcasts': <dynamic>[],
          },
        });
      }
      if (query.contains('books(')) {
        final variables = body['variables'] as Map<String, dynamic>? ?? {};
        return _json(_booksPage(books?.call(variables) ?? const []));
      }
      if (query.contains('podcasts(')) {
        final variables = body['variables'] as Map<String, dynamic>? ?? {};
        return _json(_podcastsPage(podcasts?.call(variables) ?? const []));
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
    test('the music library categories are Albums and Artists, no Discover',
        () async {
      final categories =
          await IsterMediaService().getLibraryCategories(_server, _libraryId);
      expect(categories.map((category) => category.id),
          ['albums:$_libraryId', 'artists:$_libraryId']);
      // Albums opens the mixed grouped list, so no grid hint; the artists
      // node is still a wall of covers.
      expect(
          categories[0].extras?[IsterMediaService.contentStyleBrowsableHint],
          isNull);
      expect(
          categories[1].extras?[IsterMediaService.contentStyleBrowsableHint],
          IsterMediaService.contentStyleGrid);
    });

    test('the albums tab shows the discover groups closed by an '
        'All albums folder', () async {
      _installClient(_fakeGraphQL(
        discover: _discoverAlbums(
          recentlyPlayed: [_album('played-1', 'Played Album')],
        ),
        recentlyAddedAlbums: () => [_album('new-1', 'New Album')],
      ));

      final items = await IsterMediaService().getList(
          MediaItemId(_server, IsterMediaTypes.list, 'albums:$_libraryId'));

      // Recently-played group (item + show-all), recently-added group
      // (item + show-all), then the All albums folder.
      expect(items, hasLength(5));
      expect(items.map(_groupOf), everyElement(isNotNull));
      expect(
          items.any((item) => item.id.startsWith('discover:')), isFalse);

      final allAlbums = items.last;
      expect(allAlbums.id, 'all-albums:$_libraryId');
      expect(allAlbums.isterMediaType, IsterMediaTypes.list);
      expect(allAlbums.playable, isFalse);
      expect(allAlbums.extras?[IsterMediaService.contentStyleBrowsableHint],
          IsterMediaService.contentStyleGrid);
      expect(_groupOf(allAlbums), allAlbums.title);
    });

    test('an old server degrades the albums tab to recently added plus '
        'All albums', () async {
      _installClient(_fakeGraphQL(
        discoverErrors: true,
        recentlyAddedAlbums: () => [_album('new-1', 'New Album')],
      ));

      final items = await IsterMediaService().getList(
          MediaItemId(_server, IsterMediaTypes.list, 'albums:$_libraryId'));

      expect(items, hasLength(3));
      expect(items[0].id, 'new-1');
      expect(
          items[1].id,
          RankedNodeId(
                  DiscoverKind.albums, _libraryId, DiscoverRank.recentlyAdded)
              .id);
      expect(items[2].id, 'all-albums:$_libraryId');
    });

    test('the all-albums node is the plain alphabetical list', () async {
      final variables = <Map<String, dynamic>>[];
      _installClient(_fakeGraphQL(
        recentlyAddedAlbums: () => [_album('a-1', 'An Album')],
        recordedAlbumVariables: variables,
      ));

      final items = await IsterMediaService().getList(MediaItemId(
          _server, IsterMediaTypes.list, 'all-albums:$_libraryId'));

      expect(items.single.id, 'a-1');
      expect(items.single.isterMediaType, IsterMediaTypes.album);
      expect(_groupOf(items.single), isNull);
      expect(variables.single['sorting'], 'NAME');
      expect(variables.single['sortingOrder'], 'ASCENDING');
      expect(variables.single['libraryId'], _libraryId);
    });

    test('a book library inlines the discover groups above the full list',
        () async {
      _installClient(_fakeGraphQL(
        discoverBooks: _discoverBooks(
          recentlyRead: [_book('read-1', 'Read Book')],
        ),
        books: (variables) => variables['sorting'] == 'DATE_CREATED'
            ? [_book('new-1', 'New Book')]
            : [_book('book-1', 'A Book'), _book('book-2', 'B Book')],
      ));

      final items = await IsterMediaService().getList(
          MediaItemId(_server, IsterMediaTypes.list, 'books:$_libraryId'));

      // Recently-read group, recently-added group (each item + show-all),
      // then every book of the library under one "All books" section.
      expect(items.map((item) => item.id), [
        'read-1',
        RankedNodeId(DiscoverKind.books, _libraryId, DiscoverRank.recentlyPlayed)
            .id,
        'new-1',
        RankedNodeId(DiscoverKind.books, _libraryId, DiscoverRank.recentlyAdded)
            .id,
        'book-1',
        'book-2',
      ]);
      expect(items.map(_groupOf), everyElement(isNotNull));

      final tail = items.sublist(4);
      expect(tail.map(_groupOf).toSet(), hasLength(1));
      expect(
          tail.every((book) =>
              book.playable && book.isterMediaType == IsterMediaTypes.book),
          isTrue);
    });

    test('a podcast library tags its full list as one section', () async {
      _installClient(_fakeGraphQL(
        podcasts: (variables) => variables['sorting'] == 'DATE_CREATED'
            ? const []
            : [_podcast('pod-1', 'A Podcast')],
      ));

      final items = await IsterMediaService().getList(
          MediaItemId(_server, IsterMediaTypes.list, 'podcasts:$_libraryId'));

      expect(items.single.id, 'pod-1');
      expect(items.single.isterMediaType, IsterMediaTypes.podcast);
      expect(_groupOf(items.single), isNotNull);
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
