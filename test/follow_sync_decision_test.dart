import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/FollowSyncDecision.dart';

void main() {
  test('a large error is corrected with a seek', () {
    expect(decideFollowSync(errorMs: 400, currentRate: 1.0).type,
        FollowSyncActionType.seek);
    expect(decideFollowSync(errorMs: -251, currentRate: 1.0).type,
        FollowSyncActionType.seek);
  });

  test('a moderate error nudges the rate towards the target', () {
    // Ahead of the leader → slow down.
    final ahead = decideFollowSync(errorMs: 100, currentRate: 1.0);
    expect(ahead.type, FollowSyncActionType.rate);
    expect(ahead.rate, lessThan(1.0));
    // Behind the leader → speed up.
    final behind = decideFollowSync(errorMs: -100, currentRate: 1.0);
    expect(behind.type, FollowSyncActionType.rate);
    expect(behind.rate, greaterThan(1.0));
  });

  test('the rate deviation is proportional and capped at 2%', () {
    final gentle = decideFollowSync(errorMs: 50, currentRate: 1.0);
    final firm = decideFollowSync(errorMs: 200, currentRate: 1.0);
    final capped = decideFollowSync(errorMs: 250, currentRate: 1.0);
    expect(1.0 - gentle.rate, lessThan(1.0 - firm.rate));
    expect(firm.rate, 1.0 - maxRateDelta);
    expect(capped.rate, 1.0 - maxRateDelta);
  });

  test('locking resets the rate exactly once', () {
    // Steering, then locked: back to 1.0.
    final lock = decideFollowSync(errorMs: 10, currentRate: 0.99);
    expect(lock.type, FollowSyncActionType.rate);
    expect(lock.rate, 1.0);
    // Already neutral: nothing to do.
    expect(decideFollowSync(errorMs: 10, currentRate: 1.0).type,
        FollowSyncActionType.none);
  });

  test('the dead band between lock and rate thresholds changes nothing', () {
    // Whether steering or neutral, an error of 25ms is left alone: resetting
    // would flap, steering would overshoot.
    expect(decideFollowSync(errorMs: 25, currentRate: 1.0).type,
        FollowSyncActionType.none);
    expect(decideFollowSync(errorMs: -25, currentRate: 0.99).type,
        FollowSyncActionType.none);
  });
}
