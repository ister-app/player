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

class WellKnownService {
  static const String _prefix = 'wellknown_';
  static final Map<String, WellKnownInfo> _cache = {};
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static String _nameKey(String id) => '${_prefix}${id}_name';
  static String _oidcKey(String id) => '${_prefix}${id}_oidcUrl';
  static String _urlKey(String id) => '${_prefix}${id}_serverUrl';

  /// Returns cached in-memory info synchronously. Used by [ClientManager].
  static WellKnownInfo? getCached(String serverIdentifier) {
    return _cache[serverIdentifier];
  }

  /// Always fetches /.well-known/ister from the network.
  /// Updates in-memory cache and SharedPreferences on success.
  /// Falls back to SharedPreferences if network fails.
  static Future<WellKnownInfo?> fetch(String serverIdentifier) async {
    final scheme = ClientManager.getHttpOrHttps(serverIdentifier);
    final uri = Uri.parse('$scheme://$serverIdentifier/.well-known/ister');

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
          return null;
        }

        final info = WellKnownInfo(
          name: lines[0],
          oidcUrl: lines[1],
          serverUrl: lines[2],
        );
        _cache[serverIdentifier] = info;
        await _saveToPrefs(serverIdentifier, info);
        return info;
      } else {
        LoggerService().logger.w(
            '/.well-known/ister: server $serverIdentifier returned ${response.statusCode}');
        return null;
      }
    } catch (e) {
      LoggerService().logger
          .w('Failed to fetch /.well-known/ister for $serverIdentifier: $e');
      return _loadFromPrefs(serverIdentifier);
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
