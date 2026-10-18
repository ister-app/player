import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/Throughput.dart';
import 'package:player/utils/games/GameInstallProgress.dart';
import 'package:player/utils/games/GameInstallStore.dart';

void main() {
  test('bytes in flight count towards done, finished files move out of flight', () {
    final tracker = InstallProgressTracker(totalBytes: 1000, filesTotal: 2);
    tracker.fileProgress('a', 100);
    tracker.fileProgress('b', 50);
    expect(tracker.doneBytes, 150);
    expect(tracker.filesDone, 0);
    tracker.fileProgress('a', 400);
    expect(tracker.doneBytes, 450);
    tracker.fileDone('a', 400);
    expect(tracker.doneBytes, 450);
    expect(tracker.filesDone, 1);
    expect(tracker.currentFile, 'b');
    tracker.fileDone('b', 600);
    expect(tracker.doneBytes, 1000);
    expect(tracker.filesDone, 2);
    expect(tracker.snapshot(GameInstallStatus.downloading).fraction, 1.0);
  });

  test('a file found on disk counts as done without ever being in flight', () {
    final tracker = InstallProgressTracker(totalBytes: 10, filesTotal: 1);
    tracker.fileDone('rom.bin', 10);
    expect(tracker.doneBytes, 10);
    expect(tracker.filesDone, 1);
  });

  test('speed and time left come from the throughput window while downloading', () {
    final start = DateTime(2026, 1, 1);
    final tracker = InstallProgressTracker(
        totalBytes: 10000, filesTotal: 1, throughput: Throughput(minSpan: const Duration(seconds: 1)));
    tracker.fileProgress('f', 0);
    tracker.tick(start);
    tracker.fileProgress('f', 1000);
    tracker.tick(start.add(const Duration(seconds: 1)));
    tracker.fileProgress('f', 2000);
    tracker.tick(start.add(const Duration(seconds: 2)));

    final snapshot = tracker.snapshot(GameInstallStatus.downloading);
    expect(snapshot.bytesPerSecond, closeTo(1000, 1));
    expect(snapshot.remaining, const Duration(seconds: 10));
    expect(snapshot.fraction, closeTo(0.2, 0.001));

    // Not downloading: no estimate, however much the window holds.
    final paused = tracker.snapshot(GameInstallStatus.paused);
    expect(paused.bytesPerSecond, isNull);
    expect(paused.remaining, isNull);
    expect(paused.doneBytes, 2000);
  });

  test('fraction is null without a total and clamps above it', () {
    expect(InstallProgressTracker(totalBytes: 0, filesTotal: 0).snapshot(GameInstallStatus.queued).fraction, isNull);
    final tracker = InstallProgressTracker(totalBytes: 10, filesTotal: 1)..fileProgress('f', 20);
    expect(tracker.snapshot(GameInstallStatus.downloading).fraction, 1.0);
  });
}
