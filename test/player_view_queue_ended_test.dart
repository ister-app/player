import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/components/QueueEndedBanner.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/QueueEnd.dart';

/// The full player's ended state: a controller whose queue played out
/// renders the [QueueEndedBanner] in the banner slot with play-again and
/// close, and its transport is inert.
QueueEndedInfo _ended() {
  final item = Fragment$fragmentPlayQueue$playQueueItems(
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
  return QueueEndedInfo(
    serverName: 'test-server',
    client: null,
    playQueue: Fragment$fragmentPlayQueue(
      id: 'pq-1',
      currentItemId: 'item-1',
      progressInMilliseconds: 0,
      shuffle: false,
      sourceType: Enum$PlayQueueSourceType.ALBUM,
      sourceExhausted: true,
      controlAllowedUserIds: const [],
      playQueueItems: [item],
    ),
    lastItem: item,
    lastMediaItem: MediaItem(
      id: MediaItemId('test-server', IsterMediaTypes.track, 'item-1')
          .toString(),
      title: 'Last Track',
      artist: 'The Artist',
    ),
  );
}

class _FakeController extends PlayerViewController {
  _FakeController({this.ended});

  final QueueEndedInfo? ended;
  int playAgain = 0;
  int dismissed = 0;
  int nexts = 0;

  @override
  bool get loading => false;
  @override
  bool get enabled => ended == null;
  @override
  String? get artUri => null;
  @override
  String? get artistLine => 'The Artist';
  @override
  String? get titleLine => ended?.lastMediaItem.title ?? 'Track';
  @override
  String? get albumLine => 'The Album';
  @override
  int get positionMs => 0;
  @override
  int? get durationMs => 60000;
  @override
  bool get canSeek => false;
  @override
  bool get hasPrevious => false;
  @override
  bool get hasNext => true;
  @override
  List<PlayerQueueEntry> get previous => const [];
  @override
  List<PlayerQueueEntry> get upNext => const [];
  @override
  Widget buildPlayPauseButton(BuildContext context) =>
      const Icon(Icons.play_arrow);
  @override
  Widget? buildBanner(BuildContext context) {
    final ended = this.ended;
    if (ended == null) return null;
    return QueueEndedBanner(
      info: ended,
      onPlayAgain: () => playAgain++,
      onDismiss: () => dismissed++,
    );
  }

  @override
  void skipToPrevious() {}
  @override
  void skipToNext() => nexts++;
  @override
  void seek(Duration position) {}
  @override
  void tapPrevious(int index) {}
  @override
  void tapUpNext(int index) {}
  @override
  Future<void> moveUpNext(int oldIndex, int newIndex) async {}
  @override
  Future<void> removeEntry(PlayerQueueEntry entry) async {}
}

Widget _app(PlayerViewController controller) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: PlayerView(controller: controller, onDismissed: () {}),
    );

void main() {
  testWidgets('an ended queue shows the banner with play again and close',
      (tester) async {
    final controller = _FakeController(ended: _ended());
    await tester.pumpWidget(_app(controller));
    // The view slides up on open; let it land before looking for things.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byKey(QueueEndedBanner.bannerKey), findsOneWidget);
    expect(find.text('Last Track'), findsWidgets,
        reason: 'what ended stays on screen');

    await tester.tap(find.byKey(QueueEndedBanner.playAgainKey));
    await tester.pump();
    expect(controller.playAgain, 1);

    await tester.tap(find.byKey(QueueEndedBanner.dismissKey));
    await tester.pump();
    expect(controller.dismissed, 1);
  });

  testWidgets('the transport is inert while ended', (tester) async {
    final controller = _FakeController(ended: _ended());
    await tester.pumpWidget(_app(controller));
    // The view slides up on open; let it land before looking for things.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));

    final next = tester.widget<IconButton>(find.byWidgetPredicate((w) =>
        w is IconButton && (w.icon as Icon).icon == Icons.skip_next));
    expect(next.onPressed, isNull);
  });

  testWidgets('no banner while playing', (tester) async {
    final controller = _FakeController();
    await tester.pumpWidget(_app(controller));
    // The view slides up on open; let it land before looking for things.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byKey(QueueEndedBanner.bannerKey), findsNothing);
  });
}
