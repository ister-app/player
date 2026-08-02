import 'package:player/graphql/schema.graphql.dart';

/// What the Browse grid of a library lists. Most library types show one thing;
/// music and show libraries let the user switch between kinds.
enum BrowseKind { albums, artists, tracks, shows, episodes }

/// The kinds a library type can browse, first entry = default. An empty list
/// means the type has a single implicit kind and no switcher is shown.
List<BrowseKind> browseKindsFor(Enum$LibraryType? type) {
  switch (type) {
    case Enum$LibraryType.MUSIC:
      return const [BrowseKind.albums, BrowseKind.artists, BrowseKind.tracks];
    case Enum$LibraryType.SHOW:
      return const [BrowseKind.shows, BrowseKind.episodes];
    default:
      return const [];
  }
}
