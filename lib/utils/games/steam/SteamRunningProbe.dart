import 'dart:io';

import '../launch/GameProcessRunner.dart';

/// Whether Steam is running a game right now — a `steam://rungameid` launch
/// hands off to the Steam client, so there is no process of ours to await.
///
/// - Linux: Steam starts every game under `reaper SteamLaunch AppId=<id> -- …`;
///   `pgrep` looks for it (through [GameProcessRunner], so inside the Flatpak
///   it runs on the host, where the game's processes are).
/// - Windows: Steam keeps `HKCU\Software\Valve\Steam\Apps\<id>\Running`.
///
/// Null means "cannot tell" (other platform, tool missing, unexpected
/// output); callers then leave it to the user.
class SteamRunningProbe {
  SteamRunningProbe({GameProcessRunner? runner}) : _runner = runner ?? GameProcessRunner();

  final GameProcessRunner _runner;

  Future<bool?> isRunning(int appId) async {
    try {
      if (Platform.isLinux) return await _linux(appId);
      if (Platform.isWindows) return await _windows(appId);
    } catch (_) {
      // Tool missing or not startable.
    }
    return null;
  }

  Future<bool?> _linux(int appId) async {
    // The `( |$)` keeps AppId=12 from matching AppId=123 — and keeps this
    // pattern from matching the flatpak-spawn process that carries it.
    final result = await _runner.run('pgrep', ['-f', 'SteamLaunch AppId=$appId( |\$)'],
        timeout: const Duration(seconds: 10));
    return switch (result.exitCode) { 0 => true, 1 => false, _ => null };
  }

  Future<bool?> _windows(int appId) async {
    final result = await _runner.run('reg', ['query', 'HKCU\\Software\\Valve\\Steam\\Apps\\$appId', '/v', 'Running'],
        timeout: const Duration(seconds: 10));
    // A game Steam never ran has no key at all: not running.
    if (result.exitCode != 0) return false;
    return runningFromRegOutput(result.stdout);
  }

  /// Parses `reg query … /v Running`: `Running    REG_DWORD    0x1`.
  static bool? runningFromRegOutput(String output) {
    final match = RegExp(r'Running\s+REG_DWORD\s+0x([0-9a-fA-F]+)').firstMatch(output);
    if (match == null) return null;
    return int.parse(match.group(1)!, radix: 16) != 0;
  }
}
