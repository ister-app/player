import 'package:flutter_test/flutter_test.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/upload/GameFoundProbe.dart';
import 'package:player/utils/upload/GameUploadNaming.dart';

void main() {
  group('GameUploadNaming', () {
    test('composes Title (year) and leaves the year off when empty', () {
      expect(GameUploadNaming.compose(" Demon's Souls ", '2009'), "Demon's Souls (2009)");
      expect(GameUploadNaming.compose('Tetris', ''), 'Tetris');
      expect(GameUploadNaming.compose('Tetris', null), 'Tetris');
      expect(GameUploadNaming.compose('   ', '1999'), '');
    });

    test('parses a trailing year the way the scanner does', () {
      expect(GameUploadNaming.parse("Demon's Souls (2009)"), (title: "Demon's Souls", year: '2009'));
      expect(GameUploadNaming.parse('Tetris'), (title: 'Tetris', year: null));
      expect(GameUploadNaming.parse('Game (2009) Deluxe'), (title: 'Game (2009) Deluxe', year: null));
      expect(GameUploadNaming.parse('  Spaced  (1985) '), (title: 'Spaced', year: '1985'));
    });

    test('a year is four digits in a sane range, or empty', () {
      expect(GameUploadNaming.isValidYear('2009'), isTrue);
      expect(GameUploadNaming.isValidYear(''), isTrue);
      expect(GameUploadNaming.isValidYear(null), isTrue);
      expect(GameUploadNaming.isValidYear('209'), isFalse);
      expect(GameUploadNaming.isValidYear('1899'), isFalse);
      expect(GameUploadNaming.isValidYear('20x9'), isFalse);
    });
  });

  group('GameFoundProbe', () {
    test('polls until the lookup answers, then stops', () async {
      var calls = 0;
      final probe = GameFoundProbe(
        lookup: (library, title) async {
          calls++;
          if (calls < 3) return null;
          return FoundGame(id: 'g', title: title, platform: Enum$GamePlatform.NES, form: Enum$GameForm.ROM, savePathSource: 'NONE');
        },
        interval: const Duration(milliseconds: 5),
        patience: const Duration(seconds: 2),
      );
      final found = await probe.run('lib', 'Tetris');
      expect(found?.id, 'g');
      expect(calls, 3);
    });

    test('gives up after its patience and survives lookup errors', () async {
      var calls = 0;
      final probe = GameFoundProbe(
        lookup: (library, title) async {
          calls++;
          throw Exception('busy');
        },
        interval: const Duration(milliseconds: 5),
        patience: const Duration(milliseconds: 40),
      );
      expect(await probe.run('lib', 'Tetris'), isNull);
      expect(calls, greaterThan(1));
    });

    test('stops at once when cancelled', () async {
      var calls = 0;
      final probe = GameFoundProbe(
        lookup: (library, title) async {
          calls++;
          return null;
        },
        interval: const Duration(milliseconds: 5),
        patience: const Duration(seconds: 5),
      );
      expect(await probe.run('lib', 'Tetris', cancelled: () => true), isNull);
      expect(calls, 0);
    });

    test('only PC and Steam forms carry a save-path verdict', () {
      FoundGame of(Enum$GameForm form) =>
          FoundGame(id: 'g', title: 't', platform: Enum$GamePlatform.PC, form: form, savePathSource: 'NONE');
      expect(of(Enum$GameForm.ROM).usesSavePaths, isFalse);
      expect(of(Enum$GameForm.PS3_FOLDER).usesSavePaths, isFalse);
      expect(of(Enum$GameForm.STEAM).usesSavePaths, isTrue);
      expect(of(Enum$GameForm.PC_PORTABLE_ZIP).usesSavePaths, isTrue);
    });
  });
}
