import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:player/dto/IsterMediaService.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadService.dart';

/// Decides when the downloads deserve a foreground service (Android) and what
/// its notification says, from the [DownloadService] notifiers alone — no
/// plugin involved, so the rules are unit-tested. `start` fires as soon as
/// there is queued or running work (and nothing is paused), `update` while
/// it runs (throttled), `stop` when the queue is empty or paused. The service
/// deliberately spans the gaps between downloads: a backgrounded app is not
/// allowed to start a foreground service again for the next item.
class DownloadForegroundController {
  DownloadForegroundController({
    required this.service,
    required this.start,
    required this.update,
    required this.stop,
    this.throttle = const Duration(seconds: 1),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final DownloadService service;

  /// Returns whether the service actually came up (Android may refuse a
  /// start from the background); a refused start is retried on the next
  /// state change.
  final Future<bool> Function(String title, String text) start;
  final Future<void> Function(String title, String text) update;
  final Future<void> Function() stop;
  final Duration throttle;
  final DateTime Function() _now;

  bool _active = false;
  DateTime? _lastUpdate;
  Timer? _pendingUpdate;
  final List<ValueNotifier<DownloadProgress?>> _watched = [];

  void attach() {
    service.runningCount.addListener(_onState);
    service.paused.addListener(_onState);
    service.revision.addListener(_onRevision);
    _onState();
  }

  void detach() {
    service.runningCount.removeListener(_onState);
    service.paused.removeListener(_onState);
    service.revision.removeListener(_onRevision);
    _unwatch();
    _pendingUpdate?.cancel();
  }

  bool get isActive => _active;

  bool _starting = false;

  void _onState() {
    final shouldRun = !service.paused.value &&
        (service.runningCount.value > 0 || service.hasPendingWork);
    if (shouldRun && !_active && !_starting) {
      _starting = true;
      final (title, text) = _texts();
      unawaited(start(title, text).then((ok) {
        _starting = false;
        if (!ok) return;
        _active = true;
        _lastUpdate = _now();
        _rewatch();
      }, onError: (_) => _starting = false));
    } else if (!shouldRun && _active) {
      _active = false;
      _pendingUpdate?.cancel();
      _unwatch();
      unawaited(stop());
    } else if (_active) {
      _rewatch();
      _scheduleUpdate();
    }
  }

  /// The set of running entries may have changed (one finished, another
  /// started): re-subscribe and refresh the text.
  void _onRevision() {
    if (!_active) {
      _onState();
      return;
    }
    _rewatch();
    _scheduleUpdate();
  }

  void _rewatch() {
    _unwatch();
    if (!_active) return;
    for (final (server, entry) in service.runningEntries()) {
      final n = service.progressOf(server, entry.key);
      n.addListener(_scheduleUpdate);
      _watched.add(n);
    }
  }

  void _unwatch() {
    for (final n in _watched) {
      n.removeListener(_scheduleUpdate);
    }
    _watched.clear();
  }

  /// At most one notification update per [throttle].
  void _scheduleUpdate() {
    if (!_active) return;
    final since = _now().difference(_lastUpdate ?? _now());
    if (since >= throttle) {
      _pendingUpdate?.cancel();
      _pendingUpdate = null;
      _sendUpdate();
    } else if (_pendingUpdate == null) {
      _pendingUpdate = Timer(throttle - since, () {
        _pendingUpdate = null;
        if (_active) _sendUpdate();
      });
    }
  }

  void _sendUpdate() {
    _lastUpdate = _now();
    final (title, text) = _texts();
    unawaited(update(title, text));
  }

  (String, String) _texts() {
    final running = service.runningEntries();
    var fractions = 0.0;
    var known = 0;
    for (final (server, entry) in running) {
      final f = service.progressOf(server, entry.key).value?.fraction ??
          entry.progress;
      if (f != null) {
        fractions += f;
        known++;
      }
    }
    final percent = known == 0 ? 0 : (fractions / known * 100).round();
    final loc = IsterMediaService.loc;
    final text = running.isEmpty
        ? loc.downloadStatusQueued
        : running.length == 1
            ? '${running.single.$2.title} · $percent%'
            : loc.downloadNotificationText(running.length, percent);
    return (loc.downloadNotificationTitle, text);
  }
}
