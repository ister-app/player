import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Whether the current connection is one the user would not pay per byte
/// for. Mobile data and a Bluetooth tether count as metered; everything else
/// (Wi‑Fi, ethernet, VPN, "other", unknown) as unmetered. No connection at
/// all is reported unmetered too — the download then simply fails and retries.
class NetworkPolicy {
  NetworkPolicy._();

  /// Fires whenever the connection changes (Wi‑Fi ⇄ mobile, back online).
  static Stream<void> changes() {
    if (kIsWeb) return const Stream.empty();
    try {
      // The plugin's event channel needs the services binding; without one
      // (plain unit tests, a headless start) there is nothing to watch.
      ServicesBinding.instance;
      return Connectivity().onConnectivityChanged.map((_) {});
    } catch (_) {
      return const Stream.empty();
    }
  }

  static Future<bool> isUnmetered() async {
    if (kIsWeb) return true;
    try {
      final results = await Connectivity().checkConnectivity();
      if (results.isEmpty) return true;
      final metered = results.every((r) =>
          r == ConnectivityResult.mobile || r == ConnectivityResult.bluetooth);
      return !metered;
    } catch (_) {
      return true;
    }
  }
}
