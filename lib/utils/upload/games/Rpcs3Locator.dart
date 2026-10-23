import 'dart:io';

import 'FileSystemView.dart';

/// Where RPCS3 keeps its games on this computer: the config directories
/// (native, Flatpak, Windows) that exist. Each holds `games.yml` — the disc
/// games the user added, serial → folder — and `dev_hdd0/game/<TITLE_ID>/`,
/// the installed HDD games (PSN titles) next to the disc games' update data.
class Rpcs3Locator {
  Rpcs3Locator({Map<String, String>? environment, FileSystemView? fs})
      : _env = environment ?? Platform.environment,
        _fs = fs ?? IoFileSystemView();

  final Map<String, String> _env;
  final FileSystemView _fs;

  String get _home => _env['HOME'] ?? _env['USERPROFILE'] ?? '';

  /// Candidate config directories, Flatpak first (it is the common install on Linux).
  List<String> candidates() {
    if (Platform.isWindows) {
      final appData = _env['APPDATA'];
      return [if (appData != null && appData.isNotEmpty) '$appData/rpcs3'];
    }
    return [
      '$_home/.var/app/net.rpcs3.RPCS3/config/rpcs3',
      '${_env['XDG_CONFIG_HOME'] ?? '$_home/.config'}/rpcs3',
    ];
  }

  /// The config directories that exist.
  Future<List<String>> configDirs() async => [for (final c in candidates()) if (await _fs.isDirectory(c)) c];

  /// `games.yml`: one `SERIAL: /path/` per line; folders only (a game the
  /// user removed may still be listed, the scanner checks the marker).
  static Map<String, String> parseGamesYml(String text) {
    final out = <String, String>{};
    for (final line in text.split('\n')) {
      final colon = line.indexOf(':');
      if (colon <= 0) continue;
      final serial = line.substring(0, colon).trim();
      var path = line.substring(colon + 1).trim();
      if (path.length >= 2 && (path.startsWith('"') && path.endsWith('"') || path.startsWith("'") && path.endsWith("'"))) {
        path = path.substring(1, path.length - 1);
      }
      if (serial.isEmpty || path.isEmpty || serial.startsWith('#')) continue;
      out[serial] = path.replaceAll(RegExp(r'[/\\]+$'), '');
    }
    return out;
  }
}
