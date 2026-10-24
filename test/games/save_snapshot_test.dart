import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/games/saves/SavePathResolver.dart';
import 'package:player/utils/games/saves/SaveSnapshot.dart';

void main() {
  late Directory tmp;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('ister-snapshot-');
  });

  tearDown(() async {
    await tmp.delete(recursive: true);
  });

  test('pack and unpack round-trip the slots into other roots', () async {
    final saves = Directory('${tmp.path}/a/saves')..createSync(recursive: true);
    File('${saves.path}/game.srm').writeAsStringSync('save-bytes');
    File('${saves.path}/states/slot1.state').createSync(recursive: true);
    File('${saves.path}/states/slot1.state').writeAsStringSync('state');
    File('${saves.path}/.hidden').writeAsStringSync('skip');
    final single = File('${tmp.path}/a/settings.ini')..writeAsStringSync('ini');

    final zip = File('${tmp.path}/snap.zip');
    final sha = await SaveSnapshot.pack([
      SaveSlot(index: 0, path: saves.path, template: 'retroarch'),
      SaveSlot(index: 1, path: single.path, template: '<base>/settings.ini'),
    ], zip);
    expect(sha, isNotNull);

    final otherSaves = Directory('${tmp.path}/b/saves');
    final otherIni = File('${tmp.path}/b/settings.ini');
    final written = await SaveSnapshot.unpack(zip, [
      SaveSlot(index: 0, path: otherSaves.path, template: 'retroarch'),
      SaveSlot(index: 1, path: otherIni.path, template: '<base>/settings.ini'),
    ]);
    expect(written, 3);
    expect(File('${otherSaves.path}/game.srm').readAsStringSync(), 'save-bytes');
    expect(File('${otherSaves.path}/states/slot1.state').readAsStringSync(), 'state');
    expect(otherIni.readAsStringSync(), 'ini');
    expect(File('${otherSaves.path}/.hidden').existsSync(), isFalse);
  });

  test('unpack matches on template, not index: a save folder this machine never had is created next to the rpcs3 slot', () async {
    // Machine A: the game's folder exists, so it packed as slot 1.
    final savedataA = Directory('${tmp.path}/a/savedata')..createSync(recursive: true);
    final folderA = Directory('${savedataA.path}/BCES00065_NDI_UNCHARTED_DF_0')..createSync();
    File('${folderA.path}/SAVE.DAT').writeAsStringSync('chapter 5');
    File('${folderA.path}/PARAM.SFO').writeAsStringSync('sfo');
    final zip = File('${tmp.path}/snap.zip');
    expect(
        await SaveSnapshot.pack([
          SaveSlot(index: 0, path: '${savedataA.path}/NPEA00363', template: 'rpcs3:NPEA00363'),
          SaveSlot(index: 1, path: folderA.path, template: 'rpcs3:BCES00065_NDI_UNCHARTED_DF_0'),
        ], zip),
        isNotNull);

    // Machine B: a fresh RPCS3, only the bare title-id slot is known.
    final savedataB = Directory('${tmp.path}/b/savedata')..createSync(recursive: true);
    final written = await SaveSnapshot.unpack(zip, [
      SaveSlot(index: 0, path: '${savedataB.path}/NPEA00363', template: 'rpcs3:NPEA00363'),
    ]);
    expect(written, 2);
    expect(File('${savedataB.path}/BCES00065_NDI_UNCHARTED_DF_0/SAVE.DAT').readAsStringSync(), 'chapter 5');
    expect(Directory('${savedataB.path}/NPEA00363').existsSync(), isFalse, reason: 'nothing was packed for slot 0');

    // Machine C: has the folder under a different index; the template wins.
    final savedataC = Directory('${tmp.path}/c/savedata')..createSync(recursive: true);
    Directory('${savedataC.path}/NPEA00363-OTHER').createSync();
    await SaveSnapshot.unpack(zip, [
      SaveSlot(index: 0, path: '${savedataC.path}/NPEA00363', template: 'rpcs3:NPEA00363'),
      SaveSlot(index: 1, path: '${savedataC.path}/NPEA00363-OTHER', template: 'rpcs3:NPEA00363-OTHER'),
      SaveSlot(index: 2, path: '${savedataC.path}/BCES00065_NDI_UNCHARTED_DF_0', template: 'rpcs3:BCES00065_NDI_UNCHARTED_DF_0'),
    ]);
    expect(File('${savedataC.path}/BCES00065_NDI_UNCHARTED_DF_0/SAVE.DAT').existsSync(), isTrue);
    expect(Directory('${savedataC.path}/NPEA00363-OTHER').listSync(), isEmpty);
  });

  test('unpack skips an unknown non-rpcs3 template instead of guessing by index', () async {
    final src = Directory('${tmp.path}/src')..createSync();
    File('${src.path}/x.sav').writeAsStringSync('x');
    final zip = File('${tmp.path}/snap2.zip');
    await SaveSnapshot.pack([SaveSlot(index: 0, path: src.path, template: '<home>/.config/other')], zip);
    final dst = Directory('${tmp.path}/dst')..createSync();
    expect(await SaveSnapshot.unpack(zip, [SaveSlot(index: 0, path: dst.path, template: '<base>/saves')]), 0);
    expect(dst.listSync(), isEmpty);
  });

  test('newestModified ignores hidden files inside the slot, not a hidden folder the slot lives under', () async {
    final saves = Directory('${tmp.path}/.var/app/rpcs3/savedata/GAME')..createSync(recursive: true);
    final slots = [SaveSlot(index: 0, path: saves.path, template: 'rpcs3:GAME')];
    expect(await SaveSnapshot.newestModified(slots), isNull);
    File('${saves.path}/.tmp').writeAsStringSync('x');
    expect(await SaveSnapshot.newestModified(slots), isNull);
    File('${saves.path}/SAVE.DAT').writeAsStringSync('x');
    expect(await SaveSnapshot.newestModified(slots), isNotNull);
  });

  test('pack returns null for empty slots and the fingerprint tracks changes', () async {
    final saves = Directory('${tmp.path}/empty')..createSync();
    final slots = [SaveSlot(index: 0, path: saves.path, template: 'x')];
    expect(await SaveSnapshot.pack(slots, File('${tmp.path}/z.zip')), isNull);
    final before = await SaveSnapshot.fingerprint(slots);
    File('${saves.path}/new.sav').writeAsStringSync('x');
    expect(await SaveSnapshot.fingerprint(slots), isNot(before));
  });
}
