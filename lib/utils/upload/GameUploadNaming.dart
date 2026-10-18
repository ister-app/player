/// The folder name a game upload lands under: `Title (year)`, the layout
/// the scanner reads (`{platform}/{Title (year)}/…`). Pure, so the
/// composition and the parsing of a picked folder's name are testable.
class GameUploadNaming {
  GameUploadNaming._();

  static final RegExp _trailingYear = RegExp(r'^(.*?)\s*\((\d{4})\)\s*$');

  /// `Title (2009)`, or just the trimmed title without a year.
  static String compose(String title, String? year) {
    final cleanTitle = title.trim();
    final cleanYear = year?.trim() ?? '';
    if (cleanTitle.isEmpty) return '';
    return cleanYear.isEmpty ? cleanTitle : '$cleanTitle ($cleanYear)';
  }

  /// Splits `Demon's Souls (2009)` into its title and year, the way the
  /// scanner does; a name without a year keeps the whole name as the title.
  static ({String title, String? year}) parse(String folderName) {
    final match = _trailingYear.firstMatch(folderName.trim());
    if (match == null) return (title: folderName.trim(), year: null);
    return (title: match.group(1)!.trim(), year: match.group(2));
  }

  /// A plausible release year: four digits between 1950 and 2100, or empty.
  static bool isValidYear(String? year) {
    final clean = year?.trim() ?? '';
    if (clean.isEmpty) return true;
    final value = int.tryParse(clean);
    return value != null && clean.length == 4 && value >= 1950 && value <= 2100;
  }
}
