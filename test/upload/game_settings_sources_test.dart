import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/games/GameSettings.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() => SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty());

  test('defaults are the usual game folders that exist', () {
    final folders = GameSettings.defaultUploadSourceFolders(
      environment: {'HOME': '/home/u'},
      exists: (p) => p == '/home/u/Games' || p == '/home/u/Emulation/roms',
    );
    expect(folders, Platform.isWindows ? isEmpty : ['/home/u/Games', '/home/u/Emulation/roms']);
  });

  test("the user's list wins, minus anything inside Ister's install root", () async {
    await GameSettings.setGamesRoot('/data/ister-games');
    await GameSettings.setUploadSourceFolders(['/data/roms', '/data/ister-games/snes', '/data/ister-games']);
    expect(await GameSettings.effectiveUploadSourceFolders(), ['/data/roms']);
    expect(await GameSettings.uploadSourceFolders(), ['/data/roms', '/data/ister-games/snes', '/data/ister-games']);

    await GameSettings.setUploadSourceFolders(const []);
    expect(await GameSettings.uploadSourceFolders(), isEmpty, reason: 'empty list = back to the defaults');
  });

  test('isWithin is separator- and case-insensitive', () {
    expect(GameSettings.isWithin(r'C:\Games\Ister\x', 'c:/games/ister/'), isTrue);
    expect(GameSettings.isWithin('/a/b', '/a/b'), isTrue);
    expect(GameSettings.isWithin('/a/bc', '/a/b'), isFalse);
  });
}
