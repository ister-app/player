import 'package:flutter_test/flutter_test.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/seasonById.graphql.dart';
import 'package:player/utils/download/NextUnwatched.dart';

Query$seasonById$seasonById$episodes _ep(int n,
        {bool watched = false, int progress = 0, bool file = true}) =>
    Query$seasonById$seasonById$episodes.fromJson({
      '__typename': 'Episode',
      'id': 'e$n',
      'number': n,
      'watchStatus': watched || progress > 0
          ? [
              {
                '__typename': 'WatchStatus',
                'id': 'w$n',
                'playQueueItemId': 'p',
                'progressInMilliseconds': progress,
                'watched': watched,
              }
            ]
          : [],
      'mediaFile': file
          ? [
              Fragment$fragmentMediaFiles(
                id: 'mf$n',
                path: '/e$n.mkv',
                size: 1,
                directory: Fragment$fragmentMediaFiles$directory(
                    node: Fragment$fragmentMediaFiles$directory$node(
                        url: 'https://n')),
              ).toJson()
            ]
          : [],
    });

void main() {
  List<String> ids(List<Query$seasonById$seasonById$episodes> l) =>
      l.map((e) => e.id).toList();

  test('starts after the last watched episode', () {
    final eps = [_ep(1, watched: true), _ep(2, watched: true), _ep(3), _ep(4), _ep(5)];
    expect(ids(NextUnwatched.select(eps, 2)), ['e3', 'e4']);
  });

  test('an episode in progress counts as the first of the N', () {
    final eps = [_ep(1, watched: true), _ep(2, progress: 5000), _ep(3), _ep(4)];
    expect(ids(NextUnwatched.select(eps, 2)), ['e2', 'e3']);
  });

  test('nothing watched yet: from the start, skipping episodes without a file', () {
    final eps = [_ep(1, file: false), _ep(2), _ep(3)];
    expect(ids(NextUnwatched.select(eps, 5)), ['e2', 'e3']);
  });

  test('earlier unwatched episodes are not revisited', () {
    final eps = [_ep(1), _ep(2, watched: true), _ep(3)];
    expect(ids(NextUnwatched.select(eps, 5)), ['e3']);
  });
}
