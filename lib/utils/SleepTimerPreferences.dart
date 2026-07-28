import 'package:shared_preferences/shared_preferences.dart';

/// True when [nowMinutes] falls inside the window [startMinutes, endMinutes)
/// expressed in minutes since midnight, wrapping past midnight when
/// start > end. An empty window (start == end) never matches.
bool isWithinSleepWindow(int nowMinutes, int startMinutes, int endMinutes) {
  if (startMinutes == endMinutes) return false;
  return startMinutes < endMinutes
      ? nowMinutes >= startMinutes && nowMinutes < endMinutes
      : nowMinutes >= startMinutes || nowMinutes < endMinutes;
}

/// The automatic sleep-timer schedule: when playback starts inside the
/// window, a sleep timer of [durationMinutes] arms itself.
class SleepSchedule {
  final bool enabled;
  final int startMinutes;
  final int endMinutes;
  final int durationMinutes;

  const SleepSchedule({
    required this.enabled,
    required this.startMinutes,
    required this.endMinutes,
    required this.durationMinutes,
  });
}

/// Sleep-timer settings. Local to this device on purpose: whether a sleep
/// timer makes sense depends on where the device is (bedroom vs. living
/// room), so it is not synced to the server like playback settings are.
class SleepTimerPreferences {
  static const _kAutoEnabled = 'sleep_timer_auto_enabled';
  static const _kAutoStartMinutes = 'sleep_timer_auto_start_minutes';
  static const _kAutoEndMinutes = 'sleep_timer_auto_end_minutes';
  static const _kAutoDurationMinutes = 'sleep_timer_auto_duration_minutes';
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static const defaultStartMinutes = 22 * 60;
  static const defaultEndMinutes = 6 * 60;
  static const defaultDurationMinutes = 30;

  static Future<SleepSchedule> getSchedule() async {
    return SleepSchedule(
      enabled: await _prefs.getBool(_kAutoEnabled) ?? false,
      startMinutes:
          await _prefs.getInt(_kAutoStartMinutes) ?? defaultStartMinutes,
      endMinutes: await _prefs.getInt(_kAutoEndMinutes) ?? defaultEndMinutes,
      durationMinutes:
          await _prefs.getInt(_kAutoDurationMinutes) ?? defaultDurationMinutes,
    );
  }

  static Future<void> setAutoEnabled(bool enabled) =>
      _prefs.setBool(_kAutoEnabled, enabled);

  static Future<void> setStartMinutes(int minutes) =>
      _prefs.setInt(_kAutoStartMinutes, minutes);

  static Future<void> setEndMinutes(int minutes) =>
      _prefs.setInt(_kAutoEndMinutes, minutes);

  static Future<void> setDurationMinutes(int minutes) =>
      _prefs.setInt(_kAutoDurationMinutes, minutes);
}
