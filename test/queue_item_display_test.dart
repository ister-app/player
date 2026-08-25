import 'package:flutter_test/flutter_test.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/utils/QueueItemDisplay.dart';

/// One mapping serves the audio handler and the remote control, so every queue
/// item kind has to come out of it complete — the remote used to know only
/// tracks, movies and episodes and showed "unknown" for the rest.
Map<String, dynamic> _image(String id) => {
      '__typename': 'Image',
      'id': id,
      'type': 'COVER',
      'language': null,
      'source': null,
      'blurHash': null,
      'directory': {
        '__typename': 'Directory',
        'node': {'__typename': 'Node', 'url': 'https://node.example'},
      },
    };

Map<String, dynamic> _mediaFile(int durationMs) => {
      '__typename': 'MediaFile',
      'id': 'file-1',
      'durationInMilliseconds': durationMs,
      'path': '/media/file.mkv',
      'size': 1,
      'directory': {
        '__typename': 'Directory',
        'node': {'__typename': 'Node', 'url': 'https://node.example'},
      },
      'mediaFileStreams': null,
    };

Map<String, dynamic> _metadata(String title) => {
      '__typename': 'Metadata',
      'id': 'meta-1',
      'title': title,
      'description': null,
      'language': null,
      'sourceUri': null,
      'source': null,
      'released': null,
      'genre': null,
      'tagline': null,
    };

Fragment$fragmentPlayQueue$playQueueItems _item(Map<String, dynamic> fields) =>
    Fragment$fragmentPlayQueue$playQueueItems.fromJson({
      '__typename': 'PlayQueueItem',
      'id': 'item-1',
      'position': 1.0,
      'accessible': true,
      ...fields,
    });

void main() {
  test('a track carries its artist, album and album cover', () {
    final display = QueueItemDisplay.of(
      _item({
        'track': {
          '__typename': 'Track',
          'id': 'track-1',
          'number': 3,
          'discNumber': 1,
          'rating': 8,
          'artist': {'__typename': 'Person', 'id': 'p1', 'name': 'Nick Cave'},
          'album': {
            '__typename': 'Album',
            'id': 'a1',
            'name': 'Ghosteen',
            'images': [_image('img-album')],
          },
          'metadata': [_metadata('Bright Horses')],
          'mediaFile': [_mediaFile(240000)],
        },
      }),
      token: 'tok',
    );

    expect(display.title, 'Bright Horses');
    expect(display.artist, 'Nick Cave');
    expect(display.album, 'Ghosteen');
    expect(display.artUrl, 'https://node.example/images/img-album/download?token=tok');
    expect(display.duration, const Duration(minutes: 4));
    expect(display.mediaType, IsterMediaTypes.track);
    expect(display.portraitArtwork, isFalse);
  });

  test('a chapter is titled and covered by its book, in portrait', () {
    final display = QueueItemDisplay.of(
      _item({
        'chapter': {
          '__typename': 'Chapter',
          'id': 'c1',
          'number': 4,
          'author': {'__typename': 'Person', 'id': 'p2', 'name': 'Tommy Wieringa'},
          'book': {
            '__typename': 'Book',
            'id': 'b1',
            'title': 'dit_zijn_de_namen',
            'metadata': [_metadata('Dit zijn de namen')],
            'images': [_image('img-book')],
          },
          'metadata': [_metadata('Hoofdstuk 4')],
          'mediaFile': [_mediaFile(600000)],
          'watchStatus': null,
        },
      }),
    );

    expect(display.title, 'Hoofdstuk 4');
    expect(display.artist, 'Tommy Wieringa');
    // The clean display title, not the raw directory name.
    expect(display.album, 'Dit zijn de namen');
    expect(display.artUrl, 'https://node.example/images/img-book/download');
    expect(display.portraitArtwork, isTrue);
    // A chapter is addressed as a track everywhere else in the app.
    expect(display.mediaType, IsterMediaTypes.track);
  });

  test('a chapter without a title falls back to its number', () {
    final display = QueueItemDisplay.of(_item({
      'chapter': {
        '__typename': 'Chapter',
        'id': 'c1',
        'number': 7,
        'author': {'__typename': 'Person', 'id': 'p2', 'name': 'Author'},
        'book': {
          '__typename': 'Book',
          'id': 'b1',
          'title': 'Book',
          'metadata': null,
          'images': null,
        },
        'metadata': null,
        'mediaFile': null,
        'watchStatus': null,
      },
    }));

    expect(display.title, endsWith('7'));
    expect(display.duration, Duration.zero);
  });

  test('a podcast episode is credited to the podcast', () {
    final display = QueueItemDisplay.of(_item({
      'podcastEpisode': {
        '__typename': 'PodcastEpisode',
        'id': 'pe1',
        'publishedAt': '2026-01-01',
        'podcast': {
          '__typename': 'Podcast',
          'id': 'pod1',
          'title': 'Serial',
          'author': 'Sarah Koenig',
          'images': [_image('img-pod')],
        },
        'metadata': [_metadata('Episode 1')],
        'mediaFile': [_mediaFile(1800000)],
        'watchStatus': null,
      },
    }));

    expect(display.title, 'Episode 1');
    expect(display.artist, 'Sarah Koenig');
    expect(display.album, 'Serial');
    expect(display.artUrl, 'https://node.example/images/img-pod/download');
    expect(display.mediaType, IsterMediaTypes.track);
  });

  test('a movie uses its backdrop and is addressed as a movie', () {
    final display = QueueItemDisplay.of(_item({
      'movie': {
        '__typename': 'Movie',
        'id': 'm1',
        'name': 'Heat',
        'releaseYear': 1995,
        'metadata': null,
        'watchStatus': null,
        'cast': null,
        'rating': null,
        'images': [
          {..._image('img-movie'), 'type': 'BACKGROUND'},
        ],
        'mediaFile': [_mediaFile(9000000)],
      },
    }));

    expect(display.title, 'Heat');
    expect(display.artUrl, 'https://node.example/images/img-movie/download');
    expect(display.mediaType, IsterMediaTypes.movie);
  });

  test('an item without any media is an episode without artwork', () {
    final display = QueueItemDisplay.of(_item({}));

    expect(display.title, 'unknown');
    expect(display.artUrl, isNull);
    expect(display.mediaType, IsterMediaTypes.episode);
    expect(display.duration, Duration.zero);
  });
}
