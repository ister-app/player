import 'package:player/components/upload/GameUploadTarget.dart';
import 'package:player/graphql/schema.graphql.dart';

/// The server's platform table, indexed the way the scanner asks: which
/// platform a folder name means, whether a file is a game's entry or a
/// companion of one.
class GamePlatformTable {
  GamePlatformTable(this.platforms);

  final List<GamePlatformOption> platforms;

  GamePlatformOption? byFolderName(String name) {
    final lower = name.toLowerCase();
    for (final p in platforms) {
      if (p.folderNames.any((f) => f.toLowerCase() == lower)) return p;
    }
    return null;
  }

  GamePlatformOption? byPlatform(Enum$GamePlatform platform) {
    for (final p in platforms) {
      if (p.platform == platform) return p;
    }
    return null;
  }

  /// The entry extension [fileName] carries for [platform], or null.
  String? entryExtension(GamePlatformOption platform, String fileName) =>
      _matching(platform.entryExtensions, fileName);

  String? companionExtension(GamePlatformOption platform, String fileName) =>
      _matching(platform.companionExtensions, fileName);

  static String? _matching(List<String> extensions, String fileName) {
    final lower = fileName.toLowerCase();
    String? best;
    for (final ext in extensions) {
      if (lower.endsWith('.${ext.toLowerCase()}') && (best == null || ext.length > best.length)) best = ext;
    }
    return best;
  }

  /// PS3 and Steam games are folders with a marker, not an entry file.
  static bool isTreePlatform(GamePlatformOption platform) =>
      platform.platform == Enum$GamePlatform.PS3 || platform.platform == Enum$GamePlatform.STEAM;
}
