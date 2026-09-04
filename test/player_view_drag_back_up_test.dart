import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/l10n/app_localizations.dart';

/// Regression: dragging the player sheet halfway down and then back up used to
/// scroll the queue list instead of restoring the sheet — the clamping physics
/// reported no overscroll to give back, so only the downward direction reached
/// the sheet.
class _FakeController extends PlayerViewController {
  @override
  bool get loading => false;
  @override
  String? get artUri => null;
  @override
  String? get artistLine => 'Olivia Rodrigo';
  @override
  String? get titleLine => 'honeybee';
  @override
  String? get albumLine => 'you seem pretty sad for a girl so in love';
  @override
  int get positionMs => 0;
  @override
  int? get durationMs => 223000;
  @override
  bool get canSeek => true;
  @override
  bool get hasPrevious => false;
  @override
  bool get hasNext => true;
  @override
  List<PlayerQueueEntry> get previous => const [];
  @override
  List<PlayerQueueEntry> get upNext => List.generate(
      20, (i) => PlayerQueueEntry(id: '$i', title: 'Track $i'));
  @override
  Widget buildPlayPauseButton(BuildContext context) =>
      const Icon(Icons.pause, size: 64);
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

void main() {
  testWidgets('a half dismiss drag can be dragged back up', (tester) async {
    const size = Size(400, 800);
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    var dismissed = false;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: PlayerView(
          controller: _FakeController(), onDismissed: () => dismissed = true),
    ));
    await tester.pumpAndSettle();

    final title = find.text('honeybee');
    final restingY = tester.getTopLeft(title).dy;

    final gesture = await tester.startGesture(const Offset(200, 300));
    await gesture.moveBy(const Offset(0, 240));
    await tester.pump();
    final draggedY = tester.getTopLeft(title).dy;
    expect(draggedY, greaterThan(restingY + 150),
        reason: 'the sheet follows the downward drag');

    // Back up: the sheet must come along, the list must not scroll instead.
    await gesture.moveBy(const Offset(0, -200));
    await tester.pump();
    expect(tester.getTopLeft(title).dy, lessThan(draggedY - 120),
        reason: 'the upward drag restores the sheet');

    await gesture.up();
    await tester.pumpAndSettle();
    expect(dismissed, isFalse);
    expect(tester.getTopLeft(title).dy, closeTo(restingY, 0.5));
  });
}
