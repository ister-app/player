import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/games/launch/Rpcs3SaveFolders.dart';

void main() {
  // The savedata folder of a real RPCS3: Uncharted (PSN NPEA00363) saves under
  // its disc version's name, Red Dead and Pixeljunk Monsters under theirs.
  const folders = [
    'NPEA00111-AUTO-SCORES',
    'NPEA00111-AUTO-CUSTOM',
    'BLES00680RDR2SAVE0_SAV',
    'BCES00065_NDI_UNCHARTED_DF_0',
    'NPEA00385_RC1_SAVEDATA_A',
    'NPEA00363',
    'no-sfo-here',
  ];
  const sfoTitles = {
    'NPEA00111-AUTO-SCORES': 'PixelJunk™ Monsters',
    'NPEA00111-AUTO-CUSTOM': 'PixelJunk™ Monsters',
    'BLES00680RDR2SAVE0_SAV': 'Red Dead Redemption',
    'BCES00065_NDI_UNCHARTED_DF_0': "Uncharted: Drake's Fortune™",
    'NPEA00385_RC1_SAVEDATA_A': 'Ratchet & Clank®',
  };
  final asked = <String>[];
  Future<String?> sfoTitleOf(String name) async {
    asked.add(name);
    return sfoTitles[name];
  }

  setUp(asked.clear);

  test('a folder whose PARAM.SFO names the game is its, even with the server title carrying a version', () async {
    final owned = await Rpcs3SaveFolders.select(
      folderNames: folders,
      titleId: 'NPEA00363',
      title: "Uncharted: Drake's Fortune™ 1.02",
      sfoTitleOf: sfoTitleOf,
    );
    expect(owned, ['BCES00065_NDI_UNCHARTED_DF_0']);
  });

  test('folders starting with the title id are taken without reading their SFO, sorted', () async {
    final owned = await Rpcs3SaveFolders.select(
      folderNames: folders,
      titleId: 'NPEA00111',
      title: 'PixelJunk Monsters',
      sfoTitleOf: sfoTitleOf,
    );
    expect(owned, ['NPEA00111-AUTO-CUSTOM', 'NPEA00111-AUTO-SCORES']);
    expect(asked, isNot(contains('NPEA00111-AUTO-SCORES')));
  });

  test('the bare title id folder is left to the caller, folders without an SFO are ignored', () async {
    final owned = await Rpcs3SaveFolders.select(
      folderNames: folders,
      titleId: 'NPEA00363',
      title: 'Something Else',
      sfoTitleOf: sfoTitleOf,
    );
    expect(owned, isEmpty);
  });

  test('without a game title only the title id counts', () async {
    final owned = await Rpcs3SaveFolders.select(folderNames: folders, titleId: 'NPEA00363', sfoTitleOf: sfoTitleOf);
    expect(owned, isEmpty);
    expect(asked, isEmpty);
  });
}
