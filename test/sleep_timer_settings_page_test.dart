import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/SleepTimerSettingsPage.dart';
import 'package:player/utils/SleepTimerPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// Pins the sleep timer settings page: the automatic timer is off by default,
/// the schedule tiles only work while it is on, and every control persists to
/// the device-local preferences.
Widget _app() => const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en')],
      home: SleepTimerSettingsPage(),
    );

void main() {
  setUpAll(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  // SleepTimerPreferences holds one static SharedPreferencesAsync, which
  // captures the platform instance on first use — so clear the store between
  // tests instead of swapping in a fresh platform the static never sees.
  setUp(() => SharedPreferencesAsync().clear());

  testWidgets('switch is off by default and persists when toggled',
      (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    final switchTile =
        tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(switchTile.value, isFalse);

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    final schedule = await SleepTimerPreferences.getSchedule();
    expect(schedule.enabled, isTrue);
  });

  testWidgets('schedule tiles are disabled while the switch is off',
      (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    // SwitchListTile renders a ListTile internally too; the three schedule
    // tiles are the disabled ones.
    final tiles =
        tester.widgetList<ListTile>(find.byType(ListTile)).toList();
    expect(tiles.where((t) => !t.enabled), hasLength(3));

    // Tapping the disabled "From" tile must not open the time picker.
    await tester.tap(find.text('From'));
    await tester.pumpAndSettle();
    expect(find.byType(TimePickerDialog), findsNothing);
  });

  testWidgets('changing the default duration persists', (tester) async {
    await SleepTimerPreferences.setAutoEnabled(true);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('45 min').last);
    await tester.pumpAndSettle();

    final schedule = await SleepTimerPreferences.getSchedule();
    expect(schedule.durationMinutes, 45);
  });

  testWidgets('picking a start time persists it', (tester) async {
    await SleepTimerPreferences.setAutoEnabled(true);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('From'));
    await tester.pumpAndSettle();
    expect(find.byType(TimePickerDialog), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    final schedule = await SleepTimerPreferences.getSchedule();
    // Confirming the pre-filled default keeps 22:00.
    expect(schedule.startMinutes, SleepTimerPreferences.defaultStartMinutes);
  });
}
