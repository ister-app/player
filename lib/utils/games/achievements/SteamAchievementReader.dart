import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

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
///
/// Steam keeps no achievement icons on disk (its client shows them from the
/// CDN), and the schema names them `<sha1>.jpg`; they are fetched from the
/// community CDN, converted to PNG and kept in [iconCacheDir], so each icon
/// costs one request per install.
class SteamAchievementReader {
  SteamAchievementReader({required this.steamRoot, this.iconCacheDir, this.client});

  final Directory steamRoot;
  final Directory? iconCacheDir;
  final http.Client? client;

  static const _cdnBase = 'https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/apps';
  static const _parallelIconFetches = 6;
  static final _iconName = RegExp(r'^[A-Za-z0-9_.-]+$');

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

    final found = <(ReportedAchievement, String?)>[];
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
        final unlocked = unlockedSeconds != null && unlockedSeconds > 0;
        final hidden = BinaryKeyValues.string(display, 'hidden') == '1';
        found.add((
          ReportedAchievement(
            externalId: apiName,
            name: BinaryKeyValues.string(display, 'name') ?? apiName,
            description: BinaryKeyValues.string(display, 'desc'),
            hidden: hidden,
            sortOrder: order++,
            unlockedAt: unlocked ? DateTime.fromMillisecondsSinceEpoch(unlockedSeconds * 1000, isUtc: true) : null,
          ),
          BinaryKeyValues.string(display, unlocked ? 'icon' : 'icon_gray'),
        ));
      }
    }
    final icons = await _icons(appId, found.map((f) => f.$2).toList());
    final achievements = [
      for (var i = 0; i < found.length; i++)
        icons[i] == null ? found[i].$1 : found[i].$1.withIcon(icons[i]!),
    ];
    if (achievements.isEmpty) return null;
    return AchievementReport(source: 'STEAM', achievements: achievements);
  }

  /// Resolves [names] in order, a few CDN fetches at a time.
  Future<List<Uint8List?>> _icons(int appId, List<String?> names) async {
    final result = List<Uint8List?>.filled(names.length, null);
    final client = this.client ?? http.Client();
    try {
      var next = 0;
      Future<void> worker() async {
        while (next < names.length) {
          final i = next++;
          result[i] = await _icon(client, appId, names[i]);
        }
      }
      await Future.wait([for (var w = 0; w < _parallelIconFetches; w++) worker()]);
    } finally {
      if (this.client == null) client.close();
    }
    return result;
  }

  /// One icon as PNG: from Steam's own library cache when it happens to have
  /// it, else from [iconCacheDir], else from the CDN (then cached).
  Future<Uint8List?> _icon(http.Client client, int appId, String? iconName) async {
    if (iconName == null || !_iconName.hasMatch(iconName) || iconName.startsWith('.')) return null;
    final candidates = [
      '${steamRoot.path}/appcache/librarycache/$appId/$iconName',
      '${steamRoot.path}/appcache/librarycache/${appId}_$iconName',
    ];
    for (final path in candidates) {
      final file = File(path.replaceAll('/', Platform.pathSeparator));
      if (await file.exists()) {
        final png = toPng(await file.readAsBytes());
        if (png != null) return png;
      }
    }
    final cached = iconCacheDir == null ? null : File('${iconCacheDir!.path}${Platform.pathSeparator}$appId-$iconName.png');
    if (cached != null && await cached.exists()) return cached.readAsBytes();
    try {
      final response = await client.get(Uri.parse('$_cdnBase/$appId/$iconName')).timeout(const Duration(seconds: 20));
      if (response.statusCode != 200) return null;
      final png = toPng(response.bodyBytes);
      if (png != null && cached != null) {
        await cached.parent.create(recursive: true);
        await cached.writeAsBytes(png, flush: true);
      }
      return png;
    } catch (_) {
      return null;
    }
  }

  /// [bytes] as PNG (the server stores icons as PNG): passed through when they
  /// already are, decoded and re-encoded otherwise; null when unreadable.
  static Uint8List? toPng(Uint8List bytes) {
    if (bytes.length > 8 && bytes[0] == 0x89 && bytes[1] == 0x50) return bytes;
    try {
      final decoded = img.decodeImage(bytes);
      return decoded == null ? null : img.encodePng(decoded);
    } catch (_) {
      return null;
    }
  }
}
