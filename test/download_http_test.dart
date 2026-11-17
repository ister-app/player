
import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/utils/download/DownloadHttp.dart';

void main() {
  group('getToFile progress', () {
    late Directory tmp;
    setUp(() async => tmp = await Directory.systemTemp.createTemp('ister-http-'));
    tearDown(() async => tmp.delete(recursive: true));

    DownloadHttp client(http.Client mock) => DownloadHttp(
          httpClient: mock,
          tokenProvider: (_) async => 'tok',
          onAuthFailure: (_) {},
          backoff: (_) => Duration.zero,
        );

    test('reports the running byte count after every chunk', () async {
      final mock = MockClient.streaming((req, _) async => http.StreamedResponse(
          Stream.fromIterable([
            [1, 2, 3],
            [4, 5],
            [6]
          ]),
          200));
      final seen = <int>[];
      final target = File('${tmp.path}/f.bin');
      final size = await client(mock).getToFile('srv', 'https://n/f', target, DownloadCancelToken(),
          timeout: const Duration(seconds: 5), onProgress: seen.add);
      expect(size, 6);
      expect(seen, [0, 3, 5, 6]);
      expect(target.readAsBytesSync(), [1, 2, 3, 4, 5, 6]);
      expect(File('${target.path}.part').existsSync(), isFalse);
    });

    test('a resumed part starts counting at its offset and appends', () async {
      final target = File('${tmp.path}/f.bin');
      File('${target.path}.part').writeAsBytesSync([9, 9]);
      String? range;
      final mock = MockClient.streaming((req, _) async {
        range = req.headers['Range'];
        return http.StreamedResponse(
            Stream.fromIterable([
              [7],
              [8]
            ]),
            206);
      });
      final seen = <int>[];
      await client(mock).getToFile('srv', 'https://n/f', target, DownloadCancelToken(),
          timeout: const Duration(seconds: 5), resume: true, onProgress: seen.add);
      expect(range, 'bytes=2-');
      expect(seen, [2, 3, 4]);
      expect(target.readAsBytesSync(), [9, 9, 7, 8]);
    });

    test('a part the server cannot continue (416) is fetched whole again', () async {
      final target = File('${tmp.path}/f.bin');
      // As long as the file, or longer: nothing left to ask for.
      File('${target.path}.part').writeAsBytesSync([9, 9, 9, 9]);
      final ranges = <String?>[];
      final mock = MockClient.streaming((req, _) async {
        ranges.add(req.headers['Range']);
        if (req.headers['Range'] != null) {
          return http.StreamedResponse(const Stream.empty(), 416);
        }
        return http.StreamedResponse(
            Stream.fromIterable([
              [1, 2, 3]
            ]),
            200);
      });
      final size = await client(mock).getToFile('srv', 'https://n/f', target, DownloadCancelToken(),
          timeout: const Duration(seconds: 5), resume: true, onProgress: (_) {});
      expect(ranges, ['bytes=4-', null]);
      expect(size, 3);
      expect(target.readAsBytesSync(), [1, 2, 3]);
    });

    test('a 206 for another range is not appended; the part is dropped', () async {
      final target = File('${tmp.path}/f.bin');
      final part = File('${target.path}.part')..writeAsBytesSync([9, 9]);
      final mock = MockClient.streaming((req, _) async => http.StreamedResponse(
          Stream.fromIterable([
            [7, 8]
          ]),
          206,
          headers: {'content-range': 'bytes 0-1/2'}));
      await expectLater(
        client(mock).getToFile('srv', 'https://n/f', target, DownloadCancelToken(),
            timeout: const Duration(seconds: 5), resume: true),
        throwsA(isA<DownloadFailure>().having((e) => e.transient, 'transient', isTrue)),
      );
      expect(part.existsSync(), isFalse);
      expect(target.existsSync(), isFalse);
    });

    test('a body that goes silent ends at the idle timeout, not the body budget', () async {
      final mock = MockClient.streaming((req, _) async => http.StreamedResponse(
          () async* {
            yield [1, 2];
            await Future<void>.delayed(const Duration(seconds: 5));
            yield [3];
          }(),
          200));
      final slow = DownloadHttp(
        httpClient: mock,
        tokenProvider: (_) async => 'tok',
        onAuthFailure: (_) {},
        backoff: (_) => Duration.zero,
        bodyTimeout: const Duration(hours: 6),
        idleTimeout: const Duration(milliseconds: 100),
      );
      final target = File('${tmp.path}/f.bin');
      await expectLater(
        slow.getToFile('srv', 'https://n/f', target, DownloadCancelToken(),
            timeout: const Duration(seconds: 5), resume: true, onProgress: (_) {}),
        throwsA(isA<TimeoutException>()),
      );
      // What arrived is kept for the retry.
      expect(File('${target.path}.part').lengthSync(), 2);
    });

    test('cancelling mid-body stops the stream and keeps a resumable part', () async {
      final cancel = DownloadCancelToken();
      final mock = MockClient.streaming((req, _) async => http.StreamedResponse(
          Stream.fromIterable([
            [1, 2],
            [3, 4],
            [5, 6]
          ]),
          200));
      final target = File('${tmp.path}/f.bin');
      await expectLater(
        client(mock).getToFile('srv', 'https://n/f', target, cancel,
            timeout: const Duration(seconds: 5), resume: true, onProgress: (n) {
          if (n >= 2) cancel.cancel();
        }),
        throwsA(isA<DownloadCancelled>()),
      );
      expect(target.existsSync(), isFalse);
      expect(File('${target.path}.part').lengthSync(), 2);
    });
  });

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
