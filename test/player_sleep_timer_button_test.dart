import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/components/SleepTimerSheet.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/SleepTimerService.dart';

/// Pins the sleep-timer UI chain in the full player: the bedtime button only
/// shows for controllers that support it, tapping it opens the sheet, a
/// preset arms the shared service, and the button then shows a countdown.
class _FakeController extends PlayerViewController {
  _FakeController({this.sleepTimer = true});

  final bool sleepTimer;

  @override
  bool get loading => false;
  @override
  String? get artUri => null;
  @override
  String? get artistLine => 'Artist';
  @override
  String? get titleLine => 'Track';
  @override
  String? get albumLine => 'Album';
  @override
  int get positionMs => 0;
  @override
  int? get durationMs => 60000;
  @override
  bool get canSeek => false;
  @override
  bool get hasPrevious => false;
  @override
  bool get hasNext => false;
  @override
  List<PlayerQueueEntry> get previous => const [];
  @override
  List<PlayerQueueEntry> get upNext => const [];
  @override
  bool get supportsSleepTimer => sleepTimer;
  @override
  Widget buildPlayPauseButton(BuildContext context) =>
      const Icon(Icons.play_arrow);
  @override
  void skipToPrevious() {}
  @override
  void skipToNext() {}
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
  tearDown(() {
    // The service is a real singleton shared with the app; leave it clean.
    SleepTimerService.instance.notifyPlaybackStopped();
  });

  testWidgets('bedtime button is absent when the controller lacks support',
      (tester) async {
    await tester.pumpWidget(_app(_FakeController(sleepTimer: false)));
    await tester.pump();
    expect(find.byIcon(Icons.bedtime_outlined), findsNothing);
  });

  testWidgets('preset from the sheet arms the timer and shows a countdown',
      (tester) async {
    await tester.pumpWidget(_app(_FakeController()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.bedtime_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(SleepTimerSheet), findsOneWidget);

    await tester.tap(find.text('15 min'));
    await tester.pumpAndSettle();

    expect(SleepTimerService.instance.isActive, isTrue);
    expect(find.byIcon(Icons.bedtime), findsOneWidget);
    expect(find.text('15m'), findsOneWidget);

    // Disarm before the binding's pending-timer check runs (tearDown is too
    // late for it): the service ticker is a real periodic Timer.
    SleepTimerService.instance.notifyPlaybackStopped();
    await tester.pump();
  });

  testWidgets('cancelling from the sheet disarms the timer', (tester) async {
    SleepTimerService.instance.start(const Duration(minutes: 30));
    await tester.pumpWidget(_app(_FakeController()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.bedtime));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel timer'));
    await tester.pumpAndSettle();

    expect(SleepTimerService.instance.isActive, isFalse);
    expect(find.byIcon(Icons.bedtime_outlined), findsOneWidget);
  });

  test('expiry invokes the stop callback wired by the handler', () {
    fakeAsync((async) {
      final service = SleepTimerService.forTest();
      service.now = async.getClock(DateTime(2026, 7, 28, 23, 0)).now;
      var stopped = 0;
      service.onExpire = () async => stopped++;
      service.start(const Duration(minutes: 1));
      async.elapse(const Duration(minutes: 1));
      expect(stopped, 1);
    });
  });
}
