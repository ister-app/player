import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/SleepTimerPreferences.dart';
import 'package:player/utils/SleepTimerService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// Pins the sleep-timer invariants: the countdown fires stop() exactly once
/// at the deadline, a user cancel suppresses re-arming for the rest of the
/// session, and the auto-start window wraps correctly past midnight.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('isWithinSleepWindow', () {
    test('non-wrapping window', () {
      // 10:00–12:00
      expect(isWithinSleepWindow(9 * 60, 600, 720), isFalse);
      expect(isWithinSleepWindow(600, 600, 720), isTrue);
      expect(isWithinSleepWindow(11 * 60, 600, 720), isTrue);
      expect(isWithinSleepWindow(720, 600, 720), isFalse);
      expect(isWithinSleepWindow(13 * 60, 600, 720), isFalse);
    });

    test('window wrapping past midnight', () {
      // 22:00–06:00
      expect(isWithinSleepWindow(23 * 60, 1320, 360), isTrue);
      expect(isWithinSleepWindow(3 * 60, 1320, 360), isTrue);
      expect(isWithinSleepWindow(12 * 60, 1320, 360), isFalse);
      expect(isWithinSleepWindow(1320, 1320, 360), isTrue);
      expect(isWithinSleepWindow(360, 1320, 360), isFalse);
    });

    test('empty window never matches', () {
      expect(isWithinSleepWindow(600, 600, 600), isFalse);
    });
  });

  group('countdown', () {
    SleepTimerService serviceOn(FakeAsync async) {
      final service = SleepTimerService.forTest();
      service.now = async.getClock(DateTime(2026, 7, 28, 23, 0)).now;
      return service;
    }

    test('ticks down and fires onExpire exactly once', () {
      fakeAsync((async) {
        final service = serviceOn(async);
        var expiries = 0;
        service.onExpire = () async => expiries++;
        service.start(const Duration(minutes: 15));

        expect(service.remaining.value, const Duration(minutes: 15));
        async.elapse(const Duration(minutes: 1));
        expect(service.remaining.value, const Duration(minutes: 14));
        expect(expiries, 0);

        async.elapse(const Duration(minutes: 14));
        expect(expiries, 1);
        expect(service.remaining.value, isNull);
        expect(service.isActive, isFalse);

        async.elapse(const Duration(minutes: 5));
        expect(expiries, 1);
      });
    });

    test('cancel stops the countdown without firing', () {
      fakeAsync((async) {
        final service = serviceOn(async);
        var expiries = 0;
        service.onExpire = () async => expiries++;
        service.start(const Duration(minutes: 15));

        async.elapse(const Duration(minutes: 5));
        service.cancel();
        expect(service.remaining.value, isNull);

        async.elapse(const Duration(hours: 1));
        expect(expiries, 0);
      });
    });

    test('extend pushes the deadline out', () {
      fakeAsync((async) {
        final service = serviceOn(async);
        var expiries = 0;
        service.onExpire = () async => expiries++;
        service.start(const Duration(minutes: 15));

        async.elapse(const Duration(minutes: 10));
        service.extend(const Duration(minutes: 15));
        expect(service.remaining.value, const Duration(minutes: 20));

        async.elapse(const Duration(minutes: 19));
        expect(expiries, 0);
        async.elapse(const Duration(minutes: 1));
        expect(expiries, 1);
      });
    });

    test('announces arming and expiry', () {
      fakeAsync((async) {
        final service = serviceOn(async);
        final messages = <String>[];
        service.showMessage = messages.add;
        service.onExpire = () async {};
        service.start(const Duration(minutes: 15));

        expect(messages, hasLength(1));
        expect(messages.single, contains('15'));

        async.elapse(const Duration(minutes: 14));
        expect(messages, hasLength(1));

        async.elapse(const Duration(minutes: 1));
        expect(messages, hasLength(2));

        async.elapse(const Duration(minutes: 5));
        expect(messages, hasLength(2));
      });
    });

    test('cancel announces nothing', () {
      fakeAsync((async) {
        final service = serviceOn(async);
        final messages = <String>[];
        service.start(const Duration(minutes: 15));
        service.showMessage = messages.add;

        service.cancel();
        async.elapse(const Duration(hours: 1));
        expect(messages, isEmpty);
      });
    });

    test('restarting an active timer replaces the deadline', () {
      fakeAsync((async) {
        final service = serviceOn(async);
        var expiries = 0;
        service.onExpire = () async => expiries++;
        service.start(const Duration(minutes: 90));

        async.elapse(const Duration(minutes: 5));
        service.start(const Duration(minutes: 15));
        expect(service.remaining.value, const Duration(minutes: 15));

        async.elapse(const Duration(minutes: 15));
        expect(expiries, 1);
      });
    });
  });

  group('item count', () {
    late SleepTimerService service;
    late List<String> messages;
    late int expiries;

    setUp(() {
      service = SleepTimerService.forTest();
      messages = [];
      expiries = 0;
      service.showMessage = messages.add;
      service.onExpire = () async => expiries++;
    });

    test('counts the current item and stops after the last one', () {
      service.startItems(3);
      expect(service.isActive, isTrue);
      expect(service.remainingItems.value, 3);
      expect(messages, hasLength(1));

      expect(service.notifyItemFinished(), isFalse);
      expect(service.remainingItems.value, 2);
      expect(service.notifyItemFinished(), isFalse);
      expect(service.remainingItems.value, 1);
      expect(expiries, 0);

      // The last allowed item ended: the timer disarms and announces, but
      // stopping (suspend + park on the next item) is the caller's job —
      // onExpire stays reserved for the countdown mode.
      expect(service.notifyItemFinished(), isTrue);
      expect(expiries, 0);
      expect(service.isActive, isFalse);
      expect(service.remainingItems.value, isNull);
      expect(messages, hasLength(2));
    });

    test('one item stops at the end of what is playing', () {
      service.startItems(1);
      expect(service.notifyItemFinished(), isTrue);
      expect(expiries, 0);
    });

    test('item ends are ignored when no item timer is armed', () {
      expect(service.notifyItemFinished(), isFalse);
      expect(expiries, 0);

      service.start(const Duration(minutes: 15));
      expect(service.notifyItemFinished(), isFalse);
      expect(service.remaining.value, const Duration(minutes: 15));
      expect(expiries, 0);
    });

    test('the two modes replace each other', () {
      service.startItems(3);
      service.start(const Duration(minutes: 15));
      expect(service.remainingItems.value, isNull);
      expect(service.remaining.value, const Duration(minutes: 15));

      service.startItems(2);
      expect(service.remaining.value, isNull);
      expect(service.isActive, isTrue);
    });

    test('cancel and playback stop clear the item count', () {
      service.startItems(3);
      service.cancel();
      expect(service.remainingItems.value, isNull);
      expect(service.notifyItemFinished(), isFalse);

      service.startItems(3);
      service.notifyPlaybackStopped();
      expect(service.remainingItems.value, isNull);
      expect(expiries, 0);
    });
  });

  group('auto-start', () {
    late SleepTimerService service;

    setUpAll(() {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
    });

    setUp(() async {
      // SleepTimerPreferences' static SharedPreferencesAsync captures the
      // platform instance on first use — clear the store rather than swapping
      // in a fresh platform the static never sees.
      await SharedPreferencesAsync().clear();
      service = SleepTimerService.forTest();
      // 23:30 — inside the default 22:00–06:00 window.
      service.now = () => DateTime(2026, 7, 28, 23, 30);
    });

    test('disabled by default: playback start arms nothing', () async {
      await service.notifyPlaybackStarted();
      expect(service.isActive, isFalse);
    });

    test('enabled and inside the window arms the default duration', () async {
      await SleepTimerPreferences.setAutoEnabled(true);
      await service.notifyPlaybackStarted();
      expect(service.remaining.value,
          const Duration(minutes: SleepTimerPreferences.defaultDurationMinutes));
    });

    test('enabled but outside the window arms nothing', () async {
      await SleepTimerPreferences.setAutoEnabled(true);
      service.now = () => DateTime(2026, 7, 28, 14, 0);
      await service.notifyPlaybackStarted();
      expect(service.isActive, isFalse);
    });

    test('wrapped window matches after midnight', () async {
      await SleepTimerPreferences.setAutoEnabled(true);
      service.now = () => DateTime(2026, 7, 29, 5, 0);
      await service.notifyPlaybackStarted();
      expect(service.isActive, isTrue);
    });

    test('a running timer is not re-armed on resume', () async {
      await SleepTimerPreferences.setAutoEnabled(true);
      await SleepTimerPreferences.setDurationMinutes(45);
      service.start(const Duration(minutes: 10));
      await service.notifyPlaybackStarted();
      expect(service.remaining.value, const Duration(minutes: 10));
    });

    test('user cancel suppresses auto-start until playback stops', () async {
      await SleepTimerPreferences.setAutoEnabled(true);
      await service.notifyPlaybackStarted();
      service.cancel();

      await service.notifyPlaybackStarted();
      expect(service.isActive, isFalse);

      service.notifyPlaybackStopped();
      await service.notifyPlaybackStarted();
      expect(service.isActive, isTrue);
    });

    test('playback stop cancels a running timer', () async {
      service.start(const Duration(minutes: 30));
      service.notifyPlaybackStopped();
      expect(service.isActive, isFalse);
      expect(service.remaining.value, isNull);
    });
  });
}
