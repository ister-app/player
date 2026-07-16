/// A reading position inside a comic volume, stored in the server's opaque
/// `readingLocation` field (scoped by `readingLocationMediaFileId`).
///
/// Serialized as `ister-comic:v1;page=<index>;pct=<0..1>`. The page index is
/// the first *logical* page of what is on screen — never a spread index — so
/// the position survives orientation and single/double-page changes. Anything
/// unrecognized makes [tryParse] return null, after which the caller falls
/// back to the stored progress fraction.
class ComicLocator {
  const ComicLocator({required this.pageIndex, this.fraction = 0});

  static const String _prefix = 'ister-comic:v1';

  /// Zero-based index of the left-most logical page in reading order.
  final int pageIndex;

  /// Whole-volume fraction at save time; drives the progress bar and serves
  /// as the cross-file fallback.
  final double fraction;

  String serialize() =>
      '$_prefix;page=$pageIndex;pct=${fraction.toStringAsFixed(6)}';

  static ComicLocator? tryParse(String? location) {
    if (location == null || !location.startsWith('$_prefix;')) return null;
    int? page;
    double fraction = 0;
    for (final part in location.substring(_prefix.length + 1).split(';')) {
      final separator = part.indexOf('=');
      if (separator <= 0) continue;
      final key = part.substring(0, separator);
      final value = part.substring(separator + 1);
      switch (key) {
        case 'page':
          page = int.tryParse(value);
        case 'pct':
          fraction = double.tryParse(value)?.clamp(0.0, 1.0) ?? 0;
      }
    }
    if (page == null || page < 0) return null;
    return ComicLocator(pageIndex: page, fraction: fraction);
  }
}
