import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/LanguageService.dart';
import '../../utils/MediaPlayerHandler.dart';

/// Observes the player's audio/subtitle tracks and performs track switches.
///
/// Extracted from the old below-the-video `TrackSelectionWidget` so the same
/// logic can back the in-overlay track menu (and be unit tested). Keeps the
/// one-shot late-track re-read: HLS on Linux can deliver the real track list
/// well after the stream opens, without a `tracks` event.
class TrackSelectionController extends ChangeNotifier {
  TrackSelectionController({Player? player, MediaPlayerHandler? handler})
      : _player = player ?? MediaPlayerHandler.instance.player,
        _handler = handler ?? MediaPlayerHandler.instance {
    _audioTracks = _player.state.tracks.audio;
    _subtitleTracks = _player.state.tracks.subtitle;
    _currentAudio = _player.state.track.audio;
    _currentSubtitle = _player.state.track.subtitle;

    _tracksSubscription = _player.stream.tracks.listen((tracks) {
      _audioTracks = tracks.audio;
      _subtitleTracks = tracks.subtitle;
      if (tracks.audio.length > 2 || tracks.subtitle.length > 2) {
        _tracksTimer?.cancel();
      }
      notifyListeners();
    });

    _trackSubscription = _player.stream.track.listen((track) {
      _currentAudio = track.audio;
      _currentSubtitle = track.subtitle;
      notifyListeners();
    });

    // HLS on Linux: tracks can arrive late. One-shot re-read.
    if (_audioTracks.length <= 2 && _subtitleTracks.length <= 2) {
      _tracksTimer = Timer(const Duration(milliseconds: 800), () {
        final tracks = _player.state.tracks;
        if (tracks.audio.length > 2 || tracks.subtitle.length > 2) {
          _audioTracks = tracks.audio;
          _subtitleTracks = tracks.subtitle;
          notifyListeners();
        }
      });
    }
  }

  final Player _player;
  final MediaPlayerHandler _handler;

  List<AudioTrack> _audioTracks = [];
  List<SubtitleTrack> _subtitleTracks = [];
  AudioTrack? _currentAudio;
  SubtitleTrack? _currentSubtitle;

  late final StreamSubscription _tracksSubscription;
  late final StreamSubscription _trackSubscription;
  Timer? _tracksTimer;

  List<AudioTrack> get audioTracks => _audioTracks;

  bool get hasMultipleAudio =>
      _audioTracks.where((t) => t != AudioTrack.auto()).length > 1;

  bool get hasSubtitles => _subtitleTracks.isNotEmpty;

  /// True when mpv reports no real subtitle track while the server's analysis
  /// of the file *does* list subtitle streams: those are the image-based subs
  /// (DVD/PGS bitmaps) the server dropped from the HLS master playlist. The
  /// menu then shows a disabled explanation instead of hiding entirely.
  bool get fileHasUnsupportedSubtitles => unsupportedSubtitlesFor(
      _subtitleTracks,
      _handler.currentVideoFileStreams.map((s) => s?.codecType));

  static bool unsupportedSubtitlesFor(
      List<SubtitleTrack> mpvTracks, Iterable<String?> fileStreamCodecTypes) {
    final hasRealTrack = mpvTracks.any((t) => t.id != 'no' && t.id != 'auto');
    if (hasRealTrack) return false;
    return fileStreamCodecTypes.any((t) => t == 'SUBTITLE');
  }

  bool get hasAnyMenu =>
      hasMultipleAudio || hasSubtitles || fileHasUnsupportedSubtitles;

  AudioTrack get currentAudio => effectiveAudio(_currentAudio, _audioTracks);

  /// Subtitle options always include "none", even when mpv did not list it.
  List<SubtitleTrack> get subtitleOptions =>
      subtitleOptionsFor(_subtitleTracks);

  SubtitleTrack get currentSubtitle =>
      effectiveSubtitle(_currentSubtitle, subtitleOptions);

  // The derivation/label logic is static and pure so it can be unit tested
  // without a live (native) mpv player behind the controller.

  static AudioTrack effectiveAudio(AudioTrack? current, List<AudioTrack> tracks) {
    final c = current ?? AudioTrack.auto();
    return tracks.contains(c) ? c : (tracks.isNotEmpty ? tracks.first : c);
  }

  static List<SubtitleTrack> subtitleOptionsFor(List<SubtitleTrack> tracks) {
    final noTrack = SubtitleTrack.no();
    return tracks.contains(noTrack) ? tracks : [noTrack, ...tracks];
  }

  static SubtitleTrack effectiveSubtitle(
      SubtitleTrack? current, List<SubtitleTrack> options) {
    final c = current ?? SubtitleTrack.no();
    return options.contains(c) ? c : SubtitleTrack.no();
  }

  /// `"Stereo – English"`, or just `"Dutch"` for a track without a title.
  ///
  /// mpv reports the language as the bare code the container carries (`eng`,
  /// `nld`), which is what this menu used to show. The title is dropped when it
  /// *is* that code: side-loaded subtitles get the language as their title when
  /// the file has no real one (see `MediaPlayerHandler._addExternalSubtitles`),
  /// which would otherwise read as "nld – Dutch".
  static String _trackLabel(
      String? title, String? language, String fallback, AppLocalizations loc) {
    final name = (language == null || language.isEmpty)
        ? null
        : LanguageService().displayName(language, loc.localeName);
    final parts = [
      if (title != null && title.isNotEmpty && title != language) title,
      ?name,
    ];
    return parts.isNotEmpty ? parts.join(' – ') : fallback;
  }

  static String audioLabel(AudioTrack t, AppLocalizations loc) {
    if (t == AudioTrack.auto()) return loc.trackAuto;
    return _trackLabel(t.title, t.language, t.id, loc);
  }

  static String subtitleLabel(SubtitleTrack t, AppLocalizations loc) {
    if (t == SubtitleTrack.no()) return loc.trackNone;
    return _trackLabel(t.title, t.language, t.id, loc);
  }

  Future<void> selectAudio(AudioTrack t) async {
    _currentAudio = t;
    notifyListeners();
    await _player.setAudioTrack(t);
    // mpv can leave the new audio track silent mid-HLS-stream; a re-seek to the
    // current position restarts demuxing with the new selection.
    if (!kIsWeb) await _player.seek(_player.state.position);
  }

  Future<void> selectSubtitle(SubtitleTrack t) {
    _currentSubtitle = t;
    notifyListeners();
    return _handler.switchSubtitleTrack(t);
  }

  @override
  void dispose() {
    _tracksTimer?.cancel();
    _tracksSubscription.cancel();
    _trackSubscription.cancel();
    super.dispose();
  }
}
