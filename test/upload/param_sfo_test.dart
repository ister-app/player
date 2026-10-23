import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/upload/games/ParamSfo.dart';

/// Builds a PARAM.SFO the way the PS3 does: header, index, key table, data table.
Uint8List buildSfo(Map<String, Object> values) {
  final keys = BytesBuilder();
  final data = BytesBuilder();
  final index = BytesBuilder();
  for (final entry in values.entries) {
    final keyOffset = keys.length;
    keys.add(utf8.encode(entry.key));
    keys.addByte(0);
    final dataOffset = data.length;
    final int format;
    final int length;
    if (entry.value is int) {
      format = 0x0404;
      length = 4;
      data.add((ByteData(4)..setUint32(0, entry.value as int, Endian.little)).buffer.asUint8List());
    } else {
      format = 0x0204;
      final bytes = utf8.encode(entry.value as String);
      length = bytes.length + 1;
      data.add(bytes);
      data.addByte(0);
    }
    while (data.length % 4 != 0) {
      data.addByte(0);
    }
    final row = ByteData(16)
      ..setUint16(0, keyOffset, Endian.little)
      ..setUint16(2, format, Endian.little)
      ..setUint32(4, length, Endian.little)
      ..setUint32(8, length, Endian.little)
      ..setUint32(12, dataOffset, Endian.little);
    index.add(row.buffer.asUint8List());
  }
  final keyTableStart = 20 + index.length;
  final dataTableStart = keyTableStart + keys.length;
  final header = ByteData(20)
    ..setUint32(0, 0x46535000, Endian.little)
    ..setUint32(4, 0x0101, Endian.little)
    ..setUint32(8, keyTableStart, Endian.little)
    ..setUint32(12, dataTableStart, Endian.little)
    ..setUint32(16, values.length, Endian.little);
  return Uint8List.fromList([...header.buffer.asUint8List(), ...index.toBytes(), ...keys.toBytes(), ...data.toBytes()]);
}

void main() {
  test('reads title, title id and integers', () {
    final sfo = ParamSfo.parse(buildSfo({'TITLE': "Demon's\nSouls", 'TITLE_ID': 'BLUS30443', 'PARENTAL_LEVEL': 9}));
    expect(sfo.title, "Demon's Souls");
    expect(sfo.titleId, 'BLUS30443');
    expect(sfo.values['PARENTAL_LEVEL'], 9);
  });

  test('rejects other files and truncated ones', () {
    expect(() => ParamSfo.parse(Uint8List.fromList(utf8.encode('not an sfo at all, really'))), throwsFormatException);
    final whole = buildSfo({'TITLE': 'Game'});
    expect(() => ParamSfo.parse(whole.sublist(0, whole.length - 6)), throwsFormatException);
  });
}
