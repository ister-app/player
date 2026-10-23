import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/upload/GameUploadTarget.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/games/steam/SteamLibraryLocator.dart';
import 'package:player/utils/upload/games/FileSystemView.dart';
import 'package:player/utils/upload/games/GamePlatformTable.dart';
import 'package:player/utils/upload/games/GameSourceScanner.dart';
import 'package:player/utils/upload/games/GameUploadCandidate.dart';

import 'param_sfo_test.dart' show buildSfo;

const platforms = [
  GamePlatformOption(platform: Enum$GamePlatform.SNES, folder: 'snes', folderNames: ['snes', 'sfc'], entryExtensions: ['sfc', 'smc']),
  GamePlatformOption(
      platform: Enum$GamePlatform.PSX, folder: 'psx', folderNames: ['psx', 'ps1'], entryExtensions: ['cue', 'chd', 'pbp'], companionExtensions: ['bin', 'sub', 'img', 'ccd']),
  GamePlatformOption(platform: Enum$GamePlatform.LINUX, folder: 'linux', entryExtensions: ['sh', 'tar', 'tgz', 'tar.gz', 'tar.xz']),
  GamePlatformOption(platform: Enum$GamePlatform.PS3, folder: 'ps3', entryExtensions: []),
  GamePlatformOption(platform: Enum$GamePlatform.STEAM, folder: 'steam', entryExtensions: []),
];

List<int> acf(int appid, String name, String dir, {int flags = 4}) => utf8.encode('''
"AppState" { "appid" "$appid" "name" "$name" "StateFlags" "$flags" "installdir" "$dir" "SizeOnDisk" "1000" }
''');

void main() {
  final table = GamePlatformTable(platforms);
  final sfo = buildSfo({'TITLE': "Demon's Souls", 'TITLE_ID': 'BLUS30443'});
  const bytes = [1, 2, 3];

  GameSourceScanner scanner(MemoryFileSystemView fs, {Set<String> excluded = const {}, Set<int> excludedApps = const {}}) =>
      GameSourceScanner(table: table, fs: fs, excludedPaths: excluded, excludedSteamAppIds: excludedApps);

  test('ROM folders and loose ROMs under a platform folder, aliases included, subfolders ignored', () async {
    final fs = MemoryFileSystemView({
      '/g/SFC/Chrono Trigger (1995)/ct.sfc': bytes,
      '/g/SFC/Chrono Trigger (1995)/extras/map.png': bytes,
      '/g/SFC/Chrono Trigger (1995)/cover.jpg': bytes,
      '/g/SFC/Super Mario World (USA) (Rev 1).sfc': bytes,
      '/g/SFC/notes.txt': bytes,
      '/g/SFC/.hidden/x.sfc': bytes,
      '/g/SFC/Empty folder/readme.txt': bytes,
    });
    final found = await scanner(fs).scan(['/g'], const []);
    expect(found.map((c) => '${c.platformFolder}/${c.rootName}'), ['snes/Chrono Trigger (1995)', 'snes/Super Mario World']);
    final chrono = found[0];
    expect(chrono.kind, GameCandidateKind.romFolder);
    expect(chrono.files!.map((f) => f.relativePath), ['cover.jpg', 'ct.sfc'], reason: 'only files directly in the folder');
    expect(chrono.sizeBytes, 6);
    final mario = found[1];
    expect(mario.kind, GameCandidateKind.romFile);
    expect(mario.year, isNull);
    expect(mario.files!.single.relativePath, 'Super Mario World (USA) (Rev 1).sfc');
  });

  test('a source root that is itself a platform folder', () async {
    final fs = MemoryFileSystemView({'/roms/snes/Game.sfc': bytes});
    final found = await scanner(fs).scan(['/roms/snes'], const []);
    expect(found.single.title, 'Game');
  });

  test('a cue takes its bin tracks and same-stem companions along, once', () async {
    final fs = MemoryFileSystemView({
      '/g/psx/Game (USA).cue': utf8.encode('FILE "Game (USA) (Track 1).bin" BINARY\nFILE "Game (USA) (Track 2).bin" BINARY\n'),
      '/g/psx/Game (USA) (Track 1).bin': bytes,
      '/g/psx/Game (USA) (Track 2).bin': bytes,
      '/g/psx/Game (USA).sub': bytes,
      '/g/psx/Other.chd': bytes,
      '/g/psx/game.tar.gz': bytes,
    });
    final found = await scanner(fs).scan(['/g'], const []);
    expect(found.map((c) => c.title), ['Game', 'Other']);
    expect(found[0].files!.map((f) => f.relativePath).toList()..sort(),
        ['Game (USA) (Track 1).bin', 'Game (USA) (Track 2).bin', 'Game (USA).cue', 'Game (USA).sub']);
    expect(found[1].files!.single.relativePath, 'Other.chd');
  });

  test('multi-part extensions for Linux archives', () async {
    final fs = MemoryFileSystemView({'/g/linux/factorio.tar.gz': bytes, '/g/linux/gog_game_2.0.sh': bytes});
    final found = await scanner(fs).scan(['/g'], const []);
    expect(found.map((c) => c.title), ['factorio', 'gog_game_2.0']);
  });

  test('PS3 dumps anywhere within the depth, with wrapper, title from the SFO', () async {
    final fs = MemoryFileSystemView({
      '/g/dumps/Demons Souls (2009)/PS3_GAME/PARAM.SFO': sfo,
      '/g/dumps/Demons Souls (2009)/PS3_GAME/USRDIR/EBOOT.BIN': bytes,
      '/g/dumps/wrapped/BLUS30443/PS3_GAME/PARAM.SFO': sfo,
      '/g/ps3/Laid out (2010)/PS3_GAME/PARAM.SFO': [0, 1, 2],
      '/g/a/b/c/d/Too deep/PS3_GAME/PARAM.SFO': sfo,
      '/g/second copy/Demons Souls (2009)/PS3_GAME/PARAM.SFO': sfo,
    });
    final found = await scanner(fs).scan(['/g'], const []);
    expect(found.map((c) => c.sourcePath),
        ['/g/dumps/Demons Souls (2009)', '/g/dumps/wrapped/BLUS30443', '/g/ps3/Laid out (2010)', '/g/second copy/Demons Souls (2009)']);
    expect(found[0].title, "Demon's Souls");
    expect(found[0].year, '2009');
    expect(found[0].titleId, 'BLUS30443');
    expect(found[0].kind, GameCandidateKind.tree);
    expect(found[0].files, isNull, reason: 'trees are listed later');
    expect(found[2].title, 'Laid out', reason: 'a damaged SFO falls back to the folder name');
    expect(found[1].conflictWith, isNull, reason: 'no year in the wrapper name: another server folder');
    expect(found[3].conflictWith, "Demon's Souls", reason: 'same server folder');
  });

  test('Steam libraries: installed games only, runtimes, updating and Ister-restored ones skipped', () async {
    final fs = MemoryFileSystemView({
      '/steam/steamapps/appmanifest_620.acf': acf(620, 'Portal 2', 'Portal 2'),
      '/steam/steamapps/common/Portal 2/portal2.exe': bytes,
      '/steam/steamapps/appmanifest_228980.acf': acf(228980, 'Steamworks Common Redistributables', 'Steamworks Shared'),
      '/steam/steamapps/common/Steamworks Shared/x': bytes,
      '/steam/steamapps/appmanifest_10.acf': acf(10, 'Updating', 'Updating', flags: 1026),
      '/steam/steamapps/common/Updating/x': bytes,
      '/steam/steamapps/appmanifest_11.acf': acf(11, 'Gone', 'Gone'),
      '/steam/steamapps/appmanifest_12.acf': acf(12, 'Restored by Ister', 'Restored'),
      '/steam/steamapps/common/Restored/x': bytes,
      '/steam/steamapps/appmanifest_13.acf': acf(13, 'Hollow Knight™', 'Hollow Knight'),
      '/steam/steamapps/common/Hollow Knight/hk': bytes,
    });
    final found = await scanner(fs, excludedApps: {12}).scan(const [], [const SteamLibrary(path: '/steam', label: 'main')]);
    expect(found.map((c) => c.title), ['Hollow Knight™', 'Portal 2']);
    final portal = found[1];
    expect(portal.kind, GameCandidateKind.steam);
    expect(portal.platformFolder, 'steam');
    expect(portal.steamAppId, 620);
    expect(portal.steamManifestPath, '/steam/steamapps/appmanifest_620.acf');
    expect(portal.steamInstallDir, '/steam/steamapps/common/Portal 2');
    expect(portal.sizeBytes, 1000 + fs.lengthSync('/steam/steamapps/appmanifest_620.acf'));
  });

  test('a laid-out Steam game under steam/ is a tree', () async {
    final fs = MemoryFileSystemView({
      '/g/steam/Portal 2/appmanifest_620.acf': acf(620, 'Portal 2', 'Portal 2'),
      '/g/steam/Portal 2/Portal 2/portal2.exe': bytes,
      '/g/steam/No manifest/x.exe': bytes,
    });
    final found = await scanner(fs).scan(['/g'], const []);
    expect(found.single.kind, GameCandidateKind.tree);
    expect(found.single.steamAppId, 620);
  });

  test("Ister's own install root is never offered", () async {
    final fs = MemoryFileSystemView({
      '/home/u/Games/snes/Mine.sfc': bytes,
      '/home/u/Games/Ister/srv/snes/Installed.sfc': bytes,
    });
    final found = await scanner(fs, excluded: {'/home/u/Games/Ister'}).scan(['/home/u/Games'], const []);
    expect(found.map((c) => c.title), ['Mine']);
  });

  test('candidates round-trip through JSON', () async {
    final fs = MemoryFileSystemView({'/g/snes/Game (1999).sfc': bytes});
    final c = (await scanner(fs).scan(['/g'], const [])).single;
    final back = GameUploadCandidate.fromJson(jsonDecode(jsonEncode(c.toJson())) as Map<String, dynamic>);
    expect(back.id, c.id);
    expect(back.rootName, 'Game (1999)');
    expect(back.files!.single.absolutePath, '/g/snes/Game (1999).sfc');
  });
}
