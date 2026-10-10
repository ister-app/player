import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:oidc/oidc.dart';
import 'package:player/utils/LoginManager.dart';

/// A fake OpenID provider behind `package:http`'s zone client: discovery, JWKS,
/// a token endpoint that hands out a fresh (RS256-signed) session per call, and
/// userinfo. Enough for a real [OidcUserManager] to restore and refresh a session.
class _FakeIssuer {
  _FakeIssuer({required this.expiresIn});

  static const url = 'https://issuer.test';
  final int expiresIn;
  final JsonWebKey _key = JsonWebKey.generate('RS256');
  int tokenCalls = 0;
  int issued = 0;

  Map<String, dynamic> get _publicJwk => {
        for (final e in _key.toJson().entries)
          if (const {'kty', 'n', 'e', 'kid', 'alg', 'use'}.contains(e.key)) e.key: e.value
      };

  String _idToken() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return (JsonWebSignatureBuilder()
          ..jsonContent = {
            'iss': url,
            'aud': 'ister',
            'azp': 'ister',
            'sub': 'user-1',
            'typ': 'ID',
            'iat': now,
            'auth_time': now,
            'exp': now + 3600,
          }
          ..addRecipient(_key, algorithm: 'RS256'))
        .build()
        .toCompactSerialization();
  }

  Map<String, dynamic> issueToken() {
    issued++;
    return {
      'access_token': 'at$issued',
      'token_type': 'Bearer',
      'expires_in': expiresIn,
      'refresh_token': 'rt$issued',
      'id_token': _idToken(),
      'scope': 'openid',
    };
  }

  Future<http.Response> handle(http.Request req) async {
    final path = req.url.path;
    http.Response json(Object body) =>
        http.Response(jsonEncode(body), 200, headers: {'content-type': 'application/json'});
    if (path.endsWith('/.well-known/openid-configuration')) {
      return json({
        'issuer': url,
        'authorization_endpoint': '$url/auth',
        'token_endpoint': '$url/token',
        'userinfo_endpoint': '$url/userinfo',
        'jwks_uri': '$url/jwks',
        'response_types_supported': ['code'],
        'subject_types_supported': ['public'],
        'id_token_signing_alg_values_supported': ['RS256'],
        'grant_types_supported': ['authorization_code', 'refresh_token'],
        'token_endpoint_auth_methods_supported': ['none'],
      });
    }
    if (path.endsWith('/jwks')) return json({'keys': [_publicJwk]});
    if (path.endsWith('/token')) {
      tokenCalls++;
      // Long enough for a second caller to arrive while the first exchange is in flight.
      await Future.delayed(const Duration(milliseconds: 100));
      return json(issueToken());
    }
    if (path.endsWith('/userinfo')) return json({'sub': 'user-1'});
    return http.Response('not found', 404);
  }
}

void main() {
  const serverUrl = 'media.test';

  Future<OidcUserManager> restoredManager(_FakeIssuer issuer) async {
    final store = OidcMemoryStore();
    final initial = OidcToken.fromResponse(OidcTokenResponse.fromJson(issuer.issueToken()), sessionState: null);
    await store.setMany(OidcStoreNamespace.secureTokens,
        values: {OidcConstants_Store.currentToken: jsonEncode(initial.toJson())}, managerId: serverUrl);
    final manager = OidcUserManager.lazy(
      id: serverUrl,
      discoveryDocumentUri: Uri.parse('${_FakeIssuer.url}/.well-known/openid-configuration'),
      clientCredentials: const OidcClientAuthentication.none(clientId: 'ister'),
      store: store,
      settings: OidcUserManagerSettings(
        initMode: OidcInitMode.blockingValidate,
        redirectUri: Uri.parse('http://localhost:0'),
      ),
    );
    await manager.init();
    return manager;
  }

  tearDown(() async {
    await LoginManager.managers.remove(serverUrl)?.dispose();
  });

  test('concurrent getToken calls in the about-to-expire minute share one refresh and all complete', () async {
    // 45 s left on the access token: inside the 1-minute "about to expire" window,
    // so getToken must refresh before handing out a token.
    final issuer = _FakeIssuer(expiresIn: 45);
    await http.runWithClient(() async {
      final manager = await restoredManager(issuer);
      LoginManager.managers[serverUrl] = manager;
      expect(manager.currentUser?.token.accessToken, 'at1');

      final tokens = await Future.wait([
        LoginManager.getToken(serverUrl),
        LoginManager.getToken(serverUrl),
        LoginManager.getToken(serverUrl),
      ]).timeout(const Duration(seconds: 10));

      expect(tokens, everyElement('Bearer at2'));
      expect(issuer.tokenCalls, 1, reason: 'parallel callers must not each exchange the refresh token');

      // The dedup entry is gone again: the new token is just as short-lived, so a
      // later call refreshes once more instead of waiting on the finished future.
      expect(await LoginManager.getToken(serverUrl).timeout(const Duration(seconds: 10)), 'Bearer at3');
      expect(issuer.tokenCalls, 2);
    }, () => MockClient(issuer.handle));
  });

  test('a fresh token is returned without a refresh', () async {
    final issuer = _FakeIssuer(expiresIn: 600);
    await http.runWithClient(() async {
      LoginManager.managers[serverUrl] = await restoredManager(issuer);
      expect(await LoginManager.getToken(serverUrl).timeout(const Duration(seconds: 10)), 'Bearer at1');
      expect(issuer.tokenCalls, 0);
    }, () => MockClient(issuer.handle));
  });
}
