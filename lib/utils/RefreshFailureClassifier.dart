import 'package:oidc/oidc.dart';

/// Whether a failed OIDC token refresh is final: retrying with the same
/// refresh token cannot succeed, so the stored session is dead and the user
/// has to sign in again.
///
/// Mirrors the terminal/transient split oidc_core uses for its own
/// auto-refresh timer (`OidcTokenRefreshFailedEvent.kind`), which the manual
/// `refreshToken()` path does not expose on the thrown error: `invalid_grant`
/// and friends are terminal, anything network-shaped (socket, timeout, TLS,
/// 5xx, unknown) is transient and keeps the session.
bool isTerminalRefreshError(Object error) {
  if (error is OidcException && error.kind != null) {
    return error.kind == OidcTokenRefreshFailureKind.terminal;
  }
  switch (OidcOfflineAuthErrorHandler.categorizeError(error)) {
    case OfflineAuthErrorType.authenticationError:
    case OfflineAuthErrorType.clientError:
      return true;
    case OfflineAuthErrorType.networkUnavailable:
    case OfflineAuthErrorType.networkTimeout:
    case OfflineAuthErrorType.sslError:
    case OfflineAuthErrorType.serverError:
    case OfflineAuthErrorType.unknown:
      return false;
  }
}
