import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/MediaVersions.dart';
import '../VideoVersionPicker.dart';
import 'TrackSelectionController.dart';
import 'VideoControlButtons.dart';

/// In-overlay audio/subtitle selection: one button opening a menu with an
/// audio submenu (only when there is a real choice) and a subtitles submenu.
/// Replaces the old `TrackSelectionWidget` that sat below the video and was
/// unreachable in fullscreen — on TV the only playback surface.
class TrackMenuButton extends StatefulWidget {
  const TrackMenuButton({
    super.key,
    required this.controller,
    this.onMenuOpenChanged,
  });

  static const Key versionMenuKey = Key('track-menu-version');
  static Key versionItemKey(String mediaFileId) =>
      Key('track-menu-version-$mediaFileId');

  final TrackSelectionController controller;

  /// Lets the controls shell suspend auto-hide while the menu is open.
  final ValueChanged<bool>? onMenuOpenChanged;

  @override
  State<TrackMenuButton> createState() => _TrackMenuButtonState();
}

class _TrackMenuButtonState extends State<TrackMenuButton> {
  final MenuController _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final tracks = widget.controller;
        if (!tracks.hasAnyMenu) return const SizedBox.shrink();
        final audioLabels =
            TrackSelectionController.audioLabels(tracks.audioTracks, loc);
        final versionLabels = MediaVersions.labelsFor(tracks.versions);
        final subtitleOptions = tracks.subtitleOptions;
        final subtitleLabels = TrackSelectionController.subtitleMenuLabels(
            subtitleOptions, tracks.bitmapSubtitleTracks, loc);
        return MenuAnchor(
          controller: _menuController,
          onOpen: () => widget.onMenuOpenChanged?.call(true),
          onClose: () => widget.onMenuOpenChanged?.call(false),
          consumeOutsideTap: true,
          menuChildren: [
            if (tracks.hasVersions)
              SubmenuButton(
                key: TrackMenuButton.versionMenuKey,
                leadingIcon: const Icon(Icons.high_quality, size: 18),
                menuChildren: [
                  for (final (i, file) in tracks.versions.indexed)
                    _item(
                      key: TrackMenuButton.versionItemKey(file.id),
                      label: versionLabels[i],
                      selected: file.id == tracks.currentVersionId,
                      onPressed: () => _selectVersion(file.id),
                    ),
                ],
                child: Text(loc.videoVersionLabel),
              ),
            if (tracks.hasMultipleAudio)
              SubmenuButton(
                leadingIcon: const Icon(Icons.volume_up, size: 18),
                menuChildren: [
                  for (final (i, t) in tracks.audioTracks.indexed)
                    _item(
                      label: audioLabels[i],
                      selected: t == tracks.currentAudio,
                      onPressed: () => tracks.selectAudio(t),
                    ),
                ],
                child: Text(loc.audioTrackLabel),
              ),
            if (tracks.fileHasUnsupportedSubtitles)
              // The file has subtitle streams the stream can't offer
              // (image-based); explain instead of showing a lone "None".
              MenuItemButton(
                leadingIcon: const Icon(Icons.subtitles_off, size: 18),
                onPressed: null,
                child: Text(loc.subtitlesUnsupportedImageBased),
              )
            else if (tracks.hasSubtitles || tracks.bitmapSubtitleTracks.isNotEmpty)
              SubmenuButton(
                leadingIcon: const Icon(Icons.subtitles, size: 18),
                menuChildren: [
                  for (final (i, t) in subtitleOptions.indexed)
                    _item(
                      label: subtitleLabels[i],
                      selected: t == tracks.currentSubtitle,
                      onPressed: () => tracks.selectSubtitle(t),
                    ),
                  // Picture-based tracks (Blu-ray/DVD), drawn by the app.
                  for (final (i, t) in tracks.bitmapSubtitleTracks.indexed)
                    _item(
                      label: subtitleLabels[subtitleOptions.length + i],
                      selected: t == tracks.currentBitmapSubtitle,
                      onPressed: () => tracks.selectBitmapSubtitle(t),
                    ),
                ],
                child: Text(loc.subtitlesTrackLabel),
              ),
          ],
          builder: (context, controller, child) => IconButton(
            color: Colors.white,
            style: videoControlButtonStyle(context),
            tooltip: loc.audioAndSubtitles,
            icon: const Icon(Icons.subtitles),
            onPressed: () =>
                controller.isOpen ? controller.close() : controller.open(),
          ),
        );
      },
    );
  }

  Future<void> _selectVersion(String mediaFileId) =>
      switchVideoVersion(context, mediaFileId);

  Widget _item({
    Key? key,
    required String label,
    required bool selected,
    required VoidCallback onPressed,
  }) {
    return MenuItemButton(
      key: key,
      leadingIcon: selected
          ? const Icon(Icons.check, size: 18)
          : const SizedBox(width: 18),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
