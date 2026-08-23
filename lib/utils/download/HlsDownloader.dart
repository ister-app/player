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
    int maxAttempts = 8,
    this.segmentTimeout = const Duration(seconds: 90),
    this.masterTimeout = const Duration(seconds: 150),
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

    // 3. Media playlists → segment work list, in playlist order.
    final work = <String>[];
    for (final name in uniquePlaylists) {
      DownloadHttp.checkCancel(cancel);
      final text = await _http.getText(
          serverName, _fileUrl(nodeUrl, mediaFileId, name), cancel,
          timeout: segmentTimeout);
      await DownloadHttp.writeAtomic(
          File('${dir.path}/$name'), M3u8.rewriteMediaPlaylist(text));
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
      DownloadHttp.checkCancel(cancel);
      final target = File('${dir.path}/$name');
      if (await target.exists()) {
        done++;
        report();
        continue;
      }
      final length = await _http.getToFile(
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
