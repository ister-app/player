import 'dart:io';
import 'dart:typed_data';

import 'package:xml/xml.dart';

import 'AchievementReport.dart';

/// Reads a PS3 game's trophies from RPCS3's trophy folder
/// (`dev_hdd0/home/00000001/trophy/<NPCOMMID>/`): `TROPCONF.SFM` is the XML
/// definition list (id, grade, hidden, name, detail), `TROPUSR.DAT` the
/// per-user state — a big-endian table file whose type-6 entries carry the
/// unlock flag and timestamps per trophy (layout from RPCS3's TROPUSR.h), and
/// `TROP<NNN>.PNG` the icons.
class Ps3TrophyReader {
  Ps3TrophyReader({required this.rpcs3Config, this.userId = '00000001'});

  final Directory rpcs3Config;
  final String userId;

  Directory get trophyRoot => Directory('${rpcs3Config.path}${Platform.pathSeparator}dev_hdd0${Platform.pathSeparator}home${Platform.pathSeparator}$userId${Platform.pathSeparator}trophy');

  /// The trophy folders that belong to a game: the ones whose TROPCONF.SFM
  /// names the title id, or (older dumps) every folder when none does.
  Future<List<Directory>> foldersFor(String? titleId) async {
    if (!await trophyRoot.exists()) return const [];
    final all = <Directory>[];
    final matching = <Directory>[];
    await for (final entity in trophyRoot.list()) {
      if (entity is! Directory) continue;
      final conf = File('${entity.path}${Platform.pathSeparator}TROPCONF.SFM');
      if (!await conf.exists()) continue;
      all.add(entity);
      if (titleId != null) {
        try {
          final text = await conf.readAsString();
          if (text.contains(titleId)) matching.add(entity);
        } catch (_) {}
      }
    }
    return matching.isNotEmpty ? matching : all;
  }

  Future<AchievementReport?> read(Directory folder) async {
    final conf = File('${folder.path}${Platform.pathSeparator}TROPCONF.SFM');
    final usr = File('${folder.path}${Platform.pathSeparator}TROPUSR.DAT');
    if (!await conf.exists()) return null;
    final XmlDocument xml;
    try {
      xml = XmlDocument.parse(await conf.readAsString());
    } catch (_) {
      return null;
    }
    final unlocks = await usr.exists() ? parseTropUsr(await usr.readAsBytes()) : const <int, DateTime?>{};
    final achievements = <ReportedAchievement>[];
    var order = 0;
    for (final trophy in xml.findAllElements('trophy')) {
      final id = int.tryParse(trophy.getAttribute('id') ?? '');
      if (id == null) continue;
      final grade = switch ((trophy.getAttribute('ttype') ?? '').toUpperCase()) {
        'B' => 'BRONZE',
        'S' => 'SILVER',
        'G' => 'GOLD',
        'P' => 'PLATINUM',
        _ => null,
      };
      final icon = File('${folder.path}${Platform.pathSeparator}TROP${id.toString().padLeft(3, '0')}.PNG');
      achievements.add(ReportedAchievement(
        externalId: '$id',
        name: trophy.getElement('name')?.innerText.trim() ?? 'Trophy $id',
        description: trophy.getElement('detail')?.innerText.trim(),
        grade: grade,
        hidden: (trophy.getAttribute('hidden') ?? 'no').toLowerCase() == 'yes',
        sortOrder: order++,
        unlockedAt: unlocks.containsKey(id) ? unlocks[id] : null,
        iconPng: await icon.exists() ? await icon.readAsBytes() : null,
      ));
    }
    if (achievements.isEmpty) return null;
    return AchievementReport(source: 'PS3_TROPHY', achievements: achievements);
  }

  /// Trophy id → unlock time for the unlocked trophies in a TROPUSR.DAT.
  /// Header 48 bytes (magic 0x818F54AD, u32 table count at +8), then 32-byte
  /// table headers (type u32, entry size u32, unk, count u32, offset u64);
  /// type-6 entries: 16-byte header, trophy_id u32, trophy_state u32, 2×u32,
  /// timestamp1 u64, timestamp2 u64. Everything big-endian.
  static Map<int, DateTime?> parseTropUsr(Uint8List bytes) {
    final result = <int, DateTime?>{};
    if (bytes.length < 48) return result;
    final data = ByteData.sublistView(bytes);
    if (data.getUint32(0, Endian.big) != 0x818F54AD) return result;
    final tables = data.getUint32(8, Endian.big);
    for (var t = 0; t < tables && 48 + (t + 1) * 32 <= bytes.length; t++) {
      final header = 48 + t * 32;
      final type = data.getUint32(header, Endian.big);
      final entrySize = data.getUint32(header + 4, Endian.big);
      final count = data.getUint32(header + 12, Endian.big);
      final offset = data.getUint64(header + 16, Endian.big);
      if (type != 6) continue;
      // The table header's entry size excludes the 16-byte entry header
      // (RPCS3 writes sizeof(entry) - 0x10); a type-6 entry is 0x70 bytes.
      final stride = entrySize > 0 ? entrySize + 0x10 : 0x70;
      for (var i = 0; i < count; i++) {
        final entry = offset + i * stride;
        if (entry + 48 > bytes.length) break;
        final trophyId = data.getUint32(entry + 16, Endian.big);
        final state = data.getUint32(entry + 20, Endian.big);
        if (state == 0) continue;
        final timestamp = data.getUint64(entry + 40, Endian.big); // timestamp2
        final fallback = data.getUint64(entry + 32, Endian.big);
        final micros = timestamp != 0 ? timestamp : fallback;
        // RPCS3 stores microseconds since the epoch; older files seconds.
        DateTime? when;
        if (micros > 0) {
          when = micros > 100000000000000
              ? DateTime.fromMicrosecondsSinceEpoch(micros, isUtc: true)
              : micros > 100000000000
                  ? DateTime.fromMillisecondsSinceEpoch(micros, isUtc: true)
                  : DateTime.fromMillisecondsSinceEpoch(micros * 1000, isUtc: true);
        }
        result[trophyId] = when;
      }
    }
    return result;
  }
}
