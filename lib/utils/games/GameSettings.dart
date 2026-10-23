import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This device's game settings: where games are installed, which emulator
/// binaries to use when auto-detection picks the wrong one (or none), and the
/// save-sync switches. Device-local on purpose: another machine has other
/// emulators in other places.
class GameSettings {
  GameSettings._();

  static const _kGamesRoot = 'games.root';
  static const _kEmulatorPath = 'games.emulator.'; // + kind
  static const _kCoreOverride = 'games.retroarch.core.'; // + platform
  static const _kSaveSync = 'games.save_sync';
  static const _kAchievementSync = 'games.achievement_sync';
  static const _kUploadSources = 'games.upload_sources';

  static SharedPreferencesAsync get _prefs => SharedPreferencesAsync();

  /// The folder games are installed under. Defaults to a place other
  /// applications (Flatpak emulators in particular) can read: `~/Games/Ister`
  /// on Linux, `%LOCALAPPDATA%\Ister\Games` on Windows.
  static Future<Directory> gamesRoot() async {
    final configured = await _prefs.getString(_kGamesRoot);
    if (configured != null && configured.isNotEmpty) {
      return Directory(configured);
    }
    return Directory(await defaultGamesRoot());
  }

  static Future<String> defaultGamesRoot() async {
    if (!kIsWeb && Platform.isLinux) {
      final home = Platform.environment['HOME'];
      if (home != null && home.isNotEmpty) return '$home/Games/Ister';
    }
    if (!kIsWeb && Platform.isWindows) {
      final local = Platform.environment['LOCALAPPDATA'];
      if (local != null && local.isNotEmpty) return '$local\\Ister\\Games';
    }
    return '${(await getApplicationSupportDirectory()).path}/games';
  }

  static Future<void> setGamesRoot(String? path) =>
      path == null || path.isEmpty ? _prefs.remove(_kGamesRoot) : _prefs.setString(_kGamesRoot, path);

  /// An explicit executable (or `flatpak:<app id>`) for an emulator kind
  /// (`retroarch`, `rpcs3`, `steam`); null = auto-detect.
  static Future<String?> emulatorPath(String kind) => _prefs.getString('$_kEmulatorPath$kind');

  static Future<void> setEmulatorPath(String kind, String? path) => path == null || path.isEmpty
      ? _prefs.remove('$_kEmulatorPath$kind')
      : _prefs.setString('$_kEmulatorPath$kind', path);

  /// A libretro core name overriding the server's default for a platform
  /// (no UI yet; set by hand in the preferences for a core the server does
  /// not know).
  static Future<String?> coreOverride(String platform) => _prefs.getString('$_kCoreOverride$platform');

  static Future<bool> saveSyncEnabled() async => (await _prefs.getBool(_kSaveSync)) ?? true;

  static Future<void> setSaveSyncEnabled(bool value) => _prefs.setBool(_kSaveSync, value);

  static Future<bool> achievementSyncEnabled() async => (await _prefs.getBool(_kAchievementSync)) ?? true;

  static Future<void> setAchievementSyncEnabled(bool value) => _prefs.setBool(_kAchievementSync, value);

  /// The folders the upload page searches for games on this computer, as the
  /// user set them; empty = the defaults.
  static Future<List<String>> uploadSourceFolders() async => (await _prefs.getStringList(_kUploadSources)) ?? const [];

  static Future<void> setUploadSourceFolders(List<String> folders) =>
      folders.isEmpty ? _prefs.remove(_kUploadSources) : _prefs.setStringList(_kUploadSources, folders);

  /// Where people usually keep their games: `~/Games`, `~/ROMs`, EmuDeck's
  /// `~/Emulation/roms` on Linux, `%USERPROFILE%\Games` on Windows. Only the
  /// ones that exist. Steam libraries are not in here — `SteamLibraryLocator`
  /// finds them from Steam's own files.
  static List<String> defaultUploadSourceFolders({Map<String, String>? environment, bool Function(String)? exists}) {
    if (kIsWeb) return const [];
    final env = environment ?? Platform.environment;
    final candidates = <String>[];
    if (Platform.isWindows) {
      final profile = env['USERPROFILE'];
      if (profile != null && profile.isNotEmpty) candidates.add('$profile\\Games');
    } else {
      final home = env['HOME'];
      if (home != null && home.isNotEmpty) {
        candidates.addAll(['$home/Games', '$home/ROMs', '$home/roms', '$home/Emulation/roms']);
      }
    }
    final check = exists ?? (path) => Directory(path).existsSync();
    return [for (final c in candidates) if (check(c)) c];
  }

  /// The user's list when set, else the defaults — minus anything inside the
  /// folder Ister installs games into itself (a folder *containing* it stays;
  /// the scanner skips the install root, see [isWithin]).
  static Future<List<String>> effectiveUploadSourceFolders() async {
    final configured = await uploadSourceFolders();
    final folders = configured.isNotEmpty ? configured : defaultUploadSourceFolders();
    final root = (await gamesRoot()).path;
    return [for (final f in folders) if (!isWithin(f, root)) f];
  }

  /// Whether [path] is [ancestor] or lies under it (separator- and case-insensitive).
  static bool isWithin(String path, String ancestor) {
    String norm(String p) => p.replaceAll('\\', '/').replaceAll(RegExp(r'/+$'), '').toLowerCase();
    final a = norm(path);
    final b = norm(ancestor);
    return a == b || a.startsWith('$b/');
  }
}
