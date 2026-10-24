import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/upload/games/ParamSfo.dart';

import '../support/sfo_builder.dart';

void main() {
  test('reads title, title id and integers', () {
    final sfo = ParamSfo.parse(buildSfo({'TITLE': "Demon's\nSouls", 'TITLE_ID': 'BLUS30443', 'PARENTAL_LEVEL': 9}));
    expect(sfo.title, "Demon's Souls");
    expect(sfo.titleId, 'BLUS30443');
    expect(sfo.values['PARENTAL_LEVEL'], 9);
    expect(ParamSfo.parse(buildSfo({'TITLE': "Uncharted: Drake's Fortune™\n1.02"})).title, "Uncharted: Drake's Fortune™");
    expect(ParamSfo.parse(buildSfo({'TITLE': 'Portal\n2'})).title, 'Portal 2', reason: 'a bare number is part of the name');
  });

  test('rejects other files and truncated ones', () {
    expect(() => ParamSfo.parse(Uint8List.fromList(utf8.encode('not an sfo at all, really'))), throwsFormatException);
    final whole = buildSfo({'TITLE': 'Game'});
    expect(() => ParamSfo.parse(whole.sublist(0, whole.length - 6)), throwsFormatException);
  });
}
