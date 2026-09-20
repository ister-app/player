import 'dart:async';

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
    var upNext =
        index >= 0 && index + 1 < items.length ? items.sublist(index + 1) : <T>[];
    // An entry whose removal can still be undone (or is on its way to the
    // server) is off the list already. Filtered here rather than through the
    // optimistic queue: that one is a snapshot, which a queue refresh inside
    // the undo window would silently throw away.
    if (_hiddenEntryIds.isNotEmpty) {
      upNext = upNext
          .where((item) => !_hiddenEntryIds.contains(entryFor(item).id))
          .toList();
    }
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
    // The indices are those of the list on screen, which lacks a removal
    // that is still undoable; settle it so they mean the same to the server.
    await flushPendingRemoval();

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

  /// How long a removed entry can be brought back. There is no server-side
  /// "put it back where it was", so the removal itself waits this long: the
  /// entry only leaves the list on screen, and the mutation goes out when the
  /// window closes (or sooner — see [flushPendingRemoval]).
  static const Duration undoWindow = Duration(seconds: 5);

  ({T item, PlayerQueueEntry entry, String? currentAtRemoval})? _pending;
  Timer? _pendingTimer;
  final Set<String> _hiddenEntryIds = {};

  @override
  PlayerQueueEntry? get pendingRemoval => _pending?.entry;

  @override
  Future<void> removeEntry(PlayerQueueEntry entry) async {
    final target =
        queueItems.where((item) => entryFor(item).id == entry.id).firstOrNull;
    if (target == null) return;
    // One undoable removal at a time, like the snackbar it is modelled on:
    // the one before is settled. Hidden *synchronously* though — a dismissed
    // Dismissible must be out of the tree by the next frame.
    final earlier = _takePending();
    _hiddenEntryIds.add(entry.id);
    _pending =
        (item: target, entry: entry, currentAtRemoval: currentQueueItemId);
    _pendingTimer = Timer(undoWindow, flushPendingRemoval);
    notifyListeners();
    if (earlier != null) await _commitRemoval(earlier);
  }

  ({T item, PlayerQueueEntry entry, String? currentAtRemoval})? _takePending() {
    final pending = _pending;
    _pendingTimer?.cancel();
    _pending = null;
    return pending;
  }

  Future<void> _commitRemoval(
      ({T item, PlayerQueueEntry entry, String? currentAtRemoval})
          pending) async {
    // Stays hidden while the mutation is in flight; after that the queue
    // itself says whether it is gone (a refused removal shows up again).
    await applyRemove(queueItemIdOf(pending.item));
    _hiddenEntryIds.remove(pending.entry.id);
    if (!disposed) notifyListeners();
  }

  @override
  void undoRemove() {
    final pending = _takePending();
    if (pending == null) return;
    _hiddenEntryIds.remove(pending.entry.id);
    notifyListeners();
  }

  /// Sends the removal that is still undoable, if any. Everything that
  /// addresses the queue by position calls this first: the list on screen is
  /// one entry short of the real queue until then.
  @override
  Future<void> flushPendingRemoval() async {
    final pending = _takePending();
    if (pending == null) return;
    if (!disposed) notifyListeners();
    await _commitRemoval(pending);
  }

  /// Playback moving on closes the undo window early: the next item up could
  /// be the very one being removed.
  @override
  void notifyListeners() {
    final pending = _pending;
    if (pending != null && pending.currentAtRemoval != currentQueueItemId) {
      unawaited(flushPendingRemoval());
      return;
    }
    super.notifyListeners();
  }

  /// Closing the player is not an undo.
  @override
  void dispose() {
    final pending = _takePending();
    if (pending != null) unawaited(applyRemove(queueItemIdOf(pending.item)));
    super.dispose();
  }
}
