import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/components/video_controls/GestureMath.dart';
import 'package:player/components/video_controls/VideoGestureLayer.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/SystemLevels.dart';

class _FakeSystemLevels extends SystemLevels {
  double volume = 0.5;
  double brightness = 0.5;
  int volumeSets = 0;
  int brightnessSets = 0;
  bool brightnessReset = false;

  @override
  bool get isSupported => true;

  @override
  Future<double> getVolume() async => volume;

  @override
  Future<void> setVolume(double value) async {
    volume = value;
    volumeSets++;
  }

  @override
  Future<double> getBrightness() async => brightness;

  @override
  Future<void> setBrightness(double value) async {
    brightness = value;
    brightnessSets++;
  }

  @override
  Future<void> resetBrightness() async {
    brightnessReset = true;
  }
}

void main() {
  group('GestureMath.seekOffsetSeconds', () {
    test('is sign-symmetric', () {
      final forward = GestureMath.seekOffsetSeconds(120, 600);
      final backward = GestureMath.seekOffsetSeconds(-120, 600);
      expect(forward, greaterThan(0));
      expect(backward, -forward);
    });

    test('is monotonic in |dx| and hits maxSeek at full width', () {
      final quarter = GestureMath.seekOffsetSeconds(150, 600);
      final half = GestureMath.seekOffsetSeconds(300, 600);
      final full = GestureMath.seekOffsetSeconds(600, 600);
      expect(half, greaterThan(quarter));
      expect(full, greaterThan(half));
      expect(full, closeTo(GestureMath.maxSeekSeconds, 0.001));
    });

    test('small drags are finer than the old linear 90s mapping', () {
      // 10% of the width used to scrub 9s (90s linear); the curve stays
      // close to that but sub-linear relative to its own 600s reach.
      final tenPercent = GestureMath.seekOffsetSeconds(60, 600);
      expect(tenPercent, closeTo(9.5, 0.5));
      expect(tenPercent, lessThan(0.1 * GestureMath.maxSeekSeconds));
    });

    test('clamps beyond the usable width and no-ops on degenerate input', () {
      expect(GestureMath.seekOffsetSeconds(900, 600),
          GestureMath.maxSeekSeconds);
      expect(GestureMath.seekOffsetSeconds(0, 600), 0);
      expect(GestureMath.seekOffsetSeconds(100, 0), 0);
      expect(GestureMath.seekOffsetSeconds(100, -5), 0);
    });
  });

  group('GestureMath.edgeGuard', () {
    test('uses the larger system inset when above the floor', () {
      expect(GestureMath.edgeGuard(const EdgeInsets.only(left: 32, right: 40)),
          40);
    });

    test('falls back to the 24px floor when insets report zero', () {
      expect(GestureMath.edgeGuard(EdgeInsets.zero), 24);
    });
  });

  group('GestureMath zones', () {
    const width = 400.0;
    const guard = 24.0;

    test('drags starting in either edge band are rejected', () {
      expect(GestureMath.dragStartAllowed(10, width, guard), isFalse);
      expect(GestureMath.dragStartAllowed(width - 10, width, guard), isFalse);
      expect(GestureMath.dragStartAllowed(width / 2, width, guard), isTrue);
    });

    test('left half is brightness, right half volume, bands are none', () {
      expect(GestureMath.verticalZone(100, width, guard),
          VerticalGestureZone.brightness);
      expect(GestureMath.verticalZone(300, width, guard),
          VerticalGestureZone.volume);
      expect(
          GestureMath.verticalZone(5, width, guard), VerticalGestureZone.none);
      expect(GestureMath.verticalZone(width - 5, width, guard),
          VerticalGestureZone.none);
    });
  });

  group('GestureMath.applyVerticalDelta', () {
    test('a full-height sweep spans the whole range', () {
      expect(GestureMath.applyVerticalDelta(1, 300, 300), 0);
      expect(GestureMath.applyVerticalDelta(0, -300, 300), 1);
    });

    test('dragging up increases and the result clamps to 0..1', () {
      expect(GestureMath.applyVerticalDelta(0.5, -30, 300), closeTo(0.6, 1e-9));
      expect(GestureMath.applyVerticalDelta(0.95, -60, 300), 1);
      expect(GestureMath.applyVerticalDelta(0.05, 60, 300), 0);
    });
  });

  group('VideoGestureLayer', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    // No video output plugin in a widget test: answer the texture-create
    // call with null so the handler's VideoController setup idles instead of
    // failing the suite with an unhandled MissingPluginException.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('com.alexmercerind/media_kit_video'),
            (call) async => null);
    MediaKit.ensureInitialized();
    // Create the singleton outside any test's FakeAsync zone so its stall
    // watchdog timer is not flagged as pending (same as the other widget
    // tests using MediaPlayerHandler).
    MediaPlayerHandler.instance;

    late _FakeSystemLevels levels;

    setUp(() {
      levels = _FakeSystemLevels();
      SystemLevels.testInstance = levels;
    });

    Future<void> pumpLayer(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SizedBox(
          width: 800,
          height: 400,
          child: VideoGestureLayer(
            onToggleControls: () {},
            onSeekDragActive: (_) {},
          ),
        ),
      ));
    }

    Future<void> dragVertical(WidgetTester tester, Offset start) async {
      final gesture = await tester.startGesture(start);
      await tester.pump();
      // Two moves: the first only defeats the touch slop.
      await gesture.moveBy(const Offset(0, -40));
      await tester.pump();
      await gesture.moveBy(const Offset(0, -80));
      await tester.pump();
      await gesture.up();
      // Let the double-tap window and the feedback linger timer expire.
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('left-half swipe adjusts brightness and shows the disc',
        (tester) async {
      await pumpLayer(tester);
      final gesture = await tester.startGesture(const Offset(150, 200));
      await tester.pump();
      await gesture.moveBy(const Offset(0, -40));
      await tester.pump();
      await gesture.moveBy(const Offset(0, -80));
      await tester.pump();
      // The level disc shows while the finger is still down.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.brightness_medium), findsOneWidget);
      await gesture.up();
      await tester.pump(const Duration(seconds: 1));
      expect(levels.brightnessSets, greaterThan(0));
      expect(levels.brightness, greaterThan(0.5));
      expect(levels.volumeSets, 0);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('right-half swipe adjusts device volume', (tester) async {
      await pumpLayer(tester);
      await dragVertical(tester, const Offset(600, 200));
      expect(levels.volumeSets, greaterThan(0));
      expect(levels.volume, greaterThan(0.5));
      expect(levels.brightnessSets, 0);
    });

    testWidgets('swipes starting at the screen edge are ignored',
        (tester) async {
      await pumpLayer(tester);
      await dragVertical(tester, const Offset(4, 200));
      await dragVertical(tester, const Offset(796, 200));
      expect(levels.brightnessSets, 0);
      expect(levels.volumeSets, 0);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('disposal resets brightness only after it was touched',
        (tester) async {
      await pumpLayer(tester);
      await dragVertical(tester, const Offset(150, 200));
      await tester.pumpWidget(const SizedBox.shrink());
      expect(levels.brightnessReset, isTrue);
    });
  });
}
