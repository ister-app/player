/// Valve's text KeyValues format ("VDF"): `appmanifest_<appid>.acf`,
/// `libraryfolders.vdf`, `loginusers.vdf`. Values are strings or nested maps.
/// Mirrors the server's `VdfParser` (same grammar, escapes and comments).
class Vdf {
  Vdf._(this._text);

  final String _text;
  int _pos = 0;

  /// Parses a whole document into its top-level key → value map.
  static Map<String, Object> parse(String text) {
    final parser = Vdf._(text);
    final root = <String, Object>{};
    parser._readPairs(root, nested: false);
    return root;
  }

  /// The nested map under the single top-level key, or the root itself.
  static Map<String, Object> body(Map<String, Object> document) {
    if (document.length == 1 && document.values.first is Map<String, Object>) {
      return document.values.first as Map<String, Object>;
    }
    return document;
  }

  /// A string value by case-insensitive key.
  static String? string(Map<String, Object> map, String key) {
    for (final entry in map.entries) {
      if (entry.key.toLowerCase() == key.toLowerCase() && entry.value is String) {
        return entry.value as String;
      }
    }
    return null;
  }

  static int? integer(Map<String, Object> map, String key) =>
      int.tryParse(string(map, key)?.trim() ?? '');

  static Map<String, Object>? map(Map<String, Object> map, String key) {
    for (final entry in map.entries) {
      if (entry.key.toLowerCase() == key.toLowerCase() &&
          entry.value is Map<String, Object>) {
        return entry.value as Map<String, Object>;
      }
    }
    return null;
  }

  /// Serialises a map back to the tab-indented form Steam writes itself.
  static String write(String rootKey, Map<String, Object> body) {
    final out = StringBuffer();
    _writeBlock(out, rootKey, body, 0);
    return out.toString();
  }

  static void _writeBlock(StringBuffer out, String key, Map<String, Object> map, int depth) {
    final indent = '\t' * depth;
    out
      ..write(indent)
      ..write(_quote(key))
      ..write('\n')
      ..write(indent)
      ..write('{\n');
    for (final entry in map.entries) {
      final value = entry.value;
      if (value is Map<String, Object>) {
        _writeBlock(out, entry.key, value, depth + 1);
      } else {
        out
          ..write(indent)
          ..write('\t')
          ..write(_quote(entry.key))
          ..write('\t\t')
          ..write(_quote(value.toString()))
          ..write('\n');
      }
    }
    out
      ..write(indent)
      ..write('}\n');
  }

  static String _quote(String value) =>
      '"${value.replaceAll('\\', r'\\').replaceAll('"', r'\"')}"';

  void _readPairs(Map<String, Object> into, {required bool nested}) {
    while (true) {
      _skipWhitespaceAndComments();
      if (_pos >= _text.length) {
        if (nested) throw const FormatException('Unterminated block in VDF document');
        return;
      }
      final c = _text[_pos];
      if (c == '}') {
        _pos++;
        if (!nested) throw FormatException('Unexpected } at $_pos');
        return;
      }
      final key = _readToken();
      _skipWhitespaceAndComments();
      if (_pos < _text.length && _text[_pos] == '{') {
        _pos++;
        final child = <String, Object>{};
        _readPairs(child, nested: true);
        into[key] = child;
      } else {
        into[key] = _readToken();
      }
    }
  }

  String _readToken() {
    if (_pos >= _text.length) throw const FormatException('Unexpected end of VDF document');
    if (_text[_pos] == '"') {
      _pos++;
      final out = StringBuffer();
      while (_pos < _text.length) {
        final c = _text[_pos++];
        if (c == '"') return out.toString();
        if (c == r'\' && _pos < _text.length) {
          final escaped = _text[_pos++];
          out.write(switch (escaped) {
            'n' => '\n',
            't' => '\t',
            _ => escaped,
          });
        } else {
          out.write(c);
        }
      }
      throw const FormatException('Unterminated string in VDF document');
    }
    final start = _pos;
    while (_pos < _text.length &&
        !_isWhitespace(_text[_pos]) &&
        _text[_pos] != '{' &&
        _text[_pos] != '}' &&
        _text[_pos] != '"') {
      _pos++;
    }
    if (start == _pos) throw FormatException('Unexpected character at $_pos');
    return _text.substring(start, _pos);
  }

  void _skipWhitespaceAndComments() {
    while (_pos < _text.length) {
      final c = _text[_pos];
      if (_isWhitespace(c) || c == '﻿') {
        _pos++;
      } else if (c == '/' && _pos + 1 < _text.length && _text[_pos + 1] == '/') {
        while (_pos < _text.length && _text[_pos] != '\n') {
          _pos++;
        }
      } else {
        return;
      }
    }
  }

  static bool _isWhitespace(String c) => c == ' ' || c == '\t' || c == '\n' || c == '\r';
}
