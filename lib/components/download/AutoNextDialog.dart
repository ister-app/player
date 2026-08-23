import 'package:flutter/material.dart';
import 'package:player/components/TvFocusable.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/download/AutoNextPreferences.dart';
import 'package:player/utils/download/AutoNextService.dart';

/// The counts a show can be followed with; 0 turns the follow off.
const autoNextCounts = [0, 1, 2, 3, 5];

/// Asks how many unwatched episodes to keep downloaded. Returns the chosen
/// count (0 = off), or null when dismissed.
Future<int?> showAutoNextDialog(BuildContext context, {required int current}) {
  final loc = AppLocalizations.of(context)!;
  return showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(loc.autoNextTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.autoNextDescription),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              for (final n in autoNextCounts)
                TvFocusable(
                  onTap: () => Navigator.of(context).pop(n),
                  child: ChoiceChip(
                    label: Text(n == 0 ? loc.autoNextOff : '$n'),
                    selected: n == current,
                    onSelected: (_) => Navigator.of(context).pop(n),
                  ),
                ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(loc.cancel),
        ),
      ],
    ),
  );
}

/// The whole flow behind the "keep the next episodes downloaded" menu entry,
/// shared by the show page and the downloads page: read the current follow,
/// ask, apply it and report what happened. The first run is awaited so the
/// snackbar can say how many episodes it queued.
Future<void> configureAutoNext(
  BuildContext context, {
  required String serverName,
  required String showId,
  required String title,
}) async {
  final loc = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  final service = AutoNextService.instance;
  final AutoNextFollow? current = await service.followFor(serverName, showId);
  if (!context.mounted) return;
  final count = await showAutoNextDialog(context, current: current?.count ?? 0);
  if (count == null) return;
  if (count == 0) {
    await service.unfollow(serverName, showId);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(loc.autoNextDisabled)));
    return;
  }
  final result =
      await service.follow(serverName, showId, title: title, count: count);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
        content: Text(result.failed
            ? loc.autoNextFailed
            : loc.autoNextEnabled(count))));
}
