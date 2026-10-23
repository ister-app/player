import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/upload/games/GameSourceNaming.dart';

void main() {
  test('strips No-Intro tags, keeps a year and moves a trailing article', () {
    expect(GameSourceNaming.titleAndYear('Super Mario World (USA) (Rev 1) [!]'), (title: 'Super Mario World', year: null));
    expect(GameSourceNaming.titleAndYear('Doom (1993)'), (title: 'Doom', year: '1993'));
    expect(GameSourceNaming.titleAndYear('Legend of Zelda, The (Europe) (1991)'), (title: 'The Legend of Zelda', year: '1991'));
    expect(GameSourceNaming.titleAndYear('Chrono Trigger'), (title: 'Chrono Trigger', year: null));
    expect(GameSourceNaming.titleAndYear('Final Fantasy VII (USA) (Disc 1)'), (title: 'Final Fantasy VII', year: null));
    expect(GameSourceNaming.titleAndYear('(USA)').title, '(USA)', reason: 'nothing left: keep the name');
    expect(GameSourceNaming.titleAndYear('Game (0001)'), (title: 'Game', year: null), reason: 'not a plausible year');
  });

  test('stem takes the matched extension off whole', () {
    expect(GameSourceNaming.stem('game.tar.gz', 'tar.gz'), 'game');
    expect(GameSourceNaming.stem('Game (USA).sfc', 'sfc'), 'Game (USA)');
    expect(GameSourceNaming.stem('noext', 'bin'), 'noext');
  });

  test('cue sheet file names', () {
    const cue = 'FILE "Game (Track 1).bin" BINARY\n  TRACK 01 MODE2/2352\nfile "Game (Track 2).bin" BINARY\n';
    expect(GameSourceNaming.cueReferencedFiles(cue), ['Game (Track 1).bin', 'Game (Track 2).bin']);
  });
}
