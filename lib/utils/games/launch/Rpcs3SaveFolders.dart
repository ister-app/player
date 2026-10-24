import '../Ps3Titles.dart';

/// Which folders under RPCS3's `savedata/` belong to a game. A PS3 game
/// names its save folders itself: usually `<title id>-SLOT01`, but a PSN
/// re-release keeps the disc version's name (`NPEA00363` saves to
/// `BCES00065_NDI_UNCHARTED_DF_0`), so a folder whose own `PARAM.SFO` names
/// the game is its as well. Pure: the caller lists the folders and reads
/// the SFO titles.
class Rpcs3SaveFolders {
  Rpcs3SaveFolders._();

  /// The matching folder names, sorted, so slot indices are stable between
  /// runs. [sfoTitleOf] returns the `TITLE` of a folder's `PARAM.SFO`, or
  /// null when there is none; it is only consulted for folders the title id
  /// does not already claim.
  static Future<List<String>> select({
    required Iterable<String> folderNames,
    required String titleId,
    String? title,
    required Future<String?> Function(String folderName) sfoTitleOf,
  }) async {
    final matching = <String>[];
    for (final name in folderNames) {
      if (name == titleId) continue; // the bare prefix is the caller's slot 0
      if (name.startsWith(titleId)) {
        matching.add(name);
        continue;
      }
      if (title == null) continue;
      final sfoTitle = await sfoTitleOf(name);
      if (sfoTitle != null && Ps3Titles.same(sfoTitle, title)) matching.add(name);
    }
    matching.sort();
    return matching;
  }
}
