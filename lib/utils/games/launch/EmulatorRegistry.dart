import 'dart:io';

import 'package:player/utils/games/GameSettings.dart';

import 'GameProcessRunner.dart';

/// A launcher the player can start games with.
enum EmulatorKind { retroarch, rpcs3, steam }

/// Where an emulator was found: a command for [GameProcessRunner.run] plus
/// the directory its libretro cores live in (RetroArch) and the config root
/// RPCS3 keeps its virtual hard disk under.
class EmulatorLocation {
  const EmulatorLocation({
    required this.kind,
    required this.command,
    this.coresDir,
    this.configDir,
    this.flatpakId,
    this.overridden = false,
  });

  final EmulatorKind kind;
  final String command;
  final String? coresDir;
  final String? configDir;
  final String? flatpakId;

  /// Picked by hand in the settings rather than detected.
  final bool overridden;

  bool get isFlatpak => flatpakId != null;
}

/// Finds the emulators installed on this machine. Order per kind: the
/// user's override, then the PATH, then the Flatpak, then the usual install
/// locations on Windows. Results are cached per app run; the settings page
/// re-detects explicitly.
class EmulatorRegistry {
  EmulatorRegistry({GameProcessRunner? runner, Map<String, String>? environment})
      : _runner = runner ?? GameProcessRunner(),
        _env = environment ?? Platform.environment;

  final GameProcessRunner _runner;
  final Map<String, String> _env;
  final Map<EmulatorKind, EmulatorLocation?> _cache = {};

  static const retroArchFlatpak = 'org.libretro.RetroArch';
  static const rpcs3Flatpak = 'net.rpcs3.RPCS3';
  static const steamFlatpak = 'com.valvesoftware.Steam';

  String get _home => _env['HOME'] ?? _env['USERPROFILE'] ?? '';

  Future<EmulatorLocation?> find(EmulatorKind kind, {bool refresh = false}) async {
    if (!refresh && _cache.containsKey(kind)) return _cache[kind];
    final location = await _detect(kind);
    _cache[kind] = location;
    return location;
  }

  void invalidate() => _cache.clear();

  Future<EmulatorLocation?> _detect(EmulatorKind kind) async {
    final override = await GameSettings.emulatorPath(kind.name);
    if (override != null && override.isNotEmpty) {
      if (await _runner.canRun(override)) {
        return _describe(kind, override, overridden: true);
      }
    }
    for (final candidate in _candidates(kind)) {
      if (await _runner.canRun(candidate)) {
        return _describe(kind, candidate);
      }
    }
    return null;
  }

  List<String> _candidates(EmulatorKind kind) {
    switch (kind) {
      case EmulatorKind.retroarch:
        return [
          if (Platform.isWindows) ...[
            '${_env['ProgramFiles'] ?? r'C:\Program Files'}\\RetroArch-Win64\\retroarch.exe',
            '${_env['LOCALAPPDATA'] ?? ''}\\RetroArch\\retroarch.exe',
            'C:\\RetroArch-Win64\\retroarch.exe',
          ] else ...[
            'retroarch',
            'flatpak:$retroArchFlatpak',
          ],
        ];
      case EmulatorKind.rpcs3:
        return [
          if (Platform.isWindows) ...[
            '${_env['ProgramFiles'] ?? r'C:\Program Files'}\\RPCS3\\rpcs3.exe',
            'C:\\RPCS3\\rpcs3.exe',
          ] else ...[
            'rpcs3',
            'flatpak:$rpcs3Flatpak',
            '$_home/Applications/rpcs3.AppImage',
          ],
        ];
      case EmulatorKind.steam:
        return [
          if (Platform.isWindows) ...[
            '${_env['ProgramFiles(x86)'] ?? r'C:\Program Files (x86)'}\\Steam\\steam.exe',
          ] else ...[
            'steam',
            'flatpak:$steamFlatpak',
          ],
        ];
    }
  }

  EmulatorLocation _describe(EmulatorKind kind, String command, {bool overridden = false}) {
    final flatpakId = command.startsWith('flatpak:') ? command.substring('flatpak:'.length) : null;
    switch (kind) {
      case EmulatorKind.retroarch:
        return EmulatorLocation(
          kind: kind,
          command: command,
          flatpakId: flatpakId,
          overridden: overridden,
          coresDir: _retroArchCoresDir(command, flatpakId),
          configDir: _retroArchConfigDir(flatpakId),
        );
      case EmulatorKind.rpcs3:
        return EmulatorLocation(
          kind: kind,
          command: command,
          flatpakId: flatpakId,
          overridden: overridden,
          configDir: _rpcs3ConfigDir(command, flatpakId),
        );
      case EmulatorKind.steam:
        return EmulatorLocation(kind: kind, command: command, flatpakId: flatpakId, overridden: overridden);
    }
  }

  String? _retroArchCoresDir(String command, String? flatpakId) {
    if (flatpakId != null) return '$_home/.var/app/$flatpakId/config/retroarch/cores';
    if (Platform.isWindows) {
      final dir = File(command).parent.path;
      return '$dir\\cores';
    }
    final candidates = [
      '${_env['XDG_CONFIG_HOME'] ?? '$_home/.config'}/retroarch/cores',
      '/usr/lib/libretro',
      '/usr/lib64/libretro',
      '/usr/lib/x86_64-linux-gnu/libretro',
    ];
    for (final c in candidates) {
      if (Directory(c).existsSync()) return c;
    }
    return candidates.first;
  }

  String? _retroArchConfigDir(String? flatpakId) {
    if (flatpakId != null) return '$_home/.var/app/$flatpakId/config/retroarch';
    if (Platform.isWindows) return null;
    return '${_env['XDG_CONFIG_HOME'] ?? '$_home/.config'}/retroarch';
  }

  /// RPCS3's data root: `dev_hdd0/home/00000001/savedata` and `trophy` live under it.
  String? _rpcs3ConfigDir(String command, String? flatpakId) {
    if (flatpakId != null) return '$_home/.var/app/$flatpakId/config/rpcs3';
    if (Platform.isWindows) {
      final portable = File(command).parent.path;
      if (Directory('$portable\\dev_hdd0').existsSync()) return portable;
      return '${_env['APPDATA'] ?? ''}\\rpcs3';
    }
    return '${_env['XDG_CONFIG_HOME'] ?? '$_home/.config'}/rpcs3';
  }

  /// The libretro core file for a core name, if RetroArch has it installed.
  File? coreFile(EmulatorLocation retroArch, String core) {
    final dir = retroArch.coresDir;
    if (dir == null) return null;
    final ext = Platform.isWindows ? 'dll' : 'so';
    final file = File('$dir${Platform.pathSeparator}${core}_libretro.$ext');
    return file.existsSync() ? file : null;
  }
}
