import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/download/DownloadHttp.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/M3u8.dart';
import 'package:player/utils/download/SubtitleStreams.dart';

export 'package:player/utils/download/DownloadHttp.dart'
    show DownloadCancelToken, DownloadCancelled, DownloadFailure;

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

/// Mirrors one media file's HLS tree into a directory. Implemented in-process
/// by [HlsDownloader] and on a background isolate by `IsolateHlsDownloader` —
/// the service uses the latter, the tests the former.
abstract interface class HlsDownloaderApi {
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
  });
}

/// Mirrors one media file's HLS tree into a directory: the master playlist
/// (rewritten to the kept renditions, tokens stripped), the kept media
/// playlists and every segment they list, the SRT subtitle sidecars and the
/// cover. Segment files are the unit of resumability — a complete one on disk
/// is never fetched again, a `.part` is discarded.
///
/// The server runs one FFmpeg pass per playlist and that pass writes its
/// segments in order, blocking a request until it gets there. Segments are
/// therefore fetched in playlist order and transient failures back off rather
/// than fail — but within one playlist a bounded window of them is fetched at
/// a time. A single request costs ~80 ms of server time and only ~25 ms of
/// transfer, so fetching them strictly one by one left the server (and the
/// line) idle ~90% of the time; a window of four made a measured 1.8 MB/s
/// into 36 MB/s. The window stays small on a re-encode, where the pass itself
/// is the bottleneck and reading ahead only parks requests in the backend.
class HlsDownloader implements HlsDownloaderApi {
  HlsDownloader({
    http.Client? httpClient,
    Future<String?> Function(String serverName)? tokenProvider,
    void Function(String serverName)? onAuthFailure,
    Duration Function(int attempt)? backoff,
    int maxAttempts = 8,
    this.segmentTimeout = const Duration(seconds: 90),
    this.masterTimeout = const Duration(seconds: 150),
    this.segmentConcurrency = 4,
    this.transcodeSegmentConcurrency = 2,
    Duration bodyTimeout = const Duration(minutes: 5),
    DownloadHttp? http,
  }) : _http = http ??
            DownloadHttp(
              httpClient: httpClient,
              tokenProvider: tokenProvider,
              onAuthFailure: onAuthFailure,
              backoff: backoff,
              maxAttempts: maxAttempts,
              bodyTimeout: bodyTimeout,
            );

  final DownloadHttp _http;
  final Duration segmentTimeout;
  final Duration masterTimeout;

  /// Segments fetched at a time within one playlist when the server only
  /// copies the stream (the whole pass is done in under a second, so this is
  /// pure request pipelining).
  final int segmentConcurrency;

  /// The same for a re-encoded rendition, where FFmpeg produces segments as
  /// playback speed allows: a wide window would just leave requests parked in
  /// the backend until [segmentTimeout].
  final int transcodeSegmentConcurrency;

  @override
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
    await DownloadHttp.discardPartials(dir);
    var bytes = await DownloadHttp.existingBytes(dir);

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
    final masterText = await _http.getText(serverName, masterUrl, cancel,
        timeout: masterTimeout);
    final master = M3u8.parseMaster(masterText);
    if (master.variants.isEmpty) {
      throw DownloadFailure('master playlist has no variants');
    }

    // 2. Pick variants and renditions.
    final variants = _pickVariants(master, isVideo, selection.videoQuality);
    final audioGroups =
        variants.map((v) => v.audioGroup).whereType<String>().toSet();
    final audio = master.media
        .where((m) => m.type == 'AUDIO' && audioGroups.contains(m.groupId))
        .toList();
    final keptAudio = _pickAudio(audio, selection.spokenLanguages);

    // An audio-only variant points straight at the audio playlist that the
    // rendition also names; mirror it once.
    final uniquePlaylists = <String>{
      ...variants.map((v) => v.uri),
      ...keptAudio.map((m) => m.uri),
    }.toList();

    await DownloadHttp.writeAtomic(
      File('${dir.path}/master.m3u8'),
      M3u8.rewriteMaster(master,
          keepVariantUris: variants.map((v) => v.uri).toSet(),
          keepMediaUris: keptAudio.map((m) => m.uri).toSet()),
    );

    // 3. Media playlists → segment work, per playlist and in playlist order.
    // A name is only ever fetched once: an #EXT-X-MAP init segment can repeat
    // within a playlist and be shared between renditions, and two workers on
    // one `.part` file would corrupt it.
    final work = <List<String>>[];
    final seen = <String>{};
    for (final name in uniquePlaylists) {
      DownloadHttp.checkCancel(cancel);
      final text = await _http.getText(
          serverName, _fileUrl(nodeUrl, mediaFileId, name), cancel,
          timeout: segmentTimeout);
      await DownloadHttp.writeAtomic(
          File('${dir.path}/$name'), M3u8.rewriteMediaPlaylist(text));
      work.add(
          [for (final uri in M3u8.parseSegmentUris(text)) if (seen.add(uri)) uri]);
    }
    final total = work.fold<int>(0, (sum, list) => sum + list.length);
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

    // 4. Segments: playlist after playlist (each is its own FFmpeg pass),
    // a bounded window within each.
    final window = direct ? segmentConcurrency : transcodeSegmentConcurrency;
    for (final playlist in work) {
      await _fetchSegments(
        playlist,
        window,
        serverName: serverName,
        dir: dir,
        nodeUrl: nodeUrl,
        mediaFileId: mediaFileId,
        cancel: cancel,
        onSegmentDone: (length) {
          bytes += length;
          done++;
          report();
        },
      );
    }
    report(force: true);

    // 5. Subtitle sidecars (video only, tiny, all text tracks).
    final subtitleIds = <String>[];
    if (isVideo && selection.downloadSubtitles) {
      for (final s in SubtitleStreams.sideloadable(streams)) {
        DownloadHttp.checkCancel(cancel);
        final name = 'sub_${s.id}.srt';
        final target = File('${dir.path}/$name');
        if (!await target.exists()) {
          try {
            bytes += await _http.getToFile(serverName,
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
    final artworkFile = await fetchArtwork(_http, serverName, dir, artworkUrl,
        cancel, timeout: segmentTimeout);

    return HlsDownloadResult(
      bytes: await DownloadHttp.existingBytes(dir),
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

  /// Fetches [names] with at most [window] requests in flight, handing the
  /// next name to whichever worker comes free — a worker stuck on a segment
  /// the encoder has not reached yet then holds up only itself.
  ///
  /// Each worker keeps its own failure instead of letting it escape: a bare
  /// `Future.wait` would surface the first one and leave the others
  /// unobserved, which is an unhandled async error. The first failure is
  /// rethrown with its original stack once every worker has stopped, so the
  /// service still sees `DownloadFailure.transient` / `noSpace`. A cancel
  /// outranks a failure — a download the user stopped must go back to
  /// `queued`, not to `failed` with a retry count.
  Future<void> _fetchSegments(
    List<String> names,
    int window, {
    required String serverName,
    required Directory dir,
    required String nodeUrl,
    required String mediaFileId,
    required DownloadCancelToken cancel,
    required void Function(int length) onSegmentDone,
  }) async {
    var next = 0;
    Object? firstError;
    StackTrace? firstStack;

    Future<void> worker() async {
      while (true) {
        if (firstError != null) return;
        if (cancel.isCancelled) {
          firstError ??= DownloadCancelled();
          return;
        }
        // Single-threaded: nothing can interleave between read and increment.
        final at = next++;
        if (at >= names.length) return;
        final name = names[at];
        try {
          final target = File('${dir.path}/$name');
          if (await target.exists()) {
            onSegmentDone(0);
            continue;
          }
          final length = await _http.getToFile(
              serverName, _fileUrl(nodeUrl, mediaFileId, name), target, cancel,
              timeout: segmentTimeout);
          onSegmentDone(length);
        } catch (e, stack) {
          firstError ??= e;
          firstStack ??= stack;
          return;
        }
      }
    }

    final workers = window.clamp(1, names.isEmpty ? 1 : names.length);
    await Future.wait([for (var i = 0; i < workers; i++) worker()]);

    DownloadHttp.checkCancel(cancel);
    if (firstError != null) {
      Error.throwWithStackTrace(firstError!, firstStack ?? StackTrace.current);
    }
  }

  /// `artwork.jpg` from [artworkUrl] (token-free; the token is appended per
  /// request). Null when there is no cover or it could not be fetched.
  static Future<String?> fetchArtwork(DownloadHttp http, String serverName,
      Directory dir, String? artworkUrl, DownloadCancelToken cancel,
      {required Duration timeout}) async {
    if (artworkUrl == null) return null;
    final target = File('${dir.path}/artwork.jpg');
    try {
      if (!await target.exists()) {
        await http.getToFile(serverName, artworkUrl, target, cancel,
            timeout: timeout, maxAttemptsOverride: 2);
      }
      return 'artwork.jpg';
    } on DownloadCancelled {
      rethrow;
    } catch (_) {
      return null;
    }
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
    final wanted = langs.map((l) => l.toLowerCase()).toSet();
    final kept = <HlsMedia>[];
    for (final m in audio) {
      final lang = m.language?.toLowerCase();
      if (m.isDefault || (lang != null && wanted.contains(lang))) kept.add(m);
    }
    if (kept.isEmpty) kept.add(audio.first);
    return kept;
  }

  /// `stream_audio_<streamIndex>_<label>.m3u8` → streamIndex.
  static int? _audioStreamIndex(String uri) {
    final m = RegExp(r'^stream_audio_(\d+)_').firstMatch(uri);
    return m == null ? null : int.tryParse(m.group(1)!);
  }

  static String _fileUrl(String nodeUrl, String mediaFileId, String name) {
    final base = nodeUrl.endsWith('/')
        ? nodeUrl.substring(0, nodeUrl.length - 1)
        : nodeUrl;
    return '$base/hls/$mediaFileId/$name';
  }
}
