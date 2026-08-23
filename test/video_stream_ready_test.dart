import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

/// The "stream really plays" gate behind the cover + spinner overlay.
void main() {
  bool ready({
    bool loadStarted = true,
    bool playing = true,
    bool buffering = false,
    Duration duration = const Duration(minutes: 40),
    Duration position = Duration.zero,
    int openPositionMs = 0,
  }) =>
      MediaPlayerHandler.computeStreamReady(
        loadStarted: loadStarted,
        playing: playing,
        buffering: buffering,
        duration: duration,
        position: position,
        openPositionMs: openPositionMs,
      );

  test('playing right after open() does not count before START_FILE', () {
    // media_kit reports playing=true synchronously inside open(); nothing is
    // loaded until a buffering event arrives for the new stream.
    expect(ready(loadStarted: false), isFalse);
    expect(
        ready(
            loadStarted: false,
            position: const Duration(minutes: 20),
            openPositionMs: 0),
        isFalse,
        reason: 'a stale position event of the previous stream must not count');
  });

  test('playing without buffering and a known duration is ready', () {
    expect(ready(), isTrue);
  });

  test('still buffering, or no duration yet, is not ready', () {
    expect(ready(buffering: true), isFalse);
    expect(ready(duration: Duration.zero), isFalse);
    expect(ready(playing: false), isFalse);
  });

  test('position advancing past the open position is ready (fallback)', () {
    expect(
        ready(
            buffering: true,
            duration: Duration.zero,
            openPositionMs: 90000,
            position: const Duration(milliseconds: 90200)),
        isFalse);
    expect(
        ready(
            buffering: true,
            duration: Duration.zero,
            openPositionMs: 90000,
            position: const Duration(milliseconds: 90300)),
        isTrue);
  });
}
