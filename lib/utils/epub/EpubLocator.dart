/// A reading position inside an epub, stored in the server's opaque
/// `readingLocation` field (scoped by `readingLocationMediaFileId`).
///
/// Serialized as `ister:v1;spine=<idref>;block=<index>;frag=<id>;pct=<0..1>`.
/// The block index is the position in the chapter's flattened block list (see
/// ChapterContent), which is independent of font size and viewport — unlike a
/// pixel offset. Positions written by the retired web reader are epubcfi
/// strings; those (and anything else unrecognized) make [tryParse] return
/// null, after which the caller falls back to the stored progress fraction.
class EpubLocator {
  const EpubLocator({
    required this.spineIdref,
    required this.blockIndex,
    this.fragment,
    this.bookFraction = 0,
  });

  static const String _prefix = 'ister:v1';

  final String spineIdref;
  final int blockIndex;

  /// Id of the first identified element at/inside the block, when it has one;
  /// sentence-exact for read-aloud epubs.
  final String? fragment;

  /// Whole-book fraction at save time; drives the progress bar and serves as
  /// the cross-edition fallback.
  final double bookFraction;

  String serialize() {
    final parts = [
      _prefix,
      'spine=${Uri.encodeComponent(spineIdref)}',
      'block=$blockIndex',
      if (fragment != null) 'frag=${Uri.encodeComponent(fragment!)}',
      'pct=${bookFraction.toStringAsFixed(6)}',
    ];
    return parts.join(';');
  }

  static EpubLocator? tryParse(String? location) {
    if (location == null || !location.startsWith('$_prefix;')) return null;
    String? spine;
    int? block;
    String? fragment;
    double fraction = 0;
    for (final part in location.substring(_prefix.length + 1).split(';')) {
      final separator = part.indexOf('=');
      if (separator <= 0) continue;
      final key = part.substring(0, separator);
      final value = part.substring(separator + 1);
      try {
        switch (key) {
          case 'spine':
            spine = Uri.decodeComponent(value);
          case 'block':
            block = int.tryParse(value);
          case 'frag':
            fragment = Uri.decodeComponent(value);
          case 'pct':
            fraction = double.tryParse(value)?.clamp(0.0, 1.0) ?? 0;
        }
      } on ArgumentError {
        return null;
      }
    }
    if (spine == null || spine.isEmpty || block == null || block < 0) {
      return null;
    }
    return EpubLocator(
      spineIdref: spine,
      blockIndex: block,
      fragment: fragment,
      bookFraction: fraction,
    );
  }
}
