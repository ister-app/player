import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/download/NetworkPolicy.dart';

/// Stands in for the Linux implementation on a machine without NetworkManager:
/// `checkConnectivity` throws (awaited, so catchable) and the change stream
/// throws from its `onListen` — where the plugin drops the Future and the
/// error escapes as an uncaught async error. That is what took the docs
/// screenshot tour down in CI.
class _BrokenConnectivity extends ConnectivityPlatform {
  @override
  Future<List<ConnectivityResult>> checkConnectivity() async =>
      throw StateError('org.freedesktop.NetworkManager was not provided');

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    late final StreamController<List<ConnectivityResult>> c;
    c = StreamController<List<ConnectivityResult>>.broadcast(onListen: () async {
      throw StateError('org.freedesktop.NetworkManager was not provided');
    });
    return c.stream;
  }
}

class _FakeConnectivity extends ConnectivityPlatform {
  _FakeConnectivity(this.results);

  final List<ConnectivityResult> results;
  final StreamController<List<ConnectivityResult>> controller =
      StreamController<List<ConnectivityResult>>.broadcast();

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => results;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      controller.stream;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final original = ConnectivityPlatform.instance;

  tearDown(() {
    ConnectivityPlatform.instance = original;
    NetworkPolicy.resetForTest();
  });

  test('mobile and bluetooth are metered, everything else is not', () {
    expect(NetworkPolicy.isUnmeteredFrom([]), isTrue);
    expect(NetworkPolicy.isUnmeteredFrom([ConnectivityResult.mobile]), isFalse);
    expect(
        NetworkPolicy.isUnmeteredFrom([ConnectivityResult.bluetooth]), isFalse);
    expect(NetworkPolicy.isUnmeteredFrom([ConnectivityResult.wifi]), isTrue);
    expect(NetworkPolicy.isUnmeteredFrom([ConnectivityResult.ethernet]), isTrue);
    expect(NetworkPolicy.isUnmeteredFrom([ConnectivityResult.none]), isTrue);
    // Tethered *and* on Wi-Fi: the unmetered leg wins.
    expect(
        NetworkPolicy.isUnmeteredFrom(
            [ConnectivityResult.mobile, ConnectivityResult.wifi]),
        isTrue);
  });

  test('a broken platform reports unmetered instead of throwing', () async {
    ConnectivityPlatform.instance = _BrokenConnectivity();
    expect(await NetworkPolicy.isUnmetered(), isTrue);
    expect(await NetworkPolicy.available(), isFalse);
  });

  test('changes() never subscribes when detection is broken', () async {
    ConnectivityPlatform.instance = _BrokenConnectivity();
    final errors = <Object>[];
    await runZonedGuarded(() async {
      final events = <void>[];
      final sub = NetworkPolicy.changes().listen(events.add);
      // Long enough for the probe and any subscription it would have made.
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(events, isEmpty);
      await sub.cancel();
    }, (e, _) => errors.add(e));
    expect(errors, isEmpty,
        reason: 'the plugin error must not escape as an uncaught async error');
  });

  test('changes() forwards events when detection works', () async {
    final fake = _FakeConnectivity([ConnectivityResult.wifi]);
    ConnectivityPlatform.instance = fake;
    var seen = 0;
    final sub = NetworkPolicy.changes().listen((_) => seen++);
    await NetworkPolicy.available();
    await Future<void>.delayed(const Duration(milliseconds: 20));
    fake.controller.add([ConnectivityResult.mobile]);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(seen, 1);
    expect(await NetworkPolicy.isUnmetered(), isTrue);
    await sub.cancel();
    await fake.controller.close();
  });
}
