import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:oidc/oidc.dart';
import 'package:oidc_default_store/oidc_default_store.dart';

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
      print("All ready LoginManager inited for $serverUrl");
    } else {
      ClientManager.getClientForUrl(serverUrl);
      print(discoveryDocumentUri);
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
        print(
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

  static Future<OidcUser?> startLogin(String serverUrl) async {
    print("'${managers[serverUrl]?.discoveryDocumentUri}'");
    return await managers[serverUrl]?.loginAuthorizationCodeFlow();
  }

  static String? getToken(String serverUrl) {
    var token = managers[serverUrl]?.currentUser?.token.accessToken;
    return token != null ? "Bearer $token" : null;
  }

  static Map<String, String> getHeaders(String serverUrl) {
    return httpHeaders[serverUrl] != null ? httpHeaders[serverUrl]! : {};
  }
}
