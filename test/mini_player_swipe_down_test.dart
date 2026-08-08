import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/components/MiniPlayer.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

/// Swiping the mini player down is the gesture-equivalent of the stop button:
/// past the threshold it ends playback for good (the bar disappears on the
/// null mediaItem), while a hesitant nudge springs back and keeps playing.
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

  Future<void> pumpBar(WidgetTester tester,
      {IsterMediaTypes type = IsterMediaTypes.track}) async {
    handler.mediaItem.add(MediaItem(
      id: MediaItemId('test-server', type, 'item-1').toString(),
      title: 'The Track',
      album: 'The Album',
    ));
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
          body: Align(alignment: Alignment.bottomCenter, child: MiniPlayer())),
    ));
    expect(find.text('The Track'), findsOneWidget);
  }

  testWidgets('swiping the bar down ends playback and removes it',
      (tester) async {
    await pumpBar(tester);

    // Well past the 40%-of-bar-height threshold, dragged slowly so the
    // distance rule (not the fling rule) is what dismisses.
    await tester.timedDrag(find.text('The Track'), const Offset(0, 60),
        const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(handler.mediaItem.valueOrNull, isNull);
    expect(find.text('The Track'), findsNothing);
  });

  testWidgets('a small downward nudge springs back and keeps playing',
      (tester) async {
    await pumpBar(tester);

    // Past the touch slop (so the drag recognizer wins over the tap) but
    // below the 40%-of-bar-height dismiss threshold.
    await tester.timedDrag(find.text('The Track'), const Offset(0, 20),
        const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(handler.mediaItem.valueOrNull, isNotNull);
    expect(find.text('The Track'), findsOneWidget);
  });

  testWidgets('video bars can be swiped away too', (tester) async {
    // The upward drag (open the music overlay) stays music-only, but ending
    // playback by swipe must work for a video bar as well.
    await pumpBar(tester, type: IsterMediaTypes.movie);

    await tester.timedDrag(find.text('The Track'), const Offset(0, 60),
        const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(handler.mediaItem.valueOrNull, isNull);
    expect(find.text('The Track'), findsNothing);
  });
}
