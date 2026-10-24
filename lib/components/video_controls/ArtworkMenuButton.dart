import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:material_ui/material_ui.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/selectVideoFrame.graphql.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/AppMessenger.dart';
import '../../utils/ClientManager.dart';
import '../../utils/LoggerService.dart';
import '../../utils/MediaPlayerHandler.dart';
import '../../utils/PermissionsService.dart';
import '../../utils/artwork/ArtworkTarget.dart';
import '../AppModalSheet.dart';
import 'VideoControlButtons.dart';

/// Admin-only: "use the picture on screen as this item's background/cover".
/// Reads the player's position at the tap — the file's own timeline, which is
/// what the server's `selectVideoFrame` wants (a multi-episode file included:
/// mpv plays the whole file, the controls only *display* the episode offset)
/// — and lets the server grab the frame with ffmpeg, so the stored image is
/// full resolution without subtitles or controls, on web too.
///
/// Hidden unless the login is known to be an admin ([PermissionsService]'s
/// cached answer, loaded by the pages that led here).
class ArtworkMenuButton extends StatelessWidget {
  const ArtworkMenuButton({super.key, this.onMenuOpenChanged, this.mutate});

  static const Key buttonKey = Key('artwork-menu-button');
  static const Key backgroundItemKey = Key('artwork-menu-background');
  static const Key coverItemKey = Key('artwork-menu-cover');

  /// Lets the controls shell suspend auto-hide while the sheet is open.
  final ValueChanged<bool>? onMenuOpenChanged;

  /// Test seam: the mutation call.
  final Future<QueryResult> Function(
    String serverName,
    MutationOptions options,
  )?
  mutate;

  @override
  Widget build(BuildContext context) {
    final handler = MediaPlayerHandler.instance;
    final server = handler.serverName;
    final item = _targetOf(handler);
    if (item == null ||
        PermissionsService().cachedStatusFor(server) != AdminStatus.admin) {
      return const SizedBox.shrink();
    }
    final loc = AppLocalizations.of(context)!;
    return IconButton(
      key: buttonKey,
      color: Colors.white,
      style: videoControlButtonStyle(context),
      tooltip: loc.artworkMenuTooltip,
      icon: const Icon(Icons.wallpaper_outlined),
      onPressed: () => _open(context),
    );
  }

  static ArtworkTarget? _targetOf(MediaPlayerHandler handler) {
    final movie = handler.movie;
    if (movie != null) return ArtworkTarget(ArtworkTargetKind.movie, movie.id);
    final episode = handler.episode;
    if (episode != null) {
      return ArtworkTarget(ArtworkTargetKind.episode, episode.id);
    }
    return null;
  }

  Future<void> _open(BuildContext context) async {
    onMenuOpenChanged?.call(true);
    final type = await showAppSheet<Enum$ImageType>(
      context,
      builder: (context) {
        final loc = AppLocalizations.of(context)!;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                key: backgroundItemKey,
                leading: const Icon(Icons.panorama),
                title: Text(loc.artworkSetFrameAsBackground),
                onTap: () =>
                    Navigator.of(context).pop(Enum$ImageType.BACKGROUND),
              ),
              ListTile(
                key: coverItemKey,
                leading: const Icon(Icons.portrait),
                title: Text(loc.artworkSetFrameAsCover),
                onTap: () => Navigator.of(context).pop(Enum$ImageType.COVER),
              ),
            ],
          ),
        );
      },
    );
    onMenuOpenChanged?.call(false);
    if (type == null || !context.mounted) return;
    await takeCurrentFrame(context, type, mutate: mutate);
  }

  /// Sends the frame at the player's current position to the server. Static so
  /// a TV key handler or a test can call it without the sheet.
  static Future<bool> takeCurrentFrame(
    BuildContext context,
    Enum$ImageType type, {
    Future<QueryResult> Function(String serverName, MutationOptions options)?
    mutate,
  }) async {
    final loc = AppLocalizations.of(context)!;
    final handler = MediaPlayerHandler.instance;
    final server = handler.serverName;
    final target = _targetOf(handler);
    final mediaFileId =
        handler.currentMediaFileId.value ?? handler.currentMediaFile?.id;
    if (server == null || target == null || mediaFileId == null) return false;
    final positionMs = handler.player.state.position.inMilliseconds;
    final options = MutationOptions(
      document: documentNodeMutationselectVideoFrame,
      variables: Variables$Mutation$selectVideoFrame(
        target: target.toInput(),
        type: type,
        mediaFileId: mediaFileId,
        positionMs: positionMs,
      ).toJson(),
    );
    final result = await (mutate != null
        ? mutate(server, options)
        : ClientManager.getClientForUrl(server).value.mutate(options));
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      final message =
          result.exception?.graphqlErrors.firstOrNull?.message ??
          result.exception.toString();
      showAppSnackBar(loc.artworkFailed(message));
      return false;
    }
    showAppSnackBar(loc.artworkChanged);
    return true;
  }
}
