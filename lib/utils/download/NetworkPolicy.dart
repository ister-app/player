import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Whether the current connection is one the user would not pay per byte
/// for. Mobile data and a Bluetooth tether count as metered; everything else
/// (Wi‑Fi, ethernet, VPN, "other", unknown) as unmetered. No connection at
/// all is reported unmetered too — the download then simply fails and retries.
class NetworkPolicy {
  NetworkPolicy._();

  static Future<bool>? _available;

  /// A dead D-Bus socket makes the Linux plugin's connect hang rather than
  /// throw, so every probe is bounded — the queue must never wait on it.
  static const _probeTimeout = Duration(seconds: 5);

  /// The pure classification, so the platform channel is not needed to test it.
  @visibleForTesting
  static bool isUnmeteredFrom(List<ConnectivityResult> results) {
    if (results.isEmpty) return true;
    return !results.every((r) =>
        r == ConnectivityResult.mobile || r == ConnectivityResult.bluetooth);
  }

  /// Whether connectivity detection works on this machine at all. Probed once
  /// through [Connectivity.checkConnectivity], which awaits its platform call
  /// and therefore reports failure as a catchable exception — unlike
  /// [Connectivity.onConnectivityChanged], whose Linux implementation starts
  /// listening from a `StreamController.onListen` callback whose Future is
  /// dropped: a missing NetworkManager escapes as an *uncaught* async error
  /// and takes the whole app (or an integration test) down with it.
  static Future<bool> available() {
    if (kIsWeb) return Future.value(false);
    return _available ??= () async {
      try {
        ServicesBinding.instance;
      } catch (_) {
        // No services binding (plain unit tests, a headless start).
        return false;
      }
      final results = await _probe();
      return results != null;
    }();
  }

  /// One bounded, fully contained connectivity read. The Linux plugin talks to
  /// D-Bus through a client that reports some failures on its own async
  /// machinery instead of on the future we await — a dead bus socket surfaces
  /// as an uncaught `SocketException` long after our timeout — so the call
  /// runs in its own guarded zone and everything that escapes it is swallowed
  /// here rather than taking the app (or an integration test) down.
  static Future<List<ConnectivityResult>?> _probe() {
    final done = Completer<List<ConnectivityResult>?>();
    void finish([List<ConnectivityResult>? results]) {
      if (!done.isCompleted) done.complete(results);
    }

    runZonedGuarded(() async {
      try {
        finish(await Connectivity().checkConnectivity().timeout(_probeTimeout));
      } catch (_) {
        finish();
      }
    }, (_, __) => finish());
    return done.future;
  }

  /// Fires whenever the connection changes (Wi‑Fi ⇄ mobile, back online).
  /// Stays silent when detection is unavailable — callers fall back to their
  /// own periodic sweep.
  static Stream<void> changes() {
    if (kIsWeb) return const Stream.empty();
    StreamSubscription<List<ConnectivityResult>>? sub;
    late final StreamController<void> controller;
    controller = StreamController<void>.broadcast(
      onListen: () {
        // Same containment as [_probe]: the plugin starts listening from a
        // `StreamController.onListen` whose Future it drops, so a failure
        // there escapes as an uncaught async error.
        runZonedGuarded(() async {
          if (!await available()) return;
          if (!controller.hasListener) return;
          sub = Connectivity()
              .onConnectivityChanged
              .listen((_) => controller.add(null), onError: (_) {});
        }, (_, __) {});
      },
      onCancel: () async {
        await sub?.cancel();
        sub = null;
      },
    );
    return controller.stream;
  }

  static Future<bool> isUnmetered() async {
    if (kIsWeb) return true;
    final results = await _probe();
    // Detection unavailable: assume unmetered, so a download is attempted
    // rather than silently held back forever.
    return results == null || isUnmeteredFrom(results);
  }

  @visibleForTesting
  static void resetForTest() => _available = null;
}
