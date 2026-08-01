import 'package:flutter_test/flutter_test.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

void main() {
  Fragment$fragmentPlayQueue$playQueueItems item(String id, double position) =>
      Fragment$fragmentPlayQueue$playQueueItems(id: id, position: position);

  Fragment$fragmentPlayQueue queue(
    String id, {
    String? currentItemId,
    List<Fragment$fragmentPlayQueue$playQueueItems>? items,
  }) =>
      Fragment$fragmentPlayQueue(
        id: id,
        currentItemId: currentItemId,
        progressInMilliseconds: 0,
        shuffle: false,
        sourceExhausted: true,
        controlAllowedUserIds: const [],
        playQueueItems: items,
      );

  group('MediaPlayerHandler.mergeServerPlayQueue', () {
    test('drops a response for a different queue than the active one', () {
      // The race this pins: play album A, then start album B. A progress
      // update for A's queue sent during B's createPlayQueue round-trip
      // carries the already-bumped sync generation, so only the queue id can
      // reveal that its late response belongs to the replaced queue.
      final oldQueueResponse = queue('queue-a',
          currentItemId: 'a1', items: [item('a1', 1), item('a2', 2)]);
      final active = queue('queue-b', currentItemId: 'b1', items: [item('b1', 1)]);

      expect(
        MediaPlayerHandler.mergeServerPlayQueue(active, oldQueueResponse),
        isNull,
      );
    });

    test('drops a response when no queue is active anymore', () {
      final response = queue('queue-a', items: [item('a1', 1)]);
      expect(MediaPlayerHandler.mergeServerPlayQueue(null, response), isNull);
    });

    test('applies a same-queue response but keeps the local current item', () {
      // The client is authoritative for what is playing: a progress update
      // for the previous track processed server-side around a skip can still
      // carry the pre-skip currentItemId.
      final active = queue('queue-a', currentItemId: 'a2', items: [item('a2', 2)]);
      final response = queue('queue-a',
          currentItemId: 'a1', items: [item('a1', 1), item('a2', 2), item('a3', 3)]);

      final merged = MediaPlayerHandler.mergeServerPlayQueue(active, response);

      expect(merged, isNotNull);
      expect(merged!.currentItemId, 'a2');
      expect(merged.playQueueItems, hasLength(3));
    });

    test('adopts the server current item when there is no local one', () {
      final active = queue('queue-a', items: [item('a1', 1)]);
      final response =
          queue('queue-a', currentItemId: 'a1', items: [item('a1', 1)]);

      final merged = MediaPlayerHandler.mergeServerPlayQueue(active, response);

      expect(merged!.currentItemId, 'a1');
    });
  });
}
