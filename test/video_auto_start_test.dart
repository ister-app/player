import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/VideoAutoStart.dart';

void main() {
  test('browsing into an episode/movie shows the play button', () {
    expect(
        shouldAutoStartVideo(
            routeQueueId: null, handlerQueueId: 'pq-1', isCurrentVideo: false),
        isFalse);
    expect(
        shouldAutoStartVideo(
            routeQueueId: null, handlerQueueId: null, isCurrentVideo: false),
        isFalse);
  });

  test('a route for another queue than the playing one shows the button', () {
    expect(
        shouldAutoStartVideo(
            routeQueueId: 'pq-old', handlerQueueId: 'pq-1', isCurrentVideo: false),
        isFalse);
  });

  test('the playing queue (auto-advance, mini player, watch-along) starts', () {
    expect(
        shouldAutoStartVideo(
            routeQueueId: 'pq-1', handlerQueueId: 'pq-1', isCurrentVideo: false),
        isTrue);
  });

  test('the item the handler already holds starts', () {
    expect(
        shouldAutoStartVideo(
            routeQueueId: null, handlerQueueId: 'pq-1', isCurrentVideo: true),
        isTrue);
  });
}
