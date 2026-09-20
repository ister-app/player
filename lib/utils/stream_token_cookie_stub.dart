/// Native has no cookie jar the image loader shares, and needs none: its image
/// cache is keyed token-free already (`ImageUtil.cacheKeyFor`).
String? pageOrigin() => null;

void writeCookie(String cookie) {}

String readCookies() => '';
