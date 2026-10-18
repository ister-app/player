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
}
