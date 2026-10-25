import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:image/image.dart' as img;
import 'package:player/utils/games/achievements/SteamAchievementReader.dart';

/// Builds a binary KeyValues document the way Steam writes them.
class _Kv {
  final BytesBuilder _b = BytesBuilder();
  void _key(int type, String key) {
    _b.addByte(type);
    _b.add(utf8.encode(key));
    _b.addByte(0);
  }
  void begin(String key) => _key(0x00, key);
  void end() => _b.addByte(0x08);
  void string(String key, String value) {
    _key(0x01, key);
    _b.add(utf8.encode(value));
    _b.addByte(0);
  }
  void int32(String key, int value) {
    _key(0x02, key);
    _b.add((ByteData(4)..setInt32(0, value, Endian.little)).buffer.asUint8List());
  }
  Uint8List bytes() => _b.toBytes();
}

const _appId = 2950340;
const _accountId = 76873423;

void _achievement(_Kv kv, String bit, String name, String icon, String iconGray) => kv
  ..begin(bit)
  ..string('name', name)
  ..begin('display')
  ..string('name', name)
  ..string('icon', icon)
  ..string('icon_gray', iconGray)
  ..end()
  ..end();

void main() {
  late Directory steamRoot;
  late Directory cacheDir;

  setUp(() async {
    steamRoot = await Directory.systemTemp.createTemp('steam_root');
    cacheDir = Directory('${steamRoot.path}/install/achievement-icons');
    final stats = Directory('${steamRoot.path}/appcache/stats')..createSync(recursive: true);
    final schema = _Kv()
      ..begin('$_appId')
      ..begin('stats')
      ..begin('1')
      ..string('type', '4')
      ..begin('bits');
    _achievement(schema, '0', 'ACH_UNLOCKED', 'aaa.jpg', 'aaa_gray.jpg');
    _achievement(schema, '1', 'ACH_LOCKED', 'bbb.jpg', 'bbb_gray.jpg');
    _achievement(schema, '2', 'ACH_TRAVERSAL', '../../etc/passwd', '../x.jpg');
    schema
      ..end()
      ..end()
      ..end()
      ..end()
      ..end();
    File('${stats.path}/UserGameStatsSchema_$_appId.bin').writeAsBytesSync(schema.bytes());
    final userStats = _Kv()
      ..begin('$_accountId')
      ..begin('cache')
      ..begin('1')
      ..begin('AchievementTimes')
      ..int32('0', 1700000000)
      ..end()
      ..end()
      ..end()
      ..end();
    File('${stats.path}/UserGameStats_${_accountId}_$_appId.bin').writeAsBytesSync(userStats.bytes());
  });

  tearDown(() => steamRoot.delete(recursive: true));

  final jpeg = img.encodeJpg(img.Image(width: 4, height: 4));

  test('fetches the CDN icon matching the unlock state and converts it to PNG', () async {
    final requested = <String>[];
    final client = MockClient((request) async {
      requested.add(request.url.toString());
      return http.Response.bytes(jpeg, 200, headers: {'content-type': 'image/jpeg'});
    });
    final report = await SteamAchievementReader(steamRoot: steamRoot, iconCacheDir: cacheDir, client: client)
        .read(_appId, _accountId);

    expect(requested, unorderedEquals([
      'https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/apps/$_appId/aaa.jpg',
      'https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/apps/$_appId/bbb_gray.jpg',
    ]));
    final byId = {for (final a in report!.achievements) a.externalId: a};
    expect(byId['ACH_UNLOCKED']!.unlockedAt, isNotNull);
    for (final id in ['ACH_UNLOCKED', 'ACH_LOCKED']) {
      final png = byId[id]!.iconPng!;
      expect(png.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);
      expect(img.decodePng(Uint8List.fromList(png))!.width, 4);
    }
    expect(byId['ACH_TRAVERSAL']!.iconPng, isNull);
  });

  test('serves icons from the cache directory on the next read', () async {
    var requests = 0;
    MockClient client() => MockClient((request) async {
          requests++;
          return http.Response.bytes(jpeg, 200);
        });
    await SteamAchievementReader(steamRoot: steamRoot, iconCacheDir: cacheDir, client: client()).read(_appId, _accountId);
    expect(requests, 2);
    final report =
        await SteamAchievementReader(steamRoot: steamRoot, iconCacheDir: cacheDir, client: client()).read(_appId, _accountId);
    expect(requests, 2);
    expect(report!.achievements.where((a) => a.iconPng != null), hasLength(2));
  });

  test('a failing CDN leaves the icon out but still reports the achievements', () async {
    final client = MockClient((request) async => http.Response('nope', 404));
    final report = await SteamAchievementReader(steamRoot: steamRoot, iconCacheDir: cacheDir, client: client)
        .read(_appId, _accountId);
    expect(report!.achievements, hasLength(3));
    expect(report.achievements.every((a) => a.iconPng == null), isTrue);
    expect(cacheDir.existsSync(), isFalse);
  });
}
