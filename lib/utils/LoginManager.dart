import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:oidc/oidc.dart';
import 'package:oidc_default_store/oidc_default_store.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/WellKnownService.dart';

import 'ClientManager.dart';

class LoginManager {
  static Map<String, OidcUserManager> managers = {};
  static final Map<String, Future<void>> _initFutures = {};
  static final Map<String, Future<void>> _refreshFutures = {};

  static bool isLoggedIn(String serverUrl) {
    return managers[serverUrl]?.currentUser != null;
  }

  static Stream<OidcUser?>? isLoggedInSteam(String serverUrl) {
    return managers[serverUrl]?.userChanges();
  }

  static Future<void> initIfNotExists(
      String serverUrl, String discoveryDocumentUri) {
    return _initFutures.putIfAbsent(serverUrl, () async {
      try {
        await _init(serverUrl, discoveryDocumentUri);
      } catch (_) {
        // Leave no half-initialized manager behind so a later call can retry.
        managers.remove(serverUrl);
        _initFutures.remove(serverUrl);
        rethrow;
      }
    });
  }

  static Future<void> _init(
      String serverUrl, String discoveryDocumentUri) async {
    ClientManager.getClientForUrl(serverUrl);
    LoggerService().logger.d("discoveryDocumentUri $discoveryDocumentUri");
    final manager = OidcUserManager.lazy(
      // Per-server storage id: without it every server shares the same token
      // keys in OidcDefaultStore and logging in on one server overwrites the
      // stored session of another.
      id: serverUrl,
      discoveryDocumentUri: Uri.parse(discoveryDocumentUri),
      clientCredentials:
          const OidcClientAuthentication.none(clientId: 'ister'),
      store: OidcDefaultStore(),
      settings: OidcUserManagerSettings(
        redirectUri: kIsWeb
            ? Uri.base.replace(path: "/redirect.html")
            : Platform.isIOS || Platform.isMacOS || Platform.isAndroid
                ? Uri.parse('app.ister.player:/oauth2redirect')
                : Platform.isWindows || Platform.isLinux
                    ? Uri.parse('http://localhost:0')
                    : Uri.parse("http://localhost:39149/redirect.html"),
      ),
    );
    managers[serverUrl] = manager;
    manager.userChanges().listen((event) {
      LoggerService().logger.d(
        'User changed: ${event?.claims.toJson()}, info: ${event?.userInfo}',
      );
    });
    await manager.init();
  }

  static Future<String?> waitForToken(String serverUrl) async {
    const pollInterval = Duration(seconds: 5);
    final deadline = DateTime.now().add(const Duration(minutes: 1));

    while (true) {
      LoggerService().logger.d('waiting for token for $serverUrl');

      if (managers[serverUrl] == null) {
        // Session restore (media notification / Android Auto) can get here
        // before the UI ever initialized this server — bootstrap it ourselves.
        try {
          final info = await WellKnownService.fetch(serverUrl);
          if (info != null) {
            await initIfNotExists(serverUrl, info.oidcUrl);
          }
        } catch (e) {
          LoggerService()
              .logger
              .w('Failed to bootstrap login manager for $serverUrl: $e');
        }
      }

      final manager = managers[serverUrl];
      if (manager != null &&
          manager.didInit &&
          manager.currentUser?.token.accessToken != null) {
        return getToken(serverUrl);
      }

      if (DateTime.now().isAfter(deadline)) {
        LoggerService().logger.w('Timed out waiting for token for $serverUrl');
        return null;
      }
      await Future.delayed(pollInterval);
    }
  }

  static const String _successfulLoginPage = '''
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="refresh" content="0; url=https://github.com/ister-app">
    <title>Login successful</title>
  </head>
  <body>
    <p>Login successful. Redirecting to <a href="https://github.com/ister-app">ister-app</a>...</p>
  </body>
</html>
''';

  static Future<OidcUser?> startDeviceLogin(
    String serverUrl, {
    required void Function(OidcDeviceAuthorizationResponse) onVerification,
  }) async {
    LoggerService().logger.d("Start device code flow login for '$serverUrl'");
    return await managers[serverUrl]?.loginDeviceCodeFlow(
      onVerification: onVerification,
    );
  }

  static Future<OidcUser?> startLogin(String serverUrl) async {
    LoggerService().logger.d("Start login for '${managers[serverUrl]?.discoveryDocumentUri}'");
    return await managers[serverUrl]?.loginAuthorizationCodeFlow(
      options: OidcPlatformSpecificOptions(
        linux: const OidcPlatformSpecificOptions_Native(
          successfulPageResponse: _successfulLoginPage,
        ),
        windows: const OidcPlatformSpecificOptions_Native(
          successfulPageResponse: _successfulLoginPage,
        ),
      ),
    );
  }

  /// Drops all login state for [serverUrl] and forgets the stored OIDC
  /// session (used when a server is deleted).
  static Future<void> remove(String serverUrl) async {
    _initFutures.remove(serverUrl);
    _refreshFutures.remove(serverUrl);
    final manager = managers.remove(serverUrl);
    if (manager != null) {
      try {
        await manager.forgetUser();
      } catch (e) {
        LoggerService().logger.w('forgetUser failed for $serverUrl: $e');
      }
    }
  }

  static Future<String?> getToken(String serverUrl) async {
    final manager = managers[serverUrl];
    if (manager == null) return null;

    final token = manager.currentUser?.token;
    if (token == null) return null;

    if (token.isAccessTokenAboutToExpire()) {
      // Deduplicate: every GraphQL request runs through here via AuthLink, so
      // around expiry several parallel requests would otherwise each start
      // their own refresh (fatal with refresh-token rotation).
      final refresh = _refreshFutures.putIfAbsent(
        serverUrl,
        () => manager
            .refreshToken()
            .then((_) {})
            .whenComplete(() => _refreshFutures.remove(serverUrl)),
      );
      try {
        await refresh;
      } catch (e) {
        LoggerService().logger.e('Token refresh mislukt voor $serverUrl: $e');
      }
    }

    final current = manager.currentUser?.token;
    final accessToken = current?.accessToken;
    if (accessToken == null) return null;
    // After a failed refresh the stored token can be past its expiry; sending
    // it guarantees a 401, so treat it as absent.
    if (current!.isAccessTokenExpired()) return null;
    return "Bearer $accessToken";
  }
}
