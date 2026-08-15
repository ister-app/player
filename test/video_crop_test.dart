import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/VideoCrop.dart';

void main() {
  group('mpvCropString', () {
    test('full-frame sentinel yields no crop', () {
      expect(
          mpvCropString(
              srcW: 720, srcH: 576,
              cropX: 0, cropY: 0, cropW: 720, cropH: 576,
              actualW: 720, actualH: 576),
          isNull);
    });

    test('letterbox at native size', () {
      expect(
          mpvCropString(
              srcW: 1920, srcH: 1080,
              cropX: 0, cropY: 140, cropW: 1920, cropH: 800,
              actualW: 1920, actualH: 1080),
          '1920x800+0+140');
    });

    test('scales to a downscaled transcode variant and rounds even', () {
      // 1920x1080 source crop applied to the 1280x720 variant: x2/3.
      expect(
          mpvCropString(
              srcW: 1920, srcH: 1080,
              cropX: 0, cropY: 140, cropW: 1920, cropH: 800,
              actualW: 1280, actualH: 720),
          '1280x532+0+92');
    });

    test('missing or degenerate inputs yield no crop', () {
      expect(
          mpvCropString(
              srcW: 720, srcH: 576,
              cropX: null, cropY: null, cropW: null, cropH: null,
              actualW: 720, actualH: 576),
          isNull);
      expect(
          mpvCropString(
              srcW: 0, srcH: 0,
              cropX: 0, cropY: 74, cropW: 720, cropH: 428,
              actualW: 720, actualH: 576),
          isNull);
      expect(
          mpvCropString(
              srcW: 720, srcH: 576,
              cropX: 0, cropY: 74, cropW: 720, cropH: 428,
              actualW: 0, actualH: 0),
          isNull);
    });

    test('clamps a crop that would overrun the actual frame', () {
      final result = mpvCropString(
          srcW: 720, srcH: 576,
          cropX: 0, cropY: 74, cropW: 720, cropH: 510,
          actualW: 720, actualH: 576)!;
      // 74 + 510 = 584 > 576 → height clamped to 502.
      expect(result, '720x502+0+74');
    });
  });
}
