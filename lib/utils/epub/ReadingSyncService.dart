import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:player/utils/epub/EpubLocator.dart';
import 'package:player/utils/epub/ReaderBookController.dart';
import 'package:player/utils/epub/SmilDocument.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:player/utils/WellKnownService.dart';

/// The `/book-progress` response: the epub reading position and the audiobook
/// chapter positions, together.
class BookProgress {
  BookProgress({required this.reading, required this.chapters});

  final BookProgressReading? reading;
  final List<BookProgressChapter> chapters;

  static BookProgress fromJson(Map<String, dynamic> json) => BookProgress(
        reading: json['reading'] is Map<String, dynamic>
            ? BookProgressReading.fromJson(
                json['reading'] as Map<String, dynamic>)
            : null,
        chapters: [
          for (final chapter in (json['chapters'] as List<dynamic>? ?? []))
            if (chapter is Map<String, dynamic>)
              BookProgressChapter.fromJson(chapter),
        ],
      );
}

class BookProgressReading {
  BookProgressReading({
    this.location,
    this.mediaFileId,
    this.progress = 0,
    this.updatedAt,
  });

  final String? location;
  final String? mediaFileId;
  final double progress;
  final DateTime? updatedAt;

  static BookProgressReading fromJson(Map<String, dynamic> json) =>
      BookProgressReading(
        location: json['location'] as String?,
        mediaFileId: json['mediaFileId'] as String?,
        progress: (json['progress'] as num?)?.toDouble() ?? 0,
        updatedAt: _parseDate(json['updatedAt']),
      );
}

class BookProgressChapter {
  BookProgressChapter({
    required this.id,
    this.durationInMilliseconds = 0,
    this.progressInMilliseconds = 0,
    this.watched = false,
    this.updatedAt,
  });

  final String id;
  final int durationInMilliseconds;
  final int progressInMilliseconds;
  final bool watched;
  final DateTime? updatedAt;

  static BookProgressChapter fromJson(Map<String, dynamic> json) =>
      BookProgressChapter(
        id: '${json['id']}',
        durationInMilliseconds:
            (json['durationInMilliseconds'] as num?)?.toInt() ?? 0,
        progressInMilliseconds:
            (json['progressInMilliseconds'] as num?)?.toInt() ?? 0,
        watched: json['watched'] == true,
        updatedAt: _parseDate(json['updatedAt']),
      );
}

DateTime? _parseDate(dynamic value) {
  if (value is! String || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

/// A text position expressed as a spot in the book's audiobook edition.
class AudioPosition {
  const AudioPosition({required this.chapterId, required this.positionInMilliseconds});

  final String chapterId;
  final int positionInMilliseconds;
}

/// Where listening left off, in audiobook coordinates.
class ListeningPosition {
  const ListeningPosition({
    required this.chapterIndex,
    required this.positionInMilliseconds,
    required this.updatedAt,
  });

  final int chapterIndex;
  final int positionInMilliseconds;
  final DateTime updatedAt;
}

/// Loads and saves reading progress through the server's REST endpoints —
/// the same ones the old web reader used, because they are the pair that
/// carries the audiobook mapping: on every save the server mirrors the reading
/// position onto the audiobook chapter rows, so listening resumes where
/// reading stopped (and vice versa). The GraphQL `updateReadingProgress`
/// mutation lacks that mapping.
///
/// The audio ⇄ text translation is a port of the web reader's `sync` object,
/// with the epubcfi replaced by (spine, block) coordinates: audiobook chapters
/// are aligned with the spine through the TOC (one entry per chapter) or the
/// spine itself, sentence-exact via the read-aloud SMIL timeline when it
/// matches the audiobook chapter's duration, interpolated within the chapter
/// otherwise, and proportional over the whole book when nothing aligns.
class ReadingSyncService {
  ReadingSyncService({
    required this.serverName,
    required this.bookId,
    required this.mediaFileId,
    required this.book,
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  final String serverName;
  final String bookId;
  final String mediaFileId;
  final ReaderBookController book;
  final http.Client _http;

  static const Duration _debounce = Duration(milliseconds: 1500);

  BookProgress? progress;

  /// chapter index -> spine index; null when the two could not be aligned.
  List<int>? _spineForChapter;
  final Map<int, int> _chapterBySpine = {};
  final Map<int, Future<SmilDocument?>> _trustedSmil = {};

  Timer? _saveTimer;
  EpubLocator? _pendingSave;
  bool _disposed = false;

  List<BookProgressChapter> get _chapters => progress?.chapters ?? const [];

  int get _totalDurationMs => _chapters.fold(
      0, (total, chapter) => total + chapter.durationInMilliseconds);

  String get _apiBase {
    final url = WellKnownService.getCached(serverName)?.serverUrl ?? '';
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  Future<Uri> _endpoint(String path, [Map<String, String>? query]) async {
    // A failed token fetch shouldn't kill the sync: the request goes out
    // without one and the server decides (bearer auth may still apply).
    String? token;
    try {
      token = await StreamTokenService.ensureToken(serverName);
    } catch (_) {
      token = null;
    }
    return Uri.parse('$_apiBase$path').replace(queryParameters: {
      ...?query,
      if (token != null) 'token': token,
    });
  }

  /// Fetches `/book-progress` and aligns the audiobook chapters with the
  /// spine. Failure leaves [progress] null: the book opens at its start and
  /// saving still works.
  Future<void> init() async {
    try {
      final response =
          await _http.get(await _endpoint('/book-progress', {'bookId': bookId}));
      if (response.statusCode != 200) {
        throw Exception('status ${response.statusCode}');
      }
      progress =
          BookProgress.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } catch (error) {
      LoggerService().logger.w('Could not fetch book progress: $error');
      progress = null;
    }
    _align();
  }

  /// Bypasses the HTTP fetch so the mapping logic can be unit-tested.
  @visibleForTesting
  void initWithProgress(BookProgress? bookProgress) {
    progress = bookProgress;
    _align();
  }

  void _align() {
    _spineForChapter = null;
    _chapterBySpine.clear();
    final count = _chapters.length;
    if (count == 0) return;

    // Top-level TOC entries first: that is what epub.js gave the web reader
    // (nested entries live in subitems there), and audiobook chapter files
    // correspond to top-level chapters. The flattened list is only tried as
    // a fallback; matching it first would shift the whole mapping when a
    // chapter has sub-entries.
    final toc = book.package.toc;
    for (final candidate in [
      toc.where((entry) => entry.depth == 0).toList(),
      toc,
    ]) {
      if (candidate.length != count) continue;
      final spineIndexes = candidate
          .map((entry) => book.package.spineIndexForTocEntry(entry))
          .toList();
      if (spineIndexes.every((index) => index >= 0)) {
        _spineForChapter = spineIndexes;
        break;
      }
    }
    _spineForChapter ??=
        book.package.spine.length == count
            ? List<int>.generate(count, (index) => index)
            : null;
    final aligned = _spineForChapter;
    if (aligned == null) {
      LoggerService().logger.i(
          'Chapters could not be aligned with the spine; mapping the book proportionally.');
      return;
    }
    for (var chapter = 0; chapter < aligned.length; chapter++) {
      _chapterBySpine.putIfAbsent(aligned[chapter], () => chapter);
    }
  }

  /// The saved reading position, when it was recorded in this epub file and
  /// parses as one of our locators (positions from the retired web reader are
  /// epubcfi strings and fail the parse on purpose).
  EpubLocator? savedLocator() {
    final reading = progress?.reading;
    if (reading?.location == null) return null;
    if (reading!.mediaFileId != null && reading.mediaFileId != mediaFileId) {
      return null;
    }
    return EpubLocator.tryParse(reading.location);
  }

  /// Where listening left off: the chapter touched last, or the next one when
  /// it was finished — the same resume rule the player uses.
  ListeningPosition? listeningPosition() {
    var latest = -1;
    DateTime latestTime = DateTime.fromMillisecondsSinceEpoch(0);
    for (var index = 0; index < _chapters.length; index++) {
      final updatedAt = _chapters[index].updatedAt;
      if (updatedAt == null) continue;
      if (!updatedAt.isBefore(latestTime)) {
        latestTime = updatedAt;
        latest = index;
      }
    }
    if (latest < 0) return null;
    var index = latest;
    var position = _chapters[latest].progressInMilliseconds;
    if (_chapters[latest].watched && latest + 1 < _chapters.length) {
      index = latest + 1;
      position = _chapters[index].progressInMilliseconds;
    }
    return ListeningPosition(
      chapterIndex: index,
      positionInMilliseconds: position,
      updatedAt: latestTime,
    );
  }

  /// The SMIL pars of a chapter, but only when they can be trusted as that
  /// chapter's timeline: the read-aloud audio has to be the same recording as
  /// the audiobook file, checked by comparing the SMIL's end time with the
  /// chapter's duration.
  Future<SmilDocument?> _trustedSmilFor(int chapterIndex) {
    return _trustedSmil.putIfAbsent(chapterIndex, () async {
      final aligned = _spineForChapter;
      if (aligned == null) return null;
      final overlay =
          book.package.mediaOverlayForSpineIndex(aligned[chapterIndex]);
      if (overlay == null) return null;
      final durationMs = _chapters[chapterIndex].durationInMilliseconds;
      if (durationMs <= 0) return null;
      try {
        final smil = SmilDocument.parse(
          await book.client.text(overlay.href),
          overlay.href.contains('/')
              ? overlay.href.substring(0, overlay.href.lastIndexOf('/') + 1)
              : '',
        );
        if (smil.pars.isEmpty) return null;
        final smilEndMs = smil.end.inMilliseconds;
        final tolerance = (durationMs * 0.02).clamp(2000, double.infinity);
        if ((smilEndMs - durationMs).abs() > tolerance) {
          LoggerService().logger.i(
              'Chapter $chapterIndex: SMIL timeline (${smilEndMs}ms) does not '
              'match the audiobook file (${durationMs}ms); interpolating instead.');
          return null;
        }
        return smil;
      } catch (error) {
        LoggerService().logger.w(
            'Could not read the SMIL of chapter $chapterIndex: $error');
        return null;
      }
    });
  }

  /// The text position of an audiobook position.
  Future<({int spineIndex, int blockIndex})?> audioToText(
      int chapterIndex, int positionInMilliseconds) async {
    if (chapterIndex < 0 || chapterIndex >= _chapters.length) return null;
    final aligned = _spineForChapter;
    if (aligned == null) {
      final position = book.positionForFraction(
          _bookFractionForAudio(chapterIndex, positionInMilliseconds));
      return _blockAt(position.spineIndex, position.withinChapter);
    }
    final spineIndex = aligned[chapterIndex];

    final smil = await _trustedSmilFor(chapterIndex);
    if (smil != null) {
      SmilPar par = smil.pars.first;
      for (final candidate in smil.pars) {
        if (candidate.clipBegin.inMilliseconds <= positionInMilliseconds) {
          par = candidate;
        } else {
          break;
        }
      }
      final content = await book.contentFor(spineIndex);
      final blockIndex = content.blockIndexForId(par.fragment);
      if (blockIndex != null) {
        return (spineIndex: spineIndex, blockIndex: blockIndex);
      }
    }

    final duration = _chapters[chapterIndex].durationInMilliseconds;
    final fraction = duration > 0 ? positionInMilliseconds / duration : 0.0;
    return _blockAt(spineIndex, fraction);
  }

  /// The audiobook position of a text position.
  Future<AudioPosition?> textToAudio(int spineIndex, int blockIndex) async {
    if (_chapters.isEmpty) return null;
    final chapterIndex = _chapterBySpine[spineIndex];
    if (chapterIndex == null) {
      final content = await book.contentFor(spineIndex);
      final within = content.blocks.isEmpty
          ? 0.0
          : blockIndex / content.blocks.length;
      return _audioPositionFromFraction(book.bookFraction(spineIndex, within));
    }
    final chapter = _chapters[chapterIndex];

    final smil = await _trustedSmilFor(chapterIndex);
    if (smil != null) {
      final content = await book.contentFor(spineIndex);
      Duration? begin;
      for (final par in smil.pars) {
        final parBlock = content.blockIndexForId(par.fragment);
        if (parBlock == null) continue;
        if (parBlock > blockIndex) break;
        begin = par.clipBegin;
      }
      if (begin != null) {
        return AudioPosition(
          chapterId: chapter.id,
          positionInMilliseconds: begin.inMilliseconds,
        );
      }
    }

    final content = await book.contentFor(spineIndex);
    final fraction = content.blocks.length > 1
        ? blockIndex / (content.blocks.length - 1)
        : 0.0;
    return AudioPosition(
      chapterId: chapter.id,
      positionInMilliseconds:
          (fraction.clamp(0.0, 1.0) * chapter.durationInMilliseconds).round(),
    );
  }

  double _bookFractionForAudio(int chapterIndex, int positionInMilliseconds) {
    final total = _totalDurationMs;
    if (total <= 0) return 0;
    var elapsed = 0;
    for (var index = 0; index < chapterIndex; index++) {
      elapsed += _chapters[index].durationInMilliseconds;
    }
    return ((elapsed + positionInMilliseconds) / total).clamp(0.0, 1.0);
  }

  /// Fallback for unaligned books: a fraction of the book is a fraction of the
  /// audiobook.
  AudioPosition? _audioPositionFromFraction(double fraction) {
    final total = _totalDurationMs;
    if (total <= 0) return null;
    var target = fraction.clamp(0.0, 1.0) * total;
    for (final chapter in _chapters) {
      final duration = chapter.durationInMilliseconds;
      if (target <= duration || identical(chapter, _chapters.last)) {
        return AudioPosition(
          chapterId: chapter.id,
          positionInMilliseconds: target.clamp(0, duration.toDouble()).round(),
        );
      }
      target -= duration;
    }
    return null;
  }

  Future<({int spineIndex, int blockIndex})> _blockAt(
      int spineIndex, double withinChapter) async {
    try {
      final content = await book.contentFor(spineIndex);
      final blockIndex = content.blocks.isEmpty
          ? 0
          : (withinChapter.clamp(0.0, 1.0) * (content.blocks.length - 1))
              .round();
      return (spineIndex: spineIndex, blockIndex: blockIndex);
    } catch (_) {
      return (spineIndex: spineIndex, blockIndex: 0);
    }
  }

  /// Debounced save; the newest position always wins. [flush] forces the
  /// pending one out (page close, app to background).
  void reportPosition(EpubLocator locator) {
    if (_disposed) return;
    _pendingSave = locator;
    _saveTimer?.cancel();
    _saveTimer = Timer(_debounce, () => unawaited(flush()));
  }

  Future<void> flush() async {
    _saveTimer?.cancel();
    final locator = _pendingSave;
    _pendingSave = null;
    if (locator == null) return;

    final spineIndex = book.package.spineIndexForIdref(locator.spineIdref);
    AudioPosition? audio;
    if (spineIndex >= 0) {
      try {
        audio = await textToAudio(spineIndex, locator.blockIndex);
      } catch (error) {
        LoggerService().logger.w(
            'Could not map the reading position onto the audiobook: $error');
      }
    }
    try {
      final response = await _http.post(
        await _endpoint('/reading-progress'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'bookId': bookId,
          'location': locator.serialize(),
          'progress': locator.bookFraction,
          'readingLocationMediaFileId': mediaFileId,
          'chapterId': audio?.chapterId,
          'positionInMilliseconds': audio?.positionInMilliseconds,
        }),
      );
      if (response.statusCode >= 400) {
        throw Exception('status ${response.statusCode}');
      }
    } catch (error) {
      LoggerService().logger.w('Progress sync failed: $error');
    }
  }

  /// Flushes the pending position, then closes the HTTP client.
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _saveTimer?.cancel();
    unawaited(flush().whenComplete(_http.close));
  }
}
