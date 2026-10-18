import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/games/achievements/BinaryKeyValues.dart';

/// Builds a binary KeyValues document the way Steam writes them.
class _Kv {
  final BytesBuilder _b = BytesBuilder();
  void _key(int type, String key) {
    _b.addByte(type);
    _b.add(utf8.encode(key));
    _b.addByte(0);
  }
  void begin(String key) => _key(0x00, key);
  void end() => _b.addByte(0x08);
  void string(String key, String value) {
    _key(0x01, key);
    _b.add(utf8.encode(value));
    _b.addByte(0);
  }
  void int32(String key, int value) {
    _key(0x02, key);
    _b.add((ByteData(4)..setInt32(0, value, Endian.little)).buffer.asUint8List());
  }
  void uint64(String key, int value) {
    _key(0x07, key);
    _b.add((ByteData(8)..setUint64(0, value, Endian.little)).buffer.asUint8List());
  }
  Uint8List bytes() => _b.toBytes();
}

void main() {
  test('parses nested maps, strings and numbers', () {
    final kv = _Kv()
      ..begin('413150')
      ..begin('stats')
      ..begin('1')
      ..string('type', '4')
      ..begin('bits')
      ..begin('0')
      ..string('name', 'ACH_1')
      ..begin('display')
      ..string('name', 'Greenhorn')
      ..string('hidden', '0')
      ..end()
      ..end()
      ..end()
      ..end()
      ..end()
      ..begin('cache')
      ..begin('1')
      ..begin('AchievementTimes')
      ..int32('0', 1700000000)
      ..end()
      ..end()
      ..end()
      ..uint64('crc', 123456789012)
      ..end();
    final root = BinaryKeyValues.parse(kv.bytes());
    final app = BinaryKeyValues.child(root, '413150')!;
    final stat = BinaryKeyValues.child(BinaryKeyValues.child(app, 'stats')!, '1')!;
    expect(BinaryKeyValues.string(stat, 'type'), '4');
    final bit = BinaryKeyValues.child(BinaryKeyValues.child(stat, 'bits')!, '0')!;
    expect(BinaryKeyValues.string(bit, 'name'), 'ACH_1');
    expect(BinaryKeyValues.string(BinaryKeyValues.child(bit, 'display')!, 'name'), 'Greenhorn');
    final times = BinaryKeyValues.child(BinaryKeyValues.child(BinaryKeyValues.child(app, 'cache')!, '1')!, 'AchievementTimes')!;
    expect(BinaryKeyValues.get(times, '0'), 1700000000);
    expect(BinaryKeyValues.get(app, 'crc'), 123456789012);
  });

  test('localised display strings prefer english', () {
    final map = <String, Object>{
      'name': <String, Object>{'token': '#ach', 'english': 'Hello', 'german': 'Hallo'},
    };
    expect(BinaryKeyValues.string(map, 'name'), 'Hello');
  });

  test('rejects unknown type tags', () {
    expect(() => BinaryKeyValues.parse(Uint8List.fromList([0x09, 0x61, 0x00])), throwsFormatException);
  });
}
