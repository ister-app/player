import 'package:flutter_test/flutter_test.dart';
import 'package:player/graphql/fragmentMovie.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/QueueEnd.dart';

Fragment$fragmentPlayQueue$playQueueItems _track() =>
    Fragment$fragmentPlayQueue$playQueueItems(
      accessible: true,
      id: 'i',
      position: 1,
      track: Fragment$fragmentPlayQueue$playQueueItems$track(
        id: 't',
        number: 1,
        discNumber: 1,
        artist: Fragment$fragmentPlayQueue$playQueueItems$track$artist(
            id: 'a', name: 'A'),
        artists: const [],
        album: Fragment$fragmentPlayQueue$playQueueItems$track$album(
            id: 'al', name: 'Al'),
      ),
    );

Fragment$fragmentPlayQueue$playQueueItems _movie() =>
    Fragment$fragmentPlayQueue$playQueueItems(
      accessible: true,
      id: 'i',
      position: 1,
      movie: Fragment$fragmentMovie(id: 'm', name: 'M', releaseYear: 2000),
    );

Fragment$fragmentPlayQueue$playQueueItems _chapter() =>
    Fragment$fragmentPlayQueue$playQueueItems(
      accessible: true,
      id: 'i',
      position: 1,
      chapter: Fragment$fragmentPlayQueue$playQueueItems$chapter(
        id: 'c',
        number: 1,
        author: Fragment$fragmentPlayQueue$playQueueItems$chapter$author(
            id: 'au', name: 'Au'),
        book: Fragment$fragmentPlayQueue$playQueueItems$chapter$book(
            id: 'b', title: 'B'),
      ),
    );

Fragment$fragmentPlayQueue _queue(Enum$PlayQueueSourceType? sourceType,
        Fragment$fragmentPlayQueue$playQueueItems item) =>
    Fragment$fragmentPlayQueue(
      id: 'pq',
      currentItemId: item.id,
      progressInMilliseconds: 0,
      shuffle: false,
      sourceType: sourceType,
      sourceExhausted: true,
      controlAllowedUserIds: const [],
      playQueueItems: [item],
    );

void main() {
  test('the source type decides when the server set one', () {
    expect(queueEndKindOf(_queue(Enum$PlayQueueSourceType.SHOW, _track()),
        _track()), QueueEndKind.episode);
    expect(queueEndKindOf(_queue(Enum$PlayQueueSourceType.PLAYLIST, _track()),
        _track()), QueueEndKind.playlist);
    expect(queueEndKindOf(_queue(Enum$PlayQueueSourceType.BOOK, _chapter()),
        _chapter()), QueueEndKind.book);
    expect(queueEndKindOf(_queue(Enum$PlayQueueSourceType.PODCAST, _track()),
        _track()), QueueEndKind.podcast);
  });

  test('a library, artist or filter queue of tracks counts as an album queue',
      () {
    for (final type in [
      Enum$PlayQueueSourceType.LIBRARY,
      Enum$PlayQueueSourceType.ARTIST,
      Enum$PlayQueueSourceType.FILTER,
    ]) {
      expect(queueEndKindOf(_queue(type, _track()), _track()),
          QueueEndKind.album, reason: type.name);
    }
    expect(queueEndKindOf(_queue(Enum$PlayQueueSourceType.FILTER, _movie()),
        _movie()), QueueEndKind.movie);
  });

  test('without a source type the item decides', () {
    expect(queueEndKindOf(_queue(null, _track()), _track()),
        QueueEndKind.album);
    expect(queueEndKindOf(_queue(null, _movie()), _movie()),
        QueueEndKind.movie);
    expect(queueEndKindOf(_queue(null, _chapter()), _chapter()),
        QueueEndKind.book);
  });
}
