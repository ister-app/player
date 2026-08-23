import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Whether the current connection is one the user would not pay per byte
/// for. Mobile data and a Bluetooth tether count as metered; everything else
/// (Wi‑Fi, ethernet, VPN, "other", unknown) as unmetered. No connection at
/// all is reported unmetered too — the download then simply fails and retries.
class NetworkPolicy {
  NetworkPolicy._();

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
