import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/games/achievements/Ps3TrophyReader.dart';

/// A TROPUSR.DAT with one type-6 table, laid out as RPCS3's TROPUSR.h declares it.
Uint8List tropUsr(List<({int id, bool unlocked, int micros})> trophies) {
  const headerSize = 48;
  const tableHeaderSize = 32;
  const entrySize = 0x70;
  final dataOffset = headerSize + tableHeaderSize;
  final bytes = ByteData(dataOffset + trophies.length * entrySize);
  bytes.setUint32(0, 0x818F54AD, Endian.big);
  bytes.setUint32(4, 0x00010000, Endian.big);
  bytes.setUint32(8, 1, Endian.big);
  bytes.setUint32(headerSize, 6, Endian.big); // type
  bytes.setUint32(headerSize + 4, entrySize - 0x10, Endian.big);
  bytes.setUint32(headerSize + 8, 1, Endian.big);
  bytes.setUint32(headerSize + 12, trophies.length, Endian.big);
  bytes.setUint64(headerSize + 16, dataOffset, Endian.big);
  for (var i = 0; i < trophies.length; i++) {
    final e = dataOffset + i * entrySize;
    bytes.setUint32(e, 6, Endian.big);
    bytes.setUint32(e + 4, entrySize - 0x10, Endian.big);
    bytes.setUint32(e + 8, i, Endian.big);
    bytes.setUint32(e + 16, trophies[i].id, Endian.big);
    bytes.setUint32(e + 20, trophies[i].unlocked ? 1 : 0, Endian.big);
    bytes.setUint64(e + 32, trophies[i].micros, Endian.big);
    bytes.setUint64(e + 40, trophies[i].micros, Endian.big);
  }
  return bytes.buffer.asUint8List();
}

void main() {
  test('reads the unlocked trophies and their timestamps', () {
    final unlocks = Ps3TrophyReader.parseTropUsr(tropUsr([
      (id: 0, unlocked: true, micros: 1700000000000000),
      (id: 1, unlocked: false, micros: 0),
      (id: 2, unlocked: true, micros: 1700000100000000),
    ]));
    expect(unlocks.keys, [0, 2]);
    expect(unlocks[0], DateTime.fromMillisecondsSinceEpoch(1700000000000, isUtc: true));
    expect(unlocks[2], DateTime.fromMillisecondsSinceEpoch(1700000100000, isUtc: true));
  });

  test('ignores files without the magic', () {
    expect(Ps3TrophyReader.parseTropUsr(Uint8List(64)), isEmpty);
  });

  group('which trophy folder is the game\'s', () {
    late Directory tmp;
    setUp(() async => tmp = await Directory.systemTemp.createTemp('ister-trophies-'));
    tearDown(() => tmp.delete(recursive: true));

    String conf(String commId, String title) => '<trophyconf><npcommid>$commId</npcommid><title-name>$title</title-name></trophyconf>';
    Future<void> set(String commId, String title) async {
      final dir = Directory('${tmp.path}/rpcs3/dev_hdd0/home/00000001/trophy/$commId')..createSync(recursive: true);
      File('${dir.path}/TROPCONF.SFM').writeAsStringSync(conf(commId, title));
    }

    test('the set the game ships in its TROPDIR wins; a bare title name is the fallback; no guess otherwise', () async {
      await set('NPWR00737_00', 'Fat Princess');
      await set('NPWR00867_00', 'Red Dead Redemption');
      await set('NPWR02335_00', 'Ratchet &amp; Clank');
      final reader = Ps3TrophyReader(rpcs3Config: Directory('${tmp.path}/rpcs3'));
      final hdd = Directory('${tmp.path}/rpcs3/dev_hdd0/game/NPEA00111')..createSync(recursive: true);
      Directory('${hdd.path}/TROPDIR/NPWR00737_00').createSync(recursive: true);
      final disc = Directory('${tmp.path}/dumps/Souls/BLUS30443/PS3_GAME/TROPDIR/NPWR09999_00')..createSync(recursive: true);

      expect(await Ps3TrophyReader.commIdsOf(hdd), {'NPWR00737_00'});
      expect(await Ps3TrophyReader.commIdsOf(Directory('${tmp.path}/dumps/Souls')), {'NPWR09999_00'}, reason: 'wrapper deeper');
      expect(await Ps3TrophyReader.commIdsOf(Directory('${tmp.path}/nowhere')), isEmpty);

      final byDir = await reader.foldersFor('NPEA00111', commIds: {'NPWR00737_00'}, title: 'Fat Princess');
      expect(byDir.map((d) => d.path.split('/').last), ['NPWR00737_00']);
      final byTitle = await reader.foldersFor('NPEA00385', title: 'Ratchet & Clank™');
      expect(byTitle.map((d) => d.path.split('/').last), ['NPWR02335_00']);
      expect(await reader.foldersFor('BLUS30443', title: "Demon's Souls"), isEmpty, reason: 'never every folder');
      expect(disc.existsSync(), isTrue);
    });
  });
}
