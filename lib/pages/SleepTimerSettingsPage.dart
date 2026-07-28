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
                child: ListTile(
                  enabled: _autoEnabled,
                  leading: const Icon(Icons.hourglass_bottom_outlined),
                  title: Text(loc.sleepTimerDefaultDuration),
                  trailing: DropdownButton<int>(
                    value: sleepTimerPresetsMinutes.contains(_durationMinutes)
                        ? _durationMinutes
                        : null,
                    hint: Text(loc.sleepTimerMinutes(_durationMinutes)),
                    onChanged: _autoEnabled ? _setDuration : null,
                    items: [
                      for (final minutes in sleepTimerPresetsMinutes)
                        DropdownMenuItem(
                          value: minutes,
                          child: Text(loc.sleepTimerMinutes(minutes)),
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

  void _setDuration(int? minutes) {
    if (minutes == null) return;
    SleepTimerPreferences.setDurationMinutes(minutes);
    setState(() => _durationMinutes = minutes);
  }
}
