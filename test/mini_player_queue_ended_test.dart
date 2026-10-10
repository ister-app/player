import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/components/MiniPlayer.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/graphql/fragmentMovie.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/QueueEnd.dart';

/// The mini player after a queue played out: an audio queue leaves a bar
/// with what ended, play-again and close; a video queue leaves nothing (its
/// page shows the end screen); a plain teardown leaves nothing either.
const _server = 'test-server';

Fragment$fragmentPlayQueue$playQueueItems _trackItem() =>
    Fragment$fragmentPlayQueue$playQueueItems(
      accessible: true,
      id: 'item-1',
      position: 1,
      track: Fragment$fragmentPlayQueue$playQueueItems$track(
        id: 'track-1',
        number: 1,
        discNumber: 1,
        artist: Fragment$fragmentPlayQueue$playQueueItems$track$artist(
            id: 'artist-1', name: 'The Artist'),
        artists: const [],
        album: Fragment$fragmentPlayQueue$playQueueItems$track$album(
            id: 'album-1', name: 'The Album'),
      ),
    );

Fragment$fragmentPlayQueue$playQueueItems _movieItem() =>
    Fragment$fragmentPlayQueue$playQueueItems(
      accessible: true,
      id: 'item-1',
      position: 1,
      movie: Fragment$fragmentMovie(id: 'm', name: 'The Movie', releaseYear: 2000),
    );

QueueEndedInfo _ended({required bool video}) {
  final item = video ? _movieItem() : _trackItem();
  return QueueEndedInfo(
    serverName: _server,
    client: null,
    playQueue: Fragment$fragmentPlayQueue(
      id: 'pq-1',
      currentItemId: 'item-1',
      progressInMilliseconds: 0,
      shuffle: false,
      sourceType: video
          ? Enum$PlayQueueSourceType.MOVIE
          : Enum$PlayQueueSourceType.ALBUM,
      sourceExhausted: true,
      controlAllowedUserIds: const [],
      playQueueItems: [item],
    ),
    lastItem: item,
    lastMediaItem: MediaItem(
      id: MediaItemId(_server,
              video ? IsterMediaTypes.movie : IsterMediaTypes.track, 'item-1')
          .toString(),
      title: video ? 'The Movie' : 'Last Track',
    ),
  );
}

Widget _app() => const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en')],
      home: Scaffold(
          body: Align(alignment: Alignment.bottomCenter, child: MiniPlayer())),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('com.alexmercerind/media_kit_video'),
          (call) async => null);
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;

  setUp(() {
    ClientManager.testClientBuilder = (_) => throw UnimplementedError();
  });

  tearDown(() async {
    ClientManager.testClientBuilder = null;
    handler.queueEnded.value = null;
    handler.mediaItem.add(null);
    handler.queue.add([]);
  });

  testWidgets('an ended audio queue keeps a bar with play again and close',
      (tester) async {
    handler.queueEnded.value = _ended(video: false);
    final closeRequestsBefore = handler.closePlaybackRequest.value;
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.byKey(MiniPlayer.endedBarKey), findsOneWidget);
    expect(find.text('Last Track'), findsOneWidget);
    expect(find.byKey(MiniPlayer.playAgainKey), findsOneWidget);

    await tester.tap(find.byKey(MiniPlayer.dismissEndedKey));
    await tester.pump();

    expect(handler.queueEnded.value, isNull);
    expect(handler.closePlaybackRequest.value, closeRequestsBefore + 1);
    expect(find.byKey(MiniPlayer.endedBarKey), findsNothing);
  });

  testWidgets('an ended video queue leaves no bar', (tester) async {
    handler.queueEnded.value = _ended(video: true);
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.byKey(MiniPlayer.endedBarKey), findsNothing);
  });

  testWidgets('a teardown without an ended state leaves no bar',
      (tester) async {
    handler.mediaItem.add(MediaItem(
      id: MediaItemId(_server, IsterMediaTypes.track, 'item-1').toString(),
      title: 'The Track',
    ));
    await tester.pumpWidget(_app());
    expect(find.text('The Track'), findsOneWidget);

    await handler.endPlaybackLocally(flushProgress: false);
    await tester.pump();

    expect(find.text('The Track'), findsNothing);
    expect(find.byKey(MiniPlayer.endedBarKey), findsNothing);
  });

  testWidgets('the next button is greyed out on the last item',
      (tester) async {
    handler.queue.add([
      MediaItem(
          id: MediaItemId(_server, IsterMediaTypes.track, 'item-1').toString(),
          title: 'Only Track'),
    ]);
    handler.mediaItem.add(handler.queue.value.first);
    handler.playbackState
        .add(handler.playbackState.value.copyWith(queueIndex: 0));
    await tester.pumpWidget(_app());
    await tester.pump();

    final next =
        tester.widget<IconButton>(find.byKey(MiniPlayer.skipNextKey));
    expect(next.onPressed, isNull);
  });
}
