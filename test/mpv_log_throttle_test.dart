import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/MpvLogThrottle.dart';

void main() {
  late DateTime now;
  late MpvLogThrottle throttle;

  setUp(() {
    now = DateTime(2026, 10, 5, 11);
    throttle = MpvLogThrottle(maxPerWindow: 3, now: () => now);
  });

  test('drops a repeated line and reports the count on the next one', () {
    expect(throttle.admit('underrun'), 'underrun');
    expect(throttle.admit('underrun'), isNull);
    expect(throttle.admit('underrun'), isNull);
    expect(throttle.admit('http error'), 'http error (+2 suppressed)');
  });

  test('lets a repeated line through again after the repeat window', () {
    expect(throttle.admit('underrun'), 'underrun');
    now = now.add(const Duration(seconds: 31));
    expect(throttle.admit('underrun'), 'underrun');
  });

  test('caps the number of lines per window', () {
    expect(throttle.admit('a'), 'a');
    expect(throttle.admit('b'), 'b');
    expect(throttle.admit('c'), 'c');
    expect(throttle.admit('d'), isNull);
    now = now.add(const Duration(minutes: 1));
    expect(throttle.admit('e'), 'e (+1 suppressed)');
  });
}
