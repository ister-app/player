import 'dart:io';

import 'Vdf.dart';

/// A Steam library folder (`<path>/steamapps/...`).
class SteamLibrary {
  const SteamLibrary({required this.path, required this.label});
  final String path;
  final String label;
  String get steamApps => '$path${Platform.pathSeparator}steamapps';
  String get common => '$steamApps${Platform.pathSeparator}common';
}

/// The local Steam install: its root, its library folders and the account
/// that logged in last. Everything comes from Steam's own VDF files, so it
/// works without Steam running.
class SteamLibraryLocator {
  SteamLibraryLocator({Map<String, String>? environment}) : _env = environment ?? Platform.environment;

  final Map<String, String> _env;

  String get _home => _env['HOME'] ?? _env['USERPROFILE'] ?? '';

  /// Candidate Steam roots in preference order; the first that exists wins.
  List<String> rootCandidates() {
    if (Platform.isWindows) {
      return [
        '${_env['ProgramFiles(x86)'] ?? r'C:\Program Files (x86)'}\\Steam',
        '${_env['ProgramFiles'] ?? r'C:\Program Files'}\\Steam',
      ];
    }
    return [
      '$_home/.steam/steam',
      '$_home/.local/share/Steam',
      '$_home/.var/app/com.valvesoftware.Steam/.local/share/Steam',
      '$_home/.steam/root',
    ];
  }

  Future<Directory?> root() async {
    if (Platform.isWindows) {
      final fromRegistry = await _windowsRegistrySteamPath();
      if (fromRegistry != null && Directory(fromRegistry).existsSync()) return Directory(fromRegistry);
    }
    for (final candidate in rootCandidates()) {
      final dir = Directory(candidate);
      if (dir.existsSync() && Directory('${dir.path}${Platform.pathSeparator}steamapps').existsSync()) {
        return dir;
      }
    }
    return null;
  }

  /// Every library folder listed in `steamapps/libraryfolders.vdf`, the
  /// Steam root first.
  Future<List<SteamLibrary>> libraries() async {
    final steamRoot = await root();
    if (steamRoot == null) return const [];
    final libraries = <SteamLibrary>[SteamLibrary(path: steamRoot.path, label: steamRoot.path)];
    final vdf = File('${steamRoot.path}${Platform.pathSeparator}steamapps${Platform.pathSeparator}libraryfolders.vdf');
    if (await vdf.exists()) {
      try {
        final body = Vdf.body(Vdf.parse(await vdf.readAsString()));
        for (final entry in body.values) {
          if (entry is Map<String, Object>) {
            final path = Vdf.string(entry, 'path');
            if (path != null && path.isNotEmpty && !libraries.any((l) => _samePath(l.path, path))) {
              libraries.add(SteamLibrary(path: path, label: Vdf.string(entry, 'label') ?? path));
            }
          }
        }
      } catch (_) {
        // A malformed libraryfolders.vdf: the root library is still usable.
      }
    }
    return libraries;
  }

  /// The 32-bit account id (`userdata/<id>`) of the most recent login, from
  /// `config/loginusers.vdf`; what Ludusavi's `<storeUserId>` expands to.
  Future<int?> mostRecentAccountId() async {
    final steamRoot = await root();
    if (steamRoot == null) return null;
    final file = File('${steamRoot.path}${Platform.pathSeparator}config${Platform.pathSeparator}loginusers.vdf');
    if (!await file.exists()) return null;
    try {
      final users = Vdf.body(Vdf.parse(await file.readAsString()));
      int? best;
      int bestTimestamp = -1;
      for (final entry in users.entries) {
        final steamId64 = int.tryParse(entry.key);
        final data = entry.value;
        if (steamId64 == null || data is! Map<String, Object>) continue;
        final accountId = steamId64 - 76561197960265728;
        if (Vdf.string(data, 'MostRecent') == '1') return accountId;
        final timestamp = Vdf.integer(data, 'Timestamp') ?? 0;
        if (timestamp > bestTimestamp) {
          bestTimestamp = timestamp;
          best = accountId;
        }
      }
      return best;
    } catch (_) {
      return null;
    }
  }

  /// `steamapps/compatdata/<appid>/pfx/drive_c` of a Proton game on Linux, when it exists.
  Future<Directory?> protonDriveC(int appId) async {
    if (!Platform.isLinux) return null;
    for (final library in await libraries()) {
      final dir = Directory('${library.steamApps}/compatdata/$appId/pfx/drive_c');
      if (dir.existsSync()) return dir;
    }
    return null;
  }

  Future<String?> _windowsRegistrySteamPath() async {
    try {
      final result = await Process.run('reg', ['query', r'HKCU\Software\Valve\Steam', '/v', 'SteamPath']);
      if (result.exitCode != 0) return null;
      final match = RegExp(r'SteamPath\s+REG_SZ\s+(.+)$', multiLine: true).firstMatch(result.stdout.toString());
      return match?.group(1)?.trim().replaceAll('/', r'\');
    } catch (_) {
      return null;
    }
  }

  static bool _samePath(String a, String b) =>
      a.replaceAll(r'\', '/').toLowerCase().replaceAll(RegExp(r'/+$'), '') ==
      b.replaceAll(r'\', '/').toLowerCase().replaceAll(RegExp(r'/+$'), '');
}
