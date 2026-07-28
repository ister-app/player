import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/SleepTimerService.dart';

const sleepTimerPresetsMinutes = [15, 30, 45, 60, 90];

/// Bottom sheet controlling the sleep timer: preset/custom durations when
/// inactive, a live countdown with extend/cancel when running. Talks straight
/// to [SleepTimerService] — the timer is local to this device, so it is not
/// offered on the remote-control player.
class SleepTimerSheet extends StatelessWidget {
  const SleepTimerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final service = SleepTimerService.instance;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: ValueListenableBuilder<Duration?>(
          valueListenable: service.remaining,
          builder: (context, remaining, _) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(loc.sleepTimer,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              if (remaining != null) ...[
                Center(
                  child: Text(
                    loc.sleepTimerRemaining(_format(remaining)),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () =>
                          service.extend(const Duration(minutes: 15)),
                      child: Text(loc.sleepTimerExtend),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.tonal(
                      onPressed: () {
                        service.cancel();
                        Navigator.of(context).pop();
                      },
                      child: Text(loc.sleepTimerCancel),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final minutes in sleepTimerPresetsMinutes)
                    ActionChip(
                      label: Text(loc.sleepTimerMinutes(minutes)),
                      onPressed: () =>
                          _start(context, Duration(minutes: minutes)),
                    ),
                  ActionChip(
                    label: Text(loc.sleepTimerCustom),
                    onPressed: () => _startCustom(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _start(BuildContext context, Duration duration) {
    SleepTimerService.instance.start(duration);
    Navigator.of(context).pop();
  }

  Future<void> _startCustom(BuildContext context) async {
    final minutes = await showSleepTimerMinutesDialog(context);
    if (minutes != null && minutes > 0 && context.mounted) {
      _start(context, Duration(minutes: minutes));
    }
  }

  String _format(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    if (d.inHours > 0) {
      return '${d.inHours}:${(minutes % 60).toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Dialog asking for a duration in minutes; returns null when dismissed.
/// Shared between the player sheet and the sleep timer settings page.
Future<int?> showSleepTimerMinutesDialog(BuildContext context) {
  final loc = AppLocalizations.of(context)!;
  final controller = TextEditingController();
  return showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(loc.sleepTimerCustomDuration),
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(labelText: loc.sleepTimerMinutesLabel),
        onSubmitted: (value) =>
            Navigator.of(context).pop(int.tryParse(value)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(int.tryParse(controller.text)),
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    ),
  );
}
