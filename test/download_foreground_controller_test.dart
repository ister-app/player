import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/download/DownloadForegroundController.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadService.dart';
import 'package:player/utils/download/DownloadStore.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import 'download_service_test.dart' show trackItem;

void main() {
  late Directory root;
  late DownloadService service;
  late List<String> log;
  late DateTime clock;
  late DownloadForegroundController controller;
  var startOk = true;

  setUp(() async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    root = await Directory.systemTemp.createTemp('fg');
    service = DownloadService(store: DownloadStore(rootOverride: root));
    await service.store.root();
    log = [];
    startOk = true;
    clock = DateTime(2026, 1, 1);
    controller = DownloadForegroundController(
      service: service,
      start: (t, x) async {
        log.add('start:$x');
        return startOk;
      },
      update: (t, x) async => log.add('update:$x'),
      stop: () async => log.add('stop'),
      now: () => clock,
    )..attach();
  });

  tearDown(() async {
    controller.detach();
    await root.delete(recursive: true);
  });

  Future<DownloadEntry> running(String id) async {
    final item = trackItem(id);
    final entry = DownloadEntry(
      kind: DownloadKind.track,
      mediaId: id,
      mediaFileId: 'mf-$id',
      nodeUrl: 'n',
      groupId: 'a',
      groupTitle: 'A',
      title: 'Track $id',
      queueItemJson: item.toJson(),
      createdAt: clock,
      status: DownloadStatus.downloading,
    );
    await service.store.put('srv', entry);
    service.debugSetRunning('srv', entry.key, true);
    return entry;
  }

  test('starts with the first download, updates throttled, stops with the last',
      () async {
    final e = await running('t1');
    await Future<void>.delayed(Duration.zero);
    expect(log, ['start:Track t1 · 0%']);

    final progress = service.progressOf('srv', e.key);
    progress.value = const DownloadProgress(bytes: 1, segmentsDone: 1, segmentsTotal: 4);
    expect(log, hasLength(1), reason: 'throttled: same second as start');

    clock = clock.add(const Duration(seconds: 2));
    progress.value = const DownloadProgress(bytes: 2, segmentsDone: 2, segmentsTotal: 4);
    expect(log.last, 'update:Track t1 · 50%');

    await service.store.put('srv', e.copyWith(status: DownloadStatus.complete));
    service.debugSetRunning('srv', e.key, false);
    expect(log.last, 'stop');
  });

  test('stays up between downloads while work is queued', () async {
    final e = await running('t1');
    await Future<void>.delayed(Duration.zero);
    // t2 waits in the queue while t1 finishes: no stop, no restart.
    final queued = (await running('t2')).copyWith(status: DownloadStatus.queued);
    service.debugSetRunning('srv', queued.key, false);
    await service.store.put('srv', queued);
    await service.store.put('srv', e.copyWith(status: DownloadStatus.complete));
    service.debugSetRunning('srv', e.key, false);
    expect(log.where((l) => l == 'stop'), isEmpty);
    expect(log.where((l) => l.startsWith('start:')), hasLength(1));
  });

  test('a refused start is retried on the next state change', () async {
    startOk = false;
    final e = await running('t1');
    await Future<void>.delayed(Duration.zero);
    expect(log, ['start:Track t1 · 0%']);
    expect(controller.isActive, isFalse);
    startOk = true;
    service.revision.value++;
    await Future<void>.delayed(Duration.zero);
    expect(log.where((l) => l.startsWith('start:')), hasLength(2));
    expect(controller.isActive, isTrue);
    await service.store.put('srv', e.copyWith(status: DownloadStatus.complete));
    service.debugSetRunning('srv', e.key, false);
  });

  test('pausing stops the service and resuming starts it again', () async {
    final e = await running('t1');
    await Future<void>.delayed(Duration.zero);
    await service.pauseAll();
    expect(log.last, 'stop');
    // Still "running" from the notifier's point of view until the cancel
    // lands; a resume with the same count restarts.
    await service.resumeAll();
    await Future<void>.delayed(Duration.zero);
    expect(log.last, startsWith('start:'));
    await service.store.put('srv', e.copyWith(status: DownloadStatus.complete));
    service.debugSetRunning('srv', e.key, false);
  });

  test('two downloads use the plural text', () async {
    await running('t1');
    await running('t2');
    await Future<void>.delayed(Duration.zero);
    clock = clock.add(const Duration(seconds: 2));
    service.revision.value++;
    expect(log.last, 'update:2 downloads · 0%');
  });
}
