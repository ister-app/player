import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/games/GameApi.dart';
import 'package:player/utils/games/GameInstallStore.dart';

import 'AchievementReport.dart';

/// Sends what the readers found to the server, once per change: the last
/// reported set is remembered per game (`achievements.json` in the install
/// dir) so an unchanged session costs no request, and an icon goes up only
/// when its bytes differ from the last ones uploaded for that id. Keyed by
/// content, not by "id seen before": PS3 trophy ids are 0, 1, 2… in every
/// set, so after a wrong set (Red Dead Redemption's, credited to Fat Princess
/// by an older build) the right one reuses the ids, the server updates the
/// definitions in place and keeps the wrong icons unless they are re-sent.
class AchievementSyncService {
  AchievementSyncService({required this.api, required this.deviceName});

  final GameApi api;
  final String deviceName;

  /// Returns the newly unlocked achievements (for a toast), or empty.
  Future<List<ReportedAchievement>> sync(GameInstall install, AchievementReport report) async {
    final stateFile = File('${install.dir}${Platform.pathSeparator}achievements.json');
    Map<String, dynamic> previous = const {};
    if (await stateFile.exists()) {
      try {
        previous = (jsonDecode(await stateFile.readAsString()) as Map).cast<String, dynamic>();
      } catch (_) {}
    }
    final previousUnlocked = ((previous['unlocked'] as List?) ?? const []).cast<String>().toSet();
    final previousKnown = ((previous['known'] as List?) ?? const []).cast<String>().toSet();
    final previousIcons = ((previous['icons'] as Map?) ?? const {}).cast<String, dynamic>();
    final unlockedNow = report.achievements.where((a) => a.unlockedAt != null).map((a) => a.externalId).toSet();
    final knownNow = report.achievements.map((a) => a.externalId).toSet();
    final newlyUnlocked = report.achievements
        .where((a) => a.unlockedAt != null && !previousUnlocked.contains(a.externalId))
        .toList();
    final iconsNow = {
      for (final a in report.achievements)
        if (a.iconPng != null) a.externalId: sha256.convert(a.iconPng!).toString(),
    };
    final iconsSent = previous['source'] == report.source ? previousIcons : const <String, dynamic>{};
    final unchanged = previous['source'] == report.source &&
        setEquals(previousUnlocked, unlockedNow) &&
        setEquals(previousKnown, knownNow) &&
        iconsNow.entries.every((e) => iconsSent[e.key] == e.value);
    if (unchanged) return const [];

    await api.reportAchievements(install.gameId, {
      'source': report.source,
      'deviceName': deviceName,
      'achievements': [for (final a in report.achievements) a.toJson()],
      'complete': report.complete,
    });
    final iconsUploaded = <String, String>{};
    for (final achievement in report.achievements) {
      final icon = achievement.iconPng;
      final hash = iconsNow[achievement.externalId];
      if (icon == null || hash == null) continue;
      if (iconsSent[achievement.externalId] == hash) {
        iconsUploaded[achievement.externalId] = hash;
        continue;
      }
      try {
        await api.uploadAchievementIcon(install.gameId, report.source, achievement.externalId, icon);
        iconsUploaded[achievement.externalId] = hash;
      } catch (e) {
        // Not recorded, so the next session tries again.
        LoggerService().logger.w('Achievement icon upload failed: $e');
      }
    }
    await stateFile.parent.create(recursive: true);
    await stateFile.writeAsString(jsonEncode({
      'source': report.source,
      'known': knownNow.toList()..sort(),
      'unlocked': unlockedNow.toList()..sort(),
      'icons': iconsUploaded,
      'reportedAt': DateTime.now().toUtc().toIso8601String(),
    }), flush: true);
    return newlyUnlocked;
  }

  static bool setEquals(Set<String> a, Set<String> b) => a.length == b.length && a.containsAll(b);
}
