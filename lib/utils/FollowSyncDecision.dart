/// The tight-sync control law for a following device, as a pure function so
/// the thresholds and hysteresis are unit-testable without a player.
///
/// Three regimes (the classic multi-room recipe):
///  - a large error is corrected with a seek (a rate nudge would take minutes);
///  - a moderate error is steered away with a small rate change (max ±2%,
///    inaudible with mpv's pitch correction);
///  - once locked (≤ [lockThresholdMs]) the rate returns to 1.0, and errors in
///    the dead band between lock and [rateThresholdMs] change nothing — that
///    hysteresis keeps the rate from flapping around the threshold.
library;

enum FollowSyncActionType { none, seek, rate }

class FollowSyncAction {
  const FollowSyncAction._(this.type, this.rate);

  const FollowSyncAction.none() : this._(FollowSyncActionType.none, 1.0);
  const FollowSyncAction.seek() : this._(FollowSyncActionType.seek, 1.0);
  const FollowSyncAction.rate(double rate)
      : this._(FollowSyncActionType.rate, rate);

  final FollowSyncActionType type;

  /// The playback rate to apply (only meaningful for [FollowSyncActionType.rate]).
  final double rate;
}

/// Above this error a seek is the only sensible correction.
const int seekThresholdMs = 250;

/// Above this error the rate controller engages.
const int rateThresholdMs = 40;

/// Below this error the device counts as locked and the rate resets to 1.0.
const int lockThresholdMs = 15;

/// Maximum rate deviation; ±2% is inaudible with audio pitch correction.
const double maxRateDelta = 0.02;

/// Full [maxRateDelta] is reached at an error of this size; smaller errors get
/// a proportionally gentler nudge.
const int fullRateErrorMs = 200;

/// [errorMs] is `localPosition − target`: positive means this device runs
/// ahead of the leader and must slow down. [currentRate] is the rate currently
/// applied, so a locked device isn't re-set to 1.0 every tick.
FollowSyncAction decideFollowSync(
    {required double errorMs, required double currentRate}) {
  final magnitude = errorMs.abs();
  if (magnitude > seekThresholdMs) {
    return const FollowSyncAction.seek();
  }
  if (magnitude > rateThresholdMs) {
    final delta = maxRateDelta * (magnitude / fullRateErrorMs).clamp(0.0, 1.0);
    final rate = errorMs > 0 ? 1.0 - delta : 1.0 + delta;
    return FollowSyncAction.rate(double.parse(rate.toStringAsFixed(4)));
  }
  if (magnitude <= lockThresholdMs && currentRate != 1.0) {
    return const FollowSyncAction.rate(1.0);
  }
  // Dead band (hysteresis): between lock and rate thresholds nothing changes.
  return const FollowSyncAction.none();
}
