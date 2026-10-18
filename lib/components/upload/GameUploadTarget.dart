import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:material_ui/material_ui.dart';
import 'package:player/graphql/gamePlatforms.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/games/GameLabels.dart';

import '../../l10n/app_localizations.dart';

/// One platform a game library accepts: the folder it is scanned under and
/// what a game of it has to consist of.
class GamePlatformOption {
  const GamePlatformOption({required this.platform, required this.folder, required this.entryExtensions});
  final Enum$GamePlatform platform;
  final String folder;
  final List<String> entryExtensions;

  static List<GamePlatformOption> fromQuery(Query$gamePlatforms data) => [
        for (final p in data.gamePlatforms)
          if (p.folderNames.isNotEmpty)
            GamePlatformOption(platform: p.platform, folder: p.folderNames.first, entryExtensions: p.entryExtensions),
      ];

  /// Loads the server's platform table through the server's GraphQL client.
  static Future<List<GamePlatformOption>> load(String serverName) async {
    final client = ClientManager.getClientForUrl(serverName).value;
    final result = await client.query(QueryOptions(
      document: documentNodeQuerygamePlatforms,
      fetchPolicy: FetchPolicy.cacheFirst,
    ));
    if (result.hasException) throw result.exception!;
    return fromQuery(Query$gamePlatforms.fromJson(result.data!));
  }
}

/// The platform picker of a game upload: replaces the free "inside folder"
/// field with the folder names the scanner knows, and tells what the picked
/// platform needs (a marker file, an archive, a ROM with its extension).
class GameUploadTarget extends StatelessWidget {
  const GameUploadTarget({
    super.key,
    required this.platforms,
    required this.selected,
    required this.onChanged,
    this.loading = false,
    this.error,
  });

  final List<GamePlatformOption> platforms;
  final GamePlatformOption? selected;
  final ValueChanged<GamePlatformOption?> onChanged;
  final bool loading;
  final String? error;

  /// What a game of [platform] must contain, for the helper line.
  static String requirement(AppLocalizations loc, GamePlatformOption option) {
    switch (option.platform) {
      case Enum$GamePlatform.PS3:
        return loc.uploadGamePlatformHintPs3;
      case Enum$GamePlatform.STEAM:
        return loc.uploadGamePlatformHintSteam;
      case Enum$GamePlatform.PC:
        return loc.uploadGamePlatformHintWindows;
      case Enum$GamePlatform.LINUX:
        return loc.uploadGamePlatformHintLinux;
      default:
        return loc.uploadGamePlatformHintRom(option.entryExtensions.map((e) => '.$e').join(', '));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    if (error != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: Text(error!, style: TextStyle(color: theme.colorScheme.error)),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<GamePlatformOption>(
            key: const ValueKey('upload-game-platform'),
            initialValue: selected,
            decoration: InputDecoration(
              labelText: loc.uploadGamePlatform,
              suffixIcon: loading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)))
                  : null,
            ),
            items: [
              for (final option in platforms)
                DropdownMenuItem(
                  key: ValueKey('upload-game-platform-${option.platform.name}'),
                  value: option,
                  child: Text('${GameLabels.platform(option.platform)}  ·  ${option.folder}/'),
                ),
            ],
            onChanged: loading ? null : onChanged,
          ),
          if (selected != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                requirement(loc, selected!),
                key: const ValueKey('upload-game-platform-hint'),
                style: theme.textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}
