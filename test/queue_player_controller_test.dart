import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/components/QueuePlayerViewController.dart';

/// The queue behaviour both player views inherit: how the queue is split around
/// the playing item, and what a reorder or a removal asks of the server.
class _FakeQueueController extends QueuePlayerViewController<String> {
  _FakeQueueController(this._items, this._currentIndex);

  List<String> _items;
  final int _currentIndex;
  List<String>? _optimistic;

  /// (movedId, afterId) of every move that reached the "server".
  final List<(String, String?)> moves = [];
  final List<String> removals = [];

  @override
  List<String> get queueItems => _optimistic ?? _items;

  @override
  int get currentIndex => _currentIndex;

  @override
  String? get currentQueueItemId =>
      _currentIndex >= 0 && _currentIndex < _items.length
          ? _items[_currentIndex]
          : null;

  @override
  PlayerQueueEntry entryFor(String item) => PlayerQueueEntry(
        id: 'entry-$item',
        title: item,
        subtitle: null,
        artUrl: null,
      );

  @override
  String queueItemIdOf(String item) => item;

  @override
  void setOptimisticQueue(List<String>? items) => _optimistic = items;

  @override
  bool get disposed => false;

  @override
  Future<void> applyMove(String movedId, String? afterId) async {
    moves.add((movedId, afterId));
    final items = List<String>.of(_items)..remove(movedId);
    items.insert(afterId == null ? 0 : items.indexOf(afterId) + 1, movedId);
    _items = items;
  }

  @override
  Future<void> applyRemove(String queueItemId) async {
    removals.add(queueItemId);
    _items = List<String>.of(_items)..remove(queueItemId);
  }

  // Unused by these tests, but the interface demands them.
  @override
  bool get loading => false;
  @override
  String? get artUri => null;
  @override
  String? get artistLine => null;
  @override
  String? get titleLine => null;
  @override
  String? get albumLine => null;
  @override
  int get positionMs => 0;
  @override
  int? get durationMs => null;
  @override
  bool get canSeek => false;
  @override
  Widget buildPlayPauseButton(BuildContext context) => const SizedBox.shrink();
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

void main() {
  List<String> titles(List<PlayerQueueEntry> entries) =>
      entries.map((e) => e.title).toList();

  test('the queue is split around the playing item, newest played first', () {
    final controller = _FakeQueueController(['a', 'b', 'c', 'd'], 2);

    expect(titles(controller.previous), ['b', 'a']);
    expect(titles(controller.upNext), ['d']);
    expect(controller.hasPrevious, isTrue);
    expect(controller.hasNext, isTrue);
  });

  test('the ends of the queue have no previous or next', () {
    expect(_FakeQueueController(['a', 'b'], 0).hasPrevious, isFalse);
    expect(_FakeQueueController(['a', 'b'], 1).hasNext, isFalse);
  });

  test('a stale index past the end does not reach outside the queue', () {
    // The local player's queueIndex can lag right after switching to a shorter
    // album; slicing must survive it rather than throw.
    final controller = _FakeQueueController(['a', 'b'], 7);

    expect(titles(controller.previous), ['a']);
    expect(controller.upNext, isEmpty);
  });

  test('nothing playing yet leaves the whole queue unsliced', () {
    final controller = _FakeQueueController(['a', 'b'], -1);

    expect(controller.previous, isEmpty);
    expect(controller.upNext, isEmpty);
    expect(controller.hasPrevious, isFalse);
    expect(controller.hasNext, isFalse);
  });

  test('a wrapping queue keeps both ends reachable', () {
    final controller = _WrappingController(['a', 'b'], 0);

    expect(controller.hasPrevious, isTrue);
    expect(controller.hasNext, isTrue);
  });

  test('moving to the head of up next anchors on the playing item', () async {
    final controller = _FakeQueueController(['a', 'b', 'c', 'd'], 1);

    // Drag 'd' (index 1 of up next) to the top of up next.
    await controller.moveUpNext(1, 0);

    expect(controller.moves, [('d', 'b')]);
    expect(controller.queueItems, ['a', 'b', 'd', 'c']);
  });

  test('moving further down anchors on the entry it lands behind', () async {
    final controller = _FakeQueueController(['a', 'b', 'c', 'd', 'e'], 0);

    // Drag 'b' down past 'c' — the reorder callback's raw indices.
    await controller.moveUpNext(0, 2);

    expect(controller.moves, [('b', 'c')]);
    expect(controller.queueItems, ['a', 'c', 'b', 'd', 'e']);
  });

  test('a move that changes nothing is not sent', () async {
    final controller = _FakeQueueController(['a', 'b', 'c'], 0);

    await controller.moveUpNext(1, 2);

    expect(controller.moves, isEmpty);
  });

  test('removing an entry removes exactly that queue item', () async {
    final controller = _FakeQueueController(['a', 'b', 'c'], 0);

    await controller.removeEntry(controller.entryFor('b'));

    expect(controller.removals, ['b']);
    expect(controller.queueItems, ['a', 'c']);
  });

  test('removing an entry that is already gone does nothing', () async {
    final controller = _FakeQueueController(['a'], 0);

    await controller.removeEntry(const PlayerQueueEntry(
        id: 'entry-zz', title: 'zz', subtitle: null, artUrl: null));

    expect(controller.removals, isEmpty);
  });

  test('a controller that waits for a queue-changed event keeps its optimistic '
      'order', () async {
    final controller = _EventDrivenController(['a', 'b', 'c'], 0);

    await controller.removeEntry(controller.entryFor('b'));

    // Clearing here would flash the stale queue until the refresh lands.
    expect(controller.queueItems, ['a', 'c']);
    expect(controller.optimisticCleared, isFalse);
  });
}

class _WrappingController extends _FakeQueueController {
  _WrappingController(super.items, super.currentIndex);

  @override
  bool get queueWrapsAround => true;
}

class _EventDrivenController extends _FakeQueueController {
  _EventDrivenController(super.items, super.currentIndex);

  bool optimisticCleared = false;

  @override
  bool get clearsOptimisticQueue => false;

  @override
  void setOptimisticQueue(List<String>? items) {
    if (items == null) optimisticCleared = true;
    super.setOptimisticQueue(items);
  }
}
