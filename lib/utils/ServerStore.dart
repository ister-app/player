import 'package:shared_preferences/shared_preferences.dart';

import 'ClientManager.dart';
import 'LoginManager.dart';
import 'StreamTokenService.dart';
import 'WellKnownService.dart';

/// The list of configured servers (SharedPreferences key `servers`), shared
/// by the server overview and the add-server page.
class ServerStore {
  static const String key = 'servers';

  // Bound per call: SharedPreferencesAsync captures the platform backend at
  // construction, and tests swap that backend between cases.
  static SharedPreferencesAsync get _prefs => SharedPreferencesAsync();

  static Future<List<String>> list() async =>
      await _prefs.getStringList(key) ?? [];

  static Future<bool> contains(String server) async =>
      (await list()).contains(server);

  /// Appends [server] unless it is already listed; returns the new list.
  static Future<List<String>> add(String server) async {
    final servers = await list();
    if (!servers.contains(server)) {
      servers.add(server);
      await _prefs.setStringList(key, servers);
    }
    return servers;
  }

  /// Removes [server] together with everything the app remembers about it:
  /// well-known info, the OIDC session, the stream token and the client.
  static Future<List<String>> remove(String server) async {
    final servers = await list();
    servers.remove(server);
    await WellKnownService.remove(server);
    await LoginManager.remove(server);
    StreamTokenService.invalidateToken(server);
    ClientManager.removeClient(server);
    await _prefs.setStringList(key, servers);
    return servers;
  }
}
