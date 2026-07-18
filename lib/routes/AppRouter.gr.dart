// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i30;
import 'package:flutter/foundation.dart' as _i32;
import 'package:flutter/material.dart' as _i31;
import 'package:player/pages/AdminLibrariesPage.dart' as _i1;
import 'package:player/pages/AdminUserAccessPage.dart' as _i2;
import 'package:player/pages/AdminUsersPage.dart' as _i3;
import 'package:player/pages/AlbumPage.dart' as _i4;
import 'package:player/pages/BookPage.dart' as _i5;
import 'package:player/pages/ComicReaderPage.dart' as _i6;
import 'package:player/pages/HomePage.dart' as _i7;
import 'package:player/pages/MoviePage.dart' as _i8;
import 'package:player/pages/MusicPlayerPage.dart' as _i9;
import 'package:player/pages/PersonPage.dart' as _i10;
import 'package:player/pages/PodcastPage.dart' as _i11;
import 'package:player/pages/ReaderPage.dart' as _i12;
import 'package:player/pages/RemoteControlPage.dart' as _i13;
import 'package:player/pages/SearchPage.dart' as _i14;
import 'package:player/pages/SeriesPage.dart' as _i15;
import 'package:player/pages/ServerActivityPage.dart' as _i16;
import 'package:player/pages/ServerHomeContentPage.dart' as _i17;
import 'package:player/pages/ServerHomeOverviewPage.dart' as _i18;
import 'package:player/pages/ServerHomePage.dart' as _i19;
import 'package:player/pages/ServerNowPlayingPage.dart' as _i20;
import 'package:player/pages/ServerSettingsAboutPage.dart' as _i21;
import 'package:player/pages/ServerSettingsClusterPage.dart' as _i22;
import 'package:player/pages/ServerSettingsLanguagePage.dart' as _i23;
import 'package:player/pages/ServerSettingsPage.dart' as _i24;
import 'package:player/pages/ServerSettingsPlaybackPage.dart' as _i25;
import 'package:player/pages/ShowEpisodePage.dart' as _i26;
import 'package:player/pages/ShowHomePage.dart' as _i27;
import 'package:player/pages/ShowOverviewContentPage.dart' as _i28;
import 'package:player/pages/ShowOverviewPage.dart' as _i29;

/// generated route for
/// [_i1.AdminLibrariesPage]
class AdminLibrariesRoute extends _i30.PageRouteInfo<AdminLibrariesRouteArgs> {
  AdminLibrariesRoute({_i31.Key? key, List<_i30.PageRouteInfo>? children})
      : super(
          AdminLibrariesRoute.name,
          args: AdminLibrariesRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AdminLibrariesRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<AdminLibrariesRouteArgs>(
        orElse: () => AdminLibrariesRouteArgs(),
      );
      return _i1.AdminLibrariesPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class AdminLibrariesRouteArgs {
  const AdminLibrariesRouteArgs({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return 'AdminLibrariesRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AdminLibrariesRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i2.AdminUserAccessPage]
class AdminUserAccessRoute
    extends _i30.PageRouteInfo<AdminUserAccessRouteArgs> {
  AdminUserAccessRoute({
    _i31.Key? key,
    required String userId,
    required String userName,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          AdminUserAccessRoute.name,
          args: AdminUserAccessRouteArgs(
            key: key,
            userId: userId,
            userName: userName,
          ),
          rawPathParams: {'userId': userId},
          initialChildren: children,
        );

  static const String name = 'AdminUserAccessRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<AdminUserAccessRouteArgs>();
      return _i2.AdminUserAccessPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        userId: args.userId,
        userName: args.userName,
      );
    },
  );
}

class AdminUserAccessRouteArgs {
  const AdminUserAccessRouteArgs({
    this.key,
    required this.userId,
    required this.userName,
  });

  final _i31.Key? key;

  final String userId;

  final String userName;

  @override
  String toString() {
    return 'AdminUserAccessRouteArgs{key: $key, userId: $userId, userName: $userName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AdminUserAccessRouteArgs) return false;
    return key == other.key &&
        userId == other.userId &&
        userName == other.userName;
  }

  @override
  int get hashCode => key.hashCode ^ userId.hashCode ^ userName.hashCode;
}

/// generated route for
/// [_i3.AdminUsersPage]
class AdminUsersRoute extends _i30.PageRouteInfo<AdminUsersRouteArgs> {
  AdminUsersRoute({_i31.Key? key, List<_i30.PageRouteInfo>? children})
      : super(
          AdminUsersRoute.name,
          args: AdminUsersRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AdminUsersRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<AdminUsersRouteArgs>(
        orElse: () => AdminUsersRouteArgs(),
      );
      return _i3.AdminUsersPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class AdminUsersRouteArgs {
  const AdminUsersRouteArgs({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return 'AdminUsersRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AdminUsersRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i4.AlbumPage]
class AlbumRoute extends _i30.PageRouteInfo<AlbumRouteArgs> {
  AlbumRoute({
    _i31.Key? key,
    required String albumId,
    String? playQueueId,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          AlbumRoute.name,
          args: AlbumRouteArgs(
            key: key,
            albumId: albumId,
            playQueueId: playQueueId,
          ),
          rawPathParams: {'albumId': albumId},
          rawQueryParams: {'playQueueId': playQueueId},
          initialChildren: children,
        );

  static const String name = 'AlbumRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<AlbumRouteArgs>(
        orElse: () => AlbumRouteArgs(
          albumId: pathParams.getString('albumId'),
          playQueueId: queryParams.optString('playQueueId'),
        ),
      );
      return _i4.AlbumPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        albumId: args.albumId,
        playQueueId: args.playQueueId,
      );
    },
  );
}

class AlbumRouteArgs {
  const AlbumRouteArgs({this.key, required this.albumId, this.playQueueId});

  final _i31.Key? key;

  final String albumId;

  final String? playQueueId;

  @override
  String toString() {
    return 'AlbumRouteArgs{key: $key, albumId: $albumId, playQueueId: $playQueueId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AlbumRouteArgs) return false;
    return key == other.key &&
        albumId == other.albumId &&
        playQueueId == other.playQueueId;
  }

  @override
  int get hashCode => key.hashCode ^ albumId.hashCode ^ playQueueId.hashCode;
}

/// generated route for
/// [_i5.BookPage]
class BookRoute extends _i30.PageRouteInfo<BookRouteArgs> {
  BookRoute({
    _i31.Key? key,
    required String bookId,
    String? playQueueId,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          BookRoute.name,
          args: BookRouteArgs(
            key: key,
            bookId: bookId,
            playQueueId: playQueueId,
          ),
          rawPathParams: {'bookId': bookId},
          rawQueryParams: {'playQueueId': playQueueId},
          initialChildren: children,
        );

  static const String name = 'BookRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<BookRouteArgs>(
        orElse: () => BookRouteArgs(
          bookId: pathParams.getString('bookId'),
          playQueueId: queryParams.optString('playQueueId'),
        ),
      );
      return _i5.BookPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        bookId: args.bookId,
        playQueueId: args.playQueueId,
      );
    },
  );
}

class BookRouteArgs {
  const BookRouteArgs({this.key, required this.bookId, this.playQueueId});

  final _i31.Key? key;

  final String bookId;

  final String? playQueueId;

  @override
  String toString() {
    return 'BookRouteArgs{key: $key, bookId: $bookId, playQueueId: $playQueueId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BookRouteArgs) return false;
    return key == other.key &&
        bookId == other.bookId &&
        playQueueId == other.playQueueId;
  }

  @override
  int get hashCode => key.hashCode ^ bookId.hashCode ^ playQueueId.hashCode;
}

/// generated route for
/// [_i6.ComicReaderPage]
class ComicReaderRoute extends _i30.PageRouteInfo<ComicReaderRouteArgs> {
  ComicReaderRoute({
    _i32.Key? key,
    required String bookId,
    required String mediaFileId,
    String? nodeUrl,
    String? title,
    String? seriesId,
    int? page,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          ComicReaderRoute.name,
          args: ComicReaderRouteArgs(
            key: key,
            bookId: bookId,
            mediaFileId: mediaFileId,
            nodeUrl: nodeUrl,
            title: title,
            seriesId: seriesId,
            page: page,
          ),
          rawPathParams: {'bookId': bookId, 'mediaFileId': mediaFileId},
          rawQueryParams: {
            'nodeUrl': nodeUrl,
            'title': title,
            'seriesId': seriesId,
            'page': page,
          },
          initialChildren: children,
        );

  static const String name = 'ComicReaderRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<ComicReaderRouteArgs>(
        orElse: () => ComicReaderRouteArgs(
          bookId: pathParams.getString('bookId'),
          mediaFileId: pathParams.getString('mediaFileId'),
          nodeUrl: queryParams.optString('nodeUrl'),
          title: queryParams.optString('title'),
          seriesId: queryParams.optString('seriesId'),
          page: queryParams.optInt('page'),
        ),
      );
      return _i6.ComicReaderPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        bookId: args.bookId,
        mediaFileId: args.mediaFileId,
        nodeUrl: args.nodeUrl,
        title: args.title,
        seriesId: args.seriesId,
        page: args.page,
      );
    },
  );
}

class ComicReaderRouteArgs {
  const ComicReaderRouteArgs({
    this.key,
    required this.bookId,
    required this.mediaFileId,
    this.nodeUrl,
    this.title,
    this.seriesId,
    this.page,
  });

  final _i32.Key? key;

  final String bookId;

  final String mediaFileId;

  final String? nodeUrl;

  final String? title;

  final String? seriesId;

  final int? page;

  @override
  String toString() {
    return 'ComicReaderRouteArgs{key: $key, bookId: $bookId, mediaFileId: $mediaFileId, nodeUrl: $nodeUrl, title: $title, seriesId: $seriesId, page: $page}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ComicReaderRouteArgs) return false;
    return key == other.key &&
        bookId == other.bookId &&
        mediaFileId == other.mediaFileId &&
        nodeUrl == other.nodeUrl &&
        title == other.title &&
        seriesId == other.seriesId &&
        page == other.page;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      bookId.hashCode ^
      mediaFileId.hashCode ^
      nodeUrl.hashCode ^
      title.hashCode ^
      seriesId.hashCode ^
      page.hashCode;
}

/// generated route for
/// [_i7.HomePage]
class HomeRoute extends _i30.PageRouteInfo<void> {
  const HomeRoute({List<_i30.PageRouteInfo>? children})
      : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i7.HomePage();
    },
  );
}

/// generated route for
/// [_i8.MoviePage]
class MovieRoute extends _i30.PageRouteInfo<MovieRouteArgs> {
  MovieRoute({
    _i31.Key? key,
    required String movieId,
    String? playQueueId,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          MovieRoute.name,
          args: MovieRouteArgs(
            key: key,
            movieId: movieId,
            playQueueId: playQueueId,
          ),
          rawPathParams: {'movieId': movieId},
          rawQueryParams: {'playQueueId': playQueueId},
          initialChildren: children,
        );

  static const String name = 'MovieRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<MovieRouteArgs>(
        orElse: () => MovieRouteArgs(
          movieId: pathParams.getString('movieId'),
          playQueueId: queryParams.optString('playQueueId'),
        ),
      );
      return _i8.MoviePage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        movieId: args.movieId,
        playQueueId: args.playQueueId,
      );
    },
  );
}

class MovieRouteArgs {
  const MovieRouteArgs({this.key, required this.movieId, this.playQueueId});

  final _i31.Key? key;

  final String movieId;

  final String? playQueueId;

  @override
  String toString() {
    return 'MovieRouteArgs{key: $key, movieId: $movieId, playQueueId: $playQueueId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MovieRouteArgs) return false;
    return key == other.key &&
        movieId == other.movieId &&
        playQueueId == other.playQueueId;
  }

  @override
  int get hashCode => key.hashCode ^ movieId.hashCode ^ playQueueId.hashCode;
}

/// generated route for
/// [_i9.MusicPlayerPage]
class MusicPlayerRoute extends _i30.PageRouteInfo<void> {
  const MusicPlayerRoute({List<_i30.PageRouteInfo>? children})
      : super(MusicPlayerRoute.name, initialChildren: children);

  static const String name = 'MusicPlayerRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i9.MusicPlayerPage();
    },
  );
}

/// generated route for
/// [_i10.PersonPage]
class PersonRoute extends _i30.PageRouteInfo<PersonRouteArgs> {
  PersonRoute({
    _i31.Key? key,
    required String personId,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          PersonRoute.name,
          args: PersonRouteArgs(key: key, personId: personId),
          rawPathParams: {'personId': personId},
          initialChildren: children,
        );

  static const String name = 'PersonRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PersonRouteArgs>(
        orElse: () =>
            PersonRouteArgs(personId: pathParams.getString('personId')),
      );
      return _i10.PersonPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        personId: args.personId,
      );
    },
  );
}

class PersonRouteArgs {
  const PersonRouteArgs({this.key, required this.personId});

  final _i31.Key? key;

  final String personId;

  @override
  String toString() {
    return 'PersonRouteArgs{key: $key, personId: $personId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PersonRouteArgs) return false;
    return key == other.key && personId == other.personId;
  }

  @override
  int get hashCode => key.hashCode ^ personId.hashCode;
}

/// generated route for
/// [_i11.PodcastPage]
class PodcastRoute extends _i30.PageRouteInfo<PodcastRouteArgs> {
  PodcastRoute({
    _i31.Key? key,
    required String podcastId,
    String? playQueueId,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          PodcastRoute.name,
          args: PodcastRouteArgs(
            key: key,
            podcastId: podcastId,
            playQueueId: playQueueId,
          ),
          rawPathParams: {'podcastId': podcastId},
          rawQueryParams: {'playQueueId': playQueueId},
          initialChildren: children,
        );

  static const String name = 'PodcastRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<PodcastRouteArgs>(
        orElse: () => PodcastRouteArgs(
          podcastId: pathParams.getString('podcastId'),
          playQueueId: queryParams.optString('playQueueId'),
        ),
      );
      return _i11.PodcastPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        podcastId: args.podcastId,
        playQueueId: args.playQueueId,
      );
    },
  );
}

class PodcastRouteArgs {
  const PodcastRouteArgs({this.key, required this.podcastId, this.playQueueId});

  final _i31.Key? key;

  final String podcastId;

  final String? playQueueId;

  @override
  String toString() {
    return 'PodcastRouteArgs{key: $key, podcastId: $podcastId, playQueueId: $playQueueId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PodcastRouteArgs) return false;
    return key == other.key &&
        podcastId == other.podcastId &&
        playQueueId == other.playQueueId;
  }

  @override
  int get hashCode => key.hashCode ^ podcastId.hashCode ^ playQueueId.hashCode;
}

/// generated route for
/// [_i12.ReaderPage]
class ReaderRoute extends _i30.PageRouteInfo<ReaderRouteArgs> {
  ReaderRoute({
    _i32.Key? key,
    required String bookId,
    required String mediaFileId,
    String? nodeUrl,
    String? title,
    int? chapter,
    bool readAloud = false,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          ReaderRoute.name,
          args: ReaderRouteArgs(
            key: key,
            bookId: bookId,
            mediaFileId: mediaFileId,
            nodeUrl: nodeUrl,
            title: title,
            chapter: chapter,
            readAloud: readAloud,
          ),
          rawPathParams: {'bookId': bookId, 'mediaFileId': mediaFileId},
          rawQueryParams: {
            'nodeUrl': nodeUrl,
            'title': title,
            'chapter': chapter,
            'readAloud': readAloud,
          },
          initialChildren: children,
        );

  static const String name = 'ReaderRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<ReaderRouteArgs>(
        orElse: () => ReaderRouteArgs(
          bookId: pathParams.getString('bookId'),
          mediaFileId: pathParams.getString('mediaFileId'),
          nodeUrl: queryParams.optString('nodeUrl'),
          title: queryParams.optString('title'),
          chapter: queryParams.optInt('chapter'),
          readAloud: queryParams.getBool('readAloud', false),
        ),
      );
      return _i12.ReaderPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        bookId: args.bookId,
        mediaFileId: args.mediaFileId,
        nodeUrl: args.nodeUrl,
        title: args.title,
        chapter: args.chapter,
        readAloud: args.readAloud,
      );
    },
  );
}

class ReaderRouteArgs {
  const ReaderRouteArgs({
    this.key,
    required this.bookId,
    required this.mediaFileId,
    this.nodeUrl,
    this.title,
    this.chapter,
    this.readAloud = false,
  });

  final _i32.Key? key;

  final String bookId;

  final String mediaFileId;

  final String? nodeUrl;

  final String? title;

  final int? chapter;

  final bool readAloud;

  @override
  String toString() {
    return 'ReaderRouteArgs{key: $key, bookId: $bookId, mediaFileId: $mediaFileId, nodeUrl: $nodeUrl, title: $title, chapter: $chapter, readAloud: $readAloud}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ReaderRouteArgs) return false;
    return key == other.key &&
        bookId == other.bookId &&
        mediaFileId == other.mediaFileId &&
        nodeUrl == other.nodeUrl &&
        title == other.title &&
        chapter == other.chapter &&
        readAloud == other.readAloud;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      bookId.hashCode ^
      mediaFileId.hashCode ^
      nodeUrl.hashCode ^
      title.hashCode ^
      chapter.hashCode ^
      readAloud.hashCode;
}

/// generated route for
/// [_i13.RemoteControlPage]
class RemoteControlRoute extends _i30.PageRouteInfo<RemoteControlRouteArgs> {
  RemoteControlRoute({
    _i31.Key? key,
    required String serverName,
    required String playQueueId,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          RemoteControlRoute.name,
          args: RemoteControlRouteArgs(
            key: key,
            serverName: serverName,
            playQueueId: playQueueId,
          ),
          rawPathParams: {'serverName': serverName, 'playQueueId': playQueueId},
          initialChildren: children,
        );

  static const String name = 'RemoteControlRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<RemoteControlRouteArgs>(
        orElse: () => RemoteControlRouteArgs(
          serverName: pathParams.getString('serverName'),
          playQueueId: pathParams.getString('playQueueId'),
        ),
      );
      return _i13.RemoteControlPage(
        key: args.key,
        serverName: args.serverName,
        playQueueId: args.playQueueId,
      );
    },
  );
}

class RemoteControlRouteArgs {
  const RemoteControlRouteArgs({
    this.key,
    required this.serverName,
    required this.playQueueId,
  });

  final _i31.Key? key;

  final String serverName;

  final String playQueueId;

  @override
  String toString() {
    return 'RemoteControlRouteArgs{key: $key, serverName: $serverName, playQueueId: $playQueueId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RemoteControlRouteArgs) return false;
    return key == other.key &&
        serverName == other.serverName &&
        playQueueId == other.playQueueId;
  }

  @override
  int get hashCode => key.hashCode ^ serverName.hashCode ^ playQueueId.hashCode;
}

/// generated route for
/// [_i14.SearchPage]
class SearchRoute extends _i30.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    _i31.Key? key,
    String? libraryId,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(key: key, libraryId: libraryId),
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SearchRouteArgs>(
        orElse: () => SearchRouteArgs(),
      );
      return _i14.SearchPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        libraryId: args.libraryId,
      );
    },
  );
}

class SearchRouteArgs {
  const SearchRouteArgs({this.key, this.libraryId});

  final _i31.Key? key;

  final String? libraryId;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, libraryId: $libraryId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SearchRouteArgs) return false;
    return key == other.key && libraryId == other.libraryId;
  }

  @override
  int get hashCode => key.hashCode ^ libraryId.hashCode;
}

/// generated route for
/// [_i15.SeriesPage]
class SeriesRoute extends _i30.PageRouteInfo<SeriesRouteArgs> {
  SeriesRoute({
    _i31.Key? key,
    required String seriesId,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          SeriesRoute.name,
          args: SeriesRouteArgs(key: key, seriesId: seriesId),
          rawPathParams: {'seriesId': seriesId},
          initialChildren: children,
        );

  static const String name = 'SeriesRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SeriesRouteArgs>(
        orElse: () =>
            SeriesRouteArgs(seriesId: pathParams.getString('seriesId')),
      );
      return _i15.SeriesPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        seriesId: args.seriesId,
      );
    },
  );
}

class SeriesRouteArgs {
  const SeriesRouteArgs({this.key, required this.seriesId});

  final _i31.Key? key;

  final String seriesId;

  @override
  String toString() {
    return 'SeriesRouteArgs{key: $key, seriesId: $seriesId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SeriesRouteArgs) return false;
    return key == other.key && seriesId == other.seriesId;
  }

  @override
  int get hashCode => key.hashCode ^ seriesId.hashCode;
}

/// generated route for
/// [_i16.ServerActivityPage]
class ServerActivityRoute extends _i30.PageRouteInfo<ServerActivityRouteArgs> {
  ServerActivityRoute({_i31.Key? key, List<_i30.PageRouteInfo>? children})
      : super(
          ServerActivityRoute.name,
          args: ServerActivityRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServerActivityRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerActivityRouteArgs>(
        orElse: () => ServerActivityRouteArgs(),
      );
      return _i16.ServerActivityPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerActivityRouteArgs {
  const ServerActivityRouteArgs({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return 'ServerActivityRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerActivityRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i17.ServerHomeContentPage]
class ServerHomeContentRoute
    extends _i30.PageRouteInfo<ServerHomeContentRouteArgs> {
  ServerHomeContentRoute({_i31.Key? key, List<_i30.PageRouteInfo>? children})
      : super(
          ServerHomeContentRoute.name,
          args: ServerHomeContentRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServerHomeContentRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerHomeContentRouteArgs>(
        orElse: () => ServerHomeContentRouteArgs(),
      );
      return _i17.ServerHomeContentPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerHomeContentRouteArgs {
  const ServerHomeContentRouteArgs({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return 'ServerHomeContentRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerHomeContentRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i18.ServerHomeOverviewPage]
class ServerHomeOverviewRoute
    extends _i30.PageRouteInfo<ServerHomeOverviewRouteArgs> {
  ServerHomeOverviewRoute({_i31.Key? key, List<_i30.PageRouteInfo>? children})
      : super(
          ServerHomeOverviewRoute.name,
          args: ServerHomeOverviewRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServerHomeOverviewRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerHomeOverviewRouteArgs>(
        orElse: () => ServerHomeOverviewRouteArgs(),
      );
      return _i18.ServerHomeOverviewPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerHomeOverviewRouteArgs {
  const ServerHomeOverviewRouteArgs({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return 'ServerHomeOverviewRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerHomeOverviewRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i19.ServerHomePage]
class ServerHomeRoute extends _i30.PageRouteInfo<ServerHomeRouteArgs> {
  ServerHomeRoute({
    _i31.Key? key,
    required String serverName,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          ServerHomeRoute.name,
          args: ServerHomeRouteArgs(key: key, serverName: serverName),
          rawPathParams: {'serverName': serverName},
          initialChildren: children,
        );

  static const String name = 'ServerHomeRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerHomeRouteArgs>(
        orElse: () =>
            ServerHomeRouteArgs(serverName: pathParams.getString('serverName')),
      );
      return _i19.ServerHomePage(key: args.key, serverName: args.serverName);
    },
  );
}

class ServerHomeRouteArgs {
  const ServerHomeRouteArgs({this.key, required this.serverName});

  final _i31.Key? key;

  final String serverName;

  @override
  String toString() {
    return 'ServerHomeRouteArgs{key: $key, serverName: $serverName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerHomeRouteArgs) return false;
    return key == other.key && serverName == other.serverName;
  }

  @override
  int get hashCode => key.hashCode ^ serverName.hashCode;
}

/// generated route for
/// [_i20.ServerNowPlayingPage]
class ServerNowPlayingRoute
    extends _i30.PageRouteInfo<ServerNowPlayingRouteArgs> {
  ServerNowPlayingRoute({_i31.Key? key, List<_i30.PageRouteInfo>? children})
      : super(
          ServerNowPlayingRoute.name,
          args: ServerNowPlayingRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServerNowPlayingRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerNowPlayingRouteArgs>(
        orElse: () => ServerNowPlayingRouteArgs(),
      );
      return _i20.ServerNowPlayingPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerNowPlayingRouteArgs {
  const ServerNowPlayingRouteArgs({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return 'ServerNowPlayingRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerNowPlayingRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i21.ServerSettingsAboutPage]
class ServerSettingsAboutRoute
    extends _i30.PageRouteInfo<ServerSettingsAboutRouteArgs> {
  ServerSettingsAboutRoute({_i31.Key? key, List<_i30.PageRouteInfo>? children})
      : super(
          ServerSettingsAboutRoute.name,
          args: ServerSettingsAboutRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServerSettingsAboutRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerSettingsAboutRouteArgs>(
        orElse: () => ServerSettingsAboutRouteArgs(),
      );
      return _i21.ServerSettingsAboutPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerSettingsAboutRouteArgs {
  const ServerSettingsAboutRouteArgs({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return 'ServerSettingsAboutRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerSettingsAboutRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i22.ServerSettingsClusterPage]
class ServerSettingsClusterRoute
    extends _i30.PageRouteInfo<ServerSettingsClusterRouteArgs> {
  ServerSettingsClusterRoute({
    _i31.Key? key,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          ServerSettingsClusterRoute.name,
          args: ServerSettingsClusterRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServerSettingsClusterRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerSettingsClusterRouteArgs>(
        orElse: () => ServerSettingsClusterRouteArgs(),
      );
      return _i22.ServerSettingsClusterPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerSettingsClusterRouteArgs {
  const ServerSettingsClusterRouteArgs({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return 'ServerSettingsClusterRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerSettingsClusterRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i23.ServerSettingsLanguagePage]
class ServerSettingsLanguageRoute
    extends _i30.PageRouteInfo<ServerSettingsLanguageRouteArgs> {
  ServerSettingsLanguageRoute({
    _i31.Key? key,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          ServerSettingsLanguageRoute.name,
          args: ServerSettingsLanguageRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServerSettingsLanguageRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerSettingsLanguageRouteArgs>(
        orElse: () => ServerSettingsLanguageRouteArgs(),
      );
      return _i23.ServerSettingsLanguagePage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerSettingsLanguageRouteArgs {
  const ServerSettingsLanguageRouteArgs({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return 'ServerSettingsLanguageRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerSettingsLanguageRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i24.ServerSettingsPage]
class ServerSettingsRoute extends _i30.PageRouteInfo<ServerSettingsRouteArgs> {
  ServerSettingsRoute({_i32.Key? key, List<_i30.PageRouteInfo>? children})
      : super(
          ServerSettingsRoute.name,
          args: ServerSettingsRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServerSettingsRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerSettingsRouteArgs>(
        orElse: () => ServerSettingsRouteArgs(),
      );
      return _i24.ServerSettingsPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerSettingsRouteArgs {
  const ServerSettingsRouteArgs({this.key});

  final _i32.Key? key;

  @override
  String toString() {
    return 'ServerSettingsRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerSettingsRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i25.ServerSettingsPlaybackPage]
class ServerSettingsPlaybackRoute
    extends _i30.PageRouteInfo<ServerSettingsPlaybackRouteArgs> {
  ServerSettingsPlaybackRoute({
    _i32.Key? key,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          ServerSettingsPlaybackRoute.name,
          args: ServerSettingsPlaybackRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServerSettingsPlaybackRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerSettingsPlaybackRouteArgs>(
        orElse: () => ServerSettingsPlaybackRouteArgs(),
      );
      return _i25.ServerSettingsPlaybackPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerSettingsPlaybackRouteArgs {
  const ServerSettingsPlaybackRouteArgs({this.key});

  final _i32.Key? key;

  @override
  String toString() {
    return 'ServerSettingsPlaybackRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerSettingsPlaybackRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i26.ShowEpisodePage]
class ShowEpisodeRoute extends _i30.PageRouteInfo<ShowEpisodeRouteArgs> {
  ShowEpisodeRoute({
    _i31.Key? key,
    required String showId,
    required String episodeId,
    String? playQueueId,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          ShowEpisodeRoute.name,
          args: ShowEpisodeRouteArgs(
            key: key,
            showId: showId,
            episodeId: episodeId,
            playQueueId: playQueueId,
          ),
          rawPathParams: {'showId': showId, 'episodeId': episodeId},
          rawQueryParams: {'playQueueId': playQueueId},
          initialChildren: children,
        );

  static const String name = 'ShowEpisodeRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<ShowEpisodeRouteArgs>(
        orElse: () => ShowEpisodeRouteArgs(
          showId: pathParams.getString('showId'),
          episodeId: pathParams.getString('episodeId'),
          playQueueId: queryParams.optString('playQueueId'),
        ),
      );
      return _i26.ShowEpisodePage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        showId: args.showId,
        episodeId: args.episodeId,
        playQueueId: args.playQueueId,
      );
    },
  );
}

class ShowEpisodeRouteArgs {
  const ShowEpisodeRouteArgs({
    this.key,
    required this.showId,
    required this.episodeId,
    this.playQueueId,
  });

  final _i31.Key? key;

  final String showId;

  final String episodeId;

  final String? playQueueId;

  @override
  String toString() {
    return 'ShowEpisodeRouteArgs{key: $key, showId: $showId, episodeId: $episodeId, playQueueId: $playQueueId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ShowEpisodeRouteArgs) return false;
    return key == other.key &&
        showId == other.showId &&
        episodeId == other.episodeId &&
        playQueueId == other.playQueueId;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      showId.hashCode ^
      episodeId.hashCode ^
      playQueueId.hashCode;
}

/// generated route for
/// [_i27.ShowHomePage]
class ShowHomeRoute extends _i30.PageRouteInfo<ShowHomeRouteArgs> {
  ShowHomeRoute({_i31.Key? key, List<_i30.PageRouteInfo>? children})
      : super(
          ShowHomeRoute.name,
          args: ShowHomeRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ShowHomeRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowHomeRouteArgs>(
        orElse: () => ShowHomeRouteArgs(),
      );
      return _i27.ShowHomePage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ShowHomeRouteArgs {
  const ShowHomeRouteArgs({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return 'ShowHomeRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ShowHomeRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i28.ShowOverviewContentPage]
class ShowOverviewContentRoute
    extends _i30.PageRouteInfo<ShowOverviewContentRouteArgs> {
  ShowOverviewContentRoute({
    _i31.Key? key,
    required String showId,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          ShowOverviewContentRoute.name,
          args: ShowOverviewContentRouteArgs(key: key, showId: showId),
          rawPathParams: {'showId': showId},
          initialChildren: children,
        );

  static const String name = 'ShowOverviewContentRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowOverviewContentRouteArgs>(
        orElse: () => ShowOverviewContentRouteArgs(
          showId: pathParams.getString('showId'),
        ),
      );
      return _i28.ShowOverviewContentPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        showId: args.showId,
      );
    },
  );
}

class ShowOverviewContentRouteArgs {
  const ShowOverviewContentRouteArgs({this.key, required this.showId});

  final _i31.Key? key;

  final String showId;

  @override
  String toString() {
    return 'ShowOverviewContentRouteArgs{key: $key, showId: $showId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ShowOverviewContentRouteArgs) return false;
    return key == other.key && showId == other.showId;
  }

  @override
  int get hashCode => key.hashCode ^ showId.hashCode;
}

/// generated route for
/// [_i29.ShowOverviewPage]
class ShowOverviewRoute extends _i30.PageRouteInfo<ShowOverviewRouteArgs> {
  ShowOverviewRoute({
    _i31.Key? key,
    required String showId,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          ShowOverviewRoute.name,
          args: ShowOverviewRouteArgs(key: key, showId: showId),
          rawPathParams: {'showId': showId},
          initialChildren: children,
        );

  static const String name = 'ShowOverviewRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowOverviewRouteArgs>(
        orElse: () =>
            ShowOverviewRouteArgs(showId: pathParams.getString('showId')),
      );
      return _i29.ShowOverviewPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        showId: args.showId,
      );
    },
  );
}

class ShowOverviewRouteArgs {
  const ShowOverviewRouteArgs({this.key, required this.showId});

  final _i31.Key? key;

  final String showId;

  @override
  String toString() {
    return 'ShowOverviewRouteArgs{key: $key, showId: $showId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ShowOverviewRouteArgs) return false;
    return key == other.key && showId == other.showId;
  }

  @override
  int get hashCode => key.hashCode ^ showId.hashCode;
}
