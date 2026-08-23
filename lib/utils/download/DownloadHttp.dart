import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:player/utils/StreamTokenService.dart';

class DownloadCancelToken {
  bool _cancelled = false;
  bool get isCancelled => _cancelled;
  void cancel() => _cancelled = true;
}

class DownloadCancelled implements Exception {}

/// A download that stopped. [transient] failures (network gone, server
/// unreachable, timeouts after all retries) are retried automatically by the
/// service later; the others (file gone, no disk space) wait for the user.
class DownloadFailure implements Exception {
  DownloadFailure(this.message, {this.noSpace = false, this.transient = false});
  final String message;
  final bool noSpace;
  final bool transient;
  @override
  String toString() => message;
}

/// The HTTP and file plumbing every downloader shares: GET with retry,
/// backoff and one token refresh on an auth rejection; streaming a body into
/// a `.part` file that is renamed when complete; atomic small writes.
class DownloadHttp {
  DownloadHttp({
    http.Client? httpClient,
    Future<String?> Function(String serverName)? tokenProvider,
    void Function(String serverName)? onAuthFailure,
    Duration Function(int attempt)? backoff,
    this.maxAttempts = 8,
    this.bodyTimeout = const Duration(minutes: 5),
  })  : _http = httpClient ?? http.Client(),
        _tokenProvider = tokenProvider ?? StreamTokenService.ensureToken,
        _onAuthFailure = onAuthFailure ?? StreamTokenService.invalidateToken,
        _backoff = backoff ?? defaultBackoff;

  final http.Client _http;
  final Future<String?> Function(String serverName) _tokenProvider;
  final void Function(String serverName) _onAuthFailure;
  final Duration Function(int attempt) _backoff;
  final int maxAttempts;
  final Duration bodyTimeout;

  static Duration defaultBackoff(int attempt) {
    const steps = [2, 4, 8, 16, 32, 60, 60, 60];
    return Duration(seconds: steps[attempt.clamp(0, steps.length - 1)]);
  }

  Future<Uri> tokenized(String serverName, String url) async {
    String? token;
    try {
      token = await _tokenProvider(serverName);
    } catch (_) {
      token = null;
    }
    if (token == null) return Uri.parse(url);
    return Uri.parse('$url${url.contains('?') ? '&' : '?'}token=$token');
  }

  Future<String> getText(String serverName, String url, DownloadCancelToken cancel,
      {required Duration timeout}) async {
    final response = await send(serverName, url, cancel, timeout: timeout);
    return await response.stream.bytesToString().timeout(bodyTimeout);
  }

  /// Streams a response into [target] via a `.part` file; returns its size.
  Future<int> getToFile(String serverName, String url, File target,
      DownloadCancelToken cancel,
      {required Duration timeout,
      int? maxAttemptsOverride,
      Duration? bodyTimeoutOverride}) async {
    final response = await send(serverName, url, cancel,
        timeout: timeout, maxAttemptsOverride: maxAttemptsOverride);
    await target.parent.create(recursive: true);
    final part = File('${target.path}.part');
    final sink = part.openWrite();
    try {
      await response.stream
          .pipe(sink)
          .timeout(bodyTimeoutOverride ?? bodyTimeout);
    } on FileSystemException catch (e) {
      await tryDelete(part);
      throw DownloadFailure('write failed: ${e.message}',
          noSpace: e.osError?.errorCode == 28);
    } catch (e) {
      await tryDelete(part);
      rethrow;
    }
    await part.rename(target.path);
    return await target.length();
  }

  /// GET with retry/backoff for transient failures and one token refresh on
  /// an auth rejection. Throws [DownloadFailure] for permanent errors.
  Future<http.StreamedResponse> send(
      String serverName, String url, DownloadCancelToken cancel,
      {required Duration timeout, int? maxAttemptsOverride}) async {
    final attempts = maxAttemptsOverride ?? maxAttempts;
    var authRetried = false;
    for (var attempt = 0;; attempt++) {
      checkCancel(cancel);
      http.StreamedResponse? response;
      Object? transient;
      try {
        final uri = await tokenized(serverName, url);
        response = await _http.send(http.Request('GET', uri)).timeout(timeout);
      } on TimeoutException catch (e) {
        transient = e;
      } on http.ClientException catch (e) {
        transient = e;
      } on IOException catch (e) {
        // DNS failure, TLS handshake, connection reset: the network, not
        // the file.
        transient = e;
      }
      if (response != null) {
        final code = response.statusCode;
        if (code == 200) return response;
        await _drain(response);
        if ((code == 401 || code == 403) && !authRetried) {
          authRetried = true;
          _onAuthFailure(serverName);
          continue;
        }
        if (code == 401 || code == 403) {
          // Still refused after a token refresh: the token service could not
          // mint a new one (server unreachable) — recovers later.
          throw DownloadFailure('HTTP $code for $url', transient: true);
        }
        if (code == 404) throw DownloadFailure('not found: $url');
        if (code < 500 && code != 408 && code != 429) {
          throw DownloadFailure('HTTP $code for $url');
        }
        transient = 'HTTP $code';
      }
      if (attempt + 1 >= attempts) {
        throw DownloadFailure('giving up on $url: $transient', transient: true);
      }
      await sleepCancellable(_backoff(attempt), cancel);
    }
  }

  Future<void> _drain(http.StreamedResponse r) async {
    try {
      await r.stream.drain<void>().timeout(const Duration(seconds: 5));
    } catch (_) {}
  }

  static Future<void> sleepCancellable(
      Duration d, DownloadCancelToken cancel) async {
    final end = DateTime.now().add(d);
    while (DateTime.now().isBefore(end)) {
      checkCancel(cancel);
      final left = end.difference(DateTime.now());
      await Future.delayed(left < const Duration(milliseconds: 250)
          ? left
          : const Duration(milliseconds: 250));
    }
  }

  static void checkCancel(DownloadCancelToken cancel) {
    if (cancel.isCancelled) throw DownloadCancelled();
  }

  // ---- files -----------------------------------------------------------

  static Future<void> writeAtomic(File file, String text) async {
    await file.parent.create(recursive: true);
    final tmp = File('${file.path}.part');
    try {
      await tmp.writeAsString(text, flush: true);
    } on FileSystemException catch (e) {
      throw DownloadFailure('write failed: ${e.message}',
          noSpace: e.osError?.errorCode == 28);
    }
    await tmp.rename(file.path);
  }

  static Future<void> discardPartials(Directory dir) async {
    if (!await dir.exists()) return;
    await for (final e in dir.list(recursive: true)) {
      if (e is File && e.path.endsWith('.part')) await tryDelete(e);
    }
  }

  static Future<int> existingBytes(Directory dir) async {
    if (!await dir.exists()) return 0;
    var total = 0;
    await for (final e in dir.list(recursive: true)) {
      if (e is File) total += await e.length();
    }
    return total;
  }

  static Future<void> tryDelete(File f) async {
    try {
      if (await f.exists()) await f.delete();
    } catch (_) {}
  }
}
