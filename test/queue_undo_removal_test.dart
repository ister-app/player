import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/components/QueuePlayerViewController.dart';
import 'package:player/l10n/app_localizations.dart';

/// A queue of plain ids, with "the server" being the [server] list: the
/// removal only reaches it through [applyRemove].
class _Controller extends QueuePlayerViewController<String> {
  final List<String> server = ['a', 'b', 'c', 'd'];
  String current = 'a';
  final List<String> removeCalls = [];
  bool _disposed = false;

  @override
  List<String> get queueItems => server;
  @override
  int get currentIndex => server.indexOf(current);
  @override
  String? get currentQueueItemId => current;
  @override
  PlayerQueueEntry entryFor(String item) =>
      PlayerQueueEntry(id: 'entry-$item', title: 'Track $item');
  @override
  String queueItemIdOf(String item) => item;
  @override
  void setOptimisticQueue(List<String>? items) {}
  @override
  Future<void> applyMove(String movedId, String? afterId) async {}
  @override
  Future<void> applyRemove(String queueItemId) async {
    removeCalls.add(queueItemId);
    server.remove(queueItemId);
  }

  @override
  bool get disposed => _disposed;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

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
}

List<String> _upNext(_Controller c) => c.upNext.map((e) => e.id).toList();

void main() {
  test('a removed entry leaves the list at once, the server only after the '
      'undo window', () {
    fakeAsync((async) {
      final c = _Controller();
      c.removeEntry(c.upNext[1]); // c
      async.flushMicrotasks();

      expect(_upNext(c), ['entry-b', 'entry-d']);
      expect(c.pendingRemoval?.id, 'entry-c');
      expect(c.removeCalls, isEmpty);

      async.elapse(QueuePlayerViewController.undoWindow);
      expect(c.removeCalls, ['c']);
      expect(c.pendingRemoval, isNull);
      expect(_upNext(c), ['entry-b', 'entry-d']);
      c.dispose();
    });
  });

  test('undo brings it back and nothing is ever sent', () {
    fakeAsync((async) {
      final c = _Controller();
      c.removeEntry(c.upNext[1]);
      async.elapse(const Duration(seconds: 2));
      c.undoRemove();

      expect(_upNext(c), ['entry-b', 'entry-c', 'entry-d']);
      expect(c.pendingRemoval, isNull);
      async.elapse(const Duration(seconds: 30));
      expect(c.removeCalls, isEmpty);
      c.dispose();
    });
  });

  test('a second removal settles the first; only the last can be undone', () {
    fakeAsync((async) {
      final c = _Controller();
      c.removeEntry(c.upNext[0]); // b
      async.flushMicrotasks();
      c.removeEntry(c.upNext[0]); // c
      async.flushMicrotasks();

      expect(c.removeCalls, ['b']);
      expect(c.pendingRemoval?.id, 'entry-c');
      c.undoRemove();
      expect(_upNext(c), ['entry-c', 'entry-d']);
      c.dispose();
    });
  });

  test('playback moving on closes the undo window', () {
    fakeAsync((async) {
      final c = _Controller();
      c.removeEntry(c.upNext[1]); // c
      async.flushMicrotasks();
      c.current = 'b';
      c.notifyListeners();
      async.flushMicrotasks();

      expect(c.removeCalls, ['c']);
      expect(c.pendingRemoval, isNull);
      c.dispose();
    });
  });

  test('closing the player is not an undo', () {
    fakeAsync((async) {
      final c = _Controller();
      c.removeEntry(c.upNext[0]);
      async.flushMicrotasks();
      c.dispose();
      async.flushMicrotasks();
      expect(c.removeCalls, ['b']);
    });
  });

  testWidgets('the player offers the undo while the removal is pending',
      (tester) async {
    final c = _Controller();
    addTearDown(c.dispose);
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: PlayerView(
          controller: c, onDismissed: () {}, initialSlideValue: 1.0),
    ));
    await tester.pumpAndSettle();
    expect(find.byKey(PlayerView.undoRemovalBarKey), findsNothing);

    c.removeEntry(c.upNext[0]);
    await tester.pumpAndSettle();
    expect(find.byKey(PlayerView.undoRemovalBarKey), findsOneWidget);

    await tester.tap(find.byKey(PlayerView.undoRemovalButtonKey));
    await tester.pumpAndSettle();
    expect(find.byKey(PlayerView.undoRemovalBarKey), findsNothing);
    expect(c.removeCalls, isEmpty);
    expect(_upNext(c), ['entry-b', 'entry-c', 'entry-d']);
  });
}
