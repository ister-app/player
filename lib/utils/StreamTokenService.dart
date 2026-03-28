import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/createStreamToken.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LoggerService.dart';

class StreamTokenService {
  static final Map<String, String> _tokens = {};
  static final Map<String, DateTime> _expiry = {};
  static final Map<String, Timer> _refreshTimers = {};

  static const Duration _refreshBefore = Duration(hours: 10);

  static String? getToken(String serverName) {
    final exp = _expiry[serverName];
    if (exp == null || DateTime.now().isAfter(exp)) return null;
    return _tokens[serverName];
  }

  static Future<String?> ensureToken(String serverName) async {
    if (getToken(serverName) != null) return getToken(serverName);
    return _fetchToken(serverName);
  }

  static Future<String?> _fetchToken(String serverName) async {
    final client = ClientManager.getClientForUrl(serverName).value;
    final result = await client.mutate(
      MutationOptions(document: documentNodeMutationcreateStreamTokenMutation),
    );
    if (result.hasException) {
      LoggerService().logger.e('Failed to fetch stream token: ${result.exception}');
      return null;
    }
    if (result.data == null) {
      LoggerService().logger.e('Stream token response data is null for $serverName');
      return null;
    }
    final data = Mutation$createStreamTokenMutation.fromJson(result.data!).createStreamToken;
    final token = data.token;
    final expiry = DateTime.parse(data.expiresAt);
    _tokens[serverName] = token;
    _expiry[serverName] = expiry;
    LoggerService().logger.d('Stream token fetched for $serverName, expires $expiry');
    _scheduleRefresh(serverName, expiry);
    return token;
  }

  static void _scheduleRefresh(String serverName, DateTime expiry) {
    _refreshTimers[serverName]?.cancel();
    final refreshIn = expiry.difference(DateTime.now()) - _refreshBefore;
    if (refreshIn.isNegative) {
      unawaited(_fetchToken(serverName));
      return;
    }
    _refreshTimers[serverName] = Timer(refreshIn, () {
      LoggerService().logger.d('Refreshing stream token for $serverName');
      unawaited(_fetchToken(serverName));
    });
  }

  static void invalidateToken(String serverName) {
    _refreshTimers[serverName]?.cancel();
    _refreshTimers.remove(serverName);
    _tokens.remove(serverName);
    _expiry.remove(serverName);
  }
}
