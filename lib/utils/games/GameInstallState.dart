import 'GameInstallStore.dart';

/// What can happen to an install.
enum GameInstallEvent {
  /// The user asked for the game (first time, or again after a stop).
  install,

  /// The queue gave the install its turn.
  start,

  /// Every file is on disk; archives get unpacked.
  downloaded,

  /// Unpacking finished.
  completed,
  pause,
  resume,
  cancel,
  fail,
  retry,

  /// The server reported a newer version than the one installed.
  newerVersion,

  /// The user asked for the update.
  update,

  /// The app came back with the install still marked as running.
  restart,
}

/// The transitions of [GameInstallStatus], kept apart from the IO so the
/// table can be tested on its own. [next] returns null for a move that is
/// not allowed from the current status.
class GameInstallStateMachine {
  GameInstallStateMachine._();

  static GameInstallStatus? next(GameInstallStatus? from, GameInstallEvent event) {
    switch (event) {
      case GameInstallEvent.install:
        return switch (from) {
          null ||
          GameInstallStatus.paused ||
          GameInstallStatus.failed ||
          GameInstallStatus.cancelled =>
            GameInstallStatus.queued,
          _ => null,
        };
      case GameInstallEvent.start:
        return from == GameInstallStatus.queued ? GameInstallStatus.downloading : null;
      case GameInstallEvent.downloaded:
        return from == GameInstallStatus.downloading ? GameInstallStatus.extracting : null;
      case GameInstallEvent.completed:
        return from == GameInstallStatus.extracting ? GameInstallStatus.installed : null;
      case GameInstallEvent.pause:
        return switch (from) {
          GameInstallStatus.queued || GameInstallStatus.downloading => GameInstallStatus.paused,
          _ => null,
        };
      case GameInstallEvent.resume:
      case GameInstallEvent.retry:
        return switch (from) {
          GameInstallStatus.paused || GameInstallStatus.failed || GameInstallStatus.cancelled => GameInstallStatus.queued,
          _ => null,
        };
      case GameInstallEvent.cancel:
        return switch (from) {
          GameInstallStatus.queued || GameInstallStatus.downloading || GameInstallStatus.extracting => GameInstallStatus.cancelled,
          _ => null,
        };
      case GameInstallEvent.fail:
        return switch (from) {
          GameInstallStatus.queued || GameInstallStatus.downloading || GameInstallStatus.extracting => GameInstallStatus.failed,
          _ => null,
        };
      case GameInstallEvent.newerVersion:
        return from == GameInstallStatus.installed ? GameInstallStatus.updateAvailable : null;
      case GameInstallEvent.update:
        return from == GameInstallStatus.updateAvailable ? GameInstallStatus.queued : null;
      case GameInstallEvent.restart:
        return switch (from) {
          GameInstallStatus.queued || GameInstallStatus.downloading || GameInstallStatus.extracting => GameInstallStatus.queued,
          _ => null,
        };
    }
  }
}
