import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/upload/games/SteamAppManifest.dart';

String acf({int appid = 620, String name = 'Portal 2', String dir = 'Portal 2', int flags = 4, int? size = 12345}) => '''
"AppState"
{
\t"appid"\t\t"$appid"
\t"name"\t\t"$name"
\t"StateFlags"\t\t"$flags"
\t"installdir"\t\t"$dir"
${size == null ? '' : '\t"SizeOnDisk"\t\t"$size"'}
}
''';

void main() {
  test('reads the fields the scanner needs', () {
    final m = SteamAppManifest.parse(acf())!;
    expect(m.appId, 620);
    expect(m.name, 'Portal 2');
    expect(m.installDir, 'Portal 2');
    expect(m.sizeOnDisk, 12345);
    expect(m.isFullyInstalled, isTrue);
    expect(m.isRuntimeOrRedist, isFalse);
  });

  test('a game mid-update is not fully installed', () {
    expect(SteamAppManifest.parse(acf(flags: 1026))!.isFullyInstalled, isFalse);
    expect(SteamAppManifest.parse(acf(flags: 6))!.isFullyInstalled, isFalse);
  });

  test('runtimes and redistributables are no games', () {
    expect(SteamAppManifest.parse(acf(appid: 228980, name: 'Steamworks Common Redistributables'))!.isRuntimeOrRedist, isTrue);
    expect(SteamAppManifest.parse(acf(appid: 1, name: 'Proton 9.0', dir: 'Proton 9.0'))!.isRuntimeOrRedist, isTrue);
    expect(SteamAppManifest.parse(acf(appid: 2, name: 'Steam Linux Runtime 3.0 (sniper)', dir: 'SteamLinuxRuntime_sniper'))!.isRuntimeOrRedist, isTrue);
    expect(SteamAppManifest.parse(acf(appid: 3, name: 'Legacy Steam Runtime', dir: 'LegacySteamRuntime'))!.isRuntimeOrRedist, isTrue);
    expect(SteamAppManifest.parse(acf(appid: 250820, name: 'SteamVR', dir: 'SteamVR'))!.isRuntimeOrRedist, isTrue);
  });

  test('a manifest without appid or installdir, or garbage, is null', () {
    expect(SteamAppManifest.parse('"AppState" { "name" "x" }'), isNull);
    expect(SteamAppManifest.parse('{{{'), isNull);
    expect(SteamAppManifest.parse(acf(size: null))!.sizeOnDisk, isNull);
  });
}
