import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/fragmentAlbum.graphql.dart';
import 'package:player/graphql/fragmentBook.graphql.dart';
import 'package:player/graphql/fragmentPodcastEpisode.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/QueueEnd.dart';
import 'package:player/utils/QueueEndSuggestions.dart';

/// What to play after an audio queue ended: the pure selection rules, and
/// the resolver over a fake source per kind.
Fragment$fragmentAlbum _album(String id, {String artistId = 'artist-1'}) =>
    Fragment$fragmentAlbum(
      id: id,
      name: 'Album $id',
      releaseYear: 2000,
      artist: Fragment$fragmentAlbum$artist(id: artistId, name: 'The Artist'),
    );

Fragment$fragmentBook _book(String id, {String? seriesId}) =>
    Fragment$fragmentBook(
      id: id,
      name: 'Book $id',
      title: 'Book $id',
      releaseYear: 2000,
      series: seriesId == null
          ? null
          : Fragment$fragmentBook$series(id: seriesId, name: 'The Series'),
    );

Fragment$fragmentPodcastEpisode _episode(String id, {bool watched = false}) =>
    Fragment$fragmentPodcastEpisode(
      id: id,
      downloaded: false,
      watchStatus: [
        Fragment$fragmentPodcastEpisode$watchStatus(
            id: 'ws-$id',
            playQueueItemId: 'x',
            progressInMilliseconds: 0,
            watched: watched),
      ],
    );

Fragment$fragmentPlayQueue$playQueueItems _trackItem() =>
    Fragment$fragmentPlayQueue$playQueueItems(
      accessible: true,
      id: 'item-1',
      position: 1,
      track: Fragment$fragmentPlayQueue$playQueueItems$track(
        id: 'track-1',
        number: 1,
        discNumber: 1,
        artist: Fragment$fragmentPlayQueue$playQueueItems$track$artist(
            id: 'artist-1', name: 'The Artist'),
        artists: const [],
        album: Fragment$fragmentPlayQueue$playQueueItems$track$album(
            id: 'album-1', name: 'The Album'),
      ),
    );

Fragment$fragmentPlayQueue$playQueueItems _chapterItem() =>
    Fragment$fragmentPlayQueue$playQueueItems(
      accessible: true,
      id: 'item-1',
      position: 1,
      chapter: Fragment$fragmentPlayQueue$playQueueItems$chapter(
        id: 'ch-1',
        number: 1,
        author: Fragment$fragmentPlayQueue$playQueueItems$chapter$author(
            id: 'au', name: 'Au'),
        book: Fragment$fragmentPlayQueue$playQueueItems$chapter$book(
            id: 'book-1', title: 'Book book-1'),
      ),
    );

Fragment$fragmentPlayQueue$playQueueItems _podcastItem(String episodeId) =>
    Fragment$fragmentPlayQueue$playQueueItems(
      accessible: true,
      id: 'item-$episodeId',
      position: 1,
      podcastEpisode:
          Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode(
        id: episodeId,
        podcast:
            Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast(
                id: 'pod-1', title: 'The Podcast'),
      ),
    );

QueueEndedInfo _ended(List<Fragment$fragmentPlayQueue$playQueueItems> items,
        {Enum$PlayQueueSourceType? sourceType, bool local = false}) =>
    QueueEndedInfo(
      serverName: 'srv',
      client: local
          ? null
          : GraphQLClient(
              link: HttpLink('https://api.example/graphql'),
              cache: GraphQLCache()),
      playQueue: Fragment$fragmentPlayQueue(
        id: 'pq-1',
        currentItemId: items.last.id,
        progressInMilliseconds: 0,
        shuffle: false,
        sourceType: sourceType,
        sourceExhausted: true,
        controlAllowedUserIds: const [],
        playQueueItems: items,
      ),
      lastItem: items.last,
      lastMediaItem: const MediaItem(id: 'x', title: 'x'),
    );

class _FakeSource implements QueueEndSuggestionSource {
  _FakeSource({
    this.albums = const [],
    this.books = const {},
    this.seriesBooksList = const [],
    this.order,
    this.episodes = const [],
  });

  final List<Fragment$fragmentAlbum> albums;
  final Map<String, Fragment$fragmentBook> books;
  final List<Fragment$fragmentBook> seriesBooksList;
  final Enum$SortingOrder? order;
  final List<Fragment$fragmentPodcastEpisode> episodes;
  final List<String> calls = [];

  @override
  Future<List<Fragment$fragmentAlbum>> albumsByArtist(
      GraphQLClient client, String artistId) async {
    calls.add('albums:$artistId');
    return albums;
  }

  @override
  Future<Fragment$fragmentBook?> book(GraphQLClient client, String bookId) async {
    calls.add('book:$bookId');
    return books[bookId];
  }

  @override
  Future<List<Fragment$fragmentBook>> seriesBooks(
      GraphQLClient client, String seriesId) async {
    calls.add('series:$seriesId');
    return seriesBooksList;
  }

  @override
  Future<Enum$SortingOrder?> podcastOrder(
      GraphQLClient client, String podcastId) async {
    calls.add('order:$podcastId');
    return order;
  }

  @override
  Future<List<Fragment$fragmentPodcastEpisode>> podcastEpisodes(
      GraphQLClient client, String podcastId, Enum$SortingOrder? order) async {
    calls.add('episodes:$podcastId:${order?.name}');
    return episodes;
  }
}

void main() {
  tearDown(() => QueueEndSuggestions.sourceOverride = null);

  group('selection rules', () {
    test('other albums leave out the one that ended', () {
      final albums = [_album('a'), _album('b'), _album('c')];
      expect(
          QueueEndSuggestions.otherAlbums('b', albums, (a) => a.id)
              .map((a) => a.id),
          ['a', 'c']);
    });

    test('next book in series is the one after; none after the last', () {
      final books = [_book('1'), _book('2'), _book('3')];
      expect(QueueEndSuggestions.nextBookInSeries('1', books, (b) => b.id)?.id,
          '2');
      expect(QueueEndSuggestions.nextBookInSeries('3', books, (b) => b.id),
          isNull);
      expect(QueueEndSuggestions.nextBookInSeries('9', books, (b) => b.id),
          isNull);
    });

    test('next unplayed episode skips played ones and the ended queue', () {
      final episodes = [
        _episode('e1', watched: true),
        _episode('e2'),
        _episode('e3'),
      ];
      expect(
          QueueEndSuggestions.nextUnplayedEpisode(
              {'e2'}, episodes, (e) => e.id, (e) => e.watchStatus!.first.watched)
              ?.id,
          'e3');
      expect(
          QueueEndSuggestions.nextUnplayedEpisode(
              {'e2', 'e3'}, episodes, (e) => e.id, (e) => e.watchStatus!.first.watched),
          isNull);
    });
  });

  group('resolve', () {
    test('an album queue suggests the artist\'s other albums', () async {
      final source = _FakeSource(albums: [_album('album-1'), _album('album-2')]);
      QueueEndSuggestions.sourceOverride = source;

      final set = await QueueEndSuggestions.resolve(
          _ended([_trackItem()], sourceType: Enum$PlayQueueSourceType.ALBUM));

      expect(set?.kind, QueueEndKind.album);
      expect(set?.artistName, 'The Artist');
      expect(set?.items.map((s) => s.id), ['album-2']);
      expect(source.calls, ['albums:artist-1']);
    });

    test('a book queue suggests the next book of its series', () async {
      final source = _FakeSource(
        books: {'book-1': _book('book-1', seriesId: 'series-1')},
        seriesBooksList: [_book('book-1'), _book('book-2')],
      );
      QueueEndSuggestions.sourceOverride = source;

      final set = await QueueEndSuggestions.resolve(
          _ended([_chapterItem()], sourceType: Enum$PlayQueueSourceType.BOOK));

      expect(set?.kind, QueueEndKind.book);
      expect(set?.items.map((s) => s.id), ['book-2']);
      expect(source.calls, ['book:book-1', 'series:series-1']);
    });

    test('a book outside a series suggests nothing', () async {
      final source = _FakeSource(books: {'book-1': _book('book-1')});
      QueueEndSuggestions.sourceOverride = source;

      final set = await QueueEndSuggestions.resolve(
          _ended([_chapterItem()], sourceType: Enum$PlayQueueSourceType.BOOK));

      expect(set, isNull);
      expect(source.calls, ['book:book-1']);
    });

    test('a podcast queue suggests the next unplayed episode in the stored '
        'order', () async {
      final source = _FakeSource(
        order: Enum$SortingOrder.ASCENDING,
        episodes: [_episode('e1', watched: true), _episode('e2'), _episode('e3')],
      );
      QueueEndSuggestions.sourceOverride = source;

      final set = await QueueEndSuggestions.resolve(_ended(
          [_podcastItem('e2')],
          sourceType: Enum$PlayQueueSourceType.PODCAST));

      expect(set?.kind, QueueEndKind.podcast);
      expect(set?.items.map((s) => s.id), ['e3']);
      expect(set?.items.first.subtitle, 'The Podcast');
      expect(source.calls, ['order:pod-1', 'episodes:pod-1:ASCENDING']);
    });

    test('a playlist and an offline queue get no suggestions', () async {
      final source = _FakeSource(albums: [_album('album-2')]);
      QueueEndSuggestions.sourceOverride = source;

      expect(
          await QueueEndSuggestions.resolve(_ended([_trackItem()],
              sourceType: Enum$PlayQueueSourceType.PLAYLIST)),
          isNull);
      expect(
          await QueueEndSuggestions.resolve(
              _ended([_trackItem()], local: true)),
          isNull);
      expect(source.calls, isEmpty);
    });
  });
}
