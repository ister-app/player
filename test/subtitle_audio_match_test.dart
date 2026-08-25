import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/utils/LanguageService.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

/// Pins the track-preference rules, including "no subtitles in the language you
/// are already hearing".
///
/// Pure functions, no player: [MediaPlayerHandler.preferredTrack] and
/// [MediaPlayerHandler.suppressesSubtitle] are what `_applyTrackPreferences`
/// composes.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Reading the ISO 639-3 asset is real I/O; warm it outside a test body.
    await LanguageService().ensureLoaded();
  });

  // The tracks a Dutch film with Dutch and English subtitles offers.
  const dutchAudio = AudioTrack('1', 'Stereo', 'nld');
  const englishAudio = AudioTrack('2', 'Stereo', 'eng');
  const dutchSubtitle = SubtitleTrack('3', null, 'nld');
  const englishSubtitle = SubtitleTrack('4', null, 'eng');

  /// What `_applyTrackPreferences` ends up setting for the subtitle track.
  String? resolve({
    required List<SubtitleTrack> available,
    required List<String> preferences,
    required String? audioLanguage,
    required bool hide,
  }) {
    final chosen =
        MediaPlayerHandler.preferredTrack<SubtitleTrack>(available, preferences);
    final suppressed = MediaPlayerHandler.suppressesSubtitle(
      hideSubtitlesMatchingAudio: hide,
      subtitleLanguage: chosen?.language,
      audioLanguage: audioLanguage,
    );
    return chosen == null || suppressed ? null : chosen.language;
  }

  group('preferredTrack', () {
    test('takes the first preference that is available', () {
      expect(
          MediaPlayerHandler.preferredTrack<AudioTrack>(
              [englishAudio, dutchAudio], ['nld', 'eng']),
          dutchAudio);
      expect(
          MediaPlayerHandler.preferredTrack<AudioTrack>(
              [englishAudio, dutchAudio], ['eng', 'nld']),
          englishAudio);
    });

    test('skips a preference no track offers', () {
      expect(
          MediaPlayerHandler.preferredTrack<AudioTrack>(
              [englishAudio], ['nld', 'eng']),
          englishAudio);
    });

    test('is null when nothing matches, so the caller can fall back', () {
      expect(
          MediaPlayerHandler.preferredTrack<AudioTrack>([englishAudio], ['nld']),
          isNull);
      expect(MediaPlayerHandler.preferredTrack<AudioTrack>([], ['nld']), isNull);
    });

    test('matches across ISO standards, not on the raw string', () {
      // The preference is stored as an ISO 639-3 id; mpv reports whatever the
      // container carries.
      expect(
          MediaPlayerHandler.preferredTrack<AudioTrack>(
              [const AudioTrack('1', null, 'nl')], ['nld']),
          isNotNull);
      expect(
          MediaPlayerHandler.preferredTrack<AudioTrack>(
              [const AudioTrack('1', null, 'dut')], ['nld']),
          isNotNull);
    });
  });

  group('with the setting off, nothing changes', () {
    test('the top subtitle preference wins even when it is the spoken language',
        () {
      expect(
          resolve(
              available: [dutchSubtitle, englishSubtitle],
              preferences: ['nld', 'eng'],
              audioLanguage: 'nld',
              hide: false),
          'nld');
    });
  });

  group('with the setting on', () {
    test('subtitles stay off when the pick is the spoken language', () {
      expect(
          resolve(
              available: [dutchSubtitle],
              preferences: ['nld'],
              audioLanguage: 'nld',
              hide: true),
          isNull);
    });

    test('a language ranked above the spoken one is still shown', () {
      expect(
          resolve(
              available: [dutchSubtitle, englishSubtitle],
              preferences: ['eng', 'nld'],
              audioLanguage: 'nld',
              hide: true),
          'eng');
    });

    test('it does not fall through to the next preference', () {
      // English is available, but Dutch was ranked first and Dutch is spoken:
      // the point is "show me nothing", not "show me my second choice".
      expect(
          resolve(
              available: [dutchSubtitle, englishSubtitle],
              preferences: ['nld', 'eng'],
              audioLanguage: 'nld',
              hide: true),
          isNull);
    });

    test('subtitles are shown when the audio is a different language', () {
      expect(
          resolve(
              available: [dutchSubtitle],
              preferences: ['nld'],
              audioLanguage: 'eng',
              hide: true),
          'nld');
    });

    test('an unknown audio language never suppresses', () {
      // Audio fell back to mpv's default and we could not read a language.
      for (final unknown in [null, '', 'und', 'zzz']) {
        expect(
            resolve(
                available: [dutchSubtitle],
                preferences: ['nld'],
                audioLanguage: unknown,
                hide: true),
            'nld',
            reason: 'audioLanguage=$unknown');
      }
    });
  });

  group('sameLanguage', () {
    test('spans the ISO standards for one language', () {
      expect(LanguageService().sameLanguage('eng', 'en'), isTrue);
      expect(LanguageService().sameLanguage('nl', 'dut'), isTrue);
      expect(LanguageService().sameLanguage('nld', 'nld'), isTrue);
    });

    test('different languages are not the same', () {
      expect(LanguageService().sameLanguage('nld', 'eng'), isFalse);
    });

    test('missing, unknown and special codes are never the same', () {
      expect(LanguageService().sameLanguage(null, 'nld'), isFalse);
      expect(LanguageService().sameLanguage('', 'nld'), isFalse);
      expect(LanguageService().sameLanguage('zzz', 'zzz'), isFalse);
      // Two tracks mpv could not label are not thereby in one language.
      expect(LanguageService().sameLanguage('und', 'und'), isFalse);
      expect(LanguageService().sameLanguage('mul', 'mul'), isFalse);
    });
  });
}
