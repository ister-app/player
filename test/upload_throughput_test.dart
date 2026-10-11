import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/upload/UploadThroughput.dart';

void main() {
  final t0 = DateTime(2026, 1, 1, 12);
  DateTime at(int seconds) => t0.add(Duration(seconds: seconds));

  test('no speed until the window holds enough time', () {
    final t = UploadThroughput();
    t.sample(0, at(0));
    expect(t.bytesPerSecond, isNull);
    t.sample(16, at(2));
    expect(t.bytesPerSecond, isNull, reason: 'span below minSpan');
    t.sample(32, at(4));
    expect(t.bytesPerSecond, 8);
    expect(t.remaining(100, 32), const Duration(seconds: 10), reason: '68/8 = 8.5 s, rounded up to 10 s');
  });

  test('averages over the window only', () {
    final t = UploadThroughput(window: const Duration(seconds: 10));
    for (var s = 0; s <= 10; s++) {
      t.sample(s * 100, at(s)); // 100 B/s
    }
    for (var s = 11; s <= 25; s++) {
      t.sample(1000 + (s - 10) * 10, at(s)); // then 10 B/s
    }
    expect(t.bytesPerSecond, closeTo(10, 0.01));
  });

  test('a stalled upload drifts to zero and has no time left', () {
    final t = UploadThroughput(window: const Duration(seconds: 10));
    t.sample(0, at(0));
    t.sample(1000, at(5));
    expect(t.bytesPerSecond, 200);
    for (var s = 6; s <= 30; s++) {
      t.sample(1000, at(s));
    }
    expect(t.bytesPerSecond, 0);
    expect(t.remaining(5000, 1000), isNull);
  });

  test('pause freezes the clock and forgets the speed', () {
    final t = UploadThroughput();
    t.sample(0, at(0));
    t.sample(500, at(5));
    expect(t.bytesPerSecond, 100);
    t.pause(at(10));
    expect(t.isRunning, isFalse);
    expect(t.bytesPerSecond, isNull);
    expect(t.elapsed(at(60)), const Duration(seconds: 10));
    t.sample(500, at(60));
    t.sample(600, at(65));
    expect(t.elapsed(at(65)), const Duration(seconds: 15));
    expect(t.bytesPerSecond, 20, reason: 'the 50 s gap is not averaged in');
  });

  test('time left is rounded coarser the further away', () {
    expect(UploadThroughput.roundRemaining(const Duration(seconds: 3)), const Duration(seconds: 10));
    expect(UploadThroughput.roundRemaining(const Duration(seconds: 61)), const Duration(minutes: 2));
    expect(UploadThroughput.roundRemaining(const Duration(minutes: 59, seconds: 1)), const Duration(hours: 1));
    expect(UploadThroughput.roundRemaining(const Duration(hours: 1, minutes: 1)), const Duration(hours: 1, minutes: 5));
    final t = UploadThroughput();
    t.sample(0, at(0));
    t.sample(100, at(10));
    expect(t.remaining(100, 100), Duration.zero);
  });
}
