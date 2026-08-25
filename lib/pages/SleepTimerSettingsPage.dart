import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/components/SleepTimerSheet.dart';
import 'package:player/utils/SleepTimerPreferences.dart';

import '../l10n/app_localizations.dart';

/// Settings for the automatic sleep timer. No server param on purpose: the
/// schedule is stored per device, not per server or user.
@RoutePage()
class SleepTimerSettingsPage extends StatefulWidget {
  const SleepTimerSettingsPage({super.key});

  @override
  State<SleepTimerSettingsPage> createState() => _SleepTimerSettingsPageState();
}

class _SleepTimerSettingsPageState extends State<SleepTimerSettingsPage> {
  bool _autoEnabled = false;
  int _startMinutes = SleepTimerPreferences.defaultStartMinutes;
  int _endMinutes = SleepTimerPreferences.defaultEndMinutes;
  int _durationMinutes = SleepTimerPreferences.defaultDurationMinutes;
  bool _countItems = false;
  int _itemCount = SleepTimerPreferences.defaultItemCount;
  late Future<void> _preferencesFuture;

  @override
  void initState() {
    super.initState();
    _preferencesFuture = _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final schedule = await SleepTimerPreferences.getSchedule();
    if (!mounted) return;
    setState(() {
      _autoEnabled = schedule.enabled;
      _startMinutes = schedule.startMinutes;
      _endMinutes = schedule.endMinutes;
      _durationMinutes = schedule.durationMinutes;
      _countItems = schedule.countItems;
      _itemCount = schedule.itemCount;
    });
  }

  TimeOfDay _toTime(int minutes) =>
      TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);

  Future<void> _pickTime(int current, ValueChanged<int> onPicked) async {
    final picked =
        await showTimePicker(context: context, initialTime: _toTime(current));
    if (picked != null) onPicked(picked.hour * 60 + picked.minute);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.sleepTimer)),
      body: FutureBuilder<void>(
        future: _preferencesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                child: SwitchListTile(
                  secondary: const Icon(Icons.bedtime_outlined),
                  title: Text(loc.sleepTimerAuto),
                  subtitle: Text(
                      '${loc.sleepTimerAutoDescription}\n${loc.sleepTimerDeviceOnly}'),
                  value: _autoEnabled,
                  onChanged: (value) {
                    SleepTimerPreferences.setAutoEnabled(value);
                    setState(() => _autoEnabled = value);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  enabled: _autoEnabled,
                  leading: const Icon(Icons.nightlight_outlined),
                  title: Text(loc.sleepTimerFrom),
                  trailing: Text(_toTime(_startMinutes).format(context)),
                  onTap: () => _pickTime(_startMinutes, (minutes) {
                    SleepTimerPreferences.setStartMinutes(minutes);
                    setState(() => _startMinutes = minutes);
                  }),
                ),
              ),
              Card(
                child: ListTile(
                  enabled: _autoEnabled,
                  leading: const Icon(Icons.wb_sunny_outlined),
                  title: Text(loc.sleepTimerUntil),
                  trailing: Text(_toTime(_endMinutes).format(context)),
                  onTap: () => _pickTime(_endMinutes, (minutes) {
                    SleepTimerPreferences.setEndMinutes(minutes);
                    setState(() => _endMinutes = minutes);
                  }),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        enabled: _autoEnabled,
                        leading: const Icon(Icons.hourglass_bottom_outlined),
                        title: Text(loc.sleepTimerDefault),
                      ),
                      _sectionLabel(context, loc.sleepTimerAfterDuration),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          for (final minutes in sleepTimerPresetsMinutes)
                            ChoiceChip(
                              key: Key('sleep-preset-min-$minutes'),
                              label: Text(loc.sleepTimerMinutes(minutes)),
                              selected:
                                  !_countItems && _durationMinutes == minutes,
                              onSelected: _autoEnabled
                                  ? (_) => _setDuration(minutes)
                                  : null,
                            ),
                          ChoiceChip(
                            key: const Key('sleep-preset-min-custom'),
                            // A stored value outside the presets lives on this
                            // chip, like the dropdown's hint used to.
                            label: Text(_customDurationActive
                                ? loc.sleepTimerMinutes(_durationMinutes)
                                : loc.sleepTimerCustom),
                            selected: _customDurationActive,
                            onSelected:
                                _autoEnabled ? (_) => _pickDuration() : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _sectionLabel(context, loc.sleepTimerAfterItems),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          for (final count in sleepTimerPresetsItems)
                            ChoiceChip(
                              key: Key('sleep-preset-items-$count'),
                              label: Text(loc.sleepTimerItemsPreset(count)),
                              selected: _countItems && _itemCount == count,
                              onSelected: _autoEnabled
                                  ? (_) => _setItems(count)
                                  : null,
                            ),
                          ChoiceChip(
                            key: const Key('sleep-preset-items-custom'),
                            label: Text(_customItemsActive
                                ? loc.sleepTimerItemsPreset(_itemCount)
                                : loc.sleepTimerCustom),
                            selected: _customItemsActive,
                            onSelected:
                                _autoEnabled ? (_) => _pickItems() : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  bool get _customDurationActive =>
      !_countItems && !sleepTimerPresetsMinutes.contains(_durationMinutes);

  bool get _customItemsActive =>
      _countItems && !sleepTimerPresetsItems.contains(_itemCount);

  /// A sub-label inside the default-timer card. Deliberately not
  /// [SettingsSectionLabel]: that one is a page-level section header with its
  /// own top padding and indent, which would break the card's spacing. Only
  /// the typography is kept in step.
  Widget _sectionLabel(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );

  void _setDuration(int minutes) {
    SleepTimerPreferences.setCountItems(false);
    SleepTimerPreferences.setDurationMinutes(minutes);
    setState(() {
      _countItems = false;
      _durationMinutes = minutes;
    });
  }

  Future<void> _pickDuration() async {
    final minutes = await showSleepTimerMinutesDialog(context);
    if (minutes != null && minutes > 0) _setDuration(minutes);
  }

  void _setItems(int count) {
    SleepTimerPreferences.setCountItems(true);
    SleepTimerPreferences.setItemCount(count);
    setState(() {
      _countItems = true;
      _itemCount = count;
    });
  }

  Future<void> _pickItems() async {
    final count = await showSleepTimerItemsDialog(context);
    if (count != null && count > 0) _setItems(count);
  }
}
