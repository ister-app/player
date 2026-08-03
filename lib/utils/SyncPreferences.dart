import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Per-device settings for listen-along tight sync. Cached in [ValueNotifier]s
/// so the 500ms sync loop and the UI never await SharedPreferences.
///
/// [outputLatencyMs] is the one thing software cannot measure: how long this
/// device's audio pipeline (PipeWire/AAudio buffers, and above all Bluetooth)
/// delays the sound after the player's reported position. The user tunes it
/// until the echo disappears. It applies on both roles: a leader subtracts it
/// from the anchor it publishes, a follower adds it to its target.
class SyncPreferences {
  static const _kTightSyncKey = 'follow_tight_sync_enabled';
  static const _kOutputLatencyKey = 'sync_output_latency_ms';
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  /// Whether the follower disciplines its clock against the leader's anchor
  /// ("same room" mode). Off by default: over WAN the loose follow mode is
  /// preferable to micro-seeks.
  static final ValueNotifier<bool> tightSyncEnabled = ValueNotifier(false);

  /// This device's audio output latency in ms (0–500, slider-tuned).
  static final ValueNotifier<int> outputLatencyMs = ValueNotifier(0);

  static bool _loaded = false;

  /// Loads the persisted values into the notifiers once; safe to call often.
  static Future<void> ensureLoaded() async {
    if (_loaded) return;
    _loaded = true;
    tightSyncEnabled.value = await _prefs.getBool(_kTightSyncKey) ?? false;
    outputLatencyMs.value = await _prefs.getInt(_kOutputLatencyKey) ?? 0;
  }

  static Future<void> setTightSyncEnabled(bool enabled) async {
    tightSyncEnabled.value = enabled;
    await _prefs.setBool(_kTightSyncKey, enabled);
  }

  static Future<void> setOutputLatencyMs(int latencyMs) async {
    outputLatencyMs.value = latencyMs;
    await _prefs.setInt(_kOutputLatencyKey, latencyMs);
  }

  @visibleForTesting
  static void resetForTest() {
    _loaded = false;
    tightSyncEnabled.value = false;
    outputLatencyMs.value = 0;
  }
}
