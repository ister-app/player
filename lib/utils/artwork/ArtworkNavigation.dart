import 'package:auto_route/auto_route.dart';
import 'package:material_ui/material_ui.dart';
import 'package:player/routes/AppRouter.gr.dart';

import '../../l10n/app_localizations.dart';
import 'ArtworkTarget.dart';

/// Opens the admin artwork picker for [target]; resolves when it is popped,
/// so the caller can refetch its page (the normalized cache does not see a
/// changed `selected` flag as a changed parent list).
///
/// [frameMediaFileId]/[frameDurationMs]/[frameStartMs] enable the "frame from
/// video" action for movies and episodes.
Future<void> openArtworkPicker(
  BuildContext context, {
  required ArtworkTarget target,
  String? title,
  String? frameMediaFileId,
  int? frameDurationMs,
  int? frameStartMs,
}) {
  return AutoRouter.of(context).push(
    ArtworkPickerRoute(
      kind: target.kind.name,
      id: target.id,
      title: title,
      frameMediaFileId: frameMediaFileId,
      frameDurationMs: frameDurationMs,
      frameStartMs: frameStartMs,
    ),
  );
}

/// The overflow-menu entry every detail page shows admins.
class ChangeArtworkMenuItem extends StatelessWidget {
  const ChangeArtworkMenuItem({
    super.key,
    required this.target,
    this.title,
    this.frameMediaFileId,
    this.frameDurationMs,
    this.frameStartMs,
    this.onClosed,
  });

  static const Key itemKey = Key('menu-change-artwork');

  final ArtworkTarget target;
  final String? title;
  final String? frameMediaFileId;
  final int? frameDurationMs;
  final int? frameStartMs;

  /// Called when the picker is popped (refetch the page).
  final VoidCallback? onClosed;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return MenuItemButton(
      key: itemKey,
      onPressed: () => openArtworkPicker(
        context,
        target: target,
        title: title,
        frameMediaFileId: frameMediaFileId,
        frameDurationMs: frameDurationMs,
        frameStartMs: frameStartMs,
      ).then((_) => onClosed?.call()),
      child: ListTile(
        leading: const Icon(Icons.wallpaper_outlined),
        title: Text(loc.changeArtwork),
      ),
    );
  }
}
