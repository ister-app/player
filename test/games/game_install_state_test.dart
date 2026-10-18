import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/games/GameInstallState.dart';
import 'package:player/utils/games/GameInstallStore.dart';

void main() {
  GameInstallStatus? next(GameInstallStatus? from, GameInstallEvent event) => GameInstallStateMachine.next(from, event);

  test('the happy path runs queued → downloading → extracting → installed', () {
    final queued = next(null, GameInstallEvent.install);
    expect(queued, GameInstallStatus.queued);
    final downloading = next(queued, GameInstallEvent.start);
    expect(downloading, GameInstallStatus.downloading);
    final extracting = next(downloading, GameInstallEvent.downloaded);
    expect(extracting, GameInstallStatus.extracting);
    expect(next(extracting, GameInstallEvent.completed), GameInstallStatus.installed);
  });

  test('pause and resume only apply before the download finished', () {
    expect(next(GameInstallStatus.queued, GameInstallEvent.pause), GameInstallStatus.paused);
    expect(next(GameInstallStatus.downloading, GameInstallEvent.pause), GameInstallStatus.paused);
    expect(next(GameInstallStatus.extracting, GameInstallEvent.pause), isNull);
    expect(next(GameInstallStatus.installed, GameInstallEvent.pause), isNull);
    expect(next(GameInstallStatus.paused, GameInstallEvent.resume), GameInstallStatus.queued);
    expect(next(GameInstallStatus.downloading, GameInstallEvent.resume), isNull);
  });

  test('cancel, fail and retry', () {
    for (final from in [GameInstallStatus.queued, GameInstallStatus.downloading, GameInstallStatus.extracting]) {
      expect(next(from, GameInstallEvent.cancel), GameInstallStatus.cancelled, reason: '$from');
      expect(next(from, GameInstallEvent.fail), GameInstallStatus.failed, reason: '$from');
    }
    expect(next(GameInstallStatus.installed, GameInstallEvent.cancel), isNull);
    expect(next(GameInstallStatus.failed, GameInstallEvent.retry), GameInstallStatus.queued);
    expect(next(GameInstallStatus.cancelled, GameInstallEvent.install), GameInstallStatus.queued);
    expect(next(GameInstallStatus.installed, GameInstallEvent.install), isNull);
  });

  test('updates: installed → updateAvailable → queued', () {
    expect(next(GameInstallStatus.installed, GameInstallEvent.newerVersion), GameInstallStatus.updateAvailable);
    expect(next(GameInstallStatus.updateAvailable, GameInstallEvent.update), GameInstallStatus.queued);
    expect(next(GameInstallStatus.paused, GameInstallEvent.newerVersion), isNull);
    expect(next(GameInstallStatus.installed, GameInstallEvent.update), isNull);
  });

  test('a restart re-queues what was running and leaves the rest alone', () {
    for (final from in [GameInstallStatus.queued, GameInstallStatus.downloading, GameInstallStatus.extracting]) {
      expect(next(from, GameInstallEvent.restart), GameInstallStatus.queued, reason: '$from');
    }
    for (final from in [
      GameInstallStatus.paused,
      GameInstallStatus.failed,
      GameInstallStatus.cancelled,
      GameInstallStatus.installed,
      GameInstallStatus.updateAvailable
    ]) {
      expect(next(from, GameInstallEvent.restart), isNull, reason: '$from');
    }
  });
}
