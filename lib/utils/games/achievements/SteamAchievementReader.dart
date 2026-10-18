import 'dart:io';
import 'dart:typed_data';

import 'AchievementReport.dart';
import 'BinaryKeyValues.dart';

/// Reads a Steam game's achievements from Steam's local stats cache, without
/// the Web API: `appcache/stats/UserGameStatsSchema_<appid>.bin` defines them
/// (stat type 4 = achievement bits with display name/desc/icon/hidden), and
/// `UserGameStats_<accountid>_<appid>.bin` holds, per stat id, the
/// `AchievementTimes` map of bit index → unix unlock time. Steam writes the
/// latter when the game exits / on sync, so read after the session ended.
/// The format is Valve's, undocumented and observed: everything here is
/// best effort and returns an empty report rather than failing.
class SteamAchievementReader {
  SteamAchievementReader({required this.steamRoot});

  final Directory steamRoot;

  File schemaFile(int appId) => File('${steamRoot.path}${Platform.pathSeparator}appcache${Platform.pathSeparator}stats${Platform.pathSeparator}UserGameStatsSchema_$appId.bin');

  File statsFile(int accountId, int appId) => File('${steamRoot.path}${Platform.pathSeparator}appcache${Platform.pathSeparator}stats${Platform.pathSeparator}UserGameStats_${accountId}_$appId.bin');

  Future<AchievementReport?> read(int appId, int? accountId) async {
    final schema = schemaFile(appId);
    if (!await schema.exists()) return null;
    Map<String, Object> schemaRoot;
    try {
      schemaRoot = BinaryKeyValues.parse(await schema.readAsBytes());
    } catch (_) {
      return null;
    }
    final app = BinaryKeyValues.child(schemaRoot, '$appId') ?? schemaRoot.values.whereType<Map<String, Object>>().firstOrNull;
    final stats = app == null ? null : BinaryKeyValues.child(app, 'stats');
    if (stats == null) return null;

    Map<String, Object>? cache;
    if (accountId != null) {
      final statsBin = statsFile(accountId, appId);
      if (await statsBin.exists()) {
        try {
          final root = BinaryKeyValues.parse(await statsBin.readAsBytes());
          cache = BinaryKeyValues.child(root, 'cache') ??
              root.values.whereType<Map<String, Object>>().map((m) => BinaryKeyValues.child(m, 'cache')).whereType<Map<String, Object>>().firstOrNull;
        } catch (_) {
          cache = null;
        }
      }
    }

    final achievements = <ReportedAchievement>[];
    var order = 0;
    for (final statEntry in stats.entries) {
      final stat = statEntry.value;
      if (stat is! Map<String, Object>) continue;
      final type = BinaryKeyValues.get(stat, 'type')?.toString();
      if (type != '4' && type?.toUpperCase() != 'ACHIEVEMENTS') continue;
      final bits = BinaryKeyValues.child(stat, 'bits');
      if (bits == null) continue;
      final times = cache == null ? null : BinaryKeyValues.child(BinaryKeyValues.child(cache, statEntry.key) ?? const {}, 'AchievementTimes');
      for (final bitEntry in bits.entries) {
        final bit = bitEntry.value;
        if (bit is! Map<String, Object>) continue;
        final apiName = BinaryKeyValues.string(bit, 'name');
        if (apiName == null || apiName.isEmpty) continue;
        final display = BinaryKeyValues.child(bit, 'display') ?? const <String, Object>{};
        final unlockedRaw = times == null ? null : BinaryKeyValues.get(times, bitEntry.key);
        final unlockedSeconds = unlockedRaw is int ? unlockedRaw : int.tryParse(unlockedRaw?.toString() ?? '');
        final hidden = BinaryKeyValues.string(display, 'hidden') == '1';
        achievements.add(ReportedAchievement(
          externalId: apiName,
          name: BinaryKeyValues.string(display, 'name') ?? apiName,
          description: BinaryKeyValues.string(display, 'desc'),
          hidden: hidden,
          sortOrder: order++,
          unlockedAt: unlockedSeconds != null && unlockedSeconds > 0
              ? DateTime.fromMillisecondsSinceEpoch(unlockedSeconds * 1000, isUtc: true)
              : null,
          iconPng: await _icon(appId, BinaryKeyValues.string(display, unlockedSeconds != null && unlockedSeconds > 0 ? 'icon' : 'icon_gray')),
        ));
      }
    }
    if (achievements.isEmpty) return null;
    return AchievementReport(source: 'STEAM', achievements: achievements);
  }

  /// Achievement icons Steam already cached under `appcache/librarycache`;
  /// only PNG-looking files are used (the server stores icons as PNG).
  Future<Uint8List?> _icon(int appId, String? iconName) async {
    if (iconName == null || iconName.isEmpty) return null;
    final candidates = [
      '${steamRoot.path}/appcache/librarycache/$appId/$iconName',
      '${steamRoot.path}/appcache/librarycache/${appId}_$iconName',
    ];
    for (final path in candidates) {
      final file = File(path.replaceAll('/', Platform.pathSeparator));
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        if (bytes.length > 8 && bytes[0] == 0x89 && bytes[1] == 0x50) return bytes;
      }
    }
    return null;
  }
}
