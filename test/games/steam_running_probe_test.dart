import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/games/launch/GameProcessRunner.dart';
import 'package:player/utils/games/steam/SteamRunningProbe.dart';

class _Runner extends GameProcessRunner {
  _Runner(this.exitCode) : super(isFlatpak: () => false);
  final int exitCode;
  final calls = <List<String>>[];

  @override
  Future<GameProcessResult> run(String command, List<String> arguments,
      {String? workingDirectory, Map<String, String>? environment, Duration? timeout}) async {
    calls.add([command, ...arguments]);
    return GameProcessResult(exitCode: exitCode, duration: Duration.zero, stderrTail: '');
  }
}

void main() {
  group('Linux', () {
    test('asks pgrep for the reaper of exactly this app id', () async {
      final runner = _Runner(0);
      expect(await SteamRunningProbe(runner: runner).isRunning(620), isTrue);
      expect(runner.calls.single, ['pgrep', '-f', r'SteamLaunch AppId=620( |$)']);
      final pattern = RegExp(runner.calls.single.last);
      expect(pattern.hasMatch('/home/u/.local/share/Steam/ubuntu12_32/reaper SteamLaunch AppId=620 -- /x/portal2.sh'), isTrue);
      expect(pattern.hasMatch('reaper SteamLaunch AppId=6200 -- x'), isFalse);
      expect(pattern.hasMatch(r'flatpak-spawn --host pgrep -f SteamLaunch AppId=620( |$)'), isFalse,
          reason: 'the sandboxed flatpak-spawn carrying the pattern is visible on the host');
    });

    test('exit 1 is not running, anything else is unknown', () async {
      expect(await SteamRunningProbe(runner: _Runner(1)).isRunning(620), isFalse);
      expect(await SteamRunningProbe(runner: _Runner(2)).isRunning(620), isNull);
    });
  }, skip: !Platform.isLinux);

  test('parses reg query output', () {
    const out = '\r\nHKEY_CURRENT_USER\\Software\\Valve\\Steam\\Apps\\620\r\n    Running    REG_DWORD    0x1\r\n\r\n';
    expect(SteamRunningProbe.runningFromRegOutput(out), isTrue);
    expect(SteamRunningProbe.runningFromRegOutput(out.replaceAll('0x1', '0x0')), isFalse);
    expect(SteamRunningProbe.runningFromRegOutput('garbage'), isNull);
  });
}
