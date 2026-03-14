import 'package:media_kit/media_kit.dart';
import 'package:player/utils/LanguagePreferences.dart';
import 'package:player/utils/LanguageService.dart';

class TrackSelector {
  final Player player;

  TrackSelector(this.player);

  Future<void> applyPreferences(Tracks tracks) async {
    await _selectPreferred<SubtitleTrack>(
      tracks.subtitle,
      LanguagePreferences.getSubtitleLanguages,
      player.setSubtitleTrack,
    );
    await _selectPreferred<AudioTrack>(
      tracks.audio,
      LanguagePreferences.getSpokenLanguages,
      player.setAudioTrack,
    );
  }

  Future<void> _selectPreferred<T>(
    List<T> available,
    Future<List<String>> Function() getPrefs,
    Future<void> Function(T) setter,
  ) async {
    final prefs = await getPrefs();

    for (final lang in prefs) {
      final data = await LanguageService().getLanguageData(lang);
      if (data == null) continue;

      final matches = available
          .where((t) => data.toCodeList().contains(_language(t)))
          .toList();

      if (matches.isNotEmpty) {
        await setter(matches.first);
        return;
      }
    }

    await setter(_fallback<T>());
  }

  String? _language<T>(T track) {
    if (track is SubtitleTrack) return track.language;
    if (track is AudioTrack) return track.language;
    return null;
  }

  T _fallback<T>() {
    if (T == SubtitleTrack) return SubtitleTrack.no() as T;
    if (T == AudioTrack) return AudioTrack.auto() as T;
    throw UnimplementedError('No fallback for type $T');
  }
}
