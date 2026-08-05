import '../graphql/fragmentBookProgress.graphql.dart';
import '../graphql/schema.graphql.dart';

/// Reading of `Book.progress`: where the user is in the book *as a whole*.
///
/// The server aggregates it (finished chapters count in full), so listeners see
/// their position in the book instead of the position inside one chapter.
/// Everything here tolerates a null [Fragment$fragmentBookProgress]: servers
/// older than the field simply don't send it, and callers fall back to whatever
/// they showed before.
class BookProgressUtil {
  const BookProgressUtil._();

  /// Value for a progress bar, or null when there is nothing to show — never
  /// started, or read/listened to the end (a finished book gets no bar, the way
  /// a watched episode doesn't).
  static double? barValue(Fragment$fragmentBookProgress? progress) {
    if (progress == null || progress.finished) return null;
    return progress.progress.clamp(0.0, 1.0);
  }

  /// Whether the user is in the audiobook rather than the epub.
  static bool isListening(Fragment$fragmentBookProgress? progress) =>
      progress?.mode == Enum$BookProgressMode.LISTENING;

  /// Percentage of the whole book, for a label next to the bar.
  static int? percentage(Fragment$fragmentBookProgress? progress) {
    final value = barValue(progress);
    return value == null ? null : (value * 100).round();
  }
}
