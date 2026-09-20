import 'package:flutter/material.dart';

import '../graphql/fragmentMediafiles.graphql.dart';
import '../l10n/app_localizations.dart';
import '../utils/MediaPlayerHandler.dart';
import '../utils/MediaVersions.dart';
import 'AppModalSheet.dart';
import 'TvFocusable.dart';

/// Asks where to continue in a version that is another cut: the same
/// position is then not the same scene. True = from the start, false = at
/// the same time, null = dismissed (stay on what plays).
Future<bool?> askOtherCutStart(BuildContext context) {
  final loc = AppLocalizations.of(context)!;
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(loc.videoVersionOtherCutTitle),
      content: Text(loc.videoVersionOtherCutBody),
      actions: [
        TextButton(
          key: VideoVersionChip.sameTimeKey,
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(loc.videoVersionSameTime),
        ),
        FilledButton(
          key: VideoVersionChip.fromStartKey,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(loc.videoVersionFromStart),
        ),
      ],
    ),
  );
}

/// Switches the playing video to [mediaFileId], asking first when it is
/// another cut. Shared by the in-video track menu and the page's chip.
Future<void> switchVideoVersion(BuildContext context, String mediaFileId) async {
  final handler = MediaPlayerHandler.instance;
  if (mediaFileId == handler.currentMediaFileId.value) return;
  var fromStart = false;
  if (!handler.sharesTimelineWithCurrent(mediaFileId)) {
    final answer = await askOtherCutStart(context);
    if (answer == null) return;
    fromStart = answer;
  }
  await handler.switchMediaFile(mediaFileId, fromStart: fromStart);
}

/// The version of a movie/episode page with several media files (a 4K and a
/// 1080p file, another cut): shows what is selected and opens the picker.
/// Renders nothing for an item with a single file.
///
/// [selectedId] null means "automatic" — the app's default rule picks when
/// playback starts ([MediaVersions.pickDefault]).
class VideoVersionChip extends StatelessWidget {
  const VideoVersionChip({
    super.key,
    required this.files,
    required this.selectedId,
    required this.onSelected,
    this.allowAutomatic = true,
  });

  static const Key chipKey = Key('video-version-chip');
  static const Key automaticKey = Key('video-version-automatic');
  static const Key sameTimeKey = Key('version-same-time');
  static const Key fromStartKey = Key('version-from-start');
  static Key optionKey(String mediaFileId) =>
      Key('video-version-option-$mediaFileId');

  final List<Fragment$fragmentMediaFiles>? files;
  final String? selectedId;

  /// Called with the picked media file id, or null for "automatic".
  final ValueChanged<String?> onSelected;

  /// False while the item plays: a stream is always *some* version.
  final bool allowAutomatic;

  @override
  Widget build(BuildContext context) {
    final files = this.files;
    if (files == null || files.length < 2) return const SizedBox.shrink();
    final loc = AppLocalizations.of(context)!;
    final labels = MediaVersions.labelsFor(files);
    final selectedIndex = files.indexWhere((f) => f.id == selectedId);
    final label =
        selectedIndex == -1 ? loc.videoVersionAuto : labels[selectedIndex];
    void open() => _pick(context, files, labels);
    return TvFocusable(
      onTap: open,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: ActionChip(
        key: chipKey,
        avatar: const Icon(Icons.high_quality, size: 18),
        label: Text(loc.videoVersionChip(label)),
        onPressed: open,
      ),
    );
  }

  Future<void> _pick(BuildContext context,
      List<Fragment$fragmentMediaFiles> files, List<String> labels) async {
    final loc = AppLocalizations.of(context)!;
    // Wrapped so "automatic" (null) is told apart from a dismissed sheet.
    final picked = await showAppSheet<({String? id})>(
      context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text(loc.videoVersionPickTitle,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            if (allowAutomatic)
              ListTile(
                key: automaticKey,
                leading: Icon(selectedId == null ? Icons.check : null),
                title: Text(loc.videoVersionAuto),
                onTap: () => Navigator.of(context).pop((id: null)),
              ),
            for (final (i, file) in files.indexed)
              ListTile(
                key: optionKey(file.id),
                leading: Icon(file.id == selectedId ? Icons.check : null),
                title: Text(labels[i]),
                subtitle: Text(file.path.split('/').last,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () => Navigator.of(context).pop((id: file.id)),
              ),
          ],
        ),
      ),
    );
    if (picked != null) onSelected(picked.id);
  }
}

/// [VideoVersionChip] as a movie/episode page shows it, under the video
/// surface. Before playback it holds the page's own pick ([pickedId], handed
/// to the start); once this item plays it mirrors — and switches — the file
/// that is open in the player.
class VideoVersionRow extends StatelessWidget {
  const VideoVersionRow({
    super.key,
    required this.files,
    required this.playing,
    required this.pickedId,
    required this.onPicked,
  });

  final List<Fragment$fragmentMediaFiles>? files;

  /// Whether this page's item is the one loaded in the player.
  final bool playing;
  final String? pickedId;
  final ValueChanged<String?> onPicked;

  @override
  Widget build(BuildContext context) {
    if ((files?.length ?? 0) < 2) return const SizedBox.shrink();
    final handler = MediaPlayerHandler.instance;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: ValueListenableBuilder<String?>(
          valueListenable: handler.currentMediaFileId,
          builder: (context, playingId, _) => VideoVersionChip(
            files: files,
            selectedId: playing ? playingId : pickedId,
            // Watching along plays the leader's file.
            allowAutomatic: !playing,
            onSelected: (id) {
              if (!playing) return onPicked(id);
              if (id != null && !handler.followMode) {
                switchVideoVersion(context, id);
              }
            },
          ),
        ),
      ),
    );
  }
}
