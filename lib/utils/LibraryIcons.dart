import 'package:flutter/material.dart';
import 'package:player/graphql/schema.graphql.dart';

/// The icon representing a library's content type, shared by every surface
/// that lists libraries (switcher menu, cluster settings, ...).
IconData libraryTypeIcon(Enum$LibraryType type) {
  switch (type) {
    case Enum$LibraryType.MOVIE:
      return Icons.movie;
    case Enum$LibraryType.SHOW:
      return Icons.tv;
    case Enum$LibraryType.MUSIC:
      return Icons.library_music;
    case Enum$LibraryType.BOOK:
      return Icons.menu_book;
    case Enum$LibraryType.PODCAST:
      return Icons.podcasts;
    case Enum$LibraryType.COMIC:
      return Icons.collections_bookmark;
    default:
      return Icons.video_library;
  }
}
