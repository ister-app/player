import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
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
        return MenuAnchor(
          controller: _menuController,
          onOpen: () => widget.onMenuOpenChanged?.call(true),
          onClose: () => widget.onMenuOpenChanged?.call(false),
          consumeOutsideTap: true,
          menuChildren: [
            if (tracks.hasMultipleAudio)
              SubmenuButton(
                leadingIcon: const Icon(Icons.volume_up, size: 18),
                menuChildren: [
                  for (final t in tracks.audioTracks)
                    _item(
                      label: TrackSelectionController.audioLabel(t, loc),
                      selected: t == tracks.currentAudio,
                      onPressed: () => tracks.selectAudio(t),
                    ),
                ],
                child: Text(loc.audioTrackLabel),
              ),
            if (tracks.hasSubtitles)
              SubmenuButton(
                leadingIcon: const Icon(Icons.subtitles, size: 18),
                menuChildren: [
                  for (final t in tracks.subtitleOptions)
                    _item(
                      label: TrackSelectionController.subtitleLabel(t, loc),
                      selected: t == tracks.currentSubtitle,
                      onPressed: () => tracks.selectSubtitle(t),
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

  Widget _item({
    required String label,
    required bool selected,
    required VoidCallback onPressed,
  }) {
    return MenuItemButton(
      leadingIcon: selected
          ? const Icon(Icons.check, size: 18)
          : const SizedBox(width: 18),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
