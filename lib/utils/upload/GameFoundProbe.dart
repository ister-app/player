import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/games.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/ClientManager.dart';

import 'games/GameLibraryIndex.dart';

/// What the probe found: the game as the library now lists it.
class FoundGame {
  const FoundGame({required this.id, required this.title, required this.platform, required this.form, required this.savePathSource});
  final String id;
  final String title;
  final Enum$GamePlatform platform;
  final Enum$GameForm form;

  /// ADMIN / MANIFEST / NONE — whether save sync will work for the game.
  final String savePathSource;

  /// ROMs and PS3 games keep their saves in the emulator; the Ludusavi
  /// question only applies to PC and Steam games.
  bool get usesSavePaths =>
      form == Enum$GameForm.STEAM ||
      form == Enum$GameForm.PC_PORTABLE_ZIP ||
      form == Enum$GameForm.PC_LINUX_INSTALLER ||
      form == Enum$GameForm.PC_LINUX_PORTABLE;
}

/// Looks a freshly uploaded game up by title until the scanner has it.
typedef GameLookup = Future<FoundGame?> Function(String libraryId, String title);

/// After a game upload: polls the library for the game until it shows up
/// (the scan runs once the whole session finished) or the patience runs out.
class GameFoundProbe {
  GameFoundProbe({
    required this.lookup,
    this.interval = const Duration(seconds: 5),
    this.patience = const Duration(minutes: 2),
  });

  final GameLookup lookup;
  final Duration interval;
  final Duration patience;

  /// Null when the game did not appear within [patience].
  Future<FoundGame?> run(String libraryId, String title, {bool Function()? cancelled}) async {
    final deadline = DateTime.now().add(patience);
    while (true) {
      if (cancelled?.call() == true) return null;
      try {
        final found = await lookup(libraryId, title);
        if (found != null) return found;
      } catch (_) {
        // The server may be busy ingesting; try again.
      }
      if (DateTime.now().isAfter(deadline)) return null;
      await Future<void>.delayed(interval);
    }
  }

  /// The production lookup: the library's `games` query, matched on title
  /// (case-insensitive, the folder's title without the year).
  static GameLookup graphQL(String serverName) => (libraryId, title) async {
        final client = ClientManager.getClientForUrl(serverName).value;
        final result = await client.query(QueryOptions(
          document: documentNodeQuerygames,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: Variables$Query$games(libraryId: libraryId, page: 0, size: 200, sorting: Enum$SortingEnum.NAME)
              .toJson(),
        ));
        if (result.hasException) throw result.exception!;
        final wanted = GameLibraryIndex.normalise(title);
        for (final game in Query$games.fromJson(result.data!).games?.content ?? const []) {
          if (GameLibraryIndex.normalise(game.title) == wanted || GameLibraryIndex.normalise(game.name) == wanted) {
            return FoundGame(
              id: game.id,
              title: game.title,
              platform: game.platform,
              form: game.form,
              savePathSource: game.savePathSource,
            );
          }
        }
        return null;
      };
}
