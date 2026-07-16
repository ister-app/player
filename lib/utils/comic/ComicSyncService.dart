import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:player/utils/comic/ComicLocator.dart';
import 'package:player/utils/epub/ReadingSyncService.dart' show BookProgress;

/// Loads and saves comic reading progress through the same REST pair the epub
/// reader uses (`/book-progress` + `/reading-progress`), with the audiobook
/// mapping left out: a comic has pages, not chapters. The last page reports
/// progress 1.0, which is what marks the volume finished server-side and makes
/// continue-watching hand over to the next volume of the series.
class ComicSyncService {
  ComicSyncService({
    required this.serverName,
    required this.bookId,
    required this.mediaFileId,
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  final String serverName;
  final String bookId;
  final String mediaFileId;
  final http.Client _http;

  static const Duration _debounce = Duration(milliseconds: 1500);

  BookProgress? progress;

  Timer? _saveTimer;
  ComicLocator? _pendingSave;
  bool _disposed = false;

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

  /// Fetches `/book-progress`. Failure leaves [progress] null: the volume
  /// opens at its first page and saving still works.
  Future<void> init() async {
    try {
      final response = await _http
          .get(await _endpoint('/book-progress', {'bookId': bookId}));
      if (response.statusCode != 200) {
        throw Exception('status ${response.statusCode}');
      }
      progress = BookProgress.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } catch (error) {
      LoggerService().logger.w('Could not fetch comic progress: $error');
      progress = null;
    }
  }

  /// The saved reading position, when it was recorded in this volume file and
  /// parses as a comic locator.
  ComicLocator? savedLocator() {
    final reading = progress?.reading;
    if (reading?.location == null) return null;
    if (reading!.mediaFileId != null && reading.mediaFileId != mediaFileId) {
      return null;
    }
    return ComicLocator.tryParse(reading.location);
  }

  /// The saved whole-volume fraction: the fallback when [savedLocator] fails
  /// (a position written by another file of the same book, or none at all).
  double savedFraction() => progress?.reading?.progress ?? 0;

  /// Debounced save; the newest position always wins. [flush] forces the
  /// pending one out (page close, app to background).
  void reportPosition(ComicLocator locator) {
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
    try {
      final response = await _http.post(
        await _endpoint('/reading-progress'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'bookId': bookId,
          'location': locator.serialize(),
          'progress': locator.fraction,
          'readingLocationMediaFileId': mediaFileId,
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
