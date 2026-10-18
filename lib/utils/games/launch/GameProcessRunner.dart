import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:player/utils/LoggerService.dart';

/// How a launched game or emulator ended.
class GameProcessResult {
  const GameProcessResult({required this.exitCode, required this.duration, required this.stderrTail});
  final int exitCode;
  final Duration duration;
  final String stderrTail;
}

/// Starts an emulator or a game and waits for it to exit. Inside the Flatpak
/// sandbox every command is rewritten to `flatpak-spawn --host`, so the
/// emulators installed on the host (natively or as Flatpaks) are reachable;
/// that needs `--talk-name=org.freedesktop.Flatpak` in the manifest.
class GameProcessRunner {
  GameProcessRunner({this.isFlatpak = _detectFlatpak});

  final bool Function() isFlatpak;

  static bool _detectFlatpak() => Platform.isLinux && Platform.environment.containsKey('FLATPAK_ID');

  /// Whether [command] can be started: on PATH, an absolute path that exists,
  /// or `flatpak:<app id>` when that Flatpak is installed.
  Future<bool> canRun(String command) async {
    if (command.startsWith('flatpak:')) {
      final result = await run('flatpak', ['info', command.substring('flatpak:'.length)],
          timeout: const Duration(seconds: 20));
      return result.exitCode == 0;
    }
    if (command.contains(Platform.pathSeparator) || command.contains('/')) {
      return File(command).existsSync();
    }
    final which = Platform.isWindows ? 'where' : 'which';
    final result = await run(which, [command], timeout: const Duration(seconds: 10));
    return result.exitCode == 0;
  }

  /// Runs to completion. A `flatpak:<id>` command becomes `flatpak run <id>`.
  Future<GameProcessResult> run(String command, List<String> arguments,
      {String? workingDirectory, Map<String, String>? environment, Duration? timeout}) async {
    var executable = command;
    var args = List<String>.from(arguments);
    if (command.startsWith('flatpak:')) {
      executable = 'flatpak';
      args = ['run', command.substring('flatpak:'.length), ...arguments];
    }
    if (isFlatpak()) {
      args = ['--host', if (workingDirectory != null) '--directory=$workingDirectory', executable, ...args];
      executable = 'flatpak-spawn';
      workingDirectory = null;
    }
    LoggerService().logger.i('Launching: $executable ${args.join(' ')}');
    final started = DateTime.now();
    final process = await Process.start(executable, args,
        workingDirectory: workingDirectory, environment: environment, runInShell: false);
    final stderrTail = <String>[];
    final stderrDone = process.stderr.transform(utf8.decoder).transform(const LineSplitter()).listen((line) {
      stderrTail.add(line);
      if (stderrTail.length > 40) stderrTail.removeAt(0);
    }).asFuture<void>();
    unawaited(process.stdout.drain<void>());
    int exitCode;
    if (timeout != null) {
      exitCode = await process.exitCode.timeout(timeout, onTimeout: () {
        process.kill();
        return -1;
      });
    } else {
      exitCode = await process.exitCode;
    }
    try {
      await stderrDone.timeout(const Duration(seconds: 2));
    } catch (_) {}
    return GameProcessResult(
      exitCode: exitCode,
      duration: DateTime.now().difference(started),
      stderrTail: stderrTail.join('\n'),
    );
  }

  /// Fire-and-forget for launchers that hand off to another process (Steam).
  Future<void> detach(String command, List<String> arguments) async {
    var executable = command;
    var args = List<String>.from(arguments);
    if (isFlatpak()) {
      args = ['--host', executable, ...args];
      executable = 'flatpak-spawn';
    }
    LoggerService().logger.i('Detaching: $executable ${args.join(' ')}');
    await Process.start(executable, args, mode: ProcessStartMode.detached);
  }
}
