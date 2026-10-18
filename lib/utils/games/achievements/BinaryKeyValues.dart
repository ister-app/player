import 'dart:convert';
import 'dart:typed_data';

/// Valve's binary KeyValues, as in Steam's `appcache/stats/*.bin`:
/// a type byte, a NUL-terminated key, then the value; `0x00` opens a nested
/// map that ends with `0x08` (or `0x0B`). Numbers are little-endian.
class BinaryKeyValues {
  BinaryKeyValues._(this._bytes) : _data = ByteData.sublistView(_bytes);

  final Uint8List _bytes;
  final ByteData _data;
  int _pos = 0;

  static const _typeNone = 0x00;
  static const _typeString = 0x01;
  static const _typeInt32 = 0x02;
  static const _typeFloat32 = 0x03;
  static const _typePointer = 0x04;
  static const _typeWideString = 0x05;
  static const _typeColor = 0x06;
  static const _typeUint64 = 0x07;
  static const _typeEnd = 0x08;
  static const _typeInt64 = 0x0A;
  static const _typeAltEnd = 0x0B;

  /// Parses a whole file into nested maps (values: String, int, double, Map).
  static Map<String, Object> parse(Uint8List bytes) {
    final parser = BinaryKeyValues._(bytes);
    final root = <String, Object>{};
    parser._readInto(root, topLevel: true);
    return root;
  }

  void _readInto(Map<String, Object> into, {bool topLevel = false}) {
    while (_pos < _bytes.length) {
      final type = _bytes[_pos++];
      if (type == _typeEnd || type == _typeAltEnd) return;
      final key = _readString();
      switch (type) {
        case _typeNone:
          final child = <String, Object>{};
          _readInto(child);
          into[key] = child;
        case _typeString:
          into[key] = _readString();
        case _typeWideString:
          into[key] = _readWideString();
        case _typeInt32:
        case _typeColor:
        case _typePointer:
          into[key] = _data.getInt32(_pos, Endian.little);
          _pos += 4;
        case _typeFloat32:
          into[key] = _data.getFloat32(_pos, Endian.little);
          _pos += 4;
        case _typeUint64:
          into[key] = _data.getUint64(_pos, Endian.little);
          _pos += 8;
        case _typeInt64:
          into[key] = _data.getInt64(_pos, Endian.little);
          _pos += 8;
        default:
          throw FormatException('Unknown KeyValues type 0x${type.toRadixString(16)} at ${_pos - 1}');
      }
    }
    if (!topLevel) throw const FormatException('Unterminated KeyValues block');
  }

  String _readString() {
    final start = _pos;
    while (_pos < _bytes.length && _bytes[_pos] != 0) {
      _pos++;
    }
    final text = utf8.decode(_bytes.sublist(start, _pos), allowMalformed: true);
    _pos++; // NUL
    return text;
  }

  String _readWideString() {
    final units = <int>[];
    while (_pos + 1 < _bytes.length) {
      final unit = _data.getUint16(_pos, Endian.little);
      _pos += 2;
      if (unit == 0) break;
      units.add(unit);
    }
    return String.fromCharCodes(units);
  }

  /// Case-insensitive lookup helpers, because Steam is.
  static Object? get(Map<String, Object> map, String key) {
    for (final entry in map.entries) {
      if (entry.key.toLowerCase() == key.toLowerCase()) return entry.value;
    }
    return null;
  }

  static Map<String, Object>? child(Map<String, Object> map, String key) {
    final value = get(map, key);
    return value is Map<String, Object> ? value : null;
  }

  static String? string(Map<String, Object> map, String key) {
    final value = get(map, key);
    if (value == null) return null;
    if (value is Map<String, Object>) {
      // Localised display strings: {"english": "...", "token": "..."}.
      return (get(value, 'english') ?? value.values.whereType<String>().firstOrNull)?.toString();
    }
    return value.toString();
  }
}
