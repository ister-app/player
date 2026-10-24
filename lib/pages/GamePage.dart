import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:material_ui/material_ui.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/gameById.graphql.dart';
import 'package:player/graphql/gameSaveMutations.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:player/utils/games/GameLabels.dart';
import 'package:player/utils/games/GamePlatformSupport.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/ArtworkImage.dart';
import '../components/GameCarouselTile.dart';
import '../components/MusicDetailHero.dart';
import '../components/SourceAttribution.dart';
import '../components/games/GameActionsPanel.dart';
import '../l10n/app_localizations.dart';
import 'package:player/utils/artwork/ArtworkNavigation.dart';
import 'package:player/utils/artwork/ArtworkTarget.dart';
import 'package:player/utils/PermissionsService.dart';

/// A game: cover, facts, how it is launched, the calling user's saves and
/// achievements. Installing and playing happen on desktop through
/// [GameActionsPanel]; every other platform browses and manages saves only.
@RoutePage()
class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('gameId') required this.gameId,
  });

  final String serverName;
  final String gameId;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _showAdminActions = true;

  @override
  void initState() {
    super.initState();
    PermissionsService().adminStatusFor(widget.serverName).then((status) {
      if (mounted && status == AdminStatus.notAdmin) {
        setState(() => _showAdminActions = false);
      }
    });
  }

  Query$gameById$gameById? _game;
  VoidCallback? _refetch;
  bool _saveBusy = false;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: documentNodeQuerygameById,
        variables: {'id': widget.gameId},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder:
          (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
            _refetch = refetch;
            if (result.hasException) {
              return Scaffold(
                appBar: AppBar(),
                body: Center(child: Text(result.exception.toString())),
              );
            }
            if (result.data == null) {
              return Scaffold(
                body: Skeletonizer(
                  enabled: true,
                  child: _buildContent(skeleton: true),
                ),
              );
            }
            _game = Query$gameById.fromJson(result.data!).gameById;
            return Scaffold(body: _buildContent());
          },
    );
  }

  Widget _buildContent({bool skeleton = false}) {
    final loc = AppLocalizations.of(context)!;
    final game = _game;
    final description = game != null
        ? MetadataUtil.getDescription(game.metadata)
        : null;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          stretch: true,
          foregroundColor: Colors.white,
          actions: [
            if (game != null && _showAdminActions)
              IconButton(
                key: ChangeArtworkMenuItem.itemKey,
                icon: const Icon(Icons.wallpaper_outlined),
                tooltip: loc.changeArtwork,
                onPressed: () => openArtworkPicker(
                  context,
                  target: ArtworkTarget(ArtworkTargetKind.game, game.id),
                  title: game.title,
                ).then((_) => _refetch?.call()),
              ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: _buildHeader(game, skeleton: skeleton),
          ),
        ),
        SliverToBoxAdapter(
          child: _constrained(
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: _buildFacts(loc, game, skeleton: skeleton),
            ),
          ),
        ),
        if (game != null)
          SliverToBoxAdapter(
            child: _constrained(
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: kGamesSupported
                    ? GameActionsPanel(
                        key: ValueKey('game-actions-${game.id}'),
                        serverName: widget.serverName,
                        game: game,
                        onPlayed: () => _refetch?.call(),
                      )
                    : _notice(Icons.desktop_windows_outlined, loc.gameDesktopOnly),
              ),
            ),
          ),
        if (game?.form == Enum$GameForm.STEAM)
          SliverToBoxAdapter(
            child: _constrained(
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: _notice(Icons.info_outline, loc.gameSteamOwnershipNote),
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: _constrained(
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.description,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(skeleton
                      ? BoneMock.paragraph
                      : (description ?? loc.gameNoDescription)),
                  const SizedBox(height: 6),
                  SourceAttribution(
                    metadata: game?.metadata,
                    images: game?.images,
                    skeleton: skeleton,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (game != null && _usesSavePaths(game.form))
          SliverToBoxAdapter(
            child: _constrained(
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: _buildSavePaths(loc, game),
              ),
            ),
          ),
        if (game != null)
          SliverToBoxAdapter(
            child: _constrained(
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: _buildSaves(loc, game),
              ),
            ),
          ),
        if (game != null)
          SliverToBoxAdapter(
            child: _constrained(
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: _buildAchievements(loc, game),
              ),
            ),
          ),
      ],
    );
  }

  static bool _usesSavePaths(Enum$GameForm form) =>
      form == Enum$GameForm.STEAM ||
      form == Enum$GameForm.PC_PORTABLE_ZIP ||
      form == Enum$GameForm.PC_LINUX_INSTALLER ||
      form == Enum$GameForm.PC_LINUX_PORTABLE;

  Widget _buildHeader(Query$gameById$gameById? game, {bool skeleton = false}) {
    final img = game != null
        ? ImageUtil.getImageByType(game.images, ImageTypes.cover)
        : null;
    return MusicDetailHero(
      imageUrl: img != null
          ? ImageUtil.buildUrl(img,
              token: StreamTokenService.getToken(widget.serverName))
          : null,
      blurHash: img?.blurHash,
      placeholderIcon: Icons.sports_esports,
      coverAspectRatio: GameCarouselTile.coverAspectRatio,
      title: game != null
          ? MetadataUtil.titleWithYear(game.title, game.releaseYear)
          : null,
      subtitle: game != null ? GameLabels.platform(game.platform) : null,
      skeleton: skeleton,
    );
  }

  Widget _buildFacts(AppLocalizations loc, Query$gameById$gameById? game,
      {bool skeleton = false}) {
    if (game == null) {
      return Wrap(spacing: 8, children: [
        Chip(label: Text(BoneMock.words(2))),
        Chip(label: Text(BoneMock.words(2))),
      ]);
    }
    final lastPlayed = game.lastPlayed == null
        ? loc.gameNeverPlayed
        : loc.gameLastPlayed(_formatDate(game.lastPlayed!));
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Chip(
          avatar: const Icon(Icons.videogame_asset_outlined, size: 18),
          label: Text(GameLabels.form(loc, game.form)),
        ),
        Chip(
          avatar: const Icon(Icons.rocket_launch_outlined, size: 18),
          label: Text(_launcherLabel(loc, game)),
        ),
        Chip(
          avatar: const Icon(Icons.storage_outlined, size: 18),
          label: Text(
              '${loc.gameSizeOnServer(GameLabels.bytes(game.sizeBytes))} · ${loc.gameFileCount(game.fileCount)}'),
        ),
        Chip(
          avatar: const Icon(Icons.timer_outlined, size: 18),
          label: Text(loc.gamePlayTime(GameLabels.playTime(loc, game.playTimeMs))),
        ),
        Chip(
          avatar: const Icon(Icons.history, size: 18),
          label: Text(lastPlayed),
        ),
        if (game.updatedAt != null)
          Chip(
            avatar: const Icon(Icons.update, size: 18),
            label: Text(loc.gameUpdatedOn(_formatDate(game.updatedAt!))),
          ),
      ],
    );
  }

  String _launcherLabel(AppLocalizations loc, Query$gameById$gameById game) {
    switch (game.launcher.kind) {
      case Enum$GameLauncherKind.RETROARCH:
        return loc.gameLauncherRetroArch(game.launcher.retroArchCore ?? '?');
      case Enum$GameLauncherKind.RPCS3:
        return loc.gameLauncherRpcs3;
      case Enum$GameLauncherKind.STEAM:
        return loc.gameLauncherSteam;
      case Enum$GameLauncherKind.NATIVE_WINDOWS:
      case Enum$GameLauncherKind.NATIVE_LINUX:
      case Enum$GameLauncherKind.$unknown:
        return loc.gameLauncherNative;
    }
  }

  Widget _buildSavePaths(AppLocalizations loc, Query$gameById$gameById game) {
    final source = switch (game.savePathSource) {
      'ADMIN' => loc.gameSavePathSourceAdmin,
      'MANIFEST' => loc.gameSavePathSourceManifest,
      _ => loc.gameSavePathSourceNone,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.gameSavePaths,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(source, style: Theme.of(context).textTheme.bodySmall),
        for (final path in game.savePaths)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                const Icon(Icons.folder_outlined, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    path.os == null ? path.path : '${path.path}  (${path.os})',
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ],
            ),
          ),
        if (game.steamCloud)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _notice(Icons.cloud_outlined, loc.gameSteamCloudNote),
          ),
      ],
    );
  }

  Widget _buildSaves(AppLocalizations loc, Query$gameById$gameById game) {
    final saves = game.saves;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.gameSaves, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (saves.isEmpty)
          Text(loc.gameNoSaves,
              style: Theme.of(context).textTheme.bodyMedium)
        else
          for (final save in saves)
            ListTile(
              key: ValueKey('game-save-${save.version}'),
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                save == saves.first ? Icons.save : Icons.history,
              ),
              title: Text(
                save.note == null
                    ? loc.gameSaveVersion(save.version)
                    : '${loc.gameSaveVersion(save.version)} · ${save.note}',
              ),
              subtitle: Text(
                '${loc.gameSaveFrom(save.deviceName ?? '—', _formatDate(save.createdAt))} · ${GameLabels.bytes(save.sizeBytes)}',
              ),
              trailing: Wrap(
                spacing: 4,
                children: [
                  if (save != saves.first)
                    TextButton(
                      onPressed: _saveBusy
                          ? null
                          : () => unawaited(_restoreSave(game, save.version)),
                      child: Text(loc.gameSaveRestore),
                    ),
                  IconButton(
                    tooltip: loc.gameSaveDelete,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: _saveBusy
                        ? null
                        : () => unawaited(_deleteSave(game, save.version)),
                  ),
                ],
              ),
            ),
      ],
    );
  }

  Widget _buildAchievements(AppLocalizations loc, Query$gameById$gameById game) {
    final achievements = game.achievements;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(loc.gameAchievements,
                style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            if (achievements.total > 0)
              Text(loc.gameAchievementsProgress(
                  achievements.unlocked, achievements.total)),
          ],
        ),
        const SizedBox(height: 8),
        if (achievements.total == 0)
          Text(loc.gameAchievementsNone,
              style: Theme.of(context).textTheme.bodyMedium)
        else ...[
          LinearProgressIndicator(
            value: achievements.unlocked / achievements.total,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final a in achievements.list) _achievementTile(loc, a),
            ],
          ),
        ],
      ],
    );
  }

  Widget _achievementTile(AppLocalizations loc,
      Query$gameById$gameById$achievements$list achievement) {
    final unlocked = achievement.unlockedAt != null;
    final hiddenLocked = achievement.hidden && !unlocked;
    final icon = achievement.icon;
    final iconUrl = icon == null
        ? null
        : ImageUtil.buildUrl(icon,
            token: StreamTokenService.getToken(widget.serverName));
    final theme = Theme.of(context);
    return Tooltip(
      message: hiddenLocked
          ? loc.gameAchievementHidden
          : [achievement.name, achievement.description]
              .whereType<String>()
              .join('\n'),
      child: Opacity(
        opacity: unlocked ? 1 : 0.45,
        child: SizedBox(
          width: 72,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: iconUrl != null && !hiddenLocked
                      ? ArtworkImage(
                          url: iconUrl,
                          logicalWidth: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_) => ColoredBox(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: const Icon(Icons.emoji_events_outlined),
                          ),
                        )
                      : ColoredBox(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(
                            hiddenLocked
                                ? Icons.help_outline
                                : Icons.emoji_events_outlined,
                            color: _gradeColor(achievement.grade, theme),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                hiddenLocked ? loc.gameAchievementHidden : achievement.name,
                style: theme.textTheme.labelSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Color? _gradeColor(String? grade, ThemeData theme) {
    switch (grade) {
      case 'BRONZE':
        return const Color(0xFFCD7F32);
      case 'SILVER':
        return const Color(0xFFC0C0C0);
      case 'GOLD':
        return const Color(0xFFFFD700);
      case 'PLATINUM':
        return const Color(0xFFE5E4E2);
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  Future<void> _restoreSave(Query$gameById$gameById game, int version) async {
    final loc = AppLocalizations.of(context)!;
    setState(() => _saveBusy = true);
    try {
      final client = GraphQLProvider.of(context).value;
      final result = await client.mutate(MutationOptions(
        document: documentNodeMutationrestoreGameSave,
        variables: Variables$Mutation$restoreGameSave(
                gameId: game.id, version: version)
            .toJson(),
      ));
      if (result.hasException) throw result.exception!;
      final restored = Mutation$restoreGameSave.fromJson(result.data!).restoreGameSave;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.gameSaveRestored(restored.version))));
      }
      _refetch?.call();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(loc.gameSaveActionFailed)));
      }
    } finally {
      if (mounted) setState(() => _saveBusy = false);
    }
  }

  Future<void> _deleteSave(Query$gameById$gameById game, int version) async {
    final loc = AppLocalizations.of(context)!;
    final save = game.saves.where((s) => s.version == version).firstOrNull;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.gameSaveDelete),
        content: Text(loc.gameSaveDeleteConfirm(version, save?.deviceName ?? '—', _formatDate(save?.createdAt ?? ''))),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(loc.cancel)),
          FilledButton(
              key: const ValueKey('game-save-delete-confirm'),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(loc.gameSaveDelete)),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _saveBusy = true);
    try {
      final client = GraphQLProvider.of(context).value;
      final result = await client.mutate(MutationOptions(
        document: documentNodeMutationdeleteGameSave,
        variables: Variables$Mutation$deleteGameSave(
                gameId: game.id, version: version)
            .toJson(),
      ));
      if (result.hasException) throw result.exception!;
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(loc.gameSaveDeleted)));
      }
      _refetch?.call();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(loc.gameSaveActionFailed)));
      }
    } finally {
      if (mounted) setState(() => _saveBusy = false);
    }
  }

  Widget _notice(IconData icon, String text) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  static String _formatDate(String iso) {
    final date = DateTime.tryParse(iso)?.toLocal();
    if (date == null) return iso;
    String two(int n) => n.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)} ${two(date.hour)}:${two(date.minute)}';
  }

  Widget _constrained(Widget child) {
    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1600),
        child: child,
      ),
    );
  }
}
