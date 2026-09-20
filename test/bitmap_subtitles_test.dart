import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/subtitles/BitmapSubtitles.dart';

const _json = '{"version":1,"width":1920,"height":1080,'
    '"sheets":["bsub_x_00.png","bsub_x_01.png"],"cues":['
    '{"s":1000,"e":3000,"x":700,"y":900,"w":400,"h":60,"sheet":0,"sx":0,"sy":0,"forced":false},'
    '{"s":5000,"e":7000,"x":100,"y":50,"w":200,"h":40,"sheet":0,"sx":402,"sy":0,"forced":true},'
    '{"s":5000,"e":7000,"x":600,"y":950,"w":300,"h":40,"sheet":0,"sx":0,"sy":62,"forced":false},'
    '{"s":9000,"e":9500,"x":0,"y":0,"w":10,"h":10,"sheet":1,"sx":0,"sy":0,"forced":false}]}';

void main() {
  final index = BitmapSubtitleIndex.parse(_json);

  test('parses canvas, sheets and cue geometry', () {
    expect(index.canvas, const Size(1920, 1080));
    expect(index.sheets, ['bsub_x_00.png', 'bsub_x_01.png']);
    expect(index.cues, hasLength(4));
    expect(index.cues[1].position, const Rect.fromLTWH(100, 50, 200, 40));
    expect(index.cues[1].source, const Rect.fromLTWH(402, 0, 200, 40));
    expect(index.cues[1].forced, isTrue);
  });

  test('a cue is active from its start up to, not including, its end', () {
    expect(index.activeAt(999), isEmpty);
    expect(index.activeAt(1000).single.startMs, 1000);
    expect(index.activeAt(2999).single.startMs, 1000);
    expect(index.activeAt(3000), isEmpty);
    expect(index.activeAt(4000), isEmpty);
    expect(index.activeAt(100000), isEmpty);
  });

  test('two pictures of one display set are active together', () {
    expect(index.activeAt(6000).map((c) => c.position.left), [100, 600]);
  });

  test('sheets around the playhead include the upcoming one', () {
    expect(index.sheetsAround(0, ahead: 1), {0});
    expect(index.sheetsAround(6000, ahead: 1), {0, 1});
    expect(index.sheetsAround(9200), {1});
  });

  test('cue scales from the canvas to the displayed video', () {
    // 1920x1080 shown at half size, letterboxed 100 px down.
    const video = Rect.fromLTWH(0, 100, 960, 540);
    expect(index.destinationFor(index.cues[0], video),
        const Rect.fromLTWH(350, 550, 200, 30));
  });

  test('anamorphic canvas stretches horizontally only', () {
    final dvd = BitmapSubtitleIndex.parse(
        '{"version":1,"width":720,"height":576,"sheets":[],"cues":[]}');
    const cue = BitmapCue(
        startMs: 0,
        endMs: 1,
        position: Rect.fromLTWH(360, 288, 72, 57.6),
        sheet: 0,
        source: Rect.zero);
    expect(dvd.destinationFor(cue, const Rect.fromLTWH(0, 0, 1024, 576)),
        const Rect.fromLTWH(512, 288, 102.4, 57.6));
  });

  group('crop', () {
    // 1920x1080 with 140 px bars top and bottom cropped away (-> 1920x800),
    // shown 1:1 at the top-left of the surface.
    const displayed = Rect.fromLTWH(0, 0, 1920, 800);
    const crop = Rect.fromLTWH(0, 140, 1920, 800);

    test('no crop: the canvas is the displayed video', () {
      expect(canvasRectFor(displayed, const Size(1920, 1080), null), displayed);
    });

    test('the canvas extends past the displayed video by the cropped margins', () {
      expect(canvasRectFor(displayed, const Size(1920, 1080), crop),
          const Rect.fromLTWH(0, -140, 1920, 1080));
    });

    test('a cue that sat in the cropped-off bar is pulled into the picture', () {
      final canvasRect = canvasRectFor(displayed, const Size(1920, 1080), crop);
      // y=1000 on the canvas lies in the bottom bar: 1000-140 = 860 > 800.
      const cue = BitmapCue(
          startMs: 0,
          endMs: 1,
          position: Rect.fromLTWH(700, 1000, 400, 60),
          sheet: 0,
          source: Rect.zero);
      final placed = clampInto(index.destinationFor(cue, canvasRect), displayed);
      expect(placed, const Rect.fromLTWH(700, 740, 400, 60));
    });

    test('a cue inside the picture is left alone', () {
      const rect = Rect.fromLTWH(10, 10, 100, 20);
      expect(clampInto(rect, displayed), rect);
    });
  });

  test('bitmap tracks are the supported picture codecs only', () {
    expect(BitmapSubtitleTrack.codecs, contains('hdmv_pgs_subtitle'));
    expect(BitmapSubtitleTrack.codecs, contains('dvd_subtitle'));
    expect(BitmapSubtitleTrack.codecs, isNot(contains('dvb_subtitle')));
    expect(BitmapSubtitleTrack.of(null), isEmpty);
  });
}
