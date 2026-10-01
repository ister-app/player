import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/createStreamToken.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/StreamTokenCookie.dart';
import 'package:player/utils/WellKnownService.dart';

/// Why the last stream-token fetch for a server failed, as far as it matters
/// to the UI: a rejected or missing bearer, a user the server will not serve,
/// or anything else (unreachable, 5xx) that a retry may fix.
enum StreamTokenFailure { none, unauthenticated, forbidden, other }

class StreamTokenService {
  static final Map<String, String> _tokens = {};
  static final Map<String, DateTime> _expiry = {};
  static final Map<String, Timer> _refreshTimers = {};

  /// Fetches in flight, per server. Several callers wanting a token at the
  /// same moment (a download fetching segments in parallel, images rendering
  /// after a rotation) must mint one token together, not one each: the server
  /// hands out a *new* token per mutation, so N racing fetches also mean N-1
  /// tokens nobody keeps, and a late writer could overwrite the one already
  /// in use.
  static final Map<String, Future<String?>> _inFlight = {};

  static const Duration _refreshBefore = Duration(hours: 10);
  // Lower bound on the refresh timer so a token that lives shorter than
  // [_refreshBefore] cannot cause a tight fetch loop.
  static const Duration _minRefreshDelay = Duration(minutes: 1);
  static const Duration _retryDelay = Duration(seconds: 5);
  // A user without the `user` role will not gain it within seconds; poll
  // slowly so an administrator granting it still lets the page through.
  static const Duration _forbiddenRetryDelay = Duration(minutes: 1);

  /// Last fetch outcome per server. `none` once a token is in hand;
  /// ServerHomePage listens to replace its "connecting" spinner with a
  /// login or no-access state when the cause is the session, not the network.
  static final ValueNotifier<Map<String, StreamTokenFailure>> lastFailure =
      ValueNotifier(const {});

  static StreamTokenFailure failureFor(String serverName) =>
      lastFailure.value[serverName] ?? StreamTokenFailure.none;

  static void _setFailure(String serverName, StreamTokenFailure failure) {
    if (failureFor(serverName) == failure) return;
    lastFailure.value = {...lastFailure.value, serverName: failure};
  }

  /// Pure classification of a failed `createStreamToken` result.
  ///
  /// The server's `/graphql` is permitAll at the HTTP layer, so a request
  /// *without* a bearer reaches the resolver anonymously and comes back as a
  /// GraphQL error "Unauthorized" (classification UNAUTHORIZED); a user
  /// without the `user` role gets "Forbidden" (FORBIDDEN). A bearer the
  /// server rejects outright (bad signature, wrong audience) never reaches
  /// GraphQL and is an HTTP 401 on the link.
  @visibleForTesting
  static StreamTokenFailure classifyFailure(OperationException? exception) {
    if (exception == null) return StreamTokenFailure.other;
    final link = exception.linkException;
    int? status;
    if (link is HttpLinkServerException) status = link.response.statusCode;
    if (link is HttpLinkParserException) status = link.response.statusCode;
    if (status == 401) return StreamTokenFailure.unauthenticated;
    if (status == 403) return StreamTokenFailure.forbidden;
    for (final error in exception.graphqlErrors) {
      final classification =
          error.extensions?['classification']?.toString().toUpperCase();
      final message = error.message.trim().toLowerCase();
      if (classification == 'UNAUTHORIZED' || message == 'unauthorized') {
        return StreamTokenFailure.unauthenticated;
      }
      if (classification == 'FORBIDDEN' ||
          message == 'forbidden' ||
          message.contains('access denied')) {
        return StreamTokenFailure.forbidden;
      }
    }
    return StreamTokenFailure.other;
  }

  /// Bumped whenever a server goes from "no usable token" to "token available".
  /// Image URLs embed the token, so a widget built during that gap renders a
  /// tokenless (401) URL; listeners rebuild once the token lands instead of
  /// staying broken until the next app start.
  static final ValueNotifier<int> tokenRevision = ValueNotifier(0);

  /// Bumped on *every* successful fetch, including routine rotations where the
  /// old token is still valid (unlike [tokenRevision], which only fires when a
  /// missing token becomes available, so image widgets don't re-download on
  /// every rotation). [MediaPlayerHandler] listens to re-stamp the token
  /// embedded in the published artUris — Android re-downloads notification
  /// artwork from that URL long after the queue was built.
  static final ValueNotifier<int> tokenVersion = ValueNotifier(0);

  static String? getToken(String serverName) {
    final exp = _expiry[serverName];
    if (exp == null || DateTime.now().isAfter(exp)) return null;
    return _tokens[serverName];
  }

  static Future<String?> ensureToken(String serverName) async {
    if (getToken(serverName) != null) return getToken(serverName);
    return _fetchToken(serverName);
  }

  /// [_doFetchToken], deduplicated: a fetch already in flight for [serverName]
  /// is joined instead of started again.
  static Future<String?> _fetchToken(String serverName) {
    final pending = _inFlight[serverName];
    if (pending != null) return pending;
    // Block body on purpose: `=> _inFlight.remove(...)` returns the very
    // future being awaited, and whenComplete would wait for it — a deadlock.
    final fetch = _doFetchToken(serverName).whenComplete(() {
      _inFlight.remove(serverName);
    });
    _inFlight[serverName] = fetch;
    return fetch;
  }

  static Future<String?> _doFetchToken(String serverName) async {
    final hadToken = getToken(serverName) != null;
    final client = ClientManager.getClientForUrl(serverName).value;
    final result = await client.mutate(
      MutationOptions(
        document: documentNodeMutationcreateStreamTokenMutation,
        // Fired from playback hot paths (token refresh timers, play()).
        // Keep it out of the normalized cache: every cache write costs a
        // deep-compare of all watched queries — cheaper since the client
        // uses optimizedDeepEquals, but still per-watcher UI-thread work
        // for a response nothing ever reads from the cache.
        fetchPolicy: FetchPolicy.noCache,
        cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
      ),
    );
    if (result.hasException) {
      LoggerService().logger.e('Failed to fetch stream token: ${result.exception}');
      final failure = classifyFailure(result.exception);
      _setFailure(serverName, failure);
      switch (failure) {
        case StreamTokenFailure.unauthenticated:
          // A dead or rejected bearer does not heal with time; the page
          // signs the user out and the next ensureToken after login fetches.
          _refreshTimers[serverName]?.cancel();
          _refreshTimers.remove(serverName);
        case StreamTokenFailure.forbidden:
          _scheduleRetry(serverName, _forbiddenRetryDelay);
        case StreamTokenFailure.other:
        case StreamTokenFailure.none:
          _scheduleRetry(serverName);
      }
      return null;
    }
    if (result.data == null) {
      LoggerService().logger.e('Stream token response data is null for $serverName');
      _scheduleRetry(serverName);
      return null;
    }
    final data = Mutation$createStreamTokenMutation.fromJson(result.data!).createStreamToken;
    final token = data.token;
    final DateTime expiry;
    try {
      expiry = DateTime.parse(data.expiresAt);
    } catch (e) {
      LoggerService().logger.e('Unparsable stream token expiry "${data.expiresAt}" for $serverName: $e');
      _scheduleRetry(serverName);
      return null;
    }
    _tokens[serverName] = token;
    _expiry[serverName] = expiry;
    _setFailure(serverName, StreamTokenFailure.none);
    // Web only: lets same-origin artwork urls drop their token and become
    // cacheable. Before the revision bump, so the rebuild it triggers already
    // sees the cookie.
    StreamTokenCookie.publish(
        WellKnownService.getCached(serverName)?.serverUrl, token, expiry);
    LoggerService().logger.d('Stream token fetched for $serverName, expires $expiry');
    _scheduleRefresh(serverName, expiry);
    if (!hadToken) tokenRevision.value++;
    tokenVersion.value++;
    return token;
  }

  static void _scheduleRefresh(String serverName, DateTime expiry) {
    _refreshTimers[serverName]?.cancel();
    var refreshIn = expiry.difference(DateTime.now()) - _refreshBefore;
    if (refreshIn < _minRefreshDelay) refreshIn = _minRefreshDelay;
    _refreshTimers[serverName] = Timer(refreshIn, () {
      LoggerService().logger.d('Refreshing stream token for $serverName');
      unawaited(_fetchToken(serverName));
    });
  }

  /// Keeps the refresh chain alive after a failed fetch; without this a single
  /// network error would silently stop all future refreshes. Retries quickly:
  /// until a token exists every image on screen renders a tokenless URL.
  static void _scheduleRetry(String serverName,
      [Duration delay = _retryDelay]) {
    _refreshTimers[serverName]?.cancel();
    _refreshTimers[serverName] = Timer(delay, () {
      LoggerService().logger.d('Retrying stream token fetch for $serverName');
      unawaited(_fetchToken(serverName));
    });
  }

  static void invalidateToken(String serverName) {
    _refreshTimers[serverName]?.cancel();
    _refreshTimers.remove(serverName);
    _tokens.remove(serverName);
    _expiry.remove(serverName);
    _setFailure(serverName, StreamTokenFailure.none);
    StreamTokenCookie.clear(WellKnownService.getCached(serverName)?.serverUrl);
  }

  @visibleForTesting
  static void resetForTest() {
    for (final t in _refreshTimers.values) {
      t.cancel();
    }
    _refreshTimers.clear();
    _tokens.clear();
    _expiry.clear();
    _inFlight.clear();
    lastFailure.value = const {};
  }
}
