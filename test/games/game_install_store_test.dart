import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/games/GameApi.dart';
import 'package:player/utils/games/GameInstallStore.dart';

void main() {
  late Directory tmp;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('ister-installs-');
  });

  tearDown(() async {
    await tmp.delete(recursive: true);
  });

  test('installs round-trip through installs.json with every field', () async {
    final store = GameInstallStore(tmp);
    final install = GameInstall(
      gameId: 'g1',
      form: 'ROM',
      platform: 'PSX',
      dir: '${tmp.path}/srv/g1',
      status: GameInstallStatus.paused,
      title: 'Crash',
      totalBytes: 100,
      doneBytes: 40,
      filesTotal: 2,
      filesDone: 1,
      installedVersion: 'v1',
      availableVersion: 'v2',
      availableBytes: 12,
      queuedAt: DateTime.utc(2026, 1, 2),
      sessionStartedAt: DateTime.utc(2026, 1, 3),
      sessionDetached: true,
    );
    await store.put('https://srv', install);

    final again = GameInstallStore(tmp);
    final loaded = (await again.get('https://srv', 'g1'))!;
    expect(loaded.status, GameInstallStatus.paused);
    expect(loaded.title, 'Crash');
    expect(loaded.doneBytes, 40);
    expect(loaded.installedVersion, 'v1');
    expect(loaded.availableVersion, 'v2');
    expect(loaded.availableBytes, 12);
    expect(loaded.queuedAt, DateTime.utc(2026, 1, 2));
    expect(loaded.sessionStartedAt, DateTime.utc(2026, 1, 3));
    expect(loaded.sessionDetached, isTrue);
    expect(loaded.isResumable, isTrue);
    expect(loaded.bytesOnDisk, 40);
  });

  test('a manifest written before the new fields existed still loads', () async {
    final dir = Directory('${tmp.path}/srv')..createSync(recursive: true);
    File('${dir.path}/installs.json').writeAsStringSync(jsonEncode({
      'installs': [
        {'gameId': 'old', 'form': 'ROM', 'platform': 'NES', 'dir': '${dir.path}/old', 'status': 'installed', 'totalBytes': 5}
      ]
    }));
    final loaded = (await GameInstallStore(tmp).get('srv', 'old'))!;
    expect(loaded.isInstalled, isTrue);
    expect(loaded.installedVersion, isNull);
    expect(loaded.hasOpenSession, isFalse);
    expect(loaded.bytesOnDisk, 5);
  });

  test('an unknown status reads as failed and a damaged file as empty', () async {
    final dir = Directory('${tmp.path}/srv')..createSync(recursive: true);
    File('${dir.path}/installs.json').writeAsStringSync(jsonEncode({
      'installs': [
        {'gameId': 'x', 'form': 'ROM', 'platform': 'NES', 'dir': 'd', 'status': 'teleporting'}
      ]
    }));
    expect((await GameInstallStore(tmp).get('srv', 'x'))!.status, GameInstallStatus.failed);
    File('${dir.path}/installs.json').writeAsStringSync('{not json');
    expect(await GameInstallStore(tmp).get('srv', 'x'), isNull);
  });

  test('invalidate forgets the cache so another root is read afresh', () async {
    final store = GameInstallStore(tmp);
    await store.put('srv', GameInstall(gameId: 'g', form: 'ROM', platform: 'NES', dir: 'd', status: GameInstallStatus.installed));
    expect(store.all().length, 1);
    store.invalidate();
    expect(store.all(), isEmpty);
    expect((await store.load('srv')).length, 1, reason: 're-read from disk');
  });

  test('the server manifest is kept next to the files', () async {
    final store = GameInstallStore(tmp);
    final install = GameInstall(gameId: 'g', form: 'ROM', platform: 'NES', dir: '${tmp.path}/srv/g', status: GameInstallStatus.installed);
    expect(await store.readManifest(install), isNull);
    final manifest = GameManifest(
      gameId: 'g',
      platform: 'NES',
      form: 'ROM',
      entryPath: 'rom.nes',
      titleId: null,
      steamAppId: null,
      steamInstallDir: null,
      totalBytes: 3,
      files: const [GameManifestFile(path: 'rom.nes', size: 3, entry: true, lastModified: 't')],
      etag: '"e"',
      version: 'v9',
    );
    await store.writeManifest(install, manifest);
    final read = (await store.readManifest(install))!;
    expect(read.version, 'v9');
    expect(read.files.single.lastModified, 't');
    expect(read.etag, '"e"');
  });
}
