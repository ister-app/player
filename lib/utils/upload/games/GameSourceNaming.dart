/// Turns the names ROM sets and dumps come with into the `Title (year)` the
/// scanner names a game after. Pure.
class GameSourceNaming {
  GameSourceNaming._();

  static final RegExp _tag = RegExp(r'\s*[\(\[]([^\)\]]*)[\)\]]');
  static final RegExp _year = RegExp(r'^\d{4}$');
  static final RegExp _theSuffix = RegExp(r'^(.*?),\s*(The|A|An)$', caseSensitive: false);
  static final RegExp _cueFile = RegExp(r'^\s*FILE\s+"([^"]+)"', multiLine: true, caseSensitive: false);

  /// `Super Mario World (USA) (Rev 1) [!]` → title `Super Mario World`, no
  /// year; `Doom (1993)` keeps its year; `Legend of Zelda, The (Europe)` →
  /// `The Legend of Zelda`. Tags are the No-Intro/TOSEC/Redump conventions
  /// (region, revision, dump flags); a four-digit group is the year.
  static ({String title, String? year}) titleAndYear(String name) {
    String? year;
    final stripped = name.replaceAllMapped(_tag, (m) {
      final inner = m.group(1)!.trim();
      if (year == null && _year.hasMatch(inner) && _plausibleYear(inner)) {
        year = inner;
      }
      return '';
    });
    var title = stripped.replaceAll(RegExp(r'\s+'), ' ').trim();
    final the = _theSuffix.firstMatch(title);
    if (the != null) title = '${the.group(2)} ${the.group(1)}'.trim();
    if (title.isEmpty) title = name.trim();
    return (title: title, year: year);
  }

  static bool _plausibleYear(String digits) {
    final value = int.parse(digits);
    return value >= 1950 && value <= 2100;
  }

  /// `game.tar.gz` with extension `tar.gz` → `game`; the extension is the one
  /// the platform table matched, so a multi-part extension comes off whole.
  static String stem(String fileName, String extension) {
    final suffix = '.$extension';
    if (fileName.toLowerCase().endsWith(suffix.toLowerCase())) {
      return fileName.substring(0, fileName.length - suffix.length);
    }
    final dot = fileName.lastIndexOf('.');
    return dot <= 0 ? fileName : fileName.substring(0, dot);
  }

  /// The `FILE "x.bin" BINARY` names of a cue sheet: a disc's tracks, which
  /// the scanner needs next to the cue.
  static List<String> cueReferencedFiles(String cueText) =>
      [for (final m in _cueFile.allMatches(cueText)) m.group(1)!];
}
