import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/episodeById.graphql.dart';
import 'package:player/graphql/episodesRecentWatchedQuery.graphql.dart';

/// The continue-watching row and the episode page select the same Episode
/// with different season shapes. Both must normalize the season as an
/// entity: an id-less `{ number }` written inline on `Episode.season` is
/// clobbered by the episode page's `{ id }` reference, after which the
/// row's cache round trip returns null (CacheMissException on screen).
void main() {
  test('recentlyWatched survives an episodeById write of the same episode', () {
    final cache = GraphQLCache(store: InMemoryStore());
    final rw = Request(
        operation: Operation(document: documentNodeQueryrecentlyWatched),
        variables: const {});
    cache.writeQuery(rw, data: {
      '__typename': 'Query',
      'recentlyWatched': [
        {
          '__typename': 'RecentlyWatched',
          'type': 'EPISODE',
          'episode': {
            '__typename': 'Episode',
            'id': 'e1',
            'number': 3,
            'show': {'__typename': 'Show', 'id': 's1', 'metadata': [], 'images': []},
            'season': {'__typename': 'Season', 'id': 'season-6', 'number': 6},
            'watchStatus': [],
            'mediaFile': [],
            'metadata': [],
            'images': [],
          },
          'movie': null,
          'chapter': null,
          'book': null,
          'podcastEpisode': null,
        }
      ],
    });
    expect(cache.readQuery(rw), isNotNull);

    cache.writeQuery(
      Request(
          operation: Operation(document: documentNodeQueryepisodeById),
          variables: const {'id': 'e1'}),
      data: {
        '__typename': 'Query',
        'episodeById': {
          '__typename': 'Episode',
          'id': 'e1',
          'number': 3,
          'show': {'__typename': 'Show', 'id': 's1'},
          'season': {'__typename': 'Season', 'id': 'season-6'},
          'metadata': [],
          'images': [],
          'watchStatus': [],
          'mediaFile': [],
          'mediaFileParts': [],
          'cast': [],
          'rating': null,
        }
      },
    );
    final back = cache.readQuery(rw);
    expect(back, isNotNull);
    final season = ((back!['recentlyWatched'] as List).single['episode'] as Map)['season'] as Map;
    expect(season['number'], 6);
  });
}
