import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/utils/games/GameApi.dart';
import 'package:player/utils/games/GameInstallStore.dart';
import 'package:player/utils/games/saves/SavePathResolver.dart';
import 'package:player/utils/games/saves/SaveSnapshot.dart';
import 'package:player/utils/games/saves/SaveSyncService.dart';

void main() {
  late Directory tmp;
  late List<int> serverZip;
  var saveDownloads = 0;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('ister-savesync-');
    saveDownloads = 0;
    // The snapshot the "server" holds: one save file made on another device.
    final remote = Directory('${tmp.path}/remote/saves')..createSync(recursive: true);
    File('${remote.path}/game.srm').writeAsStringSync('from-the-server');
    final zip = File('${tmp.path}/remote.zip');
    await SaveSnapshot.pack(
        [SaveSlot(index: 0, path: remote.path, template: 'retroarch')], zip);
    serverZip = zip.readAsBytesSync();
  });

  tearDown(() async {
    await tmp.delete(recursive: true);
  });

  GameApi api() => GameApi('http://srv',
      bearer: (_) async => 'Bearer t',
      httpClient: MockClient((request) async {
        if (request.url.path.endsWith('/saves')) {
          return http.Response(
              jsonEncode([
                {'version': 3, 'sizeBytes': serverZip.length, 'sha256': 'x', 'deviceName': 'deck'}
              ]),
              200);
        }
        saveDownloads++;
        return http.Response.bytes(serverZip, 200);
      }));

  GameInstall install({String? lastSaveSha, int lastSaveVersion = 0}) => GameInstall(
        gameId: 'g1',
        form: 'ROM',
        platform: 'SNES',
        dir: '${tmp.path}/install',
        status: GameInstallStatus.installed,
        lastSaveSha: lastSaveSha,
        lastSaveVersion: lastSaveVersion,
      );

  SaveSyncService service() => SaveSyncService(
      api: api(),
      store: GameInstallStore(tmp, true),
      serverName: 'srv',
      deviceName: 'desk');

  test('a never-synced install with saves of its own gets a conflict, not an overwrite',
      () async {
    final local = Directory('${tmp.path}/local/saves')..createSync(recursive: true);
    final save = File('${local.path}/game.srm')..writeAsStringSync('hours-of-progress');
    final slots = [SaveSlot(index: 0, path: local.path, template: 'retroarch')];

    final result = await service().pull(install(), slots);

    expect(result.outcome, SavePullOutcome.conflict);
    expect(result.serverHead?.version, 3);
    expect(saveDownloads, 0);
    expect(save.readAsStringSync(), 'hours-of-progress');
  });

  test('a never-synced install without saves takes the server head', () async {
    final local = Directory('${tmp.path}/local/saves')..createSync(recursive: true);
    final slots = [SaveSlot(index: 0, path: local.path, template: 'retroarch')];
    final game = install();

    final result = await service().pull(game, slots);

    expect(result.outcome, SavePullOutcome.downloaded);
    expect(File('${local.path}/game.srm').readAsStringSync(), 'from-the-server');
    expect(game.lastSaveVersion, 3);
    expect(game.lastSaveSha, isNotNull);
  });

  test('unchanged since the last sync takes the newer head; changed is a conflict',
      () async {
    final local = Directory('${tmp.path}/local/saves')..createSync(recursive: true);
    final save = File('${local.path}/game.srm')..writeAsStringSync('synced');
    final slots = [SaveSlot(index: 0, path: local.path, template: 'retroarch')];
    final synced = await SaveSnapshot.fingerprint(slots);

    final changed = await service()
        .pull(install(lastSaveSha: 'something-else', lastSaveVersion: 2), slots);
    expect(changed.outcome, SavePullOutcome.conflict);
    expect(save.readAsStringSync(), 'synced');

    final unchanged = await service()
        .pull(install(lastSaveSha: synced, lastSaveVersion: 2), slots);
    expect(unchanged.outcome, SavePullOutcome.downloaded);
    expect(save.readAsStringSync(), 'from-the-server');
  });

  test('a head this device already has is up to date', () async {
    final local = Directory('${tmp.path}/local/saves')..createSync(recursive: true);
    final slots = [SaveSlot(index: 0, path: local.path, template: 'retroarch')];
    final result = await service().pull(install(lastSaveVersion: 3), slots);
    expect(result.outcome, SavePullOutcome.upToDate);
    expect(saveDownloads, 0);
  });
}
