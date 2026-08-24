import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/SleepTimerService.dart';

const sleepTimerPresetsMinutes = [15, 30, 45, 60, 90];
const sleepTimerPresetsItems = [1, 2, 3, 5];

/// The remaining time in the compact form the player chrome shows next to the
/// bedtime icon: whole minutes while more than a minute is left, seconds below
/// that, so the label stays narrow and only ticks per second at the very end.
String shortSleepCountdown(Duration remaining) {
  if (remaining.inMinutes >= 1) return '${(remaining.inSeconds / 60).ceil()}m';
  return '${remaining.inSeconds}s';
}

/// Bottom sheet controlling the sleep timer: preset/custom durations or a
/// number of media items when inactive, a live countdown with extend/cancel
/// when running. Talks straight to [SleepTimerService] — the timer is local
/// to this device, so it is not offered on the remote-control player.
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
          builder: (context, remaining, _) => ValueListenableBuilder<int?>(
            valueListenable: service.remainingItems,
            builder: (context, items, _) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(loc.sleepTimer,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                if (remaining != null || items != null) ...[
                  Center(
                    child: Text(
                      remaining != null
                          ? loc.sleepTimerRemaining(_format(remaining))
                          : loc.sleepTimerItemsRemaining(items!),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Extending only makes sense for a countdown; the item
                      // presets below re-arm the item mode with a new count.
                      if (remaining != null) ...[
                        OutlinedButton(
                          onPressed: () =>
                              service.extend(const Duration(minutes: 15)),
                          child: Text(loc.sleepTimerExtend),
                        ),
                        const SizedBox(width: 12),
                      ],
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
                _SectionLabel(loc.sleepTimerAfterDuration),
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
                const SizedBox(height: 16),
                _SectionLabel(loc.sleepTimerAfterItems),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final count in sleepTimerPresetsItems)
                      ActionChip(
                        label: Text(loc.sleepTimerItems(count)),
                        onPressed: () => _startItems(context, count),
                      ),
                    ActionChip(
                      label: Text(loc.sleepTimerCustom),
                      onPressed: () => _startCustomItems(context),
                    ),
                  ],
                ),
              ],
            ),
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

  void _startItems(BuildContext context, int count) {
    SleepTimerService.instance.startItems(count);
    Navigator.of(context).pop();
  }

  Future<void> _startCustomItems(BuildContext context) async {
    final count = await showSleepTimerItemsDialog(context);
    if (count != null && count > 0 && context.mounted) {
      _startItems(context, count);
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

/// Small heading separating the duration and item presets.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: Theme.of(context).textTheme.labelMedium),
      );
}

/// Dialog asking for a duration in minutes; returns null when dismissed.
/// Shared between the player sheet and the sleep timer settings page.
Future<int?> showSleepTimerMinutesDialog(BuildContext context) {
  final loc = AppLocalizations.of(context)!;
  return _showCountDialog(
      context, loc.sleepTimerCustomDuration, loc.sleepTimerMinutesLabel);
}

/// Dialog asking how many media items should still play; null when dismissed.
Future<int?> showSleepTimerItemsDialog(BuildContext context) {
  final loc = AppLocalizations.of(context)!;
  return _showCountDialog(
      context, loc.sleepTimerCustomDuration, loc.sleepTimerItemsCount);
}

Future<int?> _showCountDialog(
    BuildContext context, String title, String label) {
  final controller = TextEditingController();
  return showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(labelText: label),
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
