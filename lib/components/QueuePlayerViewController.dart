import 'package:player/components/PlayerView.dart';

/// A [PlayerViewController] backed by a play queue, whatever the item type is.
///
/// The local player holds audio_service `MediaItem`s and the remote control
/// holds raw play-queue items, but everything around them is the same: split
/// the queue around the playing item, render both halves, and reorder or drop
/// an entry optimistically before the server confirms. That shared part lives
/// here; a subclass only says what its items are and how to mutate them.
abstract class QueuePlayerViewController<T> extends PlayerViewController {
  /// The whole queue in play order, including any optimistic override.
  List<T> get queueItems;

  /// Index of the playing item in [queueItems]; -1 when nothing plays.
  int get currentIndex;

  /// The playing item's server-side play-queue-item id, used as the anchor when
  /// something is moved to the head of "up next".
  String? get currentQueueItemId;

  PlayerQueueEntry entryFor(T item);

  /// The server-side play-queue-item id of [item] (the local player's entry ids
  /// are composite, so this is not always the entry id).
  String queueItemIdOf(T item);

  /// Installs (or clears, with null) the optimistic queue order shown while a
  /// mutation is in flight.
  void setOptimisticQueue(List<T>? items);

  Future<void> applyMove(String movedId, String? afterId);

  Future<void> applyRemove(String queueItemId);

  /// Whether the controller itself clears the optimistic queue once the
  /// mutation returns. False when a queue-changed event does it instead.
  bool get clearsOptimisticQueue => true;

  /// True once [dispose] ran; guards the post-await state updates.
  bool get disposed;

  /// Whether the queue is a loop, so the first and last item still have a
  /// previous/next (repeat-all).
  bool get queueWrapsAround => false;

  @override
  bool get hasPrevious =>
      currentIndex > 0 || (queueWrapsAround && queueItems.length > 1);

  @override
  bool get hasNext =>
      (currentIndex >= 0 && currentIndex < queueItems.length - 1) ||
      (queueWrapsAround && queueItems.length > 1);

  /// Splits the queue around the playing item into what was already played
  /// (newest first) and what is still to come.
  ({List<T> previous, List<T> upNext}) sliceQueue() {
    final items = queueItems;
    var index = currentIndex;
    // The index can briefly be stale (e.g. right after switching to a shorter
    // album); clamp so sublist can never reach past the queue.
    if (index >= items.length) index = items.length - 1;
    final previous =
        index > 0 ? items.sublist(0, index).reversed.toList() : <T>[];
    final upNext =
        index >= 0 && index + 1 < items.length ? items.sublist(index + 1) : <T>[];
    return (previous: previous, upNext: upNext);
  }

  @override
  List<PlayerQueueEntry> get previous =>
      sliceQueue().previous.map(entryFor).toList();

  @override
  List<PlayerQueueEntry> get upNext =>
      sliceQueue().upNext.map(entryFor).toList();

  @override
  Future<void> moveUpNext(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    if (newIndex == oldIndex) return;

    final reordered = List<T>.of(sliceQueue().upNext);
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);

    final items = queueItems;
    final index = currentIndex;
    final head = index >= 0 ? items.sublist(0, index + 1) : <T>[];
    setOptimisticQueue([...head, ...reordered]);
    notifyListeners();

    // Moving to the head of "up next" means directly after the current item.
    final afterId = newIndex == 0
        ? currentQueueItemId
        : queueItemIdOf(reordered[newIndex - 1]);
    await applyMove(queueItemIdOf(moved), afterId);
    if (disposed || !clearsOptimisticQueue) return;
    setOptimisticQueue(null);
    notifyListeners();
  }

  @override
  Future<void> removeEntry(PlayerQueueEntry entry) async {
    final items = queueItems;
    final target =
        items.where((item) => entryFor(item).id == entry.id).firstOrNull;
    if (target == null) return;

    setOptimisticQueue(
        items.where((item) => entryFor(item).id != entry.id).toList());
    notifyListeners();
    await applyRemove(queueItemIdOf(target));
    if (disposed || !clearsOptimisticQueue) return;
    setOptimisticQueue(null);
    notifyListeners();
  }
}
