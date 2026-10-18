import 'dart:async';
import 'dart:io';
import 'dart:math';

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

  /// Bumped whenever a request reacted to an auth rejection by dropping the
  /// token. Requests running in parallel share one token, so they all get the
  /// same 401 at once; only the first of them should invalidate it. The rest
  /// see a changed generation and simply retry with what the refresh produced
  /// — otherwise every worker would mint its own token and the last writer
  /// would clobber the one already in use.
  int _authGeneration = 0;

  /// Spacing between retries: 2s, 4, 8 … capped at a minute, with ±20%
  /// jitter. Without the jitter parallel workers that all hit the same server
  /// hiccup back off in lockstep and hammer it again together.
  static Duration defaultBackoff(int attempt) {
    const steps = [2, 4, 8, 16, 32, 60, 60, 60];
    final base = steps[attempt.clamp(0, steps.length - 1)] * 1000;
    final jitter = (base * 0.2 * (_random.nextDouble() * 2 - 1)).round();
    return Duration(milliseconds: base + jitter);
  }

  static final Random _random = Random();

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
  ///
  /// With [resume] a `.part` left behind by an earlier attempt is continued
  /// through an HTTP Range request instead of being thrown away — for the
  /// multi-gigabyte files of a game install. A server that answers 200 to the
  /// range (no Range support, or a changed file) restarts the file from zero.
  Future<int> getToFile(String serverName, String url, File target,
      DownloadCancelToken cancel,
      {required Duration timeout,
      int? maxAttemptsOverride,
      Duration? bodyTimeoutOverride,
      bool resume = false}) async {
    await target.parent.create(recursive: true);
    final part = File('${target.path}.part');
    var offset = 0;
    if (resume && await part.exists()) {
      offset = await part.length();
    }
    final response = await send(serverName, url, cancel,
        timeout: timeout,
        maxAttemptsOverride: maxAttemptsOverride,
        rangeStart: offset > 0 ? offset : null);
    final append = offset > 0 && response.statusCode == 206;
    final sink = part.openWrite(mode: append ? FileMode.append : FileMode.write);
    try {
      await response.stream
          .pipe(sink)
          .timeout(bodyTimeoutOverride ?? bodyTimeout);
    } on FileSystemException catch (e) {
      if (!resume) await tryDelete(part);
      throw DownloadFailure('write failed: ${e.message}',
          noSpace: e.osError?.errorCode == 28);
    } catch (e) {
      // A resumable part stays for the next attempt; the rest start over.
      if (!resume) await tryDelete(part);
      rethrow;
    }
    await part.rename(target.path);
    return await target.length();
  }

  /// GET with retry/backoff for transient failures and one token refresh on
  /// an auth rejection. Throws [DownloadFailure] for permanent errors.
  ///
  /// [rangeStart] asks for the bytes from that offset on (`Range: bytes=N-`);
  /// the response is then 206, or 200 when the server ignored the range.
  Future<http.StreamedResponse> send(
      String serverName, String url, DownloadCancelToken cancel,
      {required Duration timeout, int? maxAttemptsOverride, int? rangeStart}) async {
    final attempts = maxAttemptsOverride ?? maxAttempts;
    var authRetried = false;
    for (var attempt = 0;; attempt++) {
      checkCancel(cancel);
      http.StreamedResponse? response;
      Object? transient;
      // The generation the token below belongs to (see [_authGeneration]).
      final generation = _authGeneration;
      try {
        final uri = await tokenized(serverName, url);
        final request = http.Request('GET', uri);
        if (rangeStart != null && rangeStart > 0) {
          request.headers['Range'] = 'bytes=$rangeStart-';
        }
        response = await _http.send(request).timeout(timeout);
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
        if (code == 200 || (code == 206 && rangeStart != null)) return response;
        await _drain(response);
        if ((code == 401 || code == 403) && generation != _authGeneration) {
          // Another request already dropped this token; retry with whatever
          // the refresh produced instead of invalidating it again.
          continue;
        }
        if ((code == 401 || code == 403) && !authRetried) {
          authRetried = true;
          _authGeneration++;
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
