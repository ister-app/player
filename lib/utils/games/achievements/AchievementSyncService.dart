import 'dart:convert';
import 'dart:io';

import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/games/GameApi.dart';
import 'package:player/utils/games/GameInstallStore.dart';

import 'AchievementReport.dart';

/// Sends what the readers found to the server, once per change: the last
/// reported set is remembered per game (`achievements.json` in the install
/// dir) so an unchanged session costs no request, and icons go up only the
/// first time a definition is seen.
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
    final unlockedNow = report.achievements.where((a) => a.unlockedAt != null).map((a) => a.externalId).toSet();
    final knownNow = report.achievements.map((a) => a.externalId).toSet();
    final newlyUnlocked = report.achievements
        .where((a) => a.unlockedAt != null && !previousUnlocked.contains(a.externalId))
        .toList();
    final unchanged = previous['source'] == report.source &&
        setEquals(previousUnlocked, unlockedNow) &&
        setEquals(previousKnown, knownNow);
    if (unchanged) return const [];

    await api.reportAchievements(install.gameId, {
      'source': report.source,
      'deviceName': deviceName,
      'achievements': [for (final a in report.achievements) a.toJson()],
    });
    for (final achievement in report.achievements) {
      final icon = achievement.iconPng;
      if (icon == null || previousKnown.contains(achievement.externalId)) continue;
      try {
        await api.uploadAchievementIcon(install.gameId, report.source, achievement.externalId, icon);
      } catch (e) {
        LoggerService().logger.w('Achievement icon upload failed: $e');
      }
    }
    await stateFile.parent.create(recursive: true);
    await stateFile.writeAsString(jsonEncode({
      'source': report.source,
      'known': knownNow.toList()..sort(),
      'unlocked': unlockedNow.toList()..sort(),
      'reportedAt': DateTime.now().toUtc().toIso8601String(),
    }), flush: true);
    return newlyUnlocked;
  }

  static bool setEquals(Set<String> a, Set<String> b) => a.length == b.length && a.containsAll(b);
}
