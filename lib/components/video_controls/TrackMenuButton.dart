import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/MediaVersions.dart';
import '../AppModalSheet.dart';
import '../VideoVersionPicker.dart';
import 'TrackSelectionController.dart';
import 'VideoControlButtons.dart';

/// In-overlay version/audio/subtitle selection: one button opening a bottom
/// sheet with a section per choice (only the ones with a real choice).
/// Replaces the old `TrackSelectionWidget` that sat below the video and was
/// unreachable in fullscreen — on TV the only playback surface. A sheet
/// rather than a cascading menu: the submenus were fiddly on touch and ran
/// off a phone's screen with long track titles.
class TrackMenuButton extends StatelessWidget {
  const TrackMenuButton({
    super.key,
    required this.controller,
    this.onMenuOpenChanged,
  });

  static const Key buttonKey = Key('track-menu-button');
  static const Key versionMenuKey = Key('track-menu-version');
  static Key versionItemKey(String mediaFileId) =>
      Key('track-menu-version-$mediaFileId');
  static Key audioItemKey(String trackId) => Key('track-menu-audio-$trackId');
  static Key subtitleItemKey(String trackId) =>
      Key('track-menu-subtitle-$trackId');

  final TrackSelectionController controller;

  /// Lets the controls shell suspend auto-hide while the sheet is open.
  final ValueChanged<bool>? onMenuOpenChanged;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (!controller.hasAnyMenu) return const SizedBox.shrink();
        return IconButton(
          key: buttonKey,
          color: Colors.white,
          style: videoControlButtonStyle(context),
          tooltip: loc.audioAndSubtitles,
          icon: const Icon(Icons.subtitles),
          onPressed: () => _open(context),
        );
      },
    );
  }

  Future<void> _open(BuildContext context) async {
    onMenuOpenChanged?.call(true);
    // A version switch may still have to ask something (another cut), which
    // needs a context that outlives the sheet — so the sheet only reports it.
    final versionId = await showAppSheet<String>(
      context,
      builder: (context) => _TrackSheet(controller: controller),
    );
    onMenuOpenChanged?.call(false);
    if (versionId != null && context.mounted) {
      await switchVideoVersion(context, versionId);
    }
  }
}

class _TrackSheet extends StatelessWidget {
  const _TrackSheet({required this.controller});

  final TrackSelectionController controller;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // Live: HLS can deliver the real track list after the sheet opened.
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final tracks = controller;
        final audioLabels =
            TrackSelectionController.audioLabels(tracks.audioTracks, loc);
        final versionLabels = MediaVersions.labelsFor(tracks.versions);
        final subtitleOptions = tracks.subtitleOptions;
        final subtitleLabels = TrackSelectionController.subtitleMenuLabels(
            subtitleOptions, tracks.bitmapSubtitleTracks, loc);
        void close() => Navigator.of(context).pop();
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              if (tracks.hasVersions) ...[
                _header(context, Icons.high_quality, loc.videoVersionLabel,
                    key: TrackMenuButton.versionMenuKey),
                for (final (i, file) in tracks.versions.indexed)
                  _item(
                    key: TrackMenuButton.versionItemKey(file.id),
                    label: versionLabels[i],
                    selected: file.id == tracks.currentVersionId,
                    onTap: () => Navigator.of(context).pop(file.id),
                  ),
              ],
              if (tracks.hasMultipleAudio) ...[
                _header(context, Icons.volume_up, loc.audioTrackLabel),
                for (final (i, t) in tracks.audioTracks.indexed)
                  _item(
                    key: TrackMenuButton.audioItemKey(t.id),
                    label: audioLabels[i],
                    selected: t == tracks.currentAudio,
                    onTap: () {
                      tracks.selectAudio(t);
                      close();
                    },
                  ),
              ],
              if (tracks.fileHasUnsupportedSubtitles)
                // The file has subtitle streams the stream can't offer
                // (image-based); explain instead of showing a lone "None".
                ListTile(
                  enabled: false,
                  leading: const Icon(Icons.subtitles_off),
                  title: Text(loc.subtitlesUnsupportedImageBased),
                )
              else if (tracks.hasSubtitles ||
                  tracks.bitmapSubtitleTracks.isNotEmpty) ...[
                _header(context, Icons.subtitles, loc.subtitlesTrackLabel),
                for (final (i, t) in subtitleOptions.indexed)
                  _item(
                    key: TrackMenuButton.subtitleItemKey(t.id),
                    label: subtitleLabels[i],
                    selected: t == tracks.currentSubtitle,
                    onTap: () {
                      tracks.selectSubtitle(t);
                      close();
                    },
                  ),
                // Picture-based tracks (Blu-ray/DVD), drawn by the app.
                for (final (i, t) in tracks.bitmapSubtitleTracks.indexed)
                  _item(
                    label: subtitleLabels[subtitleOptions.length + i],
                    selected: t == tracks.currentBitmapSubtitle,
                    onTap: () {
                      tracks.selectBitmapSubtitle(t);
                      close();
                    },
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context, IconData icon, String label,
      {Key? key}) {
    final theme = Theme.of(context);
    return Padding(
      key: key,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(label, style: theme.textTheme.titleSmall),
        ],
      ),
    );
  }

  Widget _item({
    Key? key,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      key: key,
      dense: true,
      leading: Icon(selected ? Icons.check : null),
      title: Text(label),
      selected: selected,
      onTap: onTap,
    );
  }
}
