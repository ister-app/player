import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/LanguageService.dart';
import '../../utils/MediaPlayerHandler.dart';
import '../../utils/subtitles/BitmapSubtitles.dart';

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

    _handler.bitmapSubtitle.addListener(notifyListeners);

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

  /// Picture-based subtitle tracks (PGS/VobSub) the app draws itself; the
  /// player knows nothing about them.
  List<BitmapSubtitleTrack> get bitmapSubtitleTracks =>
      _handler.currentBitmapSubtitleTracks;

  /// The bitmap track on screen, or null when a player track (or none) is.
  BitmapSubtitleTrack? get currentBitmapSubtitle =>
      _handler.bitmapSubtitle.value;

  /// True when the file has subtitle streams nobody can show: no player track,
  /// no bitmap track the server has a parser for — what is left is e.g. DVB
  /// bitmaps. The menu then shows a disabled explanation instead of hiding.
  bool get fileHasUnsupportedSubtitles => unsupportedSubtitlesFor(
      _subtitleTracks,
      _handler.currentVideoFileStreams.map((s) => s?.codecType),
      bitmapSubtitleTracks);

  static bool unsupportedSubtitlesFor(
      List<SubtitleTrack> mpvTracks, Iterable<String?> fileStreamCodecTypes,
      [List<BitmapSubtitleTrack> bitmapTracks = const []]) {
    final hasRealTrack = mpvTracks.any((t) => t.id != 'no' && t.id != 'auto');
    if (hasRealTrack || bitmapTracks.isNotEmpty) return false;
    return fileStreamCodecTypes.any((t) => t == 'SUBTITLE');
  }

  bool get hasAnyMenu =>
      hasMultipleAudio ||
      hasSubtitles ||
      bitmapSubtitleTracks.isNotEmpty ||
      fileHasUnsupportedSubtitles;

  AudioTrack get currentAudio => effectiveAudio(_currentAudio, _audioTracks);

  /// Subtitle options always include "none", even when mpv did not list it.
  List<SubtitleTrack> get subtitleOptions =>
      subtitleOptionsFor(_subtitleTracks);

  /// While a bitmap track is on screen the player's own track is "none",
  /// which must not read as the selected menu entry.
  SubtitleTrack? get currentSubtitle => currentBitmapSubtitle != null
      ? null
      : effectiveSubtitle(_currentSubtitle, subtitleOptions);

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

  static String bitmapSubtitleLabel(
          BitmapSubtitleTrack t, int number, AppLocalizations loc) =>
      _trackLabel(t.title, t.language, '${loc.subtitlesTrackLabel} $number', loc);

  static String subtitleLabel(SubtitleTrack t, AppLocalizations loc) {
    if (t == SubtitleTrack.no()) return loc.trackNone;
    return _trackLabel(t.title, t.language, t.id, loc);
  }

  /// Numbers the labels that occur more than once — `"Stereo – English (1)"`,
  /// `"Stereo – English (2)"` — and leaves the rest alone. A DVD rip carries the
  /// main mix and the commentary under the same title and language; a current
  /// server already tells them apart in the rendition name, an older one (or a
  /// local file) does not.
  static List<String> numberDuplicates(List<String> labels) {
    final seen = <String, int>{};
    return [
      for (final label in labels)
        labels.where((l) => l == label).length > 1
            ? '$label (${seen[label] = (seen[label] ?? 0) + 1})'
            : label,
    ];
  }

  /// The audio menu's labels, in [tracks] order.
  static List<String> audioLabels(
          List<AudioTrack> tracks, AppLocalizations loc) =>
      numberDuplicates([for (final t in tracks) audioLabel(t, loc)]);

  /// The subtitle menu's labels: the player's [options] first, then the
  /// [bitmapTracks] — numbered as one list, because they share one menu.
  static List<String> subtitleMenuLabels(List<SubtitleTrack> options,
          List<BitmapSubtitleTrack> bitmapTracks, AppLocalizations loc) =>
      numberDuplicates([
        for (final t in options) subtitleLabel(t, loc),
        for (final (i, t) in bitmapTracks.indexed)
          bitmapSubtitleLabel(t, i + 1, loc),
      ]);

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

  Future<void> selectBitmapSubtitle(BitmapSubtitleTrack t) {
    _currentSubtitle = SubtitleTrack.no();
    return _handler.selectBitmapSubtitle(t);
  }

  @override
  void dispose() {
    _handler.bitmapSubtitle.removeListener(notifyListeners);
    _tracksTimer?.cancel();
    _tracksSubscription.cancel();
    _trackSubscription.cancel();
    super.dispose();
  }
}
