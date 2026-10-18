import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/games/saves/SavePathResolver.dart';

void main() {
  late Directory tmp;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('ister-saves-');
  });

  tearDown(() async {
    await tmp.delete(recursive: true);
  });

  test('expands linux placeholders and keeps os-specific templates apart', () async {
    final resolver = SavePathResolver(
      base: '${tmp.path}/game',
      environment: {'HOME': tmp.path, 'XDG_CONFIG_HOME': '${tmp.path}/.config'},
      isWindows: false,
    );
    final slots = await resolver.resolve([
      (path: '<xdgConfig>/StardewValley/Saves', os: 'linux'),
      (path: '<winAppData>/StardewValley/Saves', os: 'windows'),
      (path: '<base>/Saves', os: null),
    ]);
    expect(slots.map((s) => s.path), [
      '${tmp.path}/.config/StardewValley/Saves',
      '${tmp.path}/game/Saves',
    ]);
    expect(slots.map((s) => s.index), [0, 2], reason: 'the slot index is the template position');
  });

  test('windows placeholders resolve inside a proton prefix on linux', () async {
    final driveC = '${tmp.path}/compatdata/1/pfx/drive_c';
    final resolver = SavePathResolver(
      base: '${tmp.path}/game',
      environment: {'HOME': tmp.path},
      protonDriveC: driveC,
      storeUserId: 42,
      isWindows: false,
    );
    final slots = await resolver.resolve([
      (path: '<winAppData>/Game/<storeUserId>/save.dat', os: 'windows'),
    ]);
    expect(slots.single.path, '$driveC/users/steamuser/AppData/Roaming/Game/42/save.dat');
  });

  test('templates outside the owned roots are refused', () async {
    final resolver = SavePathResolver(base: '${tmp.path}/game', environment: {'HOME': tmp.path}, isWindows: false);
    final slots = await resolver.resolve([(path: '/etc/passwd', os: null)]);
    expect(slots, isEmpty);
  });

  test('globs expand against existing folders', () async {
    await Directory('${tmp.path}/game/profiles/alice/saves').create(recursive: true);
    await Directory('${tmp.path}/game/profiles/bob/saves').create(recursive: true);
    final resolver = SavePathResolver(base: '${tmp.path}/game', environment: {'HOME': tmp.path}, isWindows: false);
    final slots = await resolver.resolve([(path: '<base>/profiles/*/saves', os: null)]);
    expect(slots.map((s) => s.path).toSet(), {
      '${tmp.path}/game/profiles/alice/saves',
      '${tmp.path}/game/profiles/bob/saves',
    });
  });
}
