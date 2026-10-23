/// One achievement as the client will report it to the server.
class ReportedAchievement {
  const ReportedAchievement({
    required this.externalId,
    required this.name,
    this.description,
    this.grade,
    this.hidden = false,
    this.sortOrder = 0,
    this.unlockedAt,
    this.iconPng,
  });

  final String externalId;
  final String name;
  final String? description;
  final String? grade;
  final bool hidden;
  final int sortOrder;
  final DateTime? unlockedAt;

  /// Icon bytes to upload separately, when the reader found one.
  final List<int>? iconPng;

  Map<String, dynamic> toJson() => {
        'externalId': externalId,
        'name': name,
        'description': description,
        'grade': grade,
        'hidden': hidden,
        'sortOrder': sortOrder,
        'unlockedAt': unlockedAt?.toUtc().toIso8601String(),
      };
}

class AchievementReport {
  const AchievementReport({required this.source, required this.achievements, this.complete = true});
  final String source; // PS3_TROPHY | STEAM
  final List<ReportedAchievement> achievements;

  /// Whether [achievements] is the game's whole set (a trophy config, a Steam
  /// schema). The server then drops definitions of this source it no longer
  /// sees — the way a set once credited to the wrong game gets cleaned up.
  final bool complete;
  int get unlocked => achievements.where((a) => a.unlockedAt != null).length;
}
