import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/games.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/ClientManager.dart';

import '../GameFoundProbe.dart';

/// The games a library already lists, keyed the way the scanner names them
/// (platform + title, case-insensitive), so the candidates page can say
/// "already in the library" and the batch can tell which uploads got scanned.
class GameLibraryIndex {
  GameLibraryIndex(this._byKey);

  final Map<String, FoundGame> _byKey;

  static String key(Enum$GamePlatform platform, String title) => '${platform.name}|${normalise(title)}';

  /// The comparison the whole upload flow uses for titles.
  static String normalise(String title) => title.trim().toLowerCase();

  FoundGame? find(Enum$GamePlatform platform, String title) => _byKey[key(platform, title)];

  bool contains(Enum$GamePlatform platform, String title) => find(platform, title) != null;

  /// Every page of the library's `games` query, fresh from the server.
  static Future<GameLibraryIndex> load(String serverName, String libraryId) async {
    final client = ClientManager.getClientForUrl(serverName).value;
    final byKey = <String, FoundGame>{};
    var page = 0;
    while (true) {
      final result = await client.query(QueryOptions(
        document: documentNodeQuerygames,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: Variables$Query$games(libraryId: libraryId, page: page, size: 200, sorting: Enum$SortingEnum.NAME)
            .toJson(),
      ));
      if (result.hasException) throw result.exception!;
      final games = Query$games.fromJson(result.data!).games;
      for (final game in games?.content ?? const []) {
        final found = FoundGame(
          id: game.id,
          title: game.title,
          platform: game.platform,
          form: game.form,
          savePathSource: game.savePathSource,
        );
        byKey.putIfAbsent(key(game.platform, game.title), () => found);
        byKey.putIfAbsent(key(game.platform, game.name), () => found);
      }
      page++;
      if (games == null || page >= games.totalPages) break;
    }
    return GameLibraryIndex(byKey);
  }
}

/// Loads a library's index; swapped for a fixture in tests.
typedef GameLibraryIndexLoader = Future<GameLibraryIndex> Function(String libraryId);
