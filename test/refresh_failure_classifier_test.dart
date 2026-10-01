import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:oidc/oidc.dart';
import 'package:player/utils/RefreshFailureClassifier.dart';

OidcException _serverError(String code) => OidcException.serverError(
    errorResponse: OidcErrorResponse(src: const {}, error: code));

void main() {
  group('terminal: the refresh token is dead', () {
    test('invalid_grant (revoked session, rotated token reused)', () {
      expect(isTerminalRefreshError(_serverError('invalid_grant')), isTrue);
    });
    test('invalid_client / unauthorized_client', () {
      expect(isTerminalRefreshError(_serverError('invalid_client')), isTrue);
      expect(
          isTerminalRefreshError(_serverError('unauthorized_client')), isTrue);
    });
    test('an exception the library already classified as terminal', () {
      expect(
          isTerminalRefreshError(
              const OidcInteractionRequiredException(message: 'login')),
          isTrue);
    });
    test('a 4xx token endpoint answer', () {
      expect(isTerminalRefreshError(http.Response('', 401)), isTrue);
      expect(isTerminalRefreshError(http.Response('', 400)), isTrue);
    });
  });

  group('transient: keep the session and retry later', () {
    test('issuer temporarily unavailable', () {
      expect(isTerminalRefreshError(_serverError('server_error')), isFalse);
      expect(isTerminalRefreshError(_serverError('temporarily_unavailable')),
          isFalse);
    });
    test('an OidcException without an error response', () {
      expect(isTerminalRefreshError(const OidcException('x')), isFalse);
    });
    test('network failures', () {
      expect(isTerminalRefreshError(TimeoutException('t')), isFalse);
      expect(isTerminalRefreshError(const SocketException('x')), isFalse);
      expect(isTerminalRefreshError(http.ClientException('x')), isFalse);
      expect(isTerminalRefreshError(http.Response('', 503)), isFalse);
    });
    test('an exception the library classified as transient', () {
      expect(
          isTerminalRefreshError(const OidcException('x',
              kind: OidcTokenRefreshFailureKind.transient)),
          isFalse);
    });
  });
}
