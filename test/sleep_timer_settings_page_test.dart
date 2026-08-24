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

  testWidgets('choosing a duration preset persists the duration mode',
      (tester) async {
    await SleepTimerPreferences.setAutoEnabled(true);
    await SleepTimerPreferences.setCountItems(true);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('sleep-preset-min-45')));
    await tester.pumpAndSettle();

    final schedule = await SleepTimerPreferences.getSchedule();
    expect(schedule.durationMinutes, 45);
    expect(schedule.countItems, isFalse);
  });

  testWidgets('choosing an item preset persists the item-counting mode',
      (tester) async {
    await SleepTimerPreferences.setAutoEnabled(true);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('sleep-preset-items-3')));
    await tester.pumpAndSettle();

    final schedule = await SleepTimerPreferences.getSchedule();
    expect(schedule.countItems, isTrue);
    expect(schedule.itemCount, 3);
  });

  testWidgets('the custom item chip persists a non-preset count',
      (tester) async {
    await SleepTimerPreferences.setAutoEnabled(true);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('sleep-preset-items-custom')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '7');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    final schedule = await SleepTimerPreferences.getSchedule();
    expect(schedule.countItems, isTrue);
    expect(schedule.itemCount, 7);
    // The non-preset count lives on the custom chip, selected.
    final chip = tester.widget<ChoiceChip>(
        find.byKey(const Key('sleep-preset-items-custom')));
    expect(chip.selected, isTrue);
  });

  testWidgets('preset chips are disabled while the switch is off',
      (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    final chip = tester
        .widget<ChoiceChip>(find.byKey(const Key('sleep-preset-min-30')));
    expect(chip.onSelected, isNull);

    await tester.tap(find.byKey(const Key('sleep-preset-items-2')));
    await tester.pumpAndSettle();
    final schedule = await SleepTimerPreferences.getSchedule();
    expect(schedule.countItems, isFalse);
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
