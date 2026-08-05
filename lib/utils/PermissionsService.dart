import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/me.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/SchemaCompat.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Whether the calling user holds the admin role on a server.
///
/// [unknown] means the server could not tell us — typically an older server without the `me`
/// query. Such a server enforces nothing, so admin UI that predates permissions stays visible
/// on [unknown] (hiding it would only lock out admins), while the new permissions management
/// UI hides itself (it cannot work anyway).
enum AdminStatus { admin, notAdmin, unknown }

/// The calling user's permissions per server, mirroring [UserSettingsService]'s shape:
/// server-authoritative, memory cache per server, SharedPreferences fallback for offline
/// starts, and [invalidate] after switching user/server.
class PermissionsService {
  PermissionsService._privateConstructor();

  static final PermissionsService _instance =
      PermissionsService._privateConstructor();

  factory PermissionsService() => _instance;

  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  final Map<String, AdminStatus> _cache = {};
  final Map<String, Future<AdminStatus>> _inFlight = {};
  final Map<String, String> _userIds = {};

  /// The admin status for [serverName]: from memory, else the server, else the local cache.
  Future<AdminStatus> adminStatusFor(String? serverName) async {
    final server = serverName ?? ClientManager.instance.lastClientUsed;
    if (server == null) return AdminStatus.unknown;

    final cached = _cache[server];
    if (cached != null) return cached;

    return _inFlight[server] ??= _load(server).whenComplete(() {
      _inFlight.remove(server);
    });
  }

  /// The calling user's own id on [serverName], loading it if this is the first ask.
  /// Null on a server that has no `me` query, or when it could not be reached.
  Future<String?> userIdFor(String? serverName) async {
    final server = serverName ?? ClientManager.instance.lastClientUsed;
    if (server == null) return null;
    final cached = _userIds[server];
    if (cached != null) return cached;
    await adminStatusFor(server);
    return _userIds[server];
  }

  /// The calling user's own id without going to the server; null when never loaded.
  String? cachedUserIdFor(String? serverName) {
    final server = serverName ?? ClientManager.instance.lastClientUsed;
    if (server == null) return null;
    return _userIds[server];
  }

  /// The last known status without going to the server; [AdminStatus.unknown] when never loaded.
  AdminStatus cachedStatusFor(String? serverName) {
    final server = serverName ?? ClientManager.instance.lastClientUsed;
    if (server == null) return AdminStatus.unknown;
    return _cache[server] ?? AdminStatus.unknown;
  }

  Future<AdminStatus> _load(String server) async {
    final client = ClientManager.getClientForUrl(server).value;
    try {
      final QueryResult result = await client.query(QueryOptions(
        document: documentNodeQueryme,
        fetchPolicy: FetchPolicy.networkOnly,
      ));
      if (result.hasException || result.data == null) {
        final exception = result.exception;
        if (exception != null && _isFieldUndefined(exception)) {
          // Older server without the me query: permissions do not exist there.
          _cache[server] = AdminStatus.unknown;
          await _prefs.remove('perm_is_admin_$server');
          return AdminStatus.unknown;
        }
        throw exception ?? Exception('empty me response');
      }
      final me = Query$me.fromJson(result.data!).me;
      _userIds[server] = me.id;
      final status = me.isAdmin ? AdminStatus.admin : AdminStatus.notAdmin;
      _cache[server] = status;
      await _prefs.setBool('perm_is_admin_$server', status == AdminStatus.admin);
      return status;
    } catch (e) {
      LoggerService().logger.w('Could not load permissions from $server: $e');
      final local = await _prefs.getBool('perm_is_admin_$server');
      final fallback = local == null
          ? AdminStatus.unknown
          : (local ? AdminStatus.admin : AdminStatus.notAdmin);
      _cache[server] = fallback;
      return fallback;
    }
  }

  /// A GraphQL validation error for a field the server's schema does not have.
  bool _isFieldUndefined(OperationException exception) {
    return isUnknownFieldError(exception) ||
        exception.graphqlErrors
            .any((error) => error.message.toLowerCase().contains("field 'me'"));
  }

  /// Drops the memory cache so the next read re-queries; used after switching user/server.
  void invalidate(String serverName) {
    _cache.remove(serverName);
    _userIds.remove(serverName);
  }
}
