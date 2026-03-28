import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:oidc/oidc.dart';
import 'package:oidc_default_store/oidc_default_store.dart';
import 'package:player/utils/LoggerService.dart';

import 'ClientManager.dart';

class LoginManager {
  static Map<String, OidcUserManager> managers = {};
  static Map<String, Map<String, String>> httpHeaders = {};

  static bool isLoggedIn(String serverUrl) {
    return managers[serverUrl]?.currentUser != null;
  }

  static Stream<OidcUser?>? isLoggedInSteam(String serverUrl) {
    return managers[serverUrl]?.userChanges();
  }

  // static OidcToken? token;
  // static OidcUserManager? manager;

  static Future<void> initIfNotExists(
      String serverUrl, String discoveryDocumentUri) async {
    if (managers.containsKey(serverUrl)) {
      LoggerService().logger.d("All ready LoginManager inited for $serverUrl");
    } else {
      ClientManager.getClientForUrl(serverUrl);
      LoggerService().logger.d("discoveryDocumentUri $discoveryDocumentUri");
      httpHeaders[serverUrl] = Map.of({"Authorization": ""});
      managers[serverUrl] = OidcUserManager.lazy(
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
      managers[serverUrl]?.userChanges().listen((event) {
        LoggerService().logger.d(
          'User changed: ${event?.claims.toJson()}, info: ${event?.userInfo}',
        );
        if (event?.token.accessToken != null) {
          httpHeaders[serverUrl]!.update("Authorization",
              (String s) => "Bearer ${event!.token.accessToken!}");
        }
      });
      await managers[serverUrl]?.init();
    }
  }

  static Future<String?> waitForToken(String serverUrl) async {
    while (true) {
      LoggerService().logger.d('waiting for token for $serverUrl');
      final manager = managers[serverUrl];

      if (manager != null &&
          manager.didInit &&
          manager.currentUser?.token.accessToken != null) {
        break; // voorwaarden zijn voldaan → stop de loop
      }

      await Future.delayed(const Duration(seconds: 5));
    }

    return getToken(serverUrl);
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

  static Future<String?> getToken(String serverUrl) async {
    final manager = managers[serverUrl];
    if (manager == null) return null;

    final token = manager.currentUser?.token;
    if (token == null) return null;

    if (token.isAccessTokenAboutToExpire()) {
      try {
        await manager.refreshToken();
      } catch (e) {
        LoggerService().logger.e('Token refresh mislukt voor $serverUrl: $e');
      }
    }

    final accessToken = manager.currentUser?.token.accessToken;
    return accessToken != null ? "Bearer $accessToken" : null;
  }

  static Map<String, String> getHeaders(String serverUrl) {
    return httpHeaders[serverUrl] != null ? httpHeaders[serverUrl]! : {};
  }
}
