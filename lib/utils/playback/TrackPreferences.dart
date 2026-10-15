// Which audio and subtitle track plays, and how the picture is framed, for
// the stream mpv has open: the language preferences, the forced tracks a
// re-open restores, the side-loaded external SRTs, the bitmap-subtitle
// fallback and the server-detected crop. Every async step re-checks
// [PlaybackCore.openGeneration]: a skip or re-open may have replaced the
// stream while it waited.
import 'dart:async';
import 'dart:ui' show Rect;

import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/utils/LanguagePreferences.dart';
import 'package:player/utils/LanguageService.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/PlaybackPreferences.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:player/utils/VideoCrop.dart';
import 'package:player/utils/download/DownloadService.dart';
import 'package:player/utils/download/SubtitleStreams.dart';
import 'package:player/utils/subtitles/BitmapSubtitles.dart';

import 'MediaUrls.dart';
import 'PlaybackCore.dart';

class TrackPreferences {
  TrackPreferences(this.core);

  final PlaybackCore core;

  // The tracks a re-open must restore (a backward seek past the stream-open
  // position, a stall-watchdog retry): applied once the new stream delivers
  // its track list, instead of the language preferences.
  SubtitleTrack? _forcedSubtitle;
  AudioTrack? _forcedAudio;

  bool _audioApplied = false;
  bool _subtitleApplied = false;
  bool _bitmapApplied = false;

  /// Whether a track was actually selected for the open stream — the only
  /// state worth carrying over a re-open (a load that hung before any track
  /// arrived has nothing to preserve).
  bool get audioApplied => _audioApplied;
  bool get subtitleApplied => _subtitleApplied;

  /// The open ([PlaybackCore.openGeneration]) whose external SRTs are still
  /// being side-loaded; the subtitle preference waits for the full list (see
  /// [loadExternalSubtitleTracks]). Not the url: a token re-stamp rewrites it.
  int? _externalSubtitlesLoadingFor;

  /// Language of the audio track that was actually selected for the open media,
  /// so the subtitle rule can compare against it.
  ///
  /// A field rather than a local: HLS delivers the audio list before the
  /// side-loaded subtitles, so the two blocks of [applyTrackPreferences]
  /// usually run in different invocations. Null means "not known" — either
  /// nothing has been applied yet, or the audio fell back to mpv's default.
  String? _selectedAudioLanguage;

  /// A new stream is about to open: preferences apply afresh. A re-open of the
  /// same file (stall watchdog, token re-stamp) keeps the bitmap subtitle the
  /// viewer is looking at; a different file starts over.
  void resetForOpen() {
    _audioApplied = false;
    _subtitleApplied = false;
    _selectedAudioLanguage = null;
    final keptBitmap = core.bitmapSubtitle.value;
    if (keptBitmap != null &&
        core.currentBitmapSubtitleTracks.contains(keptBitmap)) {
      _bitmapApplied = true;
    } else {
      core.bitmapSubtitle.value = null;
      _bitmapApplied = false;
    }
  }

  /// The stream is re-opened and should come back with [audio] and
  /// [subtitle] selected instead of the preferences. Null leaves that kind to
  /// the preferences.
  void carryOverForReopen(
      {required AudioTrack? audio, required SubtitleTrack? subtitle}) {
    if (audio != null) _forcedAudio = audio;
    if (subtitle != null) _forcedSubtitle = subtitle;
    _audioApplied = false;
    _subtitleApplied = false;
    _selectedAudioLanguage = null;
  }

  /// Drops a pending forced restore (a different file is about to open).
  void clearForced() {
    _forcedAudio = null;
    _forcedSubtitle = null;
  }

  /// Teardown: nothing is open any more.
  void clear() {
    clearForced();
    _audioApplied = false;
    _subtitleApplied = false;
    _bitmapApplied = false;
    _selectedAudioLanguage = null;
  }

/// Applies the preferences on every track-list delivery.
void listen() {
  core.player.stream.tracks.listen(applyTrackPreferences);
}

/// One-shot re-read for streams whose real track list arrives without a
/// `tracks` event (HLS on Linux does this): without it the forced/preferred
/// track silently never gets applied. Mirrors the same 800ms re-read in
/// TrackSelectionController.
Timer? _lateTracksTimer;

void armLateTracksReread() {
  _lateTracksTimer?.cancel();
  if (kIsWeb) return;
  _lateTracksTimer = Timer(const Duration(milliseconds: 800), () {
    if (!_audioApplied || !_subtitleApplied) {
      unawaited(applyTrackPreferences(core.player.state.tracks));
    }
  });
}

/// The track in a re-opened stream that is the one the user had [selected].
///
/// Language alone is not enough: a DVD rip carries the main mix and the
/// commentary as two English tracks, and matching on language put the viewer
/// back on the main mix after every re-open (a seek to before the stream-open
/// position, a watchdog retry). The same stream re-opened lists its tracks in
/// the same order, so the id settles it when title and language still agree;
/// after that the title (the server numbers same-named renditions), and only
/// then the language.
static AudioTrack restoredAudioTrack(
    List<AudioTrack> tracks, AudioTrack selected) {
  if (selected.id == 'no') return AudioTrack.no();
  if (selected.language == null) return AudioTrack.auto();
  final sameLanguage =
      tracks.where((t) => t.language == selected.language).toList();
  final sameTitle =
      sameLanguage.where((t) => t.title == selected.title).toList();
  return sameTitle.where((t) => t.id == selected.id).firstOrNull ??
      sameTitle.firstOrNull ??
      sameLanguage.firstOrNull ??
      AudioTrack.auto();
}

Future<void> applyTrackPreferences(Tracks tracks) async {
    debugPrint('[TRACKS_HANDLER] audioApplied=$_audioApplied subApplied=$_subtitleApplied | audio=${tracks.audio.map((t) => t.id).join(",")} sub=${tracks.subtitle.map((t) => t.id).join(",")}');

    if (!_audioApplied &&
        tracks.audio.any((t) => t.id != 'auto' && t.id != 'no')) {
      _audioApplied = true;
      final forcedAudio = _forcedAudio;
      _forcedAudio = null;
      if (forcedAudio != null && forcedAudio.id != 'auto') {
        // Restore the audio track the user had selected before the reload
        // ("no audio" included).
        final match = restoredAudioTrack(tracks.audio, forcedAudio);
        debugPrint('[TRACKS_HANDLER] restoring forced audio: ${match.id}');
        _selectedAudioLanguage = match.language;
        await core.player.setAudioTrack(match);
      } else {
        debugPrint('[TRACKS_HANDLER] applying audio preference');
        await LanguageService().ensureLoaded();
        final chosen = preferredTrack<AudioTrack>(
          tracks.audio,
          await LanguagePreferences.getSpokenLanguages(serverName: core.serverName),
        );
        // Null when nothing matched: mpv then picks the file's default and we
        // do not know its language yet, which the subtitle rule allows for.
        _selectedAudioLanguage = chosen?.language;
        await core.player.setAudioTrack(chosen ?? AudioTrack.auto());
      }
      debugPrint('[TRACKS_HANDLER] audio applied: ${core.player.state.track.audio.id}');
      // A file whose only subtitles are pictures never reaches the subtitle
      // block below (the player reports no subtitle track at all).
      if (SubtitleStreams.sideloadable(core.currentVideoFileStreams).isEmpty) {
        await _applyBitmapSubtitlePreference(_selectedAudioLanguage);
      }
    }

    if (!_subtitleApplied &&
        _externalSubtitlesLoadingFor != core.openGeneration &&
        tracks.subtitle.any((t) => t.id != 'auto' && t.id != 'no')) {
      _subtitleApplied = true;
      final forcedSubtitle = _forcedSubtitle;
      _forcedSubtitle = null;
      if (core.bitmapSubtitle.value != null) {
        // The overlay is showing a bitmap track (kept across a re-open).
        await core.player.setSubtitleTrack(SubtitleTrack.no());
      } else if (forcedSubtitle != null) {
        if (forcedSubtitle.id == 'no') {
          debugPrint('[TRACKS_HANDLER] restoring forced subtitle: no');
          await core.player.setSubtitleTrack(SubtitleTrack.no());
        } else {
          // Match by language since track IDs can change after a reload.
          final match = tracks.subtitle.firstWhere(
            (t) => t.language != null && t.language == forcedSubtitle.language,
            orElse: () => SubtitleTrack.no(),
          );
          debugPrint('[TRACKS_HANDLER] restoring forced subtitle: ${match.id}');
          await core.player.setSubtitleTrack(match);
        }
      } else {
        debugPrint('[TRACKS_HANDLER] applying subtitle preference');
        await LanguageService().ensureLoaded();
        final chosen = preferredTrack<SubtitleTrack>(
          tracks.subtitle,
          await LanguagePreferences.getSubtitleLanguages(serverName: core.serverName),
        );
        // The audio block usually ran first, but the side-loaded external
        // SRTs (sub-add right after open) can beat the HLS audio track list
        // — the player then doesn't know the audio language yet and the
        // suppression rule below would lose the race. A pending forced
        // restore or the server's stream metadata predicts what the audio
        // language is going to be.
        final audioLanguage = _selectedAudioLanguage ??
            core.player.state.track.audio.language ??
            _forcedAudio?.language ??
            predictedAudioLanguage(
              audioStreamLanguages: [
                for (final s in core.currentVideoFileStreams)
                  if (s != null && s.codecType == 'AUDIO') s.language,
              ],
              preferences: await LanguagePreferences.getSpokenLanguages(
                  serverName: core.serverName),
            );
        final suppressed = suppressesSubtitle(
          hideSubtitlesMatchingAudio:
              await PlaybackPreferences.getHideSubtitlesMatchingAudio(
                  serverName: core.serverName),
          subtitleLanguage: chosen?.language,
          audioLanguage: audioLanguage,
        );
        if (suppressed) {
          debugPrint('[TRACKS_HANDLER] subtitle ${chosen?.language} matches '
              'audio $audioLanguage: leaving subtitles off');
        }
        await core.player.setSubtitleTrack(
            chosen == null || suppressed ? SubtitleTrack.no() : chosen);
        // No text track in a preferred language: a picture-based one may be.
        if (chosen == null) {
          await _applyBitmapSubtitlePreference(audioLanguage);
        }
      }
      debugPrint('[TRACKS_HANDLER] subtitle applied: ${core.player.state.track.subtitle.id}');
  }
}

/// Picks a bitmap subtitle track by the same language rules as a text
/// track. Text wins when both exist in a preferred language: it is lighter
/// and the platform renders it natively.
Future<void> _applyBitmapSubtitlePreference(String? audioLanguage) async {
  if (_bitmapApplied) return;
  _bitmapApplied = true;
  final tracks = core.currentBitmapSubtitleTracks;
  if (tracks.isEmpty) return;
  await LanguageService().ensureLoaded();
  final chosen = preferredTrack<BitmapSubtitleTrack>(
    tracks,
    await LanguagePreferences.getSubtitleLanguages(serverName: core.serverName),
  );
  if (chosen == null) return;
  final suppressed = suppressesSubtitle(
    hideSubtitlesMatchingAudio:
        await PlaybackPreferences.getHideSubtitlesMatchingAudio(
            serverName: core.serverName),
    subtitleLanguage: chosen.language,
    audioLanguage: audioLanguage ?? core.player.state.track.audio.language,
  );
  debugPrint('[TRACKS_HANDLER] bitmap subtitle ${chosen.language} '
      '${suppressed ? "suppressed" : "applied"}');
  if (!suppressed) await core.selectBitmapSubtitle(chosen);
}


/// Kicks mpv's subtitle decoder after a backward seek by cycling `sid`
/// off/on, which drops and re-selects the subtitle substream at the current
/// position. Waits for the seek to settle first (buffering=false is the
/// observable edge; media_kit does not expose mpv's `seeking` property).
Future<void> refreshSubtitleDecoder(String sid) async {
  final platform = core.player.platform;
  if (platform is! NativePlayer) return;
  final generation = core.openGeneration;
  try {
    if (core.player.state.buffering) {
      await core.player.stream.buffering
          .firstWhere((b) => !b)
          .timeout(const Duration(seconds: 3));
    }
  } catch (_) {
    // Still buffering after 3s — refresh anyway; worst case it's a no-op.
  }
  // A queue skip or teardown may have replaced the stream while waiting.
  if (core.openGeneration != generation || core.currentMediaUrl == null) return;
  try {
    // Dynamic dispatch: see applyMpvNetworkOptions (MpvSetup.dart).
    final dynamic native = platform;
    await native.setProperty('sid', 'no');
    await native.setProperty('sid', sid);
  } catch (e) {
    LoggerService().logger.w('Subtitle decoder refresh failed: $e');
  }
}

/// Side-loads the current video's subtitles as external whole-file SRT
/// tracks (mpv `sub-add`). In-manifest HLS subtitles are deliberately not
/// used on native: ffmpeg's HLS demuxer re-delivers segment cues on every
/// refetch/reconnect and libass stacks the duplicates on screen. A single
/// SRT file is fetched once, demuxed natively, and survives seeks in both
/// directions. Must be re-run after every open — a fresh demuxer forgets
/// external tracks.
Future<void> loadExternalSubtitleTracks(
    String serverName, IsterMediaTypes mediaType) async {
  if (kIsWeb) return;
  if (mediaType != IsterMediaTypes.movie &&
      mediaType != IsterMediaTypes.episode) {
    return;
  }
  final platform = core.player.platform;
  if (platform is! NativePlayer) return;
  // The file that is open — its stream ids name the SRTs on the server.
  final mediaFile = core.currentVideoFile;
  final streams = mediaFile?.mediaFileStreams;
  if (mediaFile == null || streams == null || streams.isEmpty) return;
  final generation = core.openGeneration;
  final urlAtOpen = core.currentMediaUrl;
  final local = urlAtOpen != null && isLocalMediaUrl(urlAtOpen);
  final token = local ? null : StreamTokenService.getToken(serverName);
  if (!local && token == null) return;
  final nodeUrl = mediaFile.directory.servingNode.url;

  // Local playback side-loads the mirrored SRT files; online the server's.
  final sideloadable = SubtitleStreams.sideloadable(streams);
  final localFiles = local
      ? Map.fromEntries(DownloadService.instance
          .localSubtitleFiles(serverName, mediaFile.id)
          .map((e) => MapEntry(e.$1, e.$2)))
      : const <String, String>{};
  final tracks = local
      ? sideloadable.where((s) => localFiles.containsKey(s.id)).toList()
      : sideloadable;
  if (tracks.isEmpty) return;

  // Dynamic dispatch: see applyMpvNetworkOptions (MpvSetup.dart).
  final dynamic native = platform;
  try {
    // The server bakes a +1480ms shift into its SRTs (SUBTITLE_OFFSET_MS,
    // compensating the browser timeline that starts at 0 while the TS
    // timeline starts at the muxer delay). mpv aligns external subs against
    // the un-rebased TS timeline, which already carries that delay — so
    // without this correction every cue shows ~1.5s late.
    await native.setProperty('sub-delay', '-1.48');
  } catch (e) {
    LoggerService().logger.w('setting sub-delay failed: $e');
  }
  // Hold the subtitle preference until every SRT is in: mpv fires a
  // `tracks` event per sub-add, and applying on the first one picked the
  // best match among a single (English) track — the Dutch one still to
  // come never got a look-in (Seinfeld on Android, 2026-09).
  _externalSubtitlesLoadingFor = generation;
  try {
    var n = 0;
    for (final s in tracks) {
      // A queue skip or re-open may have replaced the stream while adding.
      if (core.openGeneration != generation || core.currentMediaUrl == null) return;
      n++;
      final url = local
          ? localFiles[s.id]!
          : '$nodeUrl/hls/${mediaFile.id}/sub_${s.id}.srt?token=$token';
      final title = (s.title?.isNotEmpty ?? false)
          ? s.title!
          : (s.language?.isNotEmpty ?? false)
              ? s.language!
              : 'Subtitle $n';
      final lang = (s.language?.isNotEmpty ?? false) ? s.language! : 'und';
      try {
        // 'auto' loads without selecting; the language preference / forced
        // restore in _applyTrackPreferences picks the track afterwards.
        await native.command(['sub-add', url, 'auto', title, lang]);
      } catch (e) {
        LoggerService().logger.w('sub-add failed for $title: $e');
      }
    }
  } finally {
    if (_externalSubtitlesLoadingFor == generation) {
      _externalSubtitlesLoadingFor = null;
      if (core.openGeneration == generation && !_subtitleApplied) {
        unawaited(applyTrackPreferences(core.player.state.tracks));
      }
    }
  }
}

/// Applies the server-detected baked-in black-bar crop (mpv `video-crop`)
/// for the current video item, scaled to the actually-decoded dimensions —
/// the playing HLS variant may be downscaled. Clears the crop for items
/// without one: the property is player-global and would leak to the next
/// stream. Native only; the server cannot crop the direct-play variant.
Future<void> applyServerDetectedCrop(IsterMediaTypes mediaType) async {
  if (kIsWeb) return;
  final platform = core.player.platform;
  if (platform is! NativePlayer) return;
  // Dynamic dispatch: see applyMpvNetworkOptions (MpvSetup.dart).
  final dynamic native = platform;
  try {
    final isVideo = mediaType == IsterMediaTypes.movie ||
        mediaType == IsterMediaTypes.episode;
    final video = isVideo
        ? core.currentVideoFileStreams
            .where((s) =>
                s != null && s.codecType == 'VIDEO' && (s.width) > 0)
            .firstOrNull
        : null;
    if (video == null || video.cropWidth == null) {
      await native.setProperty('video-crop', '');
      core.appliedVideoCrop.value = null;
      return;
    }
    final generation = core.openGeneration;
    // The crop must be expressed in the decoded stream's *coded* pixels —
    // mpv applies video-crop to the source rectangle before anamorphic
    // stretch, and silently ignores a rect that falls outside it. A
    // transcoded HLS variant may be downscaled, so wait briefly for mpv to
    // report the coded size (videoParams.w/h; the fork does not observe
    // bare width/height), then fall back to the source dimensions — exact
    // for direct play.
    final decoded = await _waitForDecodedVideoSize();
    final actualW = decoded?.$1 ?? video.width;
    final actualH = decoded?.$2 ?? video.height;
    // A queue skip or re-open may have replaced the stream while waiting.
    if (core.openGeneration != generation || core.currentMediaUrl == null) return;
    final crop = mpvCropString(
      srcW: video.width,
      srcH: video.height,
      cropX: video.cropX,
      cropY: video.cropY,
      cropW: video.cropWidth,
      cropH: video.cropHeight,
      actualW: actualW,
      actualH: actualH,
    );
    await native.setProperty('video-crop', crop ?? '');
    core.appliedVideoCrop.value = crop == null
        ? null
        : Rect.fromLTWH(
            video.cropX! / video.width,
            video.cropY! / video.height,
            video.cropWidth! / video.width,
            video.cropHeight! / video.height);
  } catch (e) {
    LoggerService().logger.w('applying video crop failed: $e');
  }
}

/// The decoded video's *coded* dimensions from mpv's videoParams (w/h).
/// Not dw/dh or the render rect: those are aspect-corrected display sizes,
/// and for an anamorphic stream (SAR ≠ 1 — the HLS transcoder's scale
/// filter preserves DAR by adjusting SAR) a crop scaled to them can exceed
/// the coded frame, which mpv silently ignores. Null when mpv doesn't
/// report within the timeout (e.g. video decode hasn't started).
Future<(int, int)?> _waitForDecodedVideoSize(
    {Duration timeout = const Duration(seconds: 10)}) async {
  final params = core.player.state.videoParams;
  if ((params.w ?? 0) > 0 && (params.h ?? 0) > 0) {
    return (params.w!, params.h!);
  }
  final completer = Completer<(int, int)?>();
  final sub = core.player.stream.videoParams.listen((p) {
    if ((p.w ?? 0) > 0 && (p.h ?? 0) > 0 && !completer.isCompleted) {
      completer.complete((p.w!, p.h!));
    }
  });
  try {
    return await completer.future.timeout(timeout, onTimeout: () => null);
  } finally {
    await sub.cancel();
  }
}


/// Pure and synchronous so the selection rules can be unit-tested without a
/// player: [LanguageService.lookup] answers from the table `main.dart` loads
/// before the first frame. Matching goes through [LanguageData.toCodeList] —
/// mpv reports the bare container code (`eng`, `nld`) while a preference is
/// stored as an ISO 639-3 id, so raw string equality would miss.
static T? preferredTrack<T>(List<T> available, List<String> preferences) {
  for (final lang in preferences) {
    final data = LanguageService().lookup(lang);
    if (data == null) continue;

    final codes = data.toCodeList();
    for (final track in available) {
      if (codes.contains(_trackLanguage(track))) return track;
    }
  }
  return null;
}

/// Whether the subtitle track that would be selected should be dropped
/// because it is the language already coming out of the speakers.
///
/// Deliberately does *not* fall through to the next preference: the point is
/// "I understand what I hear, show me nothing", not "show me my second
/// choice". A subtitle language explicitly ranked above the spoken one still
/// wins, because [preferredTrack] picked that one first.
static bool suppressesSubtitle({
  required bool hideSubtitlesMatchingAudio,
  required String? subtitleLanguage,
  required String? audioLanguage,
}) {
  if (!hideSubtitlesMatchingAudio) return false;
  return LanguageService().sameLanguage(subtitleLanguage, audioLanguage);
}

/// The audio language playback is going to end up with, predicted from the
/// server's stream metadata — for when the subtitle decision runs before mpv
/// has delivered its audio track list. A preference match predicts the
/// track [preferredTrack] will select; without one mpv plays the file's
/// default track, which can only be pinned down when every audio stream in
/// the file carries the same known language. Null means "cannot tell", and
/// the suppression rule already treats an unknown audio language as
/// never-matching.
static String? predictedAudioLanguage({
  required List<String?> audioStreamLanguages,
  required List<String> preferences,
}) {
  var i = 0;
  final tracks = [
    for (final lang in audioStreamLanguages) AudioTrack('${i++}', null, lang),
  ];
  final preferred = preferredTrack<AudioTrack>(tracks, preferences);
  if (preferred != null) return preferred.language;
  final known = audioStreamLanguages.nonNulls.toSet();
  if (known.length == 1 && !audioStreamLanguages.contains(null)) {
    return known.single;
  }
  return null;
}

static String? _trackLanguage<T>(T track) {
  if (track is BitmapSubtitleTrack) return track.language;
  if (track is SubtitleTrack) return track.language;
  if (track is AudioTrack) return track.language;
  return null;
}
}
