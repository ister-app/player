import 'package:flutter/material.dart';
import 'package:player/graphql/fragmentPlaylist.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';
import '../utils/PlaylistService.dart';
import '../utils/filter/FilterCatalog.dart';
import 'filter/FilterSheet.dart';

/// Bottom sheet that creates a playlist in [libraryId]: a name plus — at
/// creation only — the choice between a manual and a smart playlist. Smart is
/// only offered when the library type has a playable filter kind; choosing it
/// opens the filter builder, and the playlist is created with the applied
/// filter. Calls [onCreated] with the new playlist.
Future<void> showPlaylistCreateSheet(
  BuildContext context, {
  required String serverName,
  required String libraryId,
  required Enum$LibraryType libraryType,
  required void Function(Fragment$fragmentPlaylist playlist) onCreated,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => _PlaylistCreateSheet(
      serverName: serverName,
      libraryId: libraryId,
      libraryType: libraryType,
      onCreated: onCreated,
    ),
  );
}

class _PlaylistCreateSheet extends StatefulWidget {
  const _PlaylistCreateSheet({
    required this.serverName,
    required this.libraryId,
    required this.libraryType,
    required this.onCreated,
  });

  final String serverName;
  final String libraryId;
  final Enum$LibraryType libraryType;
  final void Function(Fragment$fragmentPlaylist playlist) onCreated;

  @override
  State<_PlaylistCreateSheet> createState() => _PlaylistCreateSheetState();
}

class _PlaylistCreateSheetState extends State<_PlaylistCreateSheet> {
  final _name = TextEditingController();
  bool _smart = false;
  bool _busy = false;

  /// The playable filter kind of this library type, or null when smart
  /// playlists are not possible (books, podcasts).
  Enum$FilterKind? get _smartKind {
    final kind = FilterCatalog.kindFor(widget.libraryType, null);
    return kind != null && FilterCatalog.isPlayable(kind) ? kind : null;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final loc = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final name = _name.text.trim();
    if (name.isEmpty) return;
    final client = ClientManager.getClientForUrl(widget.serverName).value;

    if (_smart && _smartKind != null) {
      final kind = _smartKind!;
      navigator.pop();
      // The filter builder produces the smart playlist's definition; an empty
      // or cleared filter cancels the creation.
      await showFilterSheet(
        context,
        kind: kind,
        libraryId: widget.libraryId,
        onApply: (filter) async {
          if (filter == null || filter.isEmpty) return;
          final playlist = await PlaylistService.create(
            client,
            name: name,
            libraryId: widget.libraryId,
            type: Enum$PlaylistType.SMART,
            filter: filter,
            filterKind: kind,
          );
          if (playlist == null) {
            messenger.showSnackBar(
                SnackBar(content: Text(loc.addToPlaylistFailed)));
            return;
          }
          widget.onCreated(playlist);
        },
      );
      return;
    }

    setState(() => _busy = true);
    final playlist = await PlaylistService.create(
      client,
      name: name,
      libraryId: widget.libraryId,
      type: Enum$PlaylistType.MANUAL,
    );
    if (!mounted) return;
    navigator.pop();
    if (playlist == null) {
      messenger
          .showSnackBar(SnackBar(content: Text(loc.addToPlaylistFailed)));
      return;
    }
    widget.onCreated(playlist);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.newPlaylist,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _name,
              autofocus: true,
              decoration: InputDecoration(labelText: loc.playlistName),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
            ),
            if (_smartKind != null) ...[
              const SizedBox(height: 8),
              RadioListTile<bool>(
                value: false,
                groupValue: _smart,
                onChanged: (value) => setState(() => _smart = value!),
                title: Text(loc.manualPlaylist),
                subtitle: Text(loc.manualPlaylistDescription),
              ),
              RadioListTile<bool>(
                value: true,
                groupValue: _smart,
                onChanged: (value) => setState(() => _smart = value!),
                title: Text(loc.smartPlaylist),
                subtitle: Text(loc.smartPlaylistDescription),
              ),
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: _busy ? null : _submit,
                child: Text(MaterialLocalizations.of(context).okButtonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Asks for a playlist name. [title] names the action it belongs to (creating
/// one, saving a filter as one); returns null when cancelled or left empty.
Future<String?> showPlaylistNameDialog(BuildContext context, String title) async {
  final name = await showDialog<String>(
    context: context,
    builder: (context) => _PlaylistNameDialog(title: title),
  );
  final trimmed = name?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

/// A widget of its own so the controller outlives the dialog's exit animation.
class _PlaylistNameDialog extends StatefulWidget {
  const _PlaylistNameDialog({required this.title});

  final String title;

  @override
  State<_PlaylistNameDialog> createState() => _PlaylistNameDialogState();
}

class _PlaylistNameDialogState extends State<_PlaylistNameDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(labelText: loc.playlistName),
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }
}
