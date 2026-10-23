import 'dart:convert';
import 'dart:typed_data';

/// A PlayStation `PARAM.SFO`: the key/value table a PS3 game folder carries
/// (`TITLE`, `TITLE_ID`, …). Only what the scanner needs — strings and
/// 32-bit integers — mirroring the server's `ParamSfoParser`.
class ParamSfo {
  ParamSfo._(this.values);

  final Map<String, Object> values;

  static const _magic = 0x46535000; // "\0PSF" little-endian

  static ParamSfo parse(Uint8List bytes) {
    if (bytes.length < 20) throw const FormatException('PARAM.SFO too short');
    final data = ByteData.sublistView(bytes);
    if (data.getUint32(0, Endian.little) != _magic) throw const FormatException('Not a PARAM.SFO');
    final keyTable = data.getUint32(8, Endian.little);
    final dataTable = data.getUint32(12, Endian.little);
    final count = data.getUint32(16, Endian.little);
    final values = <String, Object>{};
    for (var i = 0; i < count; i++) {
      final entry = 20 + i * 16;
      if (entry + 16 > bytes.length) throw const FormatException('PARAM.SFO index truncated');
      final keyOffset = data.getUint16(entry, Endian.little);
      final format = data.getUint16(entry + 2, Endian.little);
      final length = data.getUint32(entry + 4, Endian.little);
      final dataOffset = data.getUint32(entry + 12, Endian.little);
      final key = _cString(bytes, keyTable + keyOffset);
      final start = dataTable + dataOffset;
      if (start + length > bytes.length) throw const FormatException('PARAM.SFO data truncated');
      switch (format) {
        case 0x0404:
          values[key] = data.getUint32(start, Endian.little);
        case 0x0204:
        case 0x0004:
          values[key] = _cString(bytes, start, max: length);
      }
    }
    return ParamSfo._(values);
  }

  static String _cString(Uint8List bytes, int start, {int? max}) {
    if (start >= bytes.length) throw const FormatException('PARAM.SFO string out of range');
    var end = start;
    final limit = max == null ? bytes.length : (start + max).clamp(0, bytes.length);
    while (end < limit && bytes[end] != 0) {
      end++;
    }
    return utf8.decode(bytes.sublist(start, end), allowMalformed: true);
  }

  /// The game's title with the line breaks some discs put in collapsed.
  String? get title {
    final raw = values['TITLE'];
    if (raw is! String) return null;
    final clean = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
    return clean.isEmpty ? null : clean;
  }

  String? get titleId => values['TITLE_ID'] is String ? (values['TITLE_ID'] as String).trim() : null;
}
