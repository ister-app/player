import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/components/MiniPlayer.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

/// The mini player is the visible proof that something is still loaded on this
/// device. When playback is torn down — the watch-along leader stopped, or the
/// queue moved to another device — it has to disappear rather than sit there
/// offering to resume media this device no longer has.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;

  setUp(() {
    // Keeps the teardown away from the real player (no mpv in a widget test).
    ClientManager.testClientBuilder = (_) => throw UnimplementedError();
  });

  tearDown(() async {
    ClientManager.testClientBuilder = null;
    handler.mediaItem.add(null);
    handler.queue.add([]);
  });

  testWidgets('endPlaybackLocally makes the mini player disappear',
      (tester) async {
    handler.mediaItem.add(MediaItem(
      id: MediaItemId('test-server', IsterMediaTypes.track, 'item-1').toString(),
      title: 'The Track',
      album: 'The Album',
    ));

    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: Align(alignment: Alignment.bottomCenter, child: MiniPlayer())),
    ));
    expect(find.text('The Track'), findsOneWidget);

    await handler.endPlaybackLocally(flushProgress: false);
    await tester.pump();

    expect(find.text('The Track'), findsNothing);
  });
}
