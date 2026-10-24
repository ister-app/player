import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/utils/games/GameApi.dart';
import 'package:player/utils/games/GameInstallStore.dart';
import 'package:player/utils/games/achievements/AchievementReport.dart';
import 'package:player/utils/games/achievements/AchievementSyncService.dart';

void main() {
  late Directory tmp;
  late List<String> iconUploads;
  late int reports;
  late AchievementSyncService service;
  late GameInstall install;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('ister-achievements-');
    iconUploads = [];
    reports = 0;
    final client = MockClient((request) async {
      if (request.url.path.endsWith('/icon')) {
        iconUploads.add('${request.url.pathSegments[request.url.pathSegments.length - 2]}:${request.bodyBytes.first}');
      } else {
        reports++;
      }
      return http.Response('{}', 200);
    });
    service = AchievementSyncService(
      api: GameApi('http://srv', httpClient: client, bearer: (_) async => 'b'),
      deviceName: 'test',
    );
    install = GameInstall(
      gameId: 'g1',
      form: 'PS3_FOLDER',
      platform: 'PS3',
      dir: '${tmp.path}/g1',
      status: GameInstallStatus.installed,
    );
  });

  tearDown(() async {
    await tmp.delete(recursive: true);
  });

  AchievementReport set(int iconByte, {int count = 2}) => AchievementReport(source: 'PS3_TROPHY', achievements: [
        for (var i = 0; i < count; i++)
          ReportedAchievement(externalId: '$i', name: 'Trophy $i', iconPng: [iconByte, i]),
      ]);

  test('an unchanged set sends nothing the second time', () async {
    await service.sync(install, set(1));
    expect(iconUploads, ['0:1', '1:1']);
    expect(reports, 1);
    await service.sync(install, set(1));
    expect(iconUploads, hasLength(2));
    expect(reports, 1);
  });

  test('another set reusing the same trophy ids re-sends its icons', () async {
    // Red Dead Redemption's set once credited to Fat Princess: same ids, other pictures.
    await service.sync(install, set(1));
    await service.sync(install, set(2));
    expect(iconUploads, ['0:1', '1:1', '0:2', '1:2']);
    expect(reports, 2);
  });

  test('a state file from before icons were tracked re-sends every icon once', () async {
    await Directory(install.dir).create(recursive: true);
    await File('${install.dir}/achievements.json')
        .writeAsString('{"source":"PS3_TROPHY","known":["0","1"],"unlocked":[]}');
    await service.sync(install, set(2));
    expect(iconUploads, ['0:2', '1:2']);
    await service.sync(install, set(2));
    expect(iconUploads, hasLength(2));
  });
}
