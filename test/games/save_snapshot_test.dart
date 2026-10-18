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

  test('pack returns null for empty slots and the fingerprint tracks changes', () async {
    final saves = Directory('${tmp.path}/empty')..createSync();
    final slots = [SaveSlot(index: 0, path: saves.path, template: 'x')];
    expect(await SaveSnapshot.pack(slots, File('${tmp.path}/z.zip')), isNull);
    final before = await SaveSnapshot.fingerprint(slots);
    File('${saves.path}/new.sav').writeAsStringSync('x');
    expect(await SaveSnapshot.fingerprint(slots), isNot(before));
  });
}
