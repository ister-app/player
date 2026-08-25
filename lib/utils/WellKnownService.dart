import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WellKnownInfo {
  final String name;
  final String oidcUrl;
  final String serverUrl;

  const WellKnownInfo({
    required this.name,
    required this.oidcUrl,
    required this.serverUrl,
  });
}

/// Outcome of [WellKnownService.probe]: what the add-server page needs to
/// explain *why* an address did not work.
enum WellKnownProbeStatus { found, notIster, unreachable }

class WellKnownProbe {
  final WellKnownProbeStatus status;
  final WellKnownInfo? info;

  const WellKnownProbe._(this.status, this.info);

  const WellKnownProbe.found(WellKnownInfo info)
      : this._(WellKnownProbeStatus.found, info);
  static const notIster = WellKnownProbe._(WellKnownProbeStatus.notIster, null);
  static const unreachable =
      WellKnownProbe._(WellKnownProbeStatus.unreachable, null);
}

class WellKnownService {
  static const String _prefix = 'wellknown_';
  static final Map<String, WellKnownInfo> _cache = {};
  static SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static String _nameKey(String id) => '${_prefix}${id}_name';
  static String _oidcKey(String id) => '${_prefix}${id}_oidcUrl';
  static String _urlKey(String id) => '${_prefix}${id}_serverUrl';

  /// Returns cached in-memory info synchronously. Used by [ClientManager].
  static WellKnownInfo? getCached(String serverIdentifier) {
    return _cache[serverIdentifier];
  }

  /// Test seam: drops the in-memory cache and rebinds the preferences
  /// handle. Tests swap the SharedPreferences platform per test, and the
  /// handle captures it at construction — a static one would keep reading
  /// the first test's store.
  @visibleForTesting
  static void resetForTest() {
    _cache.clear();
    _prefs = SharedPreferencesAsync();
  }

  /// Test seam: seeds the in-memory cache without network or preferences.
  @visibleForTesting
  static void cacheForTest(String serverIdentifier, WellKnownInfo info) {
    _cache[serverIdentifier] = info;
  }

  /// The servers configured in the app (the same list [ServerList] manages).
  /// Lets the audio-service handler enumerate servers on a cold start in the
  /// car, when no UI has run yet.
  static Future<List<String>> getServers() async {
    return await _prefs.getStringList('servers') ?? [];
  }

  /// Populates the in-memory [_cache] from SharedPreferences for every
  /// configured server. Call this during startup, before [runApp], so that a
  /// cold load which lands directly on a route that reaches for
  /// [ClientManager.createClient] (e.g. a restored `/remote/...` deep link,
  /// which has no well-known guard of its own) finds the info already cached
  /// instead of throwing. A later [fetch] still refreshes each entry.
  static Future<void> hydrateCacheFromPrefs() async {
    for (final server in await getServers()) {
      await _loadFromPrefs(server);
    }
  }

  /// Always fetches /.well-known/ister from the network.
  /// Updates in-memory cache and SharedPreferences on success.
  /// Falls back to SharedPreferences if network fails.
  static Future<WellKnownInfo?> fetch(String serverIdentifier) async {
    final probe = await WellKnownService.probe(serverIdentifier);
    return probe.info ?? await lastKnown(serverIdentifier);
  }

  /// The last info we ever saw for a server, from memory or preferences,
  /// without touching the network. Says nothing about reachability — use it
  /// to *label* a server, never to decide whether it answers.
  static Future<WellKnownInfo?> lastKnown(String serverIdentifier) async {
    return _cache[serverIdentifier] ?? await _loadFromPrefs(serverIdentifier);
  }

  /// Like [fetch] but without the preferences fallback, and telling apart
  /// "nothing answered" from "something answered that is not an Ister
  /// server". Caches and persists the info when found.
  static Future<WellKnownProbe> probe(String serverIdentifier) async {
    final scheme = ClientManager.getHttpOrHttps(serverIdentifier);
    final Uri uri;
    try {
      uri = Uri.parse('$scheme://$serverIdentifier/.well-known/ister');
    } on FormatException catch (e) {
      LoggerService().logger.w('Invalid server address $serverIdentifier: $e');
      return WellKnownProbe.unreachable;
    }

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final lines = response.body
            .split('\n')
            .map((l) => l.trim())
            .where((l) => l.isNotEmpty)
            .toList();

        if (lines.length != 3) {
          LoggerService().logger.w(
              '/.well-known/ister: unexpected format for $serverIdentifier (got ${lines.length} lines)');
          return WellKnownProbe.notIster;
        }

        final info = WellKnownInfo(
          name: lines[0],
          oidcUrl: lines[1],
          serverUrl: lines[2],
        );
        _cache[serverIdentifier] = info;
        await _saveToPrefs(serverIdentifier, info);
        return WellKnownProbe.found(info);
      } else {
        LoggerService().logger.w(
            '/.well-known/ister: server $serverIdentifier returned ${response.statusCode}');
        return WellKnownProbe.notIster;
      }
    } catch (e) {
      LoggerService().logger
          .w('Failed to fetch /.well-known/ister for $serverIdentifier: $e');
      return WellKnownProbe.unreachable;
    }
  }

  static Future<WellKnownInfo?> _loadFromPrefs(String id) async {
    final name = await _prefs.getString(_nameKey(id));
    final oidcUrl = await _prefs.getString(_oidcKey(id));
    final serverUrl = await _prefs.getString(_urlKey(id));
    if (name == null || oidcUrl == null || serverUrl == null) return null;
    final info = WellKnownInfo(name: name, oidcUrl: oidcUrl, serverUrl: serverUrl);
    _cache[id] = info;
    return info;
  }

  static Future<void> _saveToPrefs(String id, WellKnownInfo info) async {
    await _prefs.setString(_nameKey(id), info.name);
    await _prefs.setString(_oidcKey(id), info.oidcUrl);
    await _prefs.setString(_urlKey(id), info.serverUrl);
  }

  /// Removes all cached and persisted data for a server.
  static Future<void> remove(String serverIdentifier) async {
    _cache.remove(serverIdentifier);
    await _prefs.remove(_nameKey(serverIdentifier));
    await _prefs.remove(_oidcKey(serverIdentifier));
    await _prefs.remove(_urlKey(serverIdentifier));
  }
}
