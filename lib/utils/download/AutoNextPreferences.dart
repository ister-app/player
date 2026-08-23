import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:player/utils/download/DownloadStore.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A show whose next unwatched episodes are kept downloaded automatically.
class AutoNextFollow {
  const AutoNextFollow({
    required this.showId,
    required this.title,
    required this.count,
  });

  final String showId;

  /// Display name, for the settings UI (the manifest may not hold the show).
  final String title;

  /// How many unwatched episodes to keep ahead.
  final int count;

  Map<String, dynamic> toJson() => {'title': title, 'count': count};

  static AutoNextFollow fromJson(String showId, Map<String, dynamic> json) =>
      AutoNextFollow(
        showId: showId,
        title: json['title'] as String? ?? '',
        count: json['count'] as int? ?? 1,
      );
}

/// Device-local "keep the next N unwatched episodes downloaded" follows,
/// per server, keyed by show id.
class AutoNextPreferences {
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static String _k(String serverName) =>
      'downloads_auto_next_${DownloadStore.slug(serverName)}';

  static Future<Map<String, AutoNextFollow>> all(String serverName) async {
    final raw = await _prefs.getString(_k(serverName));
    if (raw == null) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return {
        for (final e in map.entries)
          e.key: AutoNextFollow.fromJson(e.key, e.value as Map<String, dynamic>),
      };
    } catch (e) {
      debugPrint('unreadable auto-next follows for $serverName: $e');
      return {};
    }
  }

  static Future<AutoNextFollow?> get(String serverName, String showId) async =>
      (await all(serverName))[showId];

  static Future<void> set(String serverName, AutoNextFollow follow) async {
    final follows = await all(serverName);
    follows[follow.showId] = follow;
    await _save(serverName, follows);
  }

  static Future<void> remove(String serverName, String showId) async {
    final follows = await all(serverName);
    if (follows.remove(showId) != null) await _save(serverName, follows);
  }

  static Future<void> _save(
          String serverName, Map<String, AutoNextFollow> follows) =>
      _prefs.setString(_k(serverName),
          jsonEncode({for (final f in follows.values) f.showId: f.toJson()}));

  @visibleForTesting
  static Future<void> clearForTest(String serverName) =>
      _prefs.remove(_k(serverName));
}
