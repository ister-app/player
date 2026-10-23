import 'package:player/graphql/gameById.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import '../upload/games/FileSystemView.dart';
import '../upload/games/Rpcs3Locator.dart';
import '../upload/games/SteamAppManifest.dart';
import 'steam/SteamLibraryLocator.dart';

enum LocalGameCopyKind {
  /// Installed in a Steam library (`steamapps/appmanifest_<appid>.acf`).
  steam,

  /// An HDD game under RPCS3's `dev_hdd0/game/<TITLE_ID>/` (a PSN title).
  rpcs3Hdd,

  /// A disc dump RPCS3 lists in its `games.yml`.
  rpcs3Disc,
}

/// A copy of a library game that already lives on this computer, outside
/// Ister's games folder — enough to register it as installed and launch it.
class LocalGameCopy {
  const LocalGameCopy({
    required this.kind,
    required this.path,
    this.entryPath,
    this.steamLibrary,
    this.steamInstallDir,
  });

  final LocalGameCopyKind kind;

  /// The game's folder (Steam: `steamapps/common/<installdir>`).
  final String path;

  /// PS3: the absolute path of `USRDIR/EBOOT.BIN`.
  final String? entryPath;

  /// Steam: the library root (the folder holding `steamapps/`) and the acf's `installdir`.
  final String? steamLibrary;
  final String? steamInstallDir;
}

/// Looks for a library game among the games Steam and RPCS3 already have
/// here, by the ids the server knows (`steamAppId`, `titleId`). ROMs carry
/// no id and are not matched.
class LocalGameCopyFinder {
  LocalGameCopyFinder({SteamLibraryLocator? steam, Rpcs3Locator? rpcs3, FileSystemView? fs})
      : steam = steam ?? SteamLibraryLocator(),
        rpcs3 = rpcs3 ?? Rpcs3Locator(fs: fs),
        fs = fs ?? IoFileSystemView();

  final SteamLibraryLocator steam;
  final Rpcs3Locator rpcs3;
  final FileSystemView fs;

  Future<LocalGameCopy?> find(Query$gameById$gameById game) async {
    switch (game.form) {
      case Enum$GameForm.STEAM:
        final appId = int.tryParse(game.steamAppId ?? '');
        return appId == null ? null : findSteam(appId);
      case Enum$GameForm.PS3_FOLDER:
        final titleId = game.titleId?.trim();
        return titleId == null || titleId.isEmpty ? null : findPs3(titleId);
      default:
        return null;
    }
  }

  /// A fully installed app in any Steam library whose install folder exists.
  Future<LocalGameCopy?> findSteam(int appId) async {
    for (final library in await steam.libraries()) {
      final steamApps = library.steamApps.replaceAll(r'\', '/');
      final acf = fs.join(steamApps, 'appmanifest_$appId.acf');
      if (!await fs.exists(acf)) continue;
      final SteamAppManifest? manifest;
      try {
        manifest = SteamAppManifest.parse(await fs.readString(acf));
      } catch (_) {
        continue;
      }
      if (manifest == null || manifest.appId != appId || !manifest.isFullyInstalled) continue;
      final installDir = fs.join(fs.join(steamApps, 'common'), manifest.installDir);
      if (!await fs.isDirectory(installDir)) continue;
      return LocalGameCopy(
        kind: LocalGameCopyKind.steam,
        path: installDir,
        steamLibrary: library.path,
        steamInstallDir: manifest.installDir,
      );
    }
    return null;
  }

  /// RPCS3's HDD game with that title id, else the disc dump its `games.yml`
  /// lists under that serial (`PS3_GAME/` directly in the folder or one
  /// wrapper deeper, as the emulator accepts both).
  Future<LocalGameCopy?> findPs3(String titleId) async {
    for (final config in await rpcs3.configDirs()) {
      final hdd = fs.join(fs.join(fs.join(config, 'dev_hdd0'), 'game'), titleId);
      final eboot = fs.join(fs.join(hdd, 'USRDIR'), 'EBOOT.BIN');
      if (await fs.exists(eboot)) return LocalGameCopy(kind: LocalGameCopyKind.rpcs3Hdd, path: hdd, entryPath: eboot);
      final yml = fs.join(config, 'games.yml');
      if (!await fs.exists(yml)) continue;
      final String? path;
      try {
        path = Rpcs3Locator.parseGamesYml(await fs.readString(yml))[titleId];
      } catch (_) {
        continue;
      }
      if (path == null || !await fs.isDirectory(path)) continue;
      final direct = fs.join(fs.join(fs.join(path, 'PS3_GAME'), 'USRDIR'), 'EBOOT.BIN');
      if (await fs.exists(direct)) return LocalGameCopy(kind: LocalGameCopyKind.rpcs3Disc, path: path, entryPath: direct);
      for (final entry in await fs.list(path)) {
        if (!entry.isDirectory) continue;
        final wrapped = fs.join(fs.join(fs.join(entry.path, 'PS3_GAME'), 'USRDIR'), 'EBOOT.BIN');
        if (await fs.exists(wrapped)) {
          return LocalGameCopy(kind: LocalGameCopyKind.rpcs3Disc, path: entry.path, entryPath: wrapped);
        }
      }
    }
    return null;
  }
}
