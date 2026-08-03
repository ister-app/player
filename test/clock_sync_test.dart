import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/utils/ClockSyncService.dart';
import 'package:player/utils/WellKnownService.dart';

void main() {
  group('computeOffset', () {
    test('takes the median of the accepted samples', () {
      final result = ClockSyncService.computeOffset([
        const ClockSample(offset: 10, rttMs: 5),
        const ClockSample(offset: 12, rttMs: 6),
        const ClockSample(offset: 11, rttMs: 5),
        const ClockSample(offset: 14, rttMs: 7),
        const ClockSample(offset: 9, rttMs: 6),
      ]);
      expect(result?.offsetMs, 11);
    });

    test('discards samples whose RTT is inflated beyond twice the best', () {
      final result = ClockSyncService.computeOffset([
        const ClockSample(offset: 10, rttMs: 5),
        const ClockSample(offset: 11, rttMs: 6),
        const ClockSample(offset: 9, rttMs: 7),
        // A retransmit-delayed probe: its midpoint offset is way off and its
        // RTT betrays it. It must not drag the median.
        const ClockSample(offset: 500, rttMs: 80),
      ]);
      expect(result?.offsetMs, 10);
    });

    test('needs at least three usable samples', () {
      expect(
          ClockSyncService.computeOffset([
            const ClockSample(offset: 10, rttMs: 5),
            const ClockSample(offset: 11, rttMs: 6),
          ]),
          isNull);
      // Three samples, but two are RTT-rejected.
      expect(
          ClockSyncService.computeOffset([
            const ClockSample(offset: 10, rttMs: 5),
            const ClockSample(offset: 300, rttMs: 50),
            const ClockSample(offset: 280, rttMs: 60),
          ]),
          isNull);
    });
  });

  group('ensureSynced', () {
    const server = 'clock-test-server';

    setUp(() {
      WellKnownService.cacheForTest(
          server,
          const WellKnownInfo(
              name: server,
              oidcUrl: 'http://oidc.example',
              serverUrl: 'http://api.example'));
    });

    test('measures the offset against /time and serves serverNowMs', () async {
      // Local clock: starts at 1_000_000 and advances 4ms per probe leg;
      // server clock runs exactly 500ms ahead.
      var localNow = 1000000.0;
      final client = MockClient((request) async {
        expect(request.url.path, '/time');
        localNow += 4; // request leg
        final serverTime = (localNow + 500).round();
        localNow += 4; // response leg
        return http.Response(json.encode({'serverTimeMs': serverTime}), 200,
            headers: {'content-type': 'application/json'});
      });
      final service =
          ClockSyncService.internal(httpClient: client, nowMs: () => localNow);

      expect(await service.ensureSynced(server), isTrue);
      expect(service.offsetMs(server), closeTo(500, 1));
      expect(service.serverNowMs(server), closeTo(localNow + 500, 1));
      expect(service.offsetConfidenceMs(server)!, lessThan(10));
    });

    test('keeps returning false when the endpoint is unreachable', () async {
      final client = MockClient((request) async => http.Response('down', 503));
      final service = ClockSyncService.internal(
          httpClient: client, nowMs: () => 1000000.0);

      expect(await service.ensureSynced(server), isFalse);
      expect(service.serverNowMs(server), isNull);
    });
  });
}
