import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../dto/IsterMediaItem.dart';
import '../dto/MediaItemId.dart';
import '../graphql/albumsQuery.graphql.dart';
import '../graphql/bookById.graphql.dart';
import '../graphql/fragmentAlbum.graphql.dart';
import '../graphql/fragmentBook.graphql.dart';
import '../graphql/fragmentImages.graphql.dart';
import '../graphql/fragmentPodcastEpisode.graphql.dart';
import '../graphql/podcastById.graphql.dart';
import '../graphql/podcastEpisodesQuery.graphql.dart';
import '../graphql/schema.graphql.dart';
import '../graphql/seriesById.graphql.dart';
import 'ImageTypes.dart';
import 'ImageUtil.dart';
import 'LoggerService.dart';
import 'MediaPlayerHandler.dart';
import 'MetadataUtil.dart';
import 'QueueEnd.dart';
import 'StreamTokenService.dart';

/// One thing to play after a queue ended.
class QueueEndSuggestion {
  const QueueEndSuggestion({
    required this.id,
    required this.title,
    this.subtitle,
    this.artUrl,
    required this.start,
  });

  final String id;
  final String title;
  final String? subtitle;
  final String? artUrl;

  /// Starts it (a new queue on the ended queue's server).
  final Future<void> Function() start;
}

/// The suggestions for one ended queue, with what they are of (for the
/// row's header): other albums of the artist, the next book of the series,
/// the next unplayed episode of the podcast.
class QueueEndSuggestionSet {
  const QueueEndSuggestionSet(
      {required this.kind, required this.items, this.artistName});

  final QueueEndKind kind;
  final List<QueueEndSuggestion> items;

  /// For [QueueEndKind.album]: whose albums these are.
  final String? artistName;

  bool get isEmpty => items.isEmpty;
}

/// The server lookups the resolver needs — one interface so tests can feed
/// fixtures through [QueueEndSuggestions.sourceOverride].
abstract class QueueEndSuggestionSource {
  Future<List<Fragment$fragmentAlbum>> albumsByArtist(
      GraphQLClient client, String artistId);

  /// The book, for its series.
  Future<Fragment$fragmentBook?> book(GraphQLClient client, String bookId);

  /// The books of a series, in series order.
  Future<List<Fragment$fragmentBook>> seriesBooks(
      GraphQLClient client, String seriesId);

  /// The podcast's stored episode order.
  Future<Enum$SortingOrder?> podcastOrder(
      GraphQLClient client, String podcastId);

  /// The first page of a podcast's episodes in [order].
  Future<List<Fragment$fragmentPodcastEpisode>> podcastEpisodes(
      GraphQLClient client, String podcastId, Enum$SortingOrder? order);
}

/// [QueueEndSuggestionSource] over the server's GraphQL API. Raw `query`
/// calls, no `Query` widgets: the surfaces that show the suggestions sit on
/// the root navigator, outside any GraphQLProvider.
class GraphQLQueueEndSuggestionSource implements QueueEndSuggestionSource {
  const GraphQLQueueEndSuggestionSource();

  Future<Map<String, dynamic>?> _query(GraphQLClient client,
      DocumentNode document, Map<String, dynamic> variables) async {
    final result = await client.query(QueryOptions(
      document: document,
      variables: variables,
      fetchPolicy: FetchPolicy.networkOnly,
    ));
    if (result.hasException || result.data == null) {
      LoggerService().logger.w('queue-end suggestion lookup failed: '
          '${result.exception}');
      return null;
    }
    return result.data;
  }

  @override
  Future<List<Fragment$fragmentAlbum>> albumsByArtist(
      GraphQLClient client, String artistId) async {
    final data = await _query(client, documentNodeQueryalbums,
        {'artistId': artistId, 'page': 0, 'size': 12});
    if (data == null) return const [];
    return Query$albums.fromJson(data).albums?.content ?? const [];
  }

  @override
  Future<Fragment$fragmentBook?> book(
      GraphQLClient client, String bookId) async {
    final data = await _query(client, documentNodeQuerybookById, {'id': bookId});
    if (data == null) return null;
    return Query$bookById.fromJson(data).bookById;
  }

  @override
  Future<List<Fragment$fragmentBook>> seriesBooks(
      GraphQLClient client, String seriesId) async {
    final data =
        await _query(client, documentNodeQueryseriesById, {'id': seriesId});
    if (data == null) return const [];
    return Query$seriesById.fromJson(data).seriesById?.books ?? const [];
  }

  @override
  Future<Enum$SortingOrder?> podcastOrder(
      GraphQLClient client, String podcastId) async {
    final data =
        await _query(client, documentNodeQuerypodcastById, {'id': podcastId});
    if (data == null) return null;
    return Query$podcastById.fromJson(data).podcastById?.episodeOrder;
  }

  @override
  Future<List<Fragment$fragmentPodcastEpisode>> podcastEpisodes(
      GraphQLClient client, String podcastId, Enum$SortingOrder? order) async {
    final data = await _query(client, documentNodeQuerypodcastEpisodes, {
      'podcastId': podcastId,
      'page': 0,
      'size': 20,
      if (order != null) 'sortingOrder': order.name,
    });
    if (data == null) return const [];
    return Query$podcastEpisodes.fromJson(data).podcastEpisodes.content;
  }
}

/// What to play after a queue ended. The selection rules are pure and
/// unit-tested; [resolve] does at most two round-trips per kind and returns
/// null for kinds with nothing to suggest (a playlist, a filter, an offline
/// queue, video — the video end screen has its own related row).
class QueueEndSuggestions {
  QueueEndSuggestions._();

  /// Test seam: replaces the GraphQL source.
  static QueueEndSuggestionSource? sourceOverride;

  static QueueEndSuggestionSource get _source =>
      sourceOverride ?? const GraphQLQueueEndSuggestionSource();

  /// The artist's other albums: every album but the one that ended.
  static List<T> otherAlbums<T>(
          String endedAlbumId, List<T> albums, String Function(T) id) =>
      albums.where((a) => id(a) != endedAlbumId).toList();

  /// The book after [endedBookId] in series order; null when it was the last
  /// one, or not in the list at all.
  static T? nextBookInSeries<T>(
      String endedBookId, List<T> booksInSeriesOrder, String Function(T) id) {
    final index = booksInSeriesOrder.indexWhere((b) => id(b) == endedBookId);
    if (index < 0 || index + 1 >= booksInSeriesOrder.length) return null;
    return booksInSeriesOrder[index + 1];
  }

  /// The first episode, in the listener's order, that is neither played nor
  /// was in the queue that just ended.
  static T? nextUnplayedEpisode<T>(
    Set<String> queuedEpisodeIds,
    List<T> episodesInOrder,
    String Function(T) id,
    bool Function(T) watched,
  ) {
    for (final e in episodesInOrder) {
      if (watched(e) || queuedEpisodeIds.contains(id(e))) continue;
      return e;
    }
    return null;
  }

  static Future<QueueEndSuggestionSet?> resolve(QueueEndedInfo info) async {
    final client = info.client;
    if (client == null) return null;
    try {
      switch (info.kind) {
        case QueueEndKind.album:
          return await _forAlbum(info, client);
        case QueueEndKind.book:
          return await _forBook(info, client);
        case QueueEndKind.podcast:
          return await _forPodcast(info, client);
        case QueueEndKind.episode:
        case QueueEndKind.movie:
        case QueueEndKind.playlist:
        case QueueEndKind.other:
          return null;
      }
    } catch (e) {
      LoggerService().logger.w('queue-end suggestions failed: $e');
      return null;
    }
  }

  static String? _art(String srv, List<Fragment$fragmentImages>? images) =>
      ImageUtil.buildUrl(ImageUtil.getImageByType(images, ImageTypes.cover),
          token: StreamTokenService.getToken(srv));

  static Future<QueueEndSuggestionSet?> _forAlbum(
      QueueEndedInfo info, GraphQLClient client) async {
    final track = info.lastItem.track;
    if (track == null) return null;
    final srv = info.serverName;
    final albums = otherAlbums(track.album.id,
        await _source.albumsByArtist(client, track.artist.id), (a) => a.id);
    return QueueEndSuggestionSet(
      kind: QueueEndKind.album,
      artistName: track.artist.name,
      items: [
        for (final album in albums)
          QueueEndSuggestion(
            id: album.id,
            title: MetadataUtil.getTitle(album.metadata) ?? album.name,
            subtitle: album.releaseYear > 0 ? '${album.releaseYear}' : null,
            artUrl: _art(srv, album.images),
            start: () => MediaPlayerHandler.instance.playAlbumById(
                MediaItemId(srv, IsterMediaTypes.album, album.id)),
          ),
      ],
    );
  }

  static Future<QueueEndSuggestionSet?> _forBook(
      QueueEndedInfo info, GraphQLClient client) async {
    final bookId = info.lastItem.chapter?.book.id;
    if (bookId == null) return null;
    final srv = info.serverName;
    final seriesId = (await _source.book(client, bookId))?.series?.id;
    if (seriesId == null) return null;
    final next = nextBookInSeries(
        bookId, await _source.seriesBooks(client, seriesId), (b) => b.id);
    if (next == null) return null;
    return QueueEndSuggestionSet(
      kind: QueueEndKind.book,
      items: [
        QueueEndSuggestion(
          id: next.id,
          title: MetadataUtil.getTitle(next.metadata) ?? next.title,
          subtitle: next.author?.name,
          artUrl: _art(srv, next.images),
          start: () => MediaPlayerHandler.instance
              .startPlayQueueForBook(client, null, next.id, null, srv),
        ),
      ],
    );
  }

  static Future<QueueEndSuggestionSet?> _forPodcast(
      QueueEndedInfo info, GraphQLClient client) async {
    final podcast = info.lastItem.podcastEpisode?.podcast;
    if (podcast == null) return null;
    final srv = info.serverName;
    final queued = <String>{
      for (final item in info.playQueue.playQueueItems ?? const [])
        if (item.podcastEpisode != null) item.podcastEpisode!.id,
    };
    final order = await _source.podcastOrder(client, podcast.id);
    final next = nextUnplayedEpisode(
      queued,
      await _source.podcastEpisodes(client, podcast.id, order),
      (e) => e.id,
      (e) => e.watchStatus?.any((w) => w.watched) ?? false,
    );
    if (next == null) return null;
    return QueueEndSuggestionSet(
      kind: QueueEndKind.podcast,
      items: [
        QueueEndSuggestion(
          id: next.id,
          title: MetadataUtil.getTitle(next.metadata) ?? podcast.title,
          subtitle: podcast.title,
          artUrl: _art(srv, podcast.images),
          start: () => MediaPlayerHandler.instance
              .startPlayQueueForPodcast(client, null, podcast.id, next.id, srv),
        ),
      ],
    );
  }
}
