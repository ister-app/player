import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/games/LocalGameCopy.dart';
import 'package:player/utils/games/steam/SteamLibraryLocator.dart';
import 'package:player/utils/upload/games/Rpcs3Locator.dart';

import 'support/game_fixture.dart';

void main() {
  late Directory tmp;
  late LocalGameCopyFinder finder;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('ister-local-copy-');
    final env = {'HOME': tmp.path, 'XDG_CONFIG_HOME': '${tmp.path}/.config'};
    finder = LocalGameCopyFinder(steam: SteamLibraryLocator(environment: env), rpcs3: Rpcs3Locator(environment: env));
  });

  tearDown(() => tmp.delete(recursive: true));

  Future<void> write(String path, String text) async =>
      (await File('${tmp.path}/$path').create(recursive: true)).writeAsString(text);

  String acf(int appid, String dir, {int flags = 4}) =>
      '"AppState" { "appid" "$appid" "name" "Game" "StateFlags" "$flags" "installdir" "$dir" }';

  group('Steam', () {
    test('a fully installed app in the Steam root library', () async {
      await write('.local/share/Steam/steamapps/appmanifest_620.acf', acf(620, 'Portal 2'));
      await write('.local/share/Steam/steamapps/common/Portal 2/portal2.sh', '');
      final copy = await finder.find(gameFixture(form: 'STEAM', platform: 'STEAM', steamAppId: '620'));
      expect(copy!.kind, LocalGameCopyKind.steam);
      expect(copy.steamLibrary, '${tmp.path}/.local/share/Steam');
      expect(copy.steamInstallDir, 'Portal 2');
      expect(copy.path, '${tmp.path}/.local/share/Steam/steamapps/common/Portal 2');
    });

    test('not when it is still updating, its folder is gone, or the game has no app id', () async {
      await write('.local/share/Steam/steamapps/appmanifest_1.acf', acf(1, 'Updating', flags: 1026));
      await write('.local/share/Steam/steamapps/common/Updating/x', '');
      await write('.local/share/Steam/steamapps/appmanifest_2.acf', acf(2, 'Gone'));
      expect(await finder.find(gameFixture(form: 'STEAM', platform: 'STEAM', steamAppId: '1')), isNull);
      expect(await finder.find(gameFixture(form: 'STEAM', platform: 'STEAM', steamAppId: '2')), isNull);
      expect(await finder.find(gameFixture(form: 'STEAM', platform: 'STEAM')), isNull);
      expect(await finder.find(gameFixture(form: 'ROM', platform: 'SNES')), isNull, reason: 'ROMs carry no id');
    });
  });

  group('RPCS3', () {
    test('an HDD game under dev_hdd0/game', () async {
      await write('.config/rpcs3/dev_hdd0/game/NPEA00111/PARAM.SFO', '');
      await write('.config/rpcs3/dev_hdd0/game/NPEA00111/USRDIR/EBOOT.BIN', '');
      final copy = await finder.find(gameFixture(form: 'PS3_FOLDER', platform: 'PS3', titleId: 'NPEA00111'));
      expect(copy!.kind, LocalGameCopyKind.rpcs3Hdd);
      expect(copy.entryPath, '${tmp.path}/.config/rpcs3/dev_hdd0/game/NPEA00111/USRDIR/EBOOT.BIN');
    });

    test('a disc dump from games.yml, directly or one wrapper deeper; a missing serial is nothing', () async {
      await write('.config/rpcs3/games.yml', 'BLUS30443: ${tmp.path}/dumps/Souls/\nBLES01294: ${tmp.path}/dumps/RDR/\nGONE12345: ${tmp.path}/gone/\n');
      await write('dumps/Souls/PS3_GAME/USRDIR/EBOOT.BIN', '');
      await write('dumps/RDR/BLES01294/PS3_GAME/USRDIR/EBOOT.BIN', '');
      final souls = await finder.find(gameFixture(form: 'PS3_FOLDER', platform: 'PS3', titleId: 'BLUS30443'));
      expect(souls!.kind, LocalGameCopyKind.rpcs3Disc);
      expect(souls.entryPath, '${tmp.path}/dumps/Souls/PS3_GAME/USRDIR/EBOOT.BIN');
      final rdr = await finder.find(gameFixture(form: 'PS3_FOLDER', platform: 'PS3', titleId: 'BLES01294'));
      expect(rdr!.path, '${tmp.path}/dumps/RDR/BLES01294');
      expect(await finder.find(gameFixture(form: 'PS3_FOLDER', platform: 'PS3', titleId: 'GONE12345')), isNull);
      expect(await finder.find(gameFixture(form: 'PS3_FOLDER', platform: 'PS3', titleId: 'NOPE00000')), isNull);
      expect(await finder.find(gameFixture(form: 'PS3_FOLDER', platform: 'PS3')), isNull);
    });
  });
}
