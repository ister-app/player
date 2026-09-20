import 'package:flutter/foundation.dart';
import 'package:player/utils/ImageUtil.dart';

import 'stream_token_cookie_stub.dart'
    if (dart.library.js_interop) 'stream_token_cookie_web.dart' as platform;

/// Carries the stream token in a cookie on web, so artwork urls can go out
/// without `?token=`.
///
/// Why: the browser's HTTP cache is keyed on the full url. The token is minted
/// per page load and rotates within one, so with the token in the url every
/// reload downloaded every picture again — the server's `max-age` never got a
/// second request to answer. Native does not have the problem (its image cache
/// is keyed through [ImageUtil.cacheKeyFor]); the browser's cache takes no key.
///
/// The server has always accepted the token as an `IsterStreamToken` cookie
/// (`StreamTokenAuthenticationFilter`), url parameter first. A cookie only
/// travels to the host that set it, so this covers the usual deployment — the
/// player at `/` and the api at a path on the same host — and nothing else: a
/// serving node on another origin keeps its `?token=`.
class StreamTokenCookie {
  StreamTokenCookie._();

  static const String _name = 'IsterStreamToken';

  /// Cookie path → expiry, for the cookies that verifiably stuck.
  static final Map<String, DateTime> _covered = {};

  @visibleForTesting
  static String? Function() pageOrigin = platform.pageOrigin;
  @visibleForTesting
  static void Function(String cookie) writeCookie = platform.writeCookie;
  @visibleForTesting
  static String Function() readCookies = platform.readCookies;

  /// Publishes [token] for everything under [serverUrl]. A no-op when that is
  /// another origin than the page, and on native.
  static void publish(String? serverUrl, String token, DateTime expiry) {
    final path = _sameOriginPath(serverUrl);
    if (path == null) return;
    // Strict: the cookie also authenticates POST /reading-progress, so it must
    // never ride along on a request another site triggers.
    final secure = serverUrl!.startsWith('https:') ? '; Secure' : '';
    writeCookie('$_name=$token; Path=$path; SameSite=Strict$secure'
        '; Expires=${_httpDate(expiry)}');
    // Read it back: a browser that blocks cookies drops the write silently,
    // and a tokenless url would then be a 401 on every tile.
    if (readCookies().split(';').any((c) => c.trim() == '$_name=$token')) {
      _covered[path] = expiry;
    } else {
      _covered.remove(path);
    }
  }

  static void clear(String? serverUrl) {
    final path = _sameOriginPath(serverUrl);
    if (path == null) return;
    _covered.remove(path);
    writeCookie('$_name=; Path=$path; SameSite=Strict; Max-Age=0');
  }

  /// [url] without its token when a live cookie authenticates it instead,
  /// unchanged otherwise.
  static String urlFor(String url) {
    if (_covered.isEmpty) return url;
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasAuthority || uri.origin != pageOrigin()) {
      return url;
    }
    final now = DateTime.now();
    final covered = _covered.entries.any((e) =>
        now.isBefore(e.value) &&
        (uri.path == e.key || uri.path.startsWith(_asDirectory(e.key))));
    return covered ? ImageUtil.cacheKeyFor(url)! : url;
  }

  @visibleForTesting
  static void resetForTest() {
    _covered.clear();
    pageOrigin = platform.pageOrigin;
    writeCookie = platform.writeCookie;
    readCookies = platform.readCookies;
  }

  static String? _sameOriginPath(String? serverUrl) {
    final origin = pageOrigin();
    if (origin == null || serverUrl == null) return null;
    final uri = Uri.tryParse(serverUrl);
    if (uri == null || !uri.hasAuthority || uri.origin != origin) return null;
    return uri.path.isEmpty ? '/' : uri.path;
  }

  static String _asDirectory(String path) =>
      path.endsWith('/') ? path : '$path/';

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String _httpDate(DateTime time) {
    final t = time.toUtc();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${_days[t.weekday - 1]}, ${two(t.day)} ${_months[t.month - 1]} '
        '${t.year} ${two(t.hour)}:${two(t.minute)}:${two(t.second)} GMT';
  }
}
