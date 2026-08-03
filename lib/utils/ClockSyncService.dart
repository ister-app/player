import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/WellKnownService.dart';

/// Measures this device's clock offset against a server's `GET /time` endpoint
/// (listen-along tight sync). NTP-style: a burst of RTT probes, samples with an
/// inflated RTT discarded (asymmetric latency is the dominant error source),
/// median of the rest. On LAN this gets within a few milliseconds.
///
/// The offset is refreshed lazily: [ensureSynced] re-measures when the last
/// burst is older than [refreshInterval], so callers can invoke it every tick
/// for free. All time values are epoch milliseconds as doubles (exact far
/// beyond any wall-clock horizon).
class ClockSyncService {
  ClockSyncService._() : this.internal();

  @visibleForTesting
  ClockSyncService.internal({http.Client? httpClient, double Function()? nowMs})
      : _http = httpClient ?? http.Client(),
        _nowMs = nowMs ??
            (() => DateTime.now().millisecondsSinceEpoch.toDouble());

  static final ClockSyncService instance = ClockSyncService._();

  static const int burstSize = 8;
  static const Duration refreshInterval = Duration(minutes: 2);
  static const Duration probeTimeout = Duration(seconds: 2);

  final http.Client _http;
  final double Function() _nowMs;

  final Map<String, _ServerClock> _clocks = {};
  final Map<String, Future<bool>> _inFlight = {};

  /// Offset such that `serverTime = localTime + offset`, or null when the
  /// server was never successfully measured.
  double? offsetMs(String serverName) => _clocks[serverName]?.offsetMs;

  /// Half the best observed RTT plus the sample spread — a rough upper bound
  /// on how far [serverNowMs] can be off.
  double? offsetConfidenceMs(String serverName) =>
      _clocks[serverName]?.confidenceMs;

  /// The server's clock right now (epoch ms), or null when never synced.
  double? serverNowMs(String serverName) {
    final clock = _clocks[serverName];
    return clock == null ? null : _nowMs() + clock.offsetMs;
  }

  /// Measures (or refreshes) the offset for [serverName]. Deduplicated: a
  /// burst already in flight is awaited instead of doubled. Returns whether a
  /// usable offset is available afterwards.
  Future<bool> ensureSynced(String serverName) {
    final clock = _clocks[serverName];
    if (clock != null && _nowMs() - clock.measuredAtMs < refreshInterval.inMilliseconds) {
      return Future.value(true);
    }
    final inFlight = _inFlight[serverName];
    if (inFlight != null) return inFlight;
    final attempt = _measure(serverName).whenComplete(() {
      _inFlight.remove(serverName);
    });
    _inFlight[serverName] = attempt;
    return attempt;
  }

  Future<bool> _measure(String serverName) async {
    final serverUrl = WellKnownService.getCached(serverName)?.serverUrl;
    if (serverUrl == null) return _clocks.containsKey(serverName);
    final uri = Uri.parse('$serverUrl/time');

    final samples = <ClockSample>[];
    for (var i = 0; i < burstSize; i++) {
      try {
        final t0 = _nowMs();
        final response = await _http.get(uri).timeout(probeTimeout);
        final t1 = _nowMs();
        if (response.statusCode != 200) continue;
        final serverTime =
            ((json.decode(response.body) as Map<String, dynamic>)['serverTimeMs']
                    as num)
                .toDouble();
        final rtt = t1 - t0;
        samples.add(ClockSample(offset: serverTime + rtt / 2 - t1, rttMs: rtt));
      } catch (e) {
        LoggerService().logger.w('clock probe to $serverName failed: $e');
      }
    }
    final result = computeOffset(samples);
    if (result == null) {
      // Keep a stale offset rather than dropping to nothing: clock drift over
      // minutes is far smaller than losing sync entirely.
      return _clocks.containsKey(serverName);
    }
    _clocks[serverName] = _ServerClock(
      offsetMs: result.offsetMs,
      confidenceMs: result.confidenceMs,
      measuredAtMs: _nowMs(),
    );
    LoggerService().logger.d(
        'clock sync $serverName: offset=${result.offsetMs.toStringAsFixed(1)}ms '
        '±${result.confidenceMs.toStringAsFixed(1)}ms');
    return true;
  }

  /// Median offset over the samples whose RTT is at most twice the best RTT
  /// (needs at least 3 usable samples). Pure and static so it can be tested
  /// without any network.
  @visibleForTesting
  static ({double offsetMs, double confidenceMs})? computeOffset(
      List<ClockSample> samples) {
    if (samples.length < 3) return null;
    final minRtt =
        samples.map((s) => s.rttMs).reduce((a, b) => a < b ? a : b);
    final accepted =
        samples.where((s) => s.rttMs <= 2 * minRtt).toList();
    if (accepted.length < 3) return null;
    final offsets = accepted.map((s) => s.offset).toList()..sort();
    final median = offsets[offsets.length ~/ 2];
    final spread = offsets.last - offsets.first;
    return (offsetMs: median, confidenceMs: minRtt / 2 + spread / 2);
  }

  @visibleForTesting
  void reset() => _clocks.clear();
}

/// One clock probe: the offset it implies and the round-trip it took.
class ClockSample {
  const ClockSample({required this.offset, required this.rttMs});

  final double offset;
  final double rttMs;
}

class _ServerClock {
  const _ServerClock({
    required this.offsetMs,
    required this.confidenceMs,
    required this.measuredAtMs,
  });

  final double offsetMs;
  final double confidenceMs;
  final double measuredAtMs;
}
