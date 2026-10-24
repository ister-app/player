/// Comparing PS3 titles that come from different places: a `PARAM.SFO`
/// (`TITLE`, where an updated HDD game appends its patch version on a line
/// of its own), a trophy set's `TROPCONF.SFM` (XML-escaped), the server (which
/// may still carry that version suffix from an older scanner).
class Ps3Titles {
  Ps3Titles._();

  static final RegExp _versionSuffix = RegExp(r'\s+v?\d+(\.\d+)+$');

  /// A form in which the same game's titles compare equal: entities decoded,
  /// trademark marks and a trailing version (`1.02`) dropped, whitespace
  /// collapsed, lower case. A bare number stays (`Portal 2`).
  static String normalise(String title) => title
      .replaceAll('&amp;', '&')
      .replaceAll('&apos;', "'")
      .replaceAll('&quot;', '"')
      .replaceAll(RegExp(r'[™®©]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .replaceFirst(_versionSuffix, '')
      .trim()
      .toLowerCase();

  /// Whether two titles name the same game; false when either is empty.
  static bool same(String? a, String? b) {
    if (a == null || b == null) return false;
    final na = normalise(a);
    return na.isNotEmpty && na == normalise(b);
  }
}
