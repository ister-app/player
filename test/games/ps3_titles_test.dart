import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/games/Ps3Titles.dart';

void main() {
  test('normalise drops marks, entities, whitespace and a trailing patch version', () {
    expect(Ps3Titles.normalise("Uncharted: Drake's Fortune™ 1.02"), "uncharted: drake's fortune");
    expect(Ps3Titles.normalise("Uncharted: Drake's Fortune™\n1.02"), "uncharted: drake's fortune");
    expect(Ps3Titles.normalise('Uncharted: Drake&apos;s Fortune'), "uncharted: drake's fortune");
    expect(Ps3Titles.normalise('Ratchet &amp; Clank®  Tools  of Destruction v1.20'), 'ratchet & clank tools of destruction');
    expect(Ps3Titles.normalise('Portal 2'), 'portal 2', reason: 'a bare number is part of the name');
    expect(Ps3Titles.normalise('1.02'), '1.02', reason: 'a title that is only a version stays');
  });

  test('same compares the normalised forms and rejects empties', () {
    expect(Ps3Titles.same("Uncharted: Drake's Fortune™ 1.02", "Uncharted: Drake's Fortune™"), isTrue);
    expect(Ps3Titles.same('Fat Princess', 'Fat Princess: Fistful of Cake'), isFalse);
    expect(Ps3Titles.same(null, 'x'), isFalse);
    expect(Ps3Titles.same('™', '™'), isFalse);
  });
}
