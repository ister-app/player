import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/utils/download/DownloadHttp.dart';

void main() {
  test('parallel requests share one token refresh on a 401', () async {
    // One token for everyone, as in production: every in-flight request gets
    // the same rejection when it expires.
    var token = 'stale';
    var authFailures = 0;
    var tokenReads = 0;
    final http_ = DownloadHttp(
      httpClient: MockClient((req) async {
        if (req.url.queryParameters['token'] != 'fresh') {
          return http.Response('nope', 401);
        }
        return http.Response('ok', 200);
      }),
      tokenProvider: (_) async {
        tokenReads++;
        return token;
      },
      // Stands in for invalidate + the (deduplicated) refetch that follows.
      onAuthFailure: (_) {
        authFailures++;
        token = 'fresh';
      },
      backoff: (_) => Duration.zero,
    );

    final cancel = DownloadCancelToken();
    final responses = await Future.wait([
      for (var i = 0; i < 8; i++)
        http_.send('srv', 'https://node.example/seg$i.ts', cancel,
            timeout: const Duration(seconds: 5))
    ]);

    expect(responses.every((r) => r.statusCode == 200), isTrue);
    expect(authFailures, 1,
        reason: 'only the first request drops the token the others share');
    expect(tokenReads, 16, reason: '8 stale reads, 8 retries with the fresh one');
  });

  test('a rejection that survives the refresh is transient', () async {
    final http_ = DownloadHttp(
      httpClient: MockClient((_) async => http.Response('no', 403)),
      tokenProvider: (_) async => 'tok',
      onAuthFailure: (_) {},
      backoff: (_) => Duration.zero,
    );
    await expectLater(
      http_.send('srv', 'https://node.example/seg.ts', DownloadCancelToken(),
          timeout: const Duration(seconds: 5)),
      throwsA(isA<DownloadFailure>()
          .having((e) => e.transient, 'transient', isTrue)),
    );
  });

  test('backoff doubles and stays within its jitter band', () {
    for (final (attempt, base) in const [(0, 2), (1, 4), (2, 8), (7, 60)]) {
      for (var i = 0; i < 20; i++) {
        final d = DownloadHttp.defaultBackoff(attempt).inMilliseconds;
        expect(d, greaterThanOrEqualTo((base * 800).round()));
        expect(d, lessThanOrEqualTo((base * 1200).round()));
      }
    }
    // The jitter really varies, otherwise workers still retry in lockstep.
    final samples = {
      for (var i = 0; i < 20; i++) DownloadHttp.defaultBackoff(0).inMilliseconds
    };
    expect(samples.length, greaterThan(1));
  });
}
