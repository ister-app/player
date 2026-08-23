import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/l10n/app_localizations.dart';

/// Regression: on a mid-height desktop window (the reported 705×750 case)
/// the portrait layout sized the cover from a fixed reserve that was smaller
/// than the real controls stack, so the column overflowed and the bottom
/// action bar fell off the screen. The cover must now shrink to fit instead.
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
  int get positionMs => 120000;
  @override
  int? get durationMs => 223000;
  @override
  bool get canSeek => true;
  @override
  bool get hasPrevious => true;
  @override
  bool get hasNext => true;
  @override
  List<PlayerQueueEntry> get previous => const [];
  @override
  List<PlayerQueueEntry> get upNext => const [];
  @override
  bool get supportsSleepTimer => true;
  @override
  bool get supportsRepeat => true;
  @override
  Widget? buildRating(BuildContext context, Color accent) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
            5, (_) => const Icon(Icons.star_border, color: Colors.white)),
      );
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
  for (final size in const [Size(705, 750), Size(705, 620), Size(400, 700)]) {
    testWidgets('portrait player keeps the bottom bar on screen at $size',
        (tester) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_app(_FakeController()));
      await tester.pumpAndSettle();

      // No RenderFlex overflow was thrown during layout.
      expect(tester.takeException(), isNull);

      final queueButton = find.byIcon(Icons.queue_music);
      expect(queueButton, findsOneWidget);
      final bottom = tester.getBottomLeft(queueButton).dy;
      expect(bottom, lessThanOrEqualTo(size.height),
          reason: 'bottom bar must sit inside the viewport');
      expect(tester.getBottomLeft(find.byIcon(Icons.skip_next)).dy,
          lessThan(bottom));
    });
  }
}
