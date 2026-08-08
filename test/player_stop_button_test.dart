import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/l10n/app_localizations.dart';

/// Pins the stop button in the full player: only controllers that support it
/// get one (the slot stays reserved so the row lines up), tapping it invokes
/// the controller's stop, and a disabled transport greys it out.
class _FakeController extends PlayerViewController {
  _FakeController({this.stoppable = true, this.transportEnabled = true});

  final bool stoppable;
  final bool transportEnabled;
  int stops = 0;

  @override
  bool get loading => false;
  @override
  bool get enabled => transportEnabled;
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
  bool get supportsStop => stoppable;
  @override
  void stop() => stops++;
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
  testWidgets('tapping the stop button invokes the controller', (tester) async {
    final controller = _FakeController();
    await tester.pumpWidget(_app(controller));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.stop_circle_outlined));
    await tester.pump();

    expect(controller.stops, 1);
  });

  testWidgets('the stop button is absent without support', (tester) async {
    await tester.pumpWidget(_app(_FakeController(stoppable: false)));
    await tester.pump();
    expect(find.byIcon(Icons.stop_circle_outlined), findsNothing);
  });

  testWidgets('a disabled transport disables the stop button', (tester) async {
    // E.g. the remote control after the session already ended.
    final controller = _FakeController(transportEnabled: false);
    await tester.pumpWidget(_app(controller));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.stop_circle_outlined),
        warnIfMissed: false);
    await tester.pump();

    expect(controller.stops, 0);
  });
}
