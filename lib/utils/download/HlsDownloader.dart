import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/M3u8.dart';
import 'package:player/utils/download/SubtitleStreams.dart';

class DownloadSelection {
  const DownloadSelection({
    this.videoQuality = DownloadVideoQuality.original,
    this.audioQuality = DownloadAudioQuality.original,
    this.spokenLanguages = const [],
    this.downloadSubtitles = true,
  });

  final DownloadVideoQuality videoQuality;
  final DownloadAudioQuality audioQuality;

  /// ISO 639-3 codes; the audio renditions kept besides the default one.
  final List<String> spokenLanguages;
  final bool downloadSubtitles;
}

class DownloadCancelToken {
  bool _cancelled = false;
  bool get isCancelled => _cancelled;
  void cancel() => _cancelled = true;
}

class DownloadCancelled implements Exception {}

/// A download that cannot succeed by retrying (file gone, no disk space).
class DownloadFailure implements Exception {
  DownloadFailure(this.message, {this.noSpace = false});
  final String message;
  final bool noSpace;
  @override
  String toString() => message;
}

class HlsDownloadResult {
  const HlsDownloadResult({
    required this.bytes,
    required this.segmentsDone,
    required this.segmentsTotal,
    required this.audioStreamIndexes,
    required this.subtitleStreamIds,
    required this.artworkFile,
  });

  final int bytes;
  final int segmentsDone;
  final int segmentsTotal;
  final List<int> audioStreamIndexes;
  final List<String> subtitleStreamIds;
  final String? artworkFile;
}

/// Mirrors one media file's HLS tree into a directory: the master playlist
/// (rewritten to the kept renditions, tokens stripped), the kept media
/// playlists and every segment they list, the SRT subtitle sidecars and the
/// cover. Segment files are the unit of resumability — a complete one on disk
/// is never fetched again, a `.part` is discarded.
///
/// The server generates segments lazily and sequentially, blocking a request
/// up to a minute until the FFmpeg pass reaches it, so segments are fetched in
/// playlist order and transient failures back off rather than fail.
class HlsDownloader {
  HlsDownloader({
    http.Client? httpClient,
    Future<String?> Function(String serverName)? tokenProvider,
    void Function(String serverName)? onAuthFailure,
    Duration Function(int attempt)? backoff,
    this.maxAttempts = 8,
    this.segmentTimeout = const Duration(seconds: 90),
    this.masterTimeout = const Duration(seconds: 150),
    this.bodyTimeout = const Duration(minutes: 5),
  })  : _http = httpClient ?? http.Client(),
        _tokenProvider = tokenProvider ?? StreamTokenService.ensureToken,
        _onAuthFailure = onAuthFailure ?? StreamTokenService.invalidateToken,
        _backoff = backoff ?? _defaultBackoff;

  final http.Client _http;
  final Future<String?> Function(String serverName) _tokenProvider;
  final void Function(String serverName) _onAuthFailure;
  final Duration Function(int attempt) _backoff;
  final int maxAttempts;
  final Duration segmentTimeout;
  final Duration masterTimeout;
  final Duration bodyTimeout;

  static Duration _defaultBackoff(int attempt) {
    const steps = [2, 4, 8, 16, 32, 60, 60, 60];
    return Duration(seconds: steps[attempt.clamp(0, steps.length - 1)]);
  }

  Future<HlsDownloadResult> download({
    required String serverName,
    required Directory dir,
    required String nodeUrl,
    required String mediaFileId,
    required List<Fragment$fragmentMediaFiles$mediaFileStreams?>? streams,
    required DownloadSelection selection,
    String? artworkUrl,
    required void Function(DownloadProgress progress) onProgress,
    required DownloadCancelToken cancel,
  }) async {
    await dir.create(recursive: true);
    await _discardPartials(dir);
    var bytes = await _existingBytes(dir);

    final isVideo = SubtitleStreams.hasVideo(streams);
    final bool direct;
    final bool transcode;
    if (isVideo) {
      direct = selection.videoQuality == DownloadVideoQuality.original;
      transcode = !direct;
    } else {
      direct = selection.audioQuality == DownloadAudioQuality.original;
      transcode = !direct;
    }

    // 1. Master.
    final masterUrl = ImageUtil.buildMasterUrl(nodeUrl, mediaFileId,
        direct: direct, transcode: transcode);
    final masterText = await _getText(serverName, masterUrl, cancel,
        timeout: masterTimeout);
    final master = M3u8.parseMaster(masterText);
    if (master.variants.isEmpty) {
      throw DownloadFailure('master playlist has no variants');
    }

    // 2. Pick variants and renditions.
    final variants = _pickVariants(master, isVideo, selection.videoQuality);
    final audioGroups = variants.map((v) => v.audioGroup).whereType<String>().toSet();
    final audio = master.media
        .where((m) => m.type == 'AUDIO' && audioGroups.contains(m.groupId))
        .toList();
    final keptAudio = _pickAudio(audio, selection.spokenLanguages);

    final playlists = <String>[
      ...variants.map((v) => v.uri),
      ...keptAudio.map((m) => m.uri),
    ];
    // An audio-only variant points straight at the audio playlist that the
    // rendition also names; mirror it once.
    final uniquePlaylists = playlists.toSet().toList();

    await _writeAtomic(
      File('${dir.path}/master.m3u8'),
      M3u8.rewriteMaster(master,
          keepVariantUris: variants.map((v) => v.uri).toSet(),
          keepMediaUris: keptAudio.map((m) => m.uri).toSet()),
    );

    // 3. Media playlists → segment work list, in playlist order.
    final work = <String>[];
    for (final name in uniquePlaylists) {
      _checkCancel(cancel);
      final text = await _getText(
          serverName, _fileUrl(nodeUrl, mediaFileId, name), cancel,
          timeout: segmentTimeout);
      await _writeAtomic(File('${dir.path}/$name'), M3u8.rewriteMediaPlaylist(text));
      work.addAll(M3u8.parseSegmentUris(text));
    }
    final total = work.length;
    var done = 0;
    var lastReport = DateTime.now();
    void report({bool force = false}) {
      final now = DateTime.now();
      if (force || now.difference(lastReport).inMilliseconds >= 500) {
        lastReport = now;
        onProgress(DownloadProgress(
            bytes: bytes, segmentsDone: done, segmentsTotal: total));
      }
    }

    // 4. Segments.
    for (final name in work) {
      _checkCancel(cancel);
      final target = File('${dir.path}/$name');
      if (await target.exists()) {
        done++;
        report();
        continue;
      }
      final length = await _getToFile(
          serverName, _fileUrl(nodeUrl, mediaFileId, name), target, cancel,
          timeout: segmentTimeout);
      bytes += length;
      done++;
      report();
    }
    report(force: true);

    // 5. Subtitle sidecars (video only, tiny, all text tracks).
    final subtitleIds = <String>[];
    if (isVideo && selection.downloadSubtitles) {
      for (final s in SubtitleStreams.sideloadable(streams)) {
        _checkCancel(cancel);
        final name = 'sub_${s.id}.srt';
        final target = File('${dir.path}/$name');
        if (!await target.exists()) {
          try {
            bytes += await _getToFile(serverName,
                _fileUrl(nodeUrl, mediaFileId, name), target, cancel,
                timeout: segmentTimeout);
          } on DownloadFailure {
            // A subtitle the server cannot render must not sink the download.
            continue;
          }
        }
        subtitleIds.add(s.id);
      }
    }

    // 6. Cover (best effort).
    String? artworkFile;
    if (artworkUrl != null) {
      final target = File('${dir.path}/artwork.jpg');
      try {
        if (!await target.exists()) {
          bytes += await _getToFile(serverName, artworkUrl, target, cancel,
              timeout: segmentTimeout, maxAttemptsOverride: 2);
        }
        artworkFile = 'artwork.jpg';
      } on DownloadCancelled {
        rethrow;
      } catch (_) {
        artworkFile = null;
      }
    }

    return HlsDownloadResult(
      bytes: await _existingBytes(dir),
      segmentsDone: done,
      segmentsTotal: total,
      audioStreamIndexes: keptAudio
          .map((m) => _audioStreamIndex(m.uri))
          .whereType<int>()
          .toList(),
      subtitleStreamIds: subtitleIds,
      artworkFile: artworkFile,
    );
  }

  // ---- selection -------------------------------------------------------

  static List<HlsVariant> _pickVariants(
      HlsMaster master, bool isVideo, DownloadVideoQuality quality) {
    if (!isVideo) return [master.variants.first];
    final wanted = switch (quality) {
      DownloadVideoQuality.original => null,
      DownloadVideoQuality.p720 => 720,
      DownloadVideoQuality.p480 => 480,
    };
    if (wanted == null) return [master.variants.first];
    final match = master.variants.where((v) => v.height == wanted).toList();
    return match.isEmpty ? [master.variants.first] : [match.first];
  }

  static List<HlsMedia> _pickAudio(List<HlsMedia> audio, List<String> langs) {
    if (audio.isEmpty) return const [];
    final kept = <HlsMedia>[];
    for (final m in audio) {
      final lang = m.language?.toLowerCase();
      if (m.isDefault || (lang != null && langs.map((l) => l.toLowerCase()).contains(lang))) {
        kept.add(m);
      }
    }
    if (kept.isEmpty) kept.add(audio.first);
    return kept;
  }

  /// `stream_audio_<streamIndex>_<label>.m3u8` → streamIndex.
  static int? _audioStreamIndex(String uri) {
    final m = RegExp(r'^stream_audio_(\d+)_').firstMatch(uri);
    return m == null ? null : int.tryParse(m.group(1)!);
  }

  // ---- HTTP ------------------------------------------------------------

  static String _fileUrl(String nodeUrl, String mediaFileId, String name) {
    final base = nodeUrl.endsWith('/')
        ? nodeUrl.substring(0, nodeUrl.length - 1)
        : nodeUrl;
    return '$base/hls/$mediaFileId/$name';
  }

  Future<Uri> _tokenized(String serverName, String url) async {
    String? token;
    try {
      token = await _tokenProvider(serverName);
    } catch (_) {
      token = null;
    }
    if (token == null) return Uri.parse(url);
    return Uri.parse('$url${url.contains('?') ? '&' : '?'}token=$token');
  }

  Future<String> _getText(String serverName, String url, DownloadCancelToken cancel,
      {required Duration timeout}) async {
    final response = await _send(serverName, url, cancel, timeout: timeout);
    return await response.stream.bytesToString().timeout(bodyTimeout);
  }

  /// Streams a response into [target] via a `.part` file; returns its size.
  Future<int> _getToFile(String serverName, String url, File target,
      DownloadCancelToken cancel,
      {required Duration timeout, int? maxAttemptsOverride}) async {
    final response = await _send(serverName, url, cancel,
        timeout: timeout, maxAttemptsOverride: maxAttemptsOverride);
    final part = File('${target.path}.part');
    final sink = part.openWrite();
    try {
      await response.stream.pipe(sink).timeout(bodyTimeout);
    } on FileSystemException catch (e) {
      await _tryDelete(part);
      throw DownloadFailure('write failed: ${e.message}',
          noSpace: e.osError?.errorCode == 28);
    } catch (e) {
      await _tryDelete(part);
      rethrow;
    }
    await part.rename(target.path);
    return await target.length();
  }

  /// GET with retry/backoff for transient failures and one token refresh on
  /// an auth rejection. Throws [DownloadFailure] for permanent errors.
  Future<http.StreamedResponse> _send(
      String serverName, String url, DownloadCancelToken cancel,
      {required Duration timeout, int? maxAttemptsOverride}) async {
    final attempts = maxAttemptsOverride ?? maxAttempts;
    var authRetried = false;
    for (var attempt = 0;; attempt++) {
      _checkCancel(cancel);
      http.StreamedResponse? response;
      Object? transient;
      try {
        final uri = await _tokenized(serverName, url);
        response = await _http.send(http.Request('GET', uri)).timeout(timeout);
      } on TimeoutException catch (e) {
        transient = e;
      } on http.ClientException catch (e) {
        transient = e;
      } on SocketException catch (e) {
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
        if (code == 404) throw DownloadFailure('not found: $url');
        if (code < 500 && code != 408 && code != 429) {
          throw DownloadFailure('HTTP $code for $url');
        }
        transient = 'HTTP $code';
      }
      if (attempt + 1 >= attempts) {
        throw DownloadFailure('giving up on $url: $transient');
      }
      await _sleepCancellable(_backoff(attempt), cancel);
    }
  }

  Future<void> _drain(http.StreamedResponse r) async {
    try {
      await r.stream.drain<void>().timeout(const Duration(seconds: 5));
    } catch (_) {}
  }

  Future<void> _sleepCancellable(Duration d, DownloadCancelToken cancel) async {
    final end = DateTime.now().add(d);
    while (DateTime.now().isBefore(end)) {
      _checkCancel(cancel);
      final left = end.difference(DateTime.now());
      await Future.delayed(
          left < const Duration(milliseconds: 250) ? left : const Duration(milliseconds: 250));
    }
  }

  static void _checkCancel(DownloadCancelToken cancel) {
    if (cancel.isCancelled) throw DownloadCancelled();
  }

  // ---- files -----------------------------------------------------------

  static Future<void> _writeAtomic(File file, String text) async {
    final tmp = File('${file.path}.part');
    try {
      await tmp.writeAsString(text, flush: true);
    } on FileSystemException catch (e) {
      throw DownloadFailure('write failed: ${e.message}',
          noSpace: e.osError?.errorCode == 28);
    }
    await tmp.rename(file.path);
  }

  static Future<void> _discardPartials(Directory dir) async {
    await for (final e in dir.list()) {
      if (e is File && e.path.endsWith('.part')) await _tryDelete(e);
    }
  }

  static Future<int> _existingBytes(Directory dir) async {
    var total = 0;
    await for (final e in dir.list()) {
      if (e is File) total += await e.length();
    }
    return total;
  }

  static Future<void> _tryDelete(File f) async {
    try {
      if (await f.exists()) await f.delete();
    } catch (_) {}
  }
}
