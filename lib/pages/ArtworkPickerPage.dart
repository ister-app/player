import 'package:auto_route/auto_route.dart';
import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:material_ui/material_ui.dart';
import 'package:player/components/ArtworkImage.dart';
import 'package:player/components/ConfirmDialog.dart';
import 'package:player/components/SettingsSection.dart';
import 'package:player/components/SourceAttribution.dart';
import 'package:player/components/TvFocusable.dart';
import 'package:player/graphql/clearSelectedImage.graphql.dart';
import 'package:player/graphql/deleteImage.graphql.dart';
import 'package:player/graphql/fragmentImages.graphql.dart';
import 'package:player/graphql/imageCandidates.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/selectImage.graphql.dart';
import 'package:player/graphql/selectRemoteImage.graphql.dart';
import 'package:player/graphql/selectVideoFrame.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:player/utils/artwork/ArtworkAdminApi.dart';
import 'package:player/utils/artwork/ArtworkTarget.dart';

/// Admin screen: what an item's cover or background could be, and the pick.
/// Three sources side by side — what the server already has (local files, the
/// scan's download, the generated video frame, earlier uploads), what TMDB
/// offers for the item, and new material (an upload, a frame at a position of
/// the item's video). The choice is the server's `Image.selected` flag, which
/// every image consumer honours first (`ImageUtil.getImageByType`) and a
/// metadata refresh keeps.
///
/// The frame slider needs the item's media file, which the detail pages know
/// and pass along ([frameMediaFileId], [frameDurationMs], [frameStartMs] for a
/// file holding several episodes); without one the frame action is hidden.
/// The "take this frame while watching" flow lives in the video controls.
@RoutePage()
class ArtworkPickerPage extends StatefulWidget {
  const ArtworkPickerPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('kind') required this.kind,
    @PathParam('id') required this.id,
    @QueryParam('title') this.title,
    @QueryParam('type') this.initialType,
    @QueryParam('frameMediaFileId') this.frameMediaFileId,
    @QueryParam('frameDurationMs') this.frameDurationMs,
    @QueryParam('frameStartMs') this.frameStartMs,
    this.api,
    this.pickImage,
  });

  final String serverName;
  final String kind;
  final String id;
  final String? title;

  /// `cover` or `background`; cover when absent.
  final String? initialType;
  final String? frameMediaFileId;
  final int? frameDurationMs;
  final int? frameStartMs;

  /// Test seams.
  final ArtworkAdminApi? api;
  final Future<PickedArtwork?> Function()? pickImage;

  static Key typeKey(ImageTypes type) => ValueKey('artwork-type-${type.name}');
  static Key tileKey(String imageId) => ValueKey('artwork-tile-$imageId');
  static Key remoteKey(String sourceUri) =>
      ValueKey('artwork-remote-$sourceUri');
  static Key deleteKey(String imageId) => ValueKey('artwork-delete-$imageId');
  static const Key uploadKey = ValueKey('artwork-upload');
  static const Key frameKey = ValueKey('artwork-frame');
  static const Key frameUseKey = ValueKey('artwork-frame-use');
  static const Key frameSliderKey = ValueKey('artwork-frame-slider');
  static const Key resetKey = ValueKey('artwork-reset');

  @override
  State<ArtworkPickerPage> createState() => _ArtworkPickerPageState();
}

class _ArtworkPickerPageState extends State<ArtworkPickerPage> {
  late ImageTypes _type = widget.initialType == ImageTypes.background.name
      ? ImageTypes.background
      : ImageTypes.cover;
  late final ArtworkTarget? _target = ArtworkTarget.parse(
    widget.kind,
    widget.id,
  );

  /// Candidates with a mutation in flight (image id or remote sourceUri).
  final Set<String> _busy = {};
  bool _uploading = false;
  VoidCallback? _refetch;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final target = _target;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title?.isNotEmpty == true ? widget.title! : loc.changeArtwork,
        ),
      ),
      body: target == null
          ? Center(child: Text(loc.couldNotLoad))
          : GraphQLProvider(
              client: ClientManager.getClientForUrl(widget.serverName),
              child: Query(
                options: QueryOptions(
                  document: documentNodeQueryimageCandidates,
                  // Never cached: the TMDB list and the selected flags must be
                  // the server's truth, and every mutation here refetches.
                  fetchPolicy: FetchPolicy.networkOnly,
                  variables: Variables$Query$imageCandidates(
                    target: target.toInput(),
                    type: imageTypeOf(_type),
                  ).toJson(),
                ),
                builder:
                    (
                      QueryResult result, {
                      VoidCallback? refetch,
                      FetchMore? fetchMore,
                    }) {
                      _refetch = refetch;
                      if (result.hasException) {
                        final text = result.exception.toString();
                        final tooOld =
                            text.contains('imageCandidates') ||
                            text.contains('ImageTargetInput');
                        return SettingsErrorState(
                          message: tooOld
                              ? loc.artworkServerTooOld
                              : loc.couldNotLoad,
                          detailsLabel: loc.errorDetails,
                          details: text,
                        );
                      }
                      final data = result.data == null
                          ? null
                          : Query$imageCandidates.fromJson(result.data!);
                      final candidates = data?.imageCandidates;
                      return _body(
                        context,
                        loc,
                        target,
                        candidates,
                        loading: result.isLoading && candidates == null,
                      );
                    },
              ),
            ),
    );
  }

  Widget _body(
    BuildContext context,
    AppLocalizations loc,
    ArtworkTarget target,
    Query$imageCandidates$imageCandidates? candidates, {
    required bool loading,
  }) {
    final current = candidates?.current ?? const <Fragment$fragmentImages>[];
    final remote =
        candidates?.remote ??
        const <Query$imageCandidates$imageCandidates$remote>[];
    final shown = ImageUtil.getImageByType(current, _type);
    final chosen = current.where((i) => i.selected).firstOrNull;
    final token = StreamTokenService.getToken(widget.serverName);
    final currentUris = current
        .map((i) => i.sourceUri)
        .whereType<String>()
        .toSet();
    final canFrame =
        target.hasVideo &&
        widget.frameMediaFileId != null &&
        (widget.frameDurationMs ?? 0) > 0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        Center(
          child: SegmentedButton<ImageTypes>(
            segments: [
              ButtonSegment(
                value: ImageTypes.cover,
                icon: const Icon(Icons.portrait),
                label: Text(
                  loc.artworkCover,
                  key: ArtworkPickerPage.typeKey(ImageTypes.cover),
                ),
              ),
              ButtonSegment(
                value: ImageTypes.background,
                icon: const Icon(Icons.panorama),
                label: Text(
                  loc.artworkBackground,
                  key: ArtworkPickerPage.typeKey(ImageTypes.background),
                ),
              ),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
        ),
        const SizedBox(height: 20),
        _sectionTitle(context, loc.artworkCurrent),
        const SizedBox(height: 8),
        _currentPreview(context, loc, shown, token, chosen != null, target),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            FilledButton.tonalIcon(
              key: ArtworkPickerPage.uploadKey,
              onPressed: _uploading ? null : () => _upload(context, target),
              icon: _uploading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_file),
              label: Text(loc.artworkUpload),
            ),
            if (canFrame)
              FilledButton.tonalIcon(
                key: ArtworkPickerPage.frameKey,
                onPressed: () => _pickFrame(context, target),
                icon: const Icon(Icons.movie_filter_outlined),
                label: Text(loc.artworkFromVideo),
              ),
          ],
        ),
        const SizedBox(height: 24),
        _sectionTitle(context, loc.artworkOnServer),
        const SizedBox(height: 8),
        if (loading)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (current.isEmpty)
          Text(loc.artworkEmpty, style: Theme.of(context).textTheme.bodyMedium)
        else
          _grid(context, [
            for (final image in current)
              _Tile(
                key: ArtworkPickerPage.tileKey(image.id),
                aspect: _aspect,
                url: ImageUtil.buildUrl(image, token: token),
                label: _sourceLabel(loc, image),
                detail: image.language,
                selected: image.selected,
                busy: _busy.contains(image.id),
                onTap: image.selected ? null : () => _select(context, image.id),
                onDelete: image.source == Enum$MetadataSource.USER
                    ? () => _delete(context, image)
                    : null,
                deleteKey: ArtworkPickerPage.deleteKey(image.id),
                deleteTooltip: loc.artworkDelete,
              ),
          ]),
        const SizedBox(height: 24),
        _sectionTitle(
          context,
          loc.artworkFromProvider(
            remote.isEmpty
                ? 'TMDB'
                : (SourceAttribution.displayName(remote.first.source) ??
                      remote.first.source.name),
          ),
        ),
        const SizedBox(height: 8),
        if (!loading && remote.isEmpty)
          Text(
            loc.artworkNoRemote,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        else
          _grid(context, [
            for (final candidate in remote)
              _Tile(
                key: ArtworkPickerPage.remoteKey(candidate.sourceUri),
                aspect: _aspect,
                url: candidate.previewUrl,
                label: currentUris.contains(candidate.sourceUri)
                    ? loc.artworkAlreadyOnServer
                    : (candidate.width != null && candidate.height != null
                          ? '${candidate.width}×${candidate.height}'
                          : null),
                detail: candidate.language,
                selected: false,
                busy: _busy.contains(candidate.sourceUri),
                onTap: () => _selectRemote(context, target, candidate, current),
              ),
          ]),
      ],
    );
  }

  double get _aspect => _type == ImageTypes.cover ? 2 / 3 : 16 / 9;

  Widget _sectionTitle(BuildContext context, String text) =>
      Text(text, style: Theme.of(context).textTheme.titleMedium);

  Widget _grid(BuildContext context, List<Widget> tiles) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = _type == ImageTypes.cover ? 150.0 : 240.0;
        final columns = (constraints.maxWidth / tileWidth).floor().clamp(2, 8);
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: _aspect,
          children: tiles,
        );
      },
    );
  }

  Widget _currentPreview(
    BuildContext context,
    AppLocalizations loc,
    Fragment$fragmentImages? shown,
    String? token,
    bool hasChoice,
    ArtworkTarget target,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: _type == ImageTypes.cover ? 140 : 260,
          child: AspectRatio(
            aspectRatio: _aspect,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: shown == null
                  ? Container(
                      color: scheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: scheme.onSurfaceVariant,
                      ),
                    )
                  : ArtworkImage(
                      url: ImageUtil.buildUrl(shown, token: token),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shown == null
                    ? loc.artworkEmpty
                    : (hasChoice
                          ? loc.artworkSelectedByAdmin
                          : loc.artworkAutomatic),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (shown != null) ...[
                const SizedBox(height: 4),
                Text(
                  _sourceLabel(loc, shown),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              if (hasChoice) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  key: ArtworkPickerPage.resetKey,
                  onPressed: () => _clear(context, target),
                  icon: const Icon(Icons.restart_alt),
                  label: Text(loc.artworkResetAuto),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _sourceLabel(AppLocalizations loc, Fragment$fragmentImages image) {
    final source = image.source;
    if (source == Enum$MetadataSource.USER) {
      return (image.sourceUri ?? '').startsWith('frame://')
          ? loc.artworkSourceFrame
          : loc.artworkSourceUpload;
    }
    if (source == null || source == Enum$MetadataSource.LOCAL_FILE) {
      return loc.artworkSourceLocal;
    }
    return SourceAttribution.displayName(source) ?? source.name;
  }

  // ---- actions -----------------------------------------------------------

  Future<bool> _mutate(
    BuildContext context,
    DocumentNode document,
    Map<String, dynamic> variables, {
    String? busyKey,
  }) async {
    final loc = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final client = ClientManager.getClientForUrl(widget.serverName).value;
    if (busyKey != null) setState(() => _busy.add(busyKey));
    final result = await client.mutate(
      MutationOptions(document: document, variables: variables),
    );
    if (!mounted) return false;
    if (busyKey != null) setState(() => _busy.remove(busyKey));
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      final message =
          result.exception?.graphqlErrors.firstOrNull?.message ??
          result.exception.toString();
      messenger.showSnackBar(
        SnackBar(content: Text(loc.artworkFailed(message))),
      );
      return false;
    }
    messenger.showSnackBar(SnackBar(content: Text(loc.artworkChanged)));
    _refetch?.call();
    return true;
  }

  Future<void> _select(BuildContext context, String imageId) => _mutate(
    context,
    documentNodeMutationselectImage,
    Variables$Mutation$selectImage(imageId: imageId).toJson(),
    busyKey: imageId,
  );

  Future<void> _selectRemote(
    BuildContext context,
    ArtworkTarget target,
    Query$imageCandidates$imageCandidates$remote candidate,
    List<Fragment$fragmentImages> current,
  ) {
    // Already stored: no download, just the flag.
    final stored = current
        .where((i) => i.sourceUri == candidate.sourceUri)
        .firstOrNull;
    if (stored != null) return _select(context, stored.id);
    return _mutate(
      context,
      documentNodeMutationselectRemoteImage,
      Variables$Mutation$selectRemoteImage(
        target: target.toInput(),
        type: imageTypeOf(_type),
        sourceUri: candidate.sourceUri,
      ).toJson(),
      busyKey: candidate.sourceUri,
    );
  }

  Future<void> _clear(BuildContext context, ArtworkTarget target) => _mutate(
    context,
    documentNodeMutationclearSelectedImage,
    Variables$Mutation$clearSelectedImage(
      target: target.toInput(),
      type: imageTypeOf(_type),
    ).toJson(),
  );

  Future<void> _delete(
    BuildContext context,
    Fragment$fragmentImages image,
  ) async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await showConfirmDialog(
      context,
      title: loc.artworkDelete,
      body: loc.artworkDeleteConfirm,
      confirmLabel: loc.artworkDelete,
    );
    if (!confirmed || !context.mounted) return;
    await _mutate(
      context,
      documentNodeMutationdeleteImage,
      Variables$Mutation$deleteImage(imageId: image.id).toJson(),
      busyKey: image.id,
    );
  }

  Future<void> _upload(BuildContext context, ArtworkTarget target) async {
    final loc = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final picked = await (widget.pickImage ?? pickArtworkFile)();
    if (picked == null || !mounted) return;
    final serverUrl = WellKnownService.getCached(widget.serverName)?.serverUrl;
    if (serverUrl == null) {
      messenger.showSnackBar(SnackBar(content: Text(loc.couldNotLoad)));
      return;
    }
    setState(() => _uploading = true);
    try {
      await (widget.api ?? ArtworkAdminApi(widget.serverName)).upload(
        serverUrl,
        target,
        _type,
        picked.bytes,
        contentType: picked.contentType,
      );
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(loc.artworkChanged)));
      _refetch?.call();
    } catch (e) {
      LoggerService().logger.e(e);
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(loc.artworkFailed(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _pickFrame(BuildContext context, ArtworkTarget target) async {
    final durationMs = widget.frameDurationMs!;
    final positionMs = await showDialog<int>(
      context: context,
      builder: (context) => _FrameDialog(durationMs: durationMs),
    );
    if (positionMs == null || !context.mounted) return;
    await _mutate(
      context,
      documentNodeMutationselectVideoFrame,
      Variables$Mutation$selectVideoFrame(
        target: target.toInput(),
        type: imageTypeOf(_type),
        mediaFileId: widget.frameMediaFileId!,
        // The server wants the file's own timeline; a multi-episode file's
        // episode starts later in it.
        positionMs: (widget.frameStartMs ?? 0) + positionMs,
      ).toJson(),
    );
  }
}

/// Position within the item's video for a frame grab. No preview: that would
/// take a render endpoint per slider move; the "while watching" flow in the
/// video controls shows the actual picture.
class _FrameDialog extends StatefulWidget {
  const _FrameDialog({required this.durationMs});
  final int durationMs;

  @override
  State<_FrameDialog> createState() => _FrameDialogState();
}

class _FrameDialogState extends State<_FrameDialog> {
  late double _positionMs = widget.durationMs / 2;

  static String formatMs(int ms) {
    final d = Duration(milliseconds: ms);
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(loc.artworkFromVideo),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            loc.artworkFrameAt(formatMs(_positionMs.round())),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Slider(
            key: ArtworkPickerPage.frameSliderKey,
            value: _positionMs,
            min: 0,
            max: widget.durationMs.toDouble(),
            onChanged: (v) => setState(() => _positionMs = v),
          ),
          Text(
            loc.artworkFrameHint,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(loc.cancel),
        ),
        FilledButton(
          key: ArtworkPickerPage.frameUseKey,
          onPressed: () => Navigator.of(context).pop(_positionMs.round()),
          child: Text(loc.artworkUseFrame),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    super.key,
    required this.aspect,
    required this.url,
    required this.selected,
    required this.busy,
    this.label,
    this.detail,
    this.onTap,
    this.onDelete,
    this.deleteKey,
    this.deleteTooltip,
  });

  final double aspect;
  final String? url;
  final String? label;
  final String? detail;
  final bool selected;
  final bool busy;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Key? deleteKey;
  final String? deleteTooltip;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(10);
    // TvFocusable only maps the D-pad select to onTap; pointer taps are ours.
    return TvFocusable(
      onTap: onTap,
      borderRadius: radius,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: selected ? scheme.primary : Colors.transparent,
              width: 3,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ArtworkImage(
                  url: url,
                  fit: BoxFit.cover,
                  errorBuilder: (_) => Container(
                    color: scheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (label != null || detail != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      color: Colors.black.withValues(alpha: 0.55),
                      child: Text(
                        [
                          label,
                          detail?.toUpperCase(),
                        ].whereType<String>().join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                if (selected)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: scheme.primary,
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: scheme.onPrimary,
                      ),
                    ),
                  ),
                if (onDelete != null)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: IconButton(
                      key: deleteKey,
                      tooltip: deleteTooltip,
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black, blurRadius: 6)],
                      ),
                    ),
                  ),
                if (busy)
                  Container(
                    color: Colors.black.withValues(alpha: 0.4),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
