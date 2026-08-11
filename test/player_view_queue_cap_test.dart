import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/l10n/app_localizations.dart';

/// Pins the fit-to-viewport cap on the queue tabs: both "previous" and
/// "up next" show exactly as many rows as fit in one screen, the rest is
/// dropped, and the player never scrolls beyond that one extra screen.
class _FakeController extends PlayerViewController {
  _FakeController({required this.previousItems, required this.upNextItems});

  final List<PlayerQueueEntry> previousItems;
  final List<PlayerQueueEntry> upNextItems;

  @override
  bool get loading => false;
  @override
  bool get enabled => true;
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
  bool get hasPrevious => previousItems.isNotEmpty;
  @override
  bool get hasNext => upNextItems.isNotEmpty;
  @override
  List<PlayerQueueEntry> get previous => previousItems;
  @override
  List<PlayerQueueEntry> get upNext => upNextItems;
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

List<PlayerQueueEntry> _entries(String prefix, int count) => [
      for (int i = 0; i < count; i++)
        PlayerQueueEntry(id: '$prefix-$i', title: '$prefix item $i'),
    ];

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

/// Rows of 64px fit in the viewport minus the 88px queue chrome.
int _expectedRows(double viewportHeight) => ((viewportHeight - 88) / 64).floor();

Future<void> _scrollToQueue(WidgetTester tester) async {
  final position = tester
      .state<ScrollableState>(find.byType(Scrollable).first)
      .position;
  position.jumpTo(position.maxScrollExtent);
  await tester.pumpAndSettle();
}

void main() {
  Future<void> pumpAt(WidgetTester tester, Size size,
      _FakeController controller) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_app(controller));
    await tester.pumpAndSettle();
    await _scrollToQueue(tester);
  }

  testWidgets('up next shows exactly the rows that fit, no more',
      (tester) async {
    const size = Size(400, 900);
    final controller = _FakeController(
      previousItems: _entries('prev', 40),
      upNextItems: _entries('next', 40),
    );
    await pumpAt(tester, size, controller);

    final expected = _expectedRows(size.height);
    expect(find.textContaining('next item '), findsNWidgets(expected));
    expect(find.text('next item ${expected - 1}'), findsOneWidget);
    expect(find.text('next item $expected'), findsNothing);
  });

  testWidgets('a shorter viewport shows fewer rows', (tester) async {
    // Small but still tall enough for the art/controls page, which overflows
    // (pre-existing) below ~600px and would fail the test harness.
    const size = Size(400, 680);
    final controller = _FakeController(
      previousItems: _entries('prev', 40),
      upNextItems: _entries('next', 40),
    );
    await pumpAt(tester, size, controller);

    final expected = _expectedRows(size.height);
    expect(find.textContaining('next item '), findsNWidgets(expected));
  });

  testWidgets('the previous tab is capped the same way', (tester) async {
    const size = Size(400, 900);
    final controller = _FakeController(
      previousItems: _entries('prev', 40),
      upNextItems: _entries('next', 40),
    );
    await pumpAt(tester, size, controller);

    await tester.tap(find.text('BACK TO'));
    await tester.pumpAndSettle();

    final expected = _expectedRows(size.height);
    expect(find.textContaining('prev item '), findsNWidgets(expected));
    expect(find.text('prev item $expected'), findsNothing);
  });

  testWidgets('the queue never extends the scroll range beyond one screen',
      (tester) async {
    const size = Size(400, 900);
    final controller = _FakeController(
      previousItems: _entries('prev', 40),
      upNextItems: _entries('next', 40),
    );
    await pumpAt(tester, size, controller);

    final position = tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position;
    // The queue is the one "second screen" below the art/controls page.
    expect(position.maxScrollExtent, lessThanOrEqualTo(size.height));
  });
}
