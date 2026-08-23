/// Turns what a user typed into the server identifier the rest of the app
/// keys on (`host[:port][/path]`, no scheme, no trailing slash).
///
/// [ClientManager.getHttpOrHttps] picks the scheme itself, so a pasted
/// `https://media.example.com/` must lose both the scheme and the slash or
/// every URL the app builds from it breaks. Returns null when nothing usable
/// is left (empty, or whitespace inside the address).
String? normalizeServerInput(String raw) {
  var value = raw.trim();
  value = value.replaceFirst(RegExp(r'^[a-zA-Z][a-zA-Z0-9+.-]*://'), '');
  while (value.endsWith('/')) {
    value = value.substring(0, value.length - 1);
  }
  if (value.isEmpty) return null;
  if (RegExp(r'\s').hasMatch(value)) return null;
  return value;
}
