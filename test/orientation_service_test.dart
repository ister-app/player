import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/OrientationService.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('app.ister.player/orientation');
  final calls = <String>[];

  void mockChannel({Object? Function(MethodCall call)? handler}) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      return handler?.call(call);
    });
  }

  setUp(() {
    calls.clear();
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('invokes the channel on Android', () async {
    mockChannel();
    await OrientationService.lockSensorLandscape();
    await OrientationService.unlock();
    expect(calls, ['lockSensorLandscape', 'unlock']);
  });

  test('is a no-op on other platforms', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    mockChannel();
    await OrientationService.lockSensorLandscape();
    await OrientationService.unlock();
    expect(calls, isEmpty);
  });

  test('swallows platform errors', () async {
    mockChannel(handler: (call) {
      throw PlatformException(code: 'no-activity');
    });
    await expectLater(OrientationService.lockSensorLandscape(), completes);
  });

  test('swallows a missing channel handler', () async {
    // No mock installed: invokeMethod throws MissingPluginException.
    await expectLater(OrientationService.unlock(), completes);
  });
}
