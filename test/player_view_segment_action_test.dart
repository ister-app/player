import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/components/video_controls/SegmentOverlayButtons.dart';
import 'package:player/l10n/app_localizations.dart';

/// The PlayerView (music player / remote control) shows a skip-intro or
/// next-episode prompt between the seek bar and the transport whenever the
/// controller reports one; the default controller reports none, keeping
/// music surfaces untouched.
class _FakeController extends PlayerViewController {
  _FakeController({this.actions = (skipIntro: false, nextEpisode: false)});

  SegmentActions actions;
  int skipIntroCalls = 0;
  int skipToNextCalls = 0;

  @override
  bool get loading => false;
  @override
  String? get artUri => null;
  @override
  String? get artistLine => 'Show';
  @override
  String? get titleLine => 'Episode';
  @override
  String? get albumLine => null;
  @override
  int get positionMs => 0;
  @override
  int? get durationMs => 60000;
  @override
  bool get canSeek => true;
  @override
  bool get hasPrevious => false;
  @override
  bool get hasNext => true;
  @override
  List<PlayerQueueEntry> get previous => const [];
  @override
  List<PlayerQueueEntry> get upNext =>
      const [PlayerQueueEntry(id: 'n', title: 'Next')];
  @override
  SegmentActions get segmentActions => actions;
  @override
  void skipIntro() => skipIntroCalls++;
  @override
  Widget buildPlayPauseButton(BuildContext context) =>
      const Icon(Icons.play_arrow);
  @override
  void skipToPrevious() {}
  @override
  void skipToNext() => skipToNextCalls++;
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
  testWidgets('no prompt by default (music surfaces stay untouched)',
      (tester) async {
    await tester.pumpWidget(_app(_FakeController()));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Skip intro'), findsNothing);
    expect(find.text('Next episode'), findsNothing);
  });

  testWidgets('skip intro prompt shows and taps through to the controller',
      (tester) async {
    final controller =
        _FakeController(actions: (skipIntro: true, nextEpisode: false));
    await tester.pumpWidget(_app(controller));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Skip intro'), findsOneWidget);
    await tester.tap(find.text('Skip intro'));
    expect(controller.skipIntroCalls, 1);
  });

  testWidgets('next-episode prompt follows a position tick', (tester) async {
    final controller = _FakeController();
    await tester.pumpWidget(_app(controller));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Next episode'), findsNothing);

    // The remote controller flips the actions as its interpolated position
    // enters the outro and pings the 1 Hz ticker — no structural notify.
    controller.actions = (skipIntro: false, nextEpisode: true);
    controller.positionTicker.notify();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Next episode'), findsOneWidget);
    await tester.tap(find.text('Next episode'));
    expect(controller.skipToNextCalls, 1);
  });
}
