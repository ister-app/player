import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/graphql/fragmentMovie.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

/// When the last queue item of a *video* finishes, a paused player frozen on
/// its final frame is a dead surface: playback must end so the mini player
/// closes the video page. Audio keeps the item loaded for resume/replay.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // No video output plugin in a widget test: answer the texture-create call
  // with null so the handler's VideoController setup idles. The
  // MissingPluginException it throws otherwise arrives asynchronously, so it
  // lands on whichever test happens to be running and reports that one as
  // "did not complete" — a flake that moves around and never names its cause.
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('com.alexmercerind/media_kit_video'),
          (call) async => null);
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;

  MediaItem item(String id) => MediaItem(id: id, title: 'Item $id');

  setUp(() {
    // Keeps teardown paths away from the real player and network.
    ClientManager.testClientBuilder = (_) => throw UnimplementedError();
  });

  tearDown(() async {
    ClientManager.testClientBuilder = null;
    handler.movie = null;
    handler.mediaItem.add(null);
    handler.queue.add([]);
  });

  test('video at the end of the queue ends playback locally', () async {
    handler.queue.add([item('a')]);
    handler.playbackState
        .add(handler.playbackState.value.copyWith(queueIndex: 0));
    handler.movie = Fragment$fragmentMovie(
        id: 'movie-1', name: 'The Movie', releaseYear: 2001);
    final closeRequestsBefore = handler.closePlaybackRequest.value;

    handler.advanceAfterItemEnd();
    // endPlaybackLocally is async — give it a beat to run through.
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(handler.closePlaybackRequest.value, closeRequestsBefore + 1,
        reason: 'the dead video surface must be closed at queue end');
    expect(handler.lastPlaybackCloseKeepsPage, isFalse,
        reason: 'only the user\'s own stop keeps the page (with its cover); '
            'a played-out queue closes it');
    expect(handler.movie, isNull);
  });

  test('audio at the end of the queue keeps the item loaded', () async {
    handler.queue.add([item('a')]);
    handler.playbackState
        .add(handler.playbackState.value.copyWith(queueIndex: 0));
    handler.movie = null;
    final closeRequestsBefore = handler.closePlaybackRequest.value;

    handler.advanceAfterItemEnd();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(handler.closePlaybackRequest.value, closeRequestsBefore,
        reason: 'music/audiobooks stay resumable at queue end');
  });
}
