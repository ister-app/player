import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/download/M3u8.dart';

const _master = '''
#EXTM3U
#EXT-X-VERSION:6

#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio-copy",LANGUAGE="eng",NAME="English, stereo",DEFAULT=YES,AUTOSELECT=YES,URI="stream_audio_1_copy.m3u8?token=abc"
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio-copy",LANGUAGE="nld",NAME="nld",DEFAULT=NO,AUTOSELECT=YES,URI="stream_audio_2_copy.m3u8?token=abc"

#EXT-X-MEDIA:TYPE=SUBTITLES,GROUP-ID="subs",LANGUAGE="eng",NAME="eng",DEFAULT=NO,AUTOSELECT=YES,FORCED=NO,URI="stream_sub_9_webvtt.m3u8?token=abc"

#EXT-X-STREAM-INF:BANDWIDTH=8000000,RESOLUTION=1920x1080,CODECS="avc1.640028,mp4a.40.2",AUDIO="audio-copy",SUBTITLES="subs"
stream_video_copy.m3u8?token=abc
''';

void main() {
  group('stripToken', () {
    test('bare uri with only a token', () {
      expect(M3u8.stripToken('a.m3u8?token=x'), 'a.m3u8');
    });
    test('token after another parameter', () {
      expect(M3u8.stripToken('a.m3u8?direct=true&token=x'),
          'a.m3u8?direct=true');
    });
    test('token before another parameter', () {
      expect(M3u8.stripToken('a.m3u8?token=x&direct=true'),
          'a.m3u8?direct=true');
    });
    test('inside a URI attribute', () {
      expect(M3u8.stripToken('#EXT-X-MEDIA:TYPE=AUDIO,URI="a.m3u8?token=x"'),
          '#EXT-X-MEDIA:TYPE=AUDIO,URI="a.m3u8"');
    });
    test('leaves token-less lines alone', () {
      expect(M3u8.stripToken('seg_video_copy_00001.ts'),
          'seg_video_copy_00001.ts');
    });
  });

  test('parseAttributes keeps commas inside quotes', () {
    final a = M3u8.parseAttributes(
        'TYPE=AUDIO,NAME="English, stereo",DEFAULT=YES,URI="x.m3u8"');
    expect(a['NAME'], 'English, stereo');
    expect(a['DEFAULT'], 'YES');
    expect(a['URI'], 'x.m3u8');
  });

  test('parseMaster reads renditions and variants', () {
    final m = M3u8.parseMaster(_master);
    expect(m.media.map((e) => e.type), ['AUDIO', 'AUDIO', 'SUBTITLES']);
    expect(m.media.first.uri, 'stream_audio_1_copy.m3u8');
    expect(m.media.first.isDefault, isTrue);
    expect(m.media[1].language, 'nld');
    expect(m.variants, hasLength(1));
    expect(m.variants.first.uri, 'stream_video_copy.m3u8');
    expect(m.variants.first.height, 1080);
    expect(m.variants.first.audioGroup, 'audio-copy');
    expect(m.variants.first.subtitlesGroup, 'subs');
  });

  test('rewriteMaster keeps only selected renditions and drops subtitles', () {
    final m = M3u8.parseMaster(_master);
    final out = M3u8.rewriteMaster(m,
        keepVariantUris: {'stream_video_copy.m3u8'},
        keepMediaUris: {'stream_audio_1_copy.m3u8'});
    expect(out, contains('URI="stream_audio_1_copy.m3u8"'));
    expect(out, isNot(contains('stream_audio_2_copy')));
    expect(out, isNot(contains('SUBTITLES')));
    expect(out, isNot(contains('token=')));
    expect(out, contains('\nstream_video_copy.m3u8\n'));
  });

  test('parseSegmentUris lists segments in order without tokens', () {
    const playlist = '''
#EXTM3U
#EXT-X-TARGETDURATION:6
#EXTINF:5.000000,
seg_video_copy_00000.ts?token=abc
#EXTINF:5.000000,
seg_video_copy_00001.ts?token=abc
#EXT-X-ENDLIST
''';
    expect(M3u8.parseSegmentUris(playlist),
        ['seg_video_copy_00000.ts', 'seg_video_copy_00001.ts']);
    expect(M3u8.rewriteMediaPlaylist(playlist), isNot(contains('token')));
  });
}
