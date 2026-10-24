import 'dart:io';

import 'package:player/utils/games/GameInstallStore.dart';
import 'package:player/utils/games/GameSettings.dart';
import 'package:player/utils/games/saves/SavePathResolver.dart';
import 'package:player/utils/games/steam/SteamLibraryLocator.dart';
import 'package:player/utils/games/steam/Vdf.dart';

import 'package:player/utils/upload/games/ParamSfo.dart';

import 'EmulatorRegistry.dart';
import 'Rpcs3SaveFolders.dart';

/// Why a game cannot be launched right now; the panel turns it into a message.
enum LaunchProblem { emulatorMissing, coreMissing, entryMissing, steamMissing, firmwareMissing }

class LaunchException implements Exception {
  LaunchException(this.problem, [this.detail]);
  final LaunchProblem problem;
  final String? detail;
  @override
  String toString() => 'LaunchException($problem${detail == null ? '' : ': $detail'})';
}

/// A prepared launch: the command plus where the game's saves live while it
/// runs, resolved before the process starts so the sync can pull into them.
class LaunchPlan {
  const LaunchPlan({
    required this.command,
    required this.arguments,
    required this.saveSlots,
    this.workingDirectory,
    this.environment,
    this.detached = false,
  });

  final String command;
  final List<String> arguments;
  final List<SaveSlot> saveSlots;
  final String? workingDirectory;
  final Map<String, String>? environment;

  /// The launcher hands off (Steam) and the session cannot be awaited.
  final bool detached;
}

/// Builds launch plans per game form. Save slot templates for PC/Steam games
/// come from the server (Ludusavi or the admin); the emulators' save folders
/// are known locations.
class GameLaunchers {
  GameLaunchers({EmulatorRegistry? registry, SteamLibraryLocator? steam})
      : registry = registry ?? EmulatorRegistry(),
        steam = steam ?? SteamLibraryLocator();

  final EmulatorRegistry registry;
  final SteamLibraryLocator steam;

  Future<LaunchPlan> plan(GameInstall install,
      {required String? retroArchCore, required List<({String path, String? os})> savePathTemplates}) async {
    switch (install.form) {
      case 'ROM':
        return _retroArch(install, retroArchCore);
      case 'PS3_FOLDER':
        return _rpcs3(install);
      case 'STEAM':
        return _steam(install, savePathTemplates);
      default:
        return _native(install, savePathTemplates);
    }
  }

  // ---- RetroArch ---------------------------------------------------------

  Future<LaunchPlan> _retroArch(GameInstall install, String? core) async {
    final retroArch = await registry.find(EmulatorKind.retroarch);
    if (retroArch == null) throw LaunchException(LaunchProblem.emulatorMissing, 'RetroArch');
    final coreName = (await GameSettings.coreOverride(install.platform)) ?? core;
    if (coreName == null || coreName.isEmpty) throw LaunchException(LaunchProblem.coreMissing, '?');
    final coreFile = registry.coreFile(retroArch, coreName);
    if (coreFile == null) throw LaunchException(LaunchProblem.coreMissing, coreName);
    final rom = await _entryFile(install);
    final saves = install.savesDir;
    final states = Directory('${saves.path}${Platform.pathSeparator}states');
    await states.create(recursive: true);
    // An append-config keeps RetroArch's own retroarch.cfg untouched and points
    // just this session's saves/states at the game's folder.
    final cfg = File('${install.tmpDir.path}${Platform.pathSeparator}retroarch-append.cfg');
    await cfg.parent.create(recursive: true);
    await cfg.writeAsString([
      'savefile_directory = "${saves.path}"',
      'savestate_directory = "${states.path}"',
      'sort_savefiles_enable = "false"',
      'sort_savestates_enable = "false"',
      'sort_savefiles_by_content_enable = "false"',
      'sort_savestates_by_content_enable = "false"',
      '',
    ].join('\n'));
    return LaunchPlan(
      command: retroArch.command,
      arguments: ['-L', coreFile.path, rom.path, '--appendconfig', cfg.path],
      saveSlots: [SaveSlot(index: 0, path: saves.path, template: 'retroarch')],
    );
  }

  // ---- RPCS3 -------------------------------------------------------------

  Future<LaunchPlan> _rpcs3(GameInstall install) async {
    final rpcs3 = await registry.find(EmulatorKind.rpcs3);
    if (rpcs3 == null) throw LaunchException(LaunchProblem.emulatorMissing, 'RPCS3');
    final eboot = await _entryFile(install);
    final config = rpcs3.configDir;
    if (config != null && !Directory('$config${Platform.pathSeparator}dev_flash${Platform.pathSeparator}vsh').existsSync()) {
      throw LaunchException(LaunchProblem.firmwareMissing, config);
    }
    final slots = <SaveSlot>[];
    if (config != null && install.titleId != null) {
      final savedata = Directory('$config${Platform.pathSeparator}dev_hdd0${Platform.pathSeparator}home${Platform.pathSeparator}00000001${Platform.pathSeparator}savedata');
      await savedata.create(recursive: true);
      // A PS3 game owns every savedata folder starting with its title id
      // (BLUS30443-AUTOSAVE, BLUS30443-SLOT01, ...); one slot per folder,
      // plus the bare prefix for folders created during this session.
      // A folder whose own PARAM.SFO names the game is its too: a PSN
      // re-release saves under the disc version's name (Rpcs3SaveFolders).
      var index = 0;
      slots.add(SaveSlot(index: index++, path: '${savedata.path}${Platform.pathSeparator}${install.titleId}', template: 'rpcs3:${install.titleId}'));
      final names = <String>[];
      await for (final entity in savedata.list()) {
        if (entity is Directory) names.add(entity.uri.pathSegments.where((s) => s.isNotEmpty).last);
      }
      final owned = await Rpcs3SaveFolders.select(
        folderNames: names,
        titleId: install.titleId!,
        title: install.title,
        sfoTitleOf: (name) => _sfoTitle(File('${savedata.path}${Platform.pathSeparator}$name${Platform.pathSeparator}PARAM.SFO')),
      );
      for (final name in owned) {
        slots.add(SaveSlot(index: index++, path: '${savedata.path}${Platform.pathSeparator}$name', template: 'rpcs3:$name'));
      }
    }
    return LaunchPlan(
      command: rpcs3.command,
      arguments: ['--no-gui', eboot.path],
      saveSlots: slots,
    );
  }

  static Future<String?> _sfoTitle(File sfo) async {
    try {
      if (!await sfo.exists()) return null;
      return ParamSfo.parse(await sfo.readAsBytes()).title;
    } catch (_) {
      return null;
    }
  }

  // ---- native PC ---------------------------------------------------------

  Future<LaunchPlan> _native(GameInstall install, List<({String path, String? os})> templates) async {
    final files = install.filesDir;
    String command;
    List<String> arguments = const [];
    String? workingDirectory;
    if (install.form == 'PC_LINUX_INSTALLER') {
      final game = Directory('${files.path}/game');
      final start = await _firstExisting([File('${game.path}/start.sh'), File('${game.path}/game/start.sh')]);
      if (!install.linuxInstalled || start == null) {
        final installer = await _entryFile(install);
        await Process.run('chmod', ['+x', installer.path]);
        // MojoSetup (GOG) flags: silent install into the game's own folder.
        command = installer.path;
        arguments = ['--', '--i-agree-to-all-licenses', '--noreadme', '--nooptions', '--noprompt', '--destination', game.path];
        workingDirectory = files.path;
      } else {
        command = start.path;
        workingDirectory = start.parent.path;
      }
    } else {
      final entry = await _findEntry(install);
      if (entry == null) throw LaunchException(LaunchProblem.entryMissing, files.path);
      if (!Platform.isWindows) await Process.run('chmod', ['+x', entry.path]);
      command = entry.path;
      workingDirectory = entry.parent.path;
    }
    final resolver = SavePathResolver(base: files.path, steamRoot: (await steam.root())?.path);
    return LaunchPlan(
      command: command,
      arguments: arguments,
      workingDirectory: workingDirectory,
      saveSlots: await resolver.resolve(templates),
    );
  }

  /// The launchable file of an extracted PC game: the server's entry path if
  /// it names one, else the single exe / start script at the top levels.
  Future<File?> _findEntry(GameInstall install) async {
    final files = install.filesDir;
    if (install.entryPath != null) {
      final named = File('${files.path}/${install.entryPath}');
      if (await named.exists()) return named;
    }
    final preferred = Platform.isWindows
        ? const ['.exe']
        : const ['start.sh', '.sh', '.x86_64', '.x86', '.AppImage'];
    Future<File?> search(Directory dir, int depth) async {
      if (!await dir.exists()) return null;
      final candidates = <File>[];
      final subdirs = <Directory>[];
      await for (final entity in dir.list(followLinks: false)) {
        if (entity is File) {
          final name = entity.uri.pathSegments.last.toLowerCase();
          if (name.startsWith('unins') || name.contains('crash') || name.contains('redist') || name.contains('vcredist') || name.contains('dxsetup')) continue;
          if (preferred.any((p) => p.startsWith('.') ? name.endsWith(p) : name == p)) candidates.add(entity);
        } else if (entity is Directory && depth > 0) {
          subdirs.add(entity);
        }
      }
      if (candidates.isNotEmpty) {
        candidates.sort((a, b) => a.path.length.compareTo(b.path.length));
        return candidates.first;
      }
      for (final sub in subdirs) {
        final found = await search(sub, depth - 1);
        if (found != null) return found;
      }
      return null;
    }
    return search(files, 2);
  }

  // ---- Steam -------------------------------------------------------------

  Future<LaunchPlan> _steam(GameInstall install, List<({String path, String? os})> templates) async {
    final appId = install.steamAppId;
    if (appId == null) throw LaunchException(LaunchProblem.entryMissing, 'appid');
    final steamCommand = await registry.find(EmulatorKind.steam);
    if (steamCommand == null) throw LaunchException(LaunchProblem.steamMissing);
    final library = install.steamLibrary;
    final base = library == null || install.steamInstallDir == null
        ? install.filesDir.path
        : '$library${Platform.pathSeparator}steamapps${Platform.pathSeparator}common${Platform.pathSeparator}${install.steamInstallDir}';
    final drive = await steam.protonDriveC(appId);
    final resolver = SavePathResolver(
      base: base,
      steamRoot: (await steam.root())?.path,
      protonDriveC: drive?.path,
      storeUserId: await steam.mostRecentAccountId(),
    );
    return LaunchPlan(
      command: steamCommand.command,
      arguments: ['steam://rungameid/$appId'],
      saveSlots: await resolver.resolve(templates),
      detached: true,
    );
  }

  /// Writes `appmanifest_<appid>.acf` so Steam lists the restored game as
  /// installed; Steam validates and updates it on first start. [acfSource] is
  /// the manifest the server kept, used for its name/buildid when present.
  static Future<void> writeSteamManifest(SteamLibrary library, GameInstall install, {File? acfSource}) async {
    Map<String, Object> state = {};
    if (acfSource != null && await acfSource.exists()) {
      try {
        state = Map<String, Object>.from(Vdf.body(Vdf.parse(await acfSource.readAsString())));
      } catch (_) {
        state = {};
      }
    }
    state['appid'] = '${install.steamAppId}';
    state['Universe'] = '1';
    state.putIfAbsent('name', () => install.steamInstallDir ?? '${install.steamAppId}');
    state['StateFlags'] = '4';
    state['installdir'] = install.steamInstallDir ?? '';
    state['SizeOnDisk'] = '${install.totalBytes}';
    final file = File('${library.steamApps}${Platform.pathSeparator}appmanifest_${install.steamAppId}.acf');
    await file.parent.create(recursive: true);
    await file.writeAsString(Vdf.write('AppState', state), flush: true);
  }

  // ---- helpers -----------------------------------------------------------

  Future<File> _entryFile(GameInstall install) async {
    final files = install.filesDir;
    final entryPath = install.entryPath;
    if (entryPath != null) {
      // An adopted copy names its entry by absolute path (RPCS3's own folder).
      final absolute = _isAbsolute(entryPath);
      final file = File(absolute ? entryPath : '${files.path}/$entryPath');
      if (await file.exists()) return file;
      if (absolute) throw LaunchException(LaunchProblem.entryMissing, entryPath);
    }
    // Single-file forms: the first (or only) file the manifest marked as entry
    // is stored under its plain name.
    if (await files.exists()) {
      final candidates = <File>[];
      await for (final entity in files.list(followLinks: false)) {
        if (entity is File && !entity.path.endsWith('.part')) candidates.add(entity);
      }
      final entry = candidates.where((f) => _isEntryName(install.platform, f.path)).firstOrNull ?? candidates.firstOrNull;
      if (entry != null) return entry;
    }
    throw LaunchException(LaunchProblem.entryMissing, files.path);
  }

  /// `/…`, `C:\…` or a UNC path.
  static bool _isAbsolute(String path) =>
      path.startsWith('/') || path.startsWith(r'\\') || RegExp(r'^[A-Za-z]:[\\/]').hasMatch(path);

  static bool _isEntryName(String platform, String path) {
    final lower = path.toLowerCase();
    return switch (platform) {
      'PSX' => lower.endsWith('.cue') || lower.endsWith('.chd') || lower.endsWith('.pbp'),
      _ => !lower.endsWith('.bin') && !lower.endsWith('.sub') && !lower.endsWith('.img') && !lower.endsWith('.ccd'),
    };
  }

  static Future<File?> _firstExisting(List<File> files) async {
    for (final file in files) {
      if (await file.exists()) return file;
    }
    return null;
  }
}
