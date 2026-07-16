import 'package:flutter/foundation.dart';
import 'package:player/utils/epub/ChapterContent.dart';
import 'package:player/utils/epub/EpubPackage.dart';
import 'package:player/utils/epub/EpubResourceClient.dart';
import 'package:player/utils/LoggerService.dart';

/// One open book: the parsed package, a per-spine-item content cache and the
/// text-length weights that turn a (spine, block) position into a whole-book
/// fraction.
///
/// The weights start out uniform and are refined by a background pass that
/// loads every spine document once (they are small, and both the session cache
/// and the server's immutable caching make this cheap). Listeners are notified
/// when the weights improve so the progress label can update; positions never
/// depend on the weights, only the displayed fraction does.
class ReaderBookController extends ChangeNotifier {
  ReaderBookController({required this.client, required this.package}) {
    _charCounts = List<int?>.filled(package.spine.length, null);
  }

  final EpubResourceClient client;
  final EpubPackage package;

  final Map<int, Future<ChapterContent>> _content = {};
  late final List<int?> _charCounts;
  Future<void>? _weighing;
  bool _disposed = false;

  Future<ChapterContent> contentFor(int spineIndex) {
    return _content.putIfAbsent(spineIndex, () async {
      final href = package.spine[spineIndex].href;
      final content = ChapterContent.parse(
        await client.text(href),
        _dirOf(href),
      );
      _charCounts[spineIndex] = content.charCount;
      return content;
    });
  }

  /// Kicks off the background weighing pass; safe to call more than once. The
  /// returned future completes when every chapter has a real weight — the
  /// moment fraction-based mappings become trustworthy (the web reader's
  /// "locations generated" equivalent).
  Future<void> refineWeights() {
    return _weighing ??= () async {
      for (var index = 0; index < package.spine.length; index++) {
        if (_disposed) return;
        if (_charCounts[index] != null) continue;
        try {
          await contentFor(index);
        } catch (error) {
          // A chapter that fails to load keeps its uniform weight.
          _charCounts[index] ??= 0;
          LoggerService().logger.w('Could not weigh chapter $index: $error');
        }
      }
      if (!_disposed) notifyListeners();
    }();
  }

  /// The whole-book fraction of a position, by text length when known and by
  /// chapter count otherwise.
  double bookFraction(int spineIndex, double withinChapter) {
    final weights = _effectiveWeights();
    final total = weights.fold<double>(0, (sum, weight) => sum + weight);
    if (total <= 0 || spineIndex < 0 || spineIndex >= weights.length) return 0;
    double elapsed = 0;
    for (var index = 0; index < spineIndex; index++) {
      elapsed += weights[index];
    }
    elapsed += weights[spineIndex] * withinChapter.clamp(0.0, 1.0);
    return (elapsed / total).clamp(0.0, 1.0);
  }

  /// The inverse of [bookFraction]: which chapter (and how far into it) a
  /// whole-book fraction lands on.
  ({int spineIndex, double withinChapter}) positionForFraction(
      double fraction) {
    final weights = _effectiveWeights();
    final total = weights.fold<double>(0, (sum, weight) => sum + weight);
    if (total <= 0 || weights.isEmpty) {
      return (spineIndex: 0, withinChapter: 0);
    }
    var target = fraction.clamp(0.0, 1.0) * total;
    for (var index = 0; index < weights.length; index++) {
      if (target <= weights[index] || index == weights.length - 1) {
        final within = weights[index] > 0 ? target / weights[index] : 0.0;
        return (spineIndex: index, withinChapter: within.clamp(0.0, 1.0));
      }
      target -= weights[index];
    }
    return (spineIndex: 0, withinChapter: 0);
  }

  /// Unknown chapters weigh as much as the average known one (or 1 when
  /// nothing is known yet), so early estimates stay sane.
  List<double> _effectiveWeights() {
    final known = _charCounts.whereType<int>().where((count) => count > 0);
    final fallback = known.isEmpty
        ? 1.0
        : known.fold<double>(0, (sum, count) => sum + count) / known.length;
    return _charCounts
        .map((count) =>
            count == null || count <= 0 ? fallback : count.toDouble())
        .toList();
  }

  static String _dirOf(String entryPath) => entryPath.contains('/')
      ? entryPath.substring(0, entryPath.lastIndexOf('/') + 1)
      : '';

  @override
  void dispose() {
    _disposed = true;
    client.dispose();
    super.dispose();
  }
}
