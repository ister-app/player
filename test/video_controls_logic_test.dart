import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/components/video_controls/TrackSelectionController.dart';
import 'package:player/components/video_controls/VideoControlButtons.dart';
import 'package:player/l10n/app_localizations_en.dart';

void main() {
  group('SkipButtons.availabilityFor', () {
    test('unknown queue index disables both directions', () {
      final skip = SkipButtons.availabilityFor(
        queueIndex: null,
        queueLength: 5,
        repeatMode: AudioServiceRepeatMode.none,
      );
      expect(skip.hasPrevious, isFalse);
      expect(skip.hasNext, isFalse);
    });

    test('middle of the queue allows both', () {
      final skip = SkipButtons.availabilityFor(
        queueIndex: 1,
        queueLength: 3,
        repeatMode: AudioServiceRepeatMode.none,
      );
      expect(skip.hasPrevious, isTrue);
      expect(skip.hasNext, isTrue);
    });

    test('the edges do not wrap without repeat-all', () {
      final first = SkipButtons.availabilityFor(
        queueIndex: 0,
        queueLength: 3,
        repeatMode: AudioServiceRepeatMode.none,
      );
      expect(first.hasPrevious, isFalse);
      expect(first.hasNext, isTrue);

      final last = SkipButtons.availabilityFor(
        queueIndex: 2,
        queueLength: 3,
        repeatMode: AudioServiceRepeatMode.none,
      );
      expect(last.hasPrevious, isTrue);
      expect(last.hasNext, isFalse);
    });

    test('repeat-all wraps the edges, matching skipToNext/skipToPrevious', () {
      final first = SkipButtons.availabilityFor(
        queueIndex: 0,
        queueLength: 3,
        repeatMode: AudioServiceRepeatMode.all,
      );
      expect(first.hasPrevious, isTrue);

      final last = SkipButtons.availabilityFor(
        queueIndex: 2,
        queueLength: 3,
        repeatMode: AudioServiceRepeatMode.all,
      );
      expect(last.hasNext, isTrue);
    });

    test('a single-item queue never offers a skip, even in repeat-all', () {
      final skip = SkipButtons.availabilityFor(
        queueIndex: 0,
        queueLength: 1,
        repeatMode: AudioServiceRepeatMode.all,
      );
      expect(skip.hasPrevious, isFalse);
      expect(skip.hasNext, isFalse);
    });
  });

  group('PositionText.format', () {
    test('under an hour formats m:ss', () {
      expect(PositionText.format(const Duration(minutes: 4, seconds: 7)),
          '4:07');
      expect(PositionText.format(Duration.zero), '0:00');
    });

    test('an hour or more formats h:mm:ss', () {
      expect(
          PositionText.format(
              const Duration(hours: 1, minutes: 2, seconds: 3)),
          '1:02:03');
    });
  });

  group('TrackSelectionController derivations', () {
    final loc = AppLocalizationsEn();

    test('effectiveAudio falls back to the first known track', () {
      final tracks = [AudioTrack.auto(), const AudioTrack('1', 'Main', 'eng')];
      expect(TrackSelectionController.effectiveAudio(null, tracks),
          AudioTrack.auto());
      expect(
          TrackSelectionController.effectiveAudio(
              const AudioTrack('9', null, null), tracks),
          tracks.first);
      expect(
          TrackSelectionController.effectiveAudio(tracks[1], tracks),
          tracks[1]);
    });

    test('subtitleOptionsFor always includes "none" exactly once', () {
      final without = [const SubtitleTrack('1', 'Dutch', 'nld')];
      expect(TrackSelectionController.subtitleOptionsFor(without).first,
          SubtitleTrack.no());
      final withNo = [SubtitleTrack.no(), ...without];
      expect(TrackSelectionController.subtitleOptionsFor(withNo), withNo);
    });

    test('effectiveSubtitle falls back to none for an unknown track', () {
      final options = TrackSelectionController.subtitleOptionsFor(
          [const SubtitleTrack('1', 'Dutch', 'nld')]);
      expect(
          TrackSelectionController.effectiveSubtitle(
              const SubtitleTrack('9', null, null), options),
          SubtitleTrack.no());
    });

    test('unsupported-subtitles hint fires only without real mpv tracks', () {
      final placeholders = [SubtitleTrack.auto(), SubtitleTrack.no()];
      // File has a dropped image sub, mpv only placeholders → hint.
      expect(
          TrackSelectionController.unsupportedSubtitlesFor(
              placeholders, ['VIDEO', 'AUDIO', 'SUBTITLE']),
          isTrue);
      // mpv offers a real rendition → no hint, whatever the file rows say.
      expect(
          TrackSelectionController.unsupportedSubtitlesFor(
              [...placeholders, const SubtitleTrack('3', 'Dutch', 'nld')],
              ['SUBTITLE']),
          isFalse);
      // File has no subtitle rows at all → no hint.
      expect(
          TrackSelectionController.unsupportedSubtitlesFor(
              placeholders, ['VIDEO', 'AUDIO', 'EXTERNAL_SUBTITLE']),
          isFalse);
      expect(TrackSelectionController.unsupportedSubtitlesFor(placeholders, []),
          isFalse);
    });

    test('labels join title and language, and localize the sentinels', () {
      expect(
          TrackSelectionController.audioLabel(
              const AudioTrack('1', 'Main', 'eng'), loc),
          'Main – eng');
      expect(TrackSelectionController.audioLabel(AudioTrack.auto(), loc),
          loc.trackAuto);
      expect(
          TrackSelectionController.subtitleLabel(
              const SubtitleTrack('2', null, 'nld'), loc),
          'nld');
      expect(TrackSelectionController.subtitleLabel(SubtitleTrack.no(), loc),
          loc.trackNone);
    });
  });
}
