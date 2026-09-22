import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

/// A re-open (seek to before the stream-open position, watchdog retry) must
/// land on the audio track the user picked — not on the first one that speaks
/// the same language.
void main() {
  const restore = MediaPlayerHandler.restoredAudioTrack;

  test('two tracks with one title and language: the id decides', () {
    // An older server: main mix and commentary are indistinguishable by name.
    const tracks = [
      AudioTrack('1', 'AC3 Stereo', 'eng'),
      AudioTrack('2', 'AC3 Stereo', 'fre'),
      AudioTrack('4', 'AC3 Stereo', 'eng'),
    ];
    expect(restore(tracks, tracks[2]).id, '4');
    expect(restore(tracks, tracks[0]).id, '1');
  });

  test('the title decides when the ids moved', () {
    const tracks = [
      AudioTrack('1', 'AC3 Stereo 1', 'eng'),
      AudioTrack('2', 'AC3 Stereo 2', 'eng'),
    ];
    expect(restore(tracks, const AudioTrack('7', 'AC3 Stereo 2', 'eng')).id,
        '2');
  });

  test('an id that now belongs to another language is not trusted', () {
    const tracks = [
      AudioTrack('1', 'Stereo', 'fre'),
      AudioTrack('2', 'Surround', 'eng'),
    ];
    expect(restore(tracks, const AudioTrack('1', 'Stereo', 'eng')).id, '2');
  });

  test('nothing in that language, or no language at all: auto', () {
    const tracks = [AudioTrack('1', 'Stereo', 'fre')];
    expect(restore(tracks, const AudioTrack('1', 'Stereo', 'eng')),
        AudioTrack.auto());
    expect(restore(tracks, const AudioTrack('1', 'Stereo', null)),
        AudioTrack.auto());
  });

  test('"no audio" stays off across a re-open', () {
    const tracks = [AudioTrack('1', 'Stereo', 'eng')];
    expect(restore(tracks, AudioTrack.no()), AudioTrack.no());
  });
}
