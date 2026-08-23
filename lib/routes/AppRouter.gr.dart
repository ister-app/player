// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i43;
import 'package:flutter/foundation.dart' as _i45;
import 'package:flutter/material.dart' as _i44;
import 'package:player/pages/AddServerPage.dart' as _i1;
import 'package:player/pages/AdminLibrariesPage.dart' as _i2;
import 'package:player/pages/AdminUserAccessPage.dart' as _i3;
import 'package:player/pages/AdminUsersPage.dart' as _i4;
import 'package:player/pages/AlbumPage.dart' as _i5;
import 'package:player/pages/BookPage.dart' as _i6;
import 'package:player/pages/CastListPage.dart' as _i7;
import 'package:player/pages/ComicReaderPage.dart' as _i8;
import 'package:player/pages/DownloadSettingsPage.dart' as _i9;
import 'package:player/pages/DownloadsPage.dart' as _i10;
import 'package:player/pages/HomePage.dart' as _i11;
import 'package:player/pages/LocalVideoPage.dart' as _i12;
import 'package:player/pages/MediaListPage.dart' as _i13;
import 'package:player/pages/MoviePage.dart' as _i14;
import 'package:player/pages/MusicPlayerPage.dart' as _i15;
import 'package:player/pages/OfflineReaderPage.dart' as _i16;
import 'package:player/pages/PersonPage.dart' as _i17;
import 'package:player/pages/PlaylistListPage.dart' as _i18;
import 'package:player/pages/PlaylistPage.dart' as _i19;
import 'package:player/pages/PodcastPage.dart' as _i20;
import 'package:player/pages/ReaderPage.dart' as _i21;
import 'package:player/pages/RemoteControlPage.dart' as _i22;
import 'package:player/pages/SearchPage.dart' as _i23;
import 'package:player/pages/SeriesPage.dart' as _i24;
import 'package:player/pages/ServerActivityPage.dart' as _i25;
import 'package:player/pages/ServerDownloadsPages.dart' as _i26;
import 'package:player/pages/ServerHomeContentPage.dart' as _i27;
import 'package:player/pages/ServerHomeOverviewPage.dart' as _i28;
import 'package:player/pages/ServerHomePage.dart' as _i29;
import 'package:player/pages/ServerNowPlayingPage.dart' as _i30;
import 'package:player/pages/ServerSettingsAboutPage.dart' as _i31;
import 'package:player/pages/ServerSettingsClusterPage.dart' as _i32;
import 'package:player/pages/ServerSettingsDevicesPage.dart' as _i33;
import 'package:player/pages/ServerSettingsLanguagePage.dart' as _i34;
import 'package:player/pages/ServerSettingsPage.dart' as _i35;
import 'package:player/pages/ServerSettingsPlaybackPage.dart' as _i36;
import 'package:player/pages/ServerSettingsSharingPage.dart' as _i37;
import 'package:player/pages/ShowEpisodePage.dart' as _i38;
import 'package:player/pages/ShowHomePage.dart' as _i39;
import 'package:player/pages/ShowOverviewContentPage.dart' as _i40;
import 'package:player/pages/ShowOverviewPage.dart' as _i41;
import 'package:player/pages/SleepTimerSettingsPage.dart' as _i42;

/// generated route for
/// [_i1.AddServerPage]
class AddServerRoute extends _i43.PageRouteInfo<AddServerRouteArgs> {
  AddServerRoute({
    _i44.Key? key,
    bool firstRun = false,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         AddServerRoute.name,
         args: AddServerRouteArgs(key: key, firstRun: firstRun),
         initialChildren: children,
       );

  static const String name = 'AddServerRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddServerRouteArgs>(
        orElse: () => const AddServerRouteArgs(),
      );
      return _i1.AddServerPage(key: args.key, firstRun: args.firstRun);
    },
  );
}

class AddServerRouteArgs {
  const AddServerRouteArgs({this.key, this.firstRun = false});

  final _i44.Key? key;

  final bool firstRun;

  @override
  String toString() {
    return 'AddServerRouteArgs{key: $key, firstRun: $firstRun}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AddServerRouteArgs) return false;
    return key == other.key && firstRun == other.firstRun;
  }

  @override
  int get hashCode => key.hashCode ^ firstRun.hashCode;
}

/// generated route for
/// [_i2.AdminLibrariesPage]
class AdminLibrariesRoute extends _i43.PageRouteInfo<AdminLibrariesRouteArgs> {
  AdminLibrariesRoute({_i44.Key? key, List<_i43.PageRouteInfo>? children})
    : super(
        AdminLibrariesRoute.name,
        args: AdminLibrariesRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'AdminLibrariesRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<AdminLibrariesRouteArgs>(
        orElse: () => AdminLibrariesRouteArgs(),
      );
      return _i2.AdminLibrariesPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class AdminLibrariesRouteArgs {
  const AdminLibrariesRouteArgs({this.key});

  final _i44.Key? key;

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
/// [_i3.AdminUserAccessPage]
class AdminUserAccessRoute
    extends _i43.PageRouteInfo<AdminUserAccessRouteArgs> {
  AdminUserAccessRoute({
    _i44.Key? key,
    required String userId,
    String? userName,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         AdminUserAccessRoute.name,
         args: AdminUserAccessRouteArgs(
           key: key,
           userId: userId,
           userName: userName,
         ),
         rawPathParams: {'userId': userId},
         rawQueryParams: {'userName': userName},
         initialChildren: children,
       );

  static const String name = 'AdminUserAccessRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<AdminUserAccessRouteArgs>(
        orElse: () => AdminUserAccessRouteArgs(
          userId: pathParams.getString('userId'),
          userName: queryParams.optString('userName'),
        ),
      );
      return _i3.AdminUserAccessPage(
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
    this.userName,
  });

  final _i44.Key? key;

  final String userId;

  final String? userName;

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
/// [_i4.AdminUsersPage]
class AdminUsersRoute extends _i43.PageRouteInfo<AdminUsersRouteArgs> {
  AdminUsersRoute({_i44.Key? key, List<_i43.PageRouteInfo>? children})
    : super(
        AdminUsersRoute.name,
        args: AdminUsersRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'AdminUsersRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<AdminUsersRouteArgs>(
        orElse: () => AdminUsersRouteArgs(),
      );
      return _i4.AdminUsersPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class AdminUsersRouteArgs {
  const AdminUsersRouteArgs({this.key});

  final _i44.Key? key;

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
/// [_i5.AlbumPage]
class AlbumRoute extends _i43.PageRouteInfo<AlbumRouteArgs> {
  AlbumRoute({
    _i44.Key? key,
    required String albumId,
    String? playQueueId,
    String? trackId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         AlbumRoute.name,
         args: AlbumRouteArgs(
           key: key,
           albumId: albumId,
           playQueueId: playQueueId,
           trackId: trackId,
         ),
         rawPathParams: {'albumId': albumId},
         rawQueryParams: {'playQueueId': playQueueId, 'trackId': trackId},
         initialChildren: children,
       );

  static const String name = 'AlbumRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<AlbumRouteArgs>(
        orElse: () => AlbumRouteArgs(
          albumId: pathParams.getString('albumId'),
          playQueueId: queryParams.optString('playQueueId'),
          trackId: queryParams.optString('trackId'),
        ),
      );
      return _i5.AlbumPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        albumId: args.albumId,
        playQueueId: args.playQueueId,
        trackId: args.trackId,
      );
    },
  );
}

class AlbumRouteArgs {
  const AlbumRouteArgs({
    this.key,
    required this.albumId,
    this.playQueueId,
    this.trackId,
  });

  final _i44.Key? key;

  final String albumId;

  final String? playQueueId;

  final String? trackId;

  @override
  String toString() {
    return 'AlbumRouteArgs{key: $key, albumId: $albumId, playQueueId: $playQueueId, trackId: $trackId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AlbumRouteArgs) return false;
    return key == other.key &&
        albumId == other.albumId &&
        playQueueId == other.playQueueId &&
        trackId == other.trackId;
  }

  @override
  int get hashCode =>
      key.hashCode ^ albumId.hashCode ^ playQueueId.hashCode ^ trackId.hashCode;
}

/// generated route for
/// [_i6.BookPage]
class BookRoute extends _i43.PageRouteInfo<BookRouteArgs> {
  BookRoute({
    _i44.Key? key,
    required String bookId,
    String? playQueueId,
    List<_i43.PageRouteInfo>? children,
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

  static _i43.PageInfo page = _i43.PageInfo(
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
      return _i6.BookPage(
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

  final _i44.Key? key;

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
/// [_i7.CastListPage]
class CastListRoute extends _i43.PageRouteInfo<CastListRouteArgs> {
  CastListRoute({
    _i44.Key? key,
    String? showId,
    String? movieId,
    String? episodeId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         CastListRoute.name,
         args: CastListRouteArgs(
           key: key,
           showId: showId,
           movieId: movieId,
           episodeId: episodeId,
         ),
         rawQueryParams: {
           'showId': showId,
           'movieId': movieId,
           'episodeId': episodeId,
         },
         initialChildren: children,
       );

  static const String name = 'CastListRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<CastListRouteArgs>(
        orElse: () => CastListRouteArgs(
          showId: queryParams.optString('showId'),
          movieId: queryParams.optString('movieId'),
          episodeId: queryParams.optString('episodeId'),
        ),
      );
      return _i7.CastListPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        showId: args.showId,
        movieId: args.movieId,
        episodeId: args.episodeId,
      );
    },
  );
}

class CastListRouteArgs {
  const CastListRouteArgs({
    this.key,
    this.showId,
    this.movieId,
    this.episodeId,
  });

  final _i44.Key? key;

  final String? showId;

  final String? movieId;

  final String? episodeId;

  @override
  String toString() {
    return 'CastListRouteArgs{key: $key, showId: $showId, movieId: $movieId, episodeId: $episodeId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CastListRouteArgs) return false;
    return key == other.key &&
        showId == other.showId &&
        movieId == other.movieId &&
        episodeId == other.episodeId;
  }

  @override
  int get hashCode =>
      key.hashCode ^ showId.hashCode ^ movieId.hashCode ^ episodeId.hashCode;
}

/// generated route for
/// [_i8.ComicReaderPage]
class ComicReaderRoute extends _i43.PageRouteInfo<ComicReaderRouteArgs> {
  ComicReaderRoute({
    _i45.Key? key,
    required String bookId,
    required String mediaFileId,
    String? nodeUrl,
    String? title,
    String? seriesId,
    int? page,
    List<_i43.PageRouteInfo>? children,
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

  static _i43.PageInfo page = _i43.PageInfo(
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
      return _i8.ComicReaderPage(
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

  final _i45.Key? key;

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
/// [_i9.DownloadSettingsPage]
class DownloadSettingsRoute
    extends _i43.PageRouteInfo<DownloadSettingsRouteArgs> {
  DownloadSettingsRoute({
    _i44.Key? key,
    required String serverName,
    bool inShell = false,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         DownloadSettingsRoute.name,
         args: DownloadSettingsRouteArgs(
           key: key,
           serverName: serverName,
           inShell: inShell,
         ),
         rawPathParams: {'serverName': serverName},
         initialChildren: children,
       );

  static const String name = 'DownloadSettingsRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<DownloadSettingsRouteArgs>(
        orElse: () => DownloadSettingsRouteArgs(
          serverName: pathParams.getString('serverName'),
        ),
      );
      return _i9.DownloadSettingsPage(
        key: args.key,
        serverName: args.serverName,
        inShell: args.inShell,
      );
    },
  );
}

class DownloadSettingsRouteArgs {
  const DownloadSettingsRouteArgs({
    this.key,
    required this.serverName,
    this.inShell = false,
  });

  final _i44.Key? key;

  final String serverName;

  final bool inShell;

  @override
  String toString() {
    return 'DownloadSettingsRouteArgs{key: $key, serverName: $serverName, inShell: $inShell}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DownloadSettingsRouteArgs) return false;
    return key == other.key &&
        serverName == other.serverName &&
        inShell == other.inShell;
  }

  @override
  int get hashCode => key.hashCode ^ serverName.hashCode ^ inShell.hashCode;
}

/// generated route for
/// [_i10.DownloadsPage]
class DownloadsRoute extends _i43.PageRouteInfo<DownloadsRouteArgs> {
  DownloadsRoute({
    _i44.Key? key,
    required String serverName,
    bool inShell = false,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         DownloadsRoute.name,
         args: DownloadsRouteArgs(
           key: key,
           serverName: serverName,
           inShell: inShell,
         ),
         rawPathParams: {'serverName': serverName},
         initialChildren: children,
       );

  static const String name = 'DownloadsRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<DownloadsRouteArgs>(
        orElse: () =>
            DownloadsRouteArgs(serverName: pathParams.getString('serverName')),
      );
      return _i10.DownloadsPage(
        key: args.key,
        serverName: args.serverName,
        inShell: args.inShell,
      );
    },
  );
}

class DownloadsRouteArgs {
  const DownloadsRouteArgs({
    this.key,
    required this.serverName,
    this.inShell = false,
  });

  final _i44.Key? key;

  final String serverName;

  final bool inShell;

  @override
  String toString() {
    return 'DownloadsRouteArgs{key: $key, serverName: $serverName, inShell: $inShell}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DownloadsRouteArgs) return false;
    return key == other.key &&
        serverName == other.serverName &&
        inShell == other.inShell;
  }

  @override
  int get hashCode => key.hashCode ^ serverName.hashCode ^ inShell.hashCode;
}

/// generated route for
/// [_i11.HomePage]
class HomeRoute extends _i43.PageRouteInfo<void> {
  const HomeRoute({List<_i43.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i11.HomePage();
    },
  );
}

/// generated route for
/// [_i12.LocalVideoPage]
class LocalVideoRoute extends _i43.PageRouteInfo<LocalVideoRouteArgs> {
  LocalVideoRoute({
    _i44.Key? key,
    required String serverName,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         LocalVideoRoute.name,
         args: LocalVideoRouteArgs(key: key, serverName: serverName),
         rawPathParams: {'serverName': serverName},
         initialChildren: children,
       );

  static const String name = 'LocalVideoRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<LocalVideoRouteArgs>(
        orElse: () =>
            LocalVideoRouteArgs(serverName: pathParams.getString('serverName')),
      );
      return _i12.LocalVideoPage(key: args.key, serverName: args.serverName);
    },
  );
}

class LocalVideoRouteArgs {
  const LocalVideoRouteArgs({this.key, required this.serverName});

  final _i44.Key? key;

  final String serverName;

  @override
  String toString() {
    return 'LocalVideoRouteArgs{key: $key, serverName: $serverName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LocalVideoRouteArgs) return false;
    return key == other.key && serverName == other.serverName;
  }

  @override
  int get hashCode => key.hashCode ^ serverName.hashCode;
}

/// generated route for
/// [_i13.MediaListPage]
class MediaListRoute extends _i43.PageRouteInfo<MediaListRouteArgs> {
  MediaListRoute({
    _i44.Key? key,
    String? kindName,
    String? libraryId,
    String? libraryTypeName,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         MediaListRoute.name,
         args: MediaListRouteArgs(
           key: key,
           kindName: kindName,
           libraryId: libraryId,
           libraryTypeName: libraryTypeName,
         ),
         rawQueryParams: {
           'kind': kindName,
           'libraryId': libraryId,
           'libraryType': libraryTypeName,
         },
         initialChildren: children,
       );

  static const String name = 'MediaListRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<MediaListRouteArgs>(
        orElse: () => MediaListRouteArgs(
          kindName: queryParams.optString('kind'),
          libraryId: queryParams.optString('libraryId'),
          libraryTypeName: queryParams.optString('libraryType'),
        ),
      );
      return _i13.MediaListPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        kindName: args.kindName,
        libraryId: args.libraryId,
        libraryTypeName: args.libraryTypeName,
      );
    },
  );
}

class MediaListRouteArgs {
  const MediaListRouteArgs({
    this.key,
    this.kindName,
    this.libraryId,
    this.libraryTypeName,
  });

  final _i44.Key? key;

  final String? kindName;

  final String? libraryId;

  final String? libraryTypeName;

  @override
  String toString() {
    return 'MediaListRouteArgs{key: $key, kindName: $kindName, libraryId: $libraryId, libraryTypeName: $libraryTypeName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MediaListRouteArgs) return false;
    return key == other.key &&
        kindName == other.kindName &&
        libraryId == other.libraryId &&
        libraryTypeName == other.libraryTypeName;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      kindName.hashCode ^
      libraryId.hashCode ^
      libraryTypeName.hashCode;
}

/// generated route for
/// [_i14.MoviePage]
class MovieRoute extends _i43.PageRouteInfo<MovieRouteArgs> {
  MovieRoute({
    _i44.Key? key,
    required String movieId,
    String? playQueueId,
    List<_i43.PageRouteInfo>? children,
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

  static _i43.PageInfo page = _i43.PageInfo(
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
      return _i14.MoviePage(
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

  final _i44.Key? key;

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
/// [_i15.MusicPlayerPage]
class MusicPlayerRoute extends _i43.PageRouteInfo<void> {
  const MusicPlayerRoute({List<_i43.PageRouteInfo>? children})
    : super(MusicPlayerRoute.name, initialChildren: children);

  static const String name = 'MusicPlayerRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i15.MusicPlayerPage();
    },
  );
}

/// generated route for
/// [_i16.OfflineComicReaderPage]
class OfflineComicReaderRoute
    extends _i43.PageRouteInfo<OfflineComicReaderRouteArgs> {
  OfflineComicReaderRoute({
    _i44.Key? key,
    required String serverName,
    required String bookId,
    required String mediaFileId,
    String? nodeUrl,
    String? title,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         OfflineComicReaderRoute.name,
         args: OfflineComicReaderRouteArgs(
           key: key,
           serverName: serverName,
           bookId: bookId,
           mediaFileId: mediaFileId,
           nodeUrl: nodeUrl,
           title: title,
         ),
         rawPathParams: {
           'serverName': serverName,
           'bookId': bookId,
           'mediaFileId': mediaFileId,
         },
         rawQueryParams: {'nodeUrl': nodeUrl, 'title': title},
         initialChildren: children,
       );

  static const String name = 'OfflineComicReaderRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<OfflineComicReaderRouteArgs>(
        orElse: () => OfflineComicReaderRouteArgs(
          serverName: pathParams.getString('serverName'),
          bookId: pathParams.getString('bookId'),
          mediaFileId: pathParams.getString('mediaFileId'),
          nodeUrl: queryParams.optString('nodeUrl'),
          title: queryParams.optString('title'),
        ),
      );
      return _i16.OfflineComicReaderPage(
        key: args.key,
        serverName: args.serverName,
        bookId: args.bookId,
        mediaFileId: args.mediaFileId,
        nodeUrl: args.nodeUrl,
        title: args.title,
      );
    },
  );
}

class OfflineComicReaderRouteArgs {
  const OfflineComicReaderRouteArgs({
    this.key,
    required this.serverName,
    required this.bookId,
    required this.mediaFileId,
    this.nodeUrl,
    this.title,
  });

  final _i44.Key? key;

  final String serverName;

  final String bookId;

  final String mediaFileId;

  final String? nodeUrl;

  final String? title;

  @override
  String toString() {
    return 'OfflineComicReaderRouteArgs{key: $key, serverName: $serverName, bookId: $bookId, mediaFileId: $mediaFileId, nodeUrl: $nodeUrl, title: $title}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OfflineComicReaderRouteArgs) return false;
    return key == other.key &&
        serverName == other.serverName &&
        bookId == other.bookId &&
        mediaFileId == other.mediaFileId &&
        nodeUrl == other.nodeUrl &&
        title == other.title;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      serverName.hashCode ^
      bookId.hashCode ^
      mediaFileId.hashCode ^
      nodeUrl.hashCode ^
      title.hashCode;
}

/// generated route for
/// [_i16.OfflineReaderPage]
class OfflineReaderRoute extends _i43.PageRouteInfo<OfflineReaderRouteArgs> {
  OfflineReaderRoute({
    _i44.Key? key,
    required String serverName,
    required String bookId,
    required String mediaFileId,
    String? nodeUrl,
    String? title,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         OfflineReaderRoute.name,
         args: OfflineReaderRouteArgs(
           key: key,
           serverName: serverName,
           bookId: bookId,
           mediaFileId: mediaFileId,
           nodeUrl: nodeUrl,
           title: title,
         ),
         rawPathParams: {
           'serverName': serverName,
           'bookId': bookId,
           'mediaFileId': mediaFileId,
         },
         rawQueryParams: {'nodeUrl': nodeUrl, 'title': title},
         initialChildren: children,
       );

  static const String name = 'OfflineReaderRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<OfflineReaderRouteArgs>(
        orElse: () => OfflineReaderRouteArgs(
          serverName: pathParams.getString('serverName'),
          bookId: pathParams.getString('bookId'),
          mediaFileId: pathParams.getString('mediaFileId'),
          nodeUrl: queryParams.optString('nodeUrl'),
          title: queryParams.optString('title'),
        ),
      );
      return _i16.OfflineReaderPage(
        key: args.key,
        serverName: args.serverName,
        bookId: args.bookId,
        mediaFileId: args.mediaFileId,
        nodeUrl: args.nodeUrl,
        title: args.title,
      );
    },
  );
}

class OfflineReaderRouteArgs {
  const OfflineReaderRouteArgs({
    this.key,
    required this.serverName,
    required this.bookId,
    required this.mediaFileId,
    this.nodeUrl,
    this.title,
  });

  final _i44.Key? key;

  final String serverName;

  final String bookId;

  final String mediaFileId;

  final String? nodeUrl;

  final String? title;

  @override
  String toString() {
    return 'OfflineReaderRouteArgs{key: $key, serverName: $serverName, bookId: $bookId, mediaFileId: $mediaFileId, nodeUrl: $nodeUrl, title: $title}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OfflineReaderRouteArgs) return false;
    return key == other.key &&
        serverName == other.serverName &&
        bookId == other.bookId &&
        mediaFileId == other.mediaFileId &&
        nodeUrl == other.nodeUrl &&
        title == other.title;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      serverName.hashCode ^
      bookId.hashCode ^
      mediaFileId.hashCode ^
      nodeUrl.hashCode ^
      title.hashCode;
}

/// generated route for
/// [_i17.PersonPage]
class PersonRoute extends _i43.PageRouteInfo<PersonRouteArgs> {
  PersonRoute({
    _i44.Key? key,
    required String personId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         PersonRoute.name,
         args: PersonRouteArgs(key: key, personId: personId),
         rawPathParams: {'personId': personId},
         initialChildren: children,
       );

  static const String name = 'PersonRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PersonRouteArgs>(
        orElse: () =>
            PersonRouteArgs(personId: pathParams.getString('personId')),
      );
      return _i17.PersonPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        personId: args.personId,
      );
    },
  );
}

class PersonRouteArgs {
  const PersonRouteArgs({this.key, required this.personId});

  final _i44.Key? key;

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
/// [_i18.PlaylistListPage]
class PlaylistListRoute extends _i43.PageRouteInfo<PlaylistListRouteArgs> {
  PlaylistListRoute({
    _i44.Key? key,
    String? libraryId,
    String? libraryTypeName,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         PlaylistListRoute.name,
         args: PlaylistListRouteArgs(
           key: key,
           libraryId: libraryId,
           libraryTypeName: libraryTypeName,
         ),
         rawQueryParams: {
           'libraryId': libraryId,
           'libraryType': libraryTypeName,
         },
         initialChildren: children,
       );

  static const String name = 'PlaylistListRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<PlaylistListRouteArgs>(
        orElse: () => PlaylistListRouteArgs(
          libraryId: queryParams.optString('libraryId'),
          libraryTypeName: queryParams.optString('libraryType'),
        ),
      );
      return _i18.PlaylistListPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        libraryId: args.libraryId,
        libraryTypeName: args.libraryTypeName,
      );
    },
  );
}

class PlaylistListRouteArgs {
  const PlaylistListRouteArgs({this.key, this.libraryId, this.libraryTypeName});

  final _i44.Key? key;

  final String? libraryId;

  final String? libraryTypeName;

  @override
  String toString() {
    return 'PlaylistListRouteArgs{key: $key, libraryId: $libraryId, libraryTypeName: $libraryTypeName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PlaylistListRouteArgs) return false;
    return key == other.key &&
        libraryId == other.libraryId &&
        libraryTypeName == other.libraryTypeName;
  }

  @override
  int get hashCode =>
      key.hashCode ^ libraryId.hashCode ^ libraryTypeName.hashCode;
}

/// generated route for
/// [_i19.PlaylistPage]
class PlaylistRoute extends _i43.PageRouteInfo<PlaylistRouteArgs> {
  PlaylistRoute({
    _i44.Key? key,
    required String playlistId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         PlaylistRoute.name,
         args: PlaylistRouteArgs(key: key, playlistId: playlistId),
         rawPathParams: {'playlistId': playlistId},
         initialChildren: children,
       );

  static const String name = 'PlaylistRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PlaylistRouteArgs>(
        orElse: () =>
            PlaylistRouteArgs(playlistId: pathParams.getString('playlistId')),
      );
      return _i19.PlaylistPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        playlistId: args.playlistId,
      );
    },
  );
}

class PlaylistRouteArgs {
  const PlaylistRouteArgs({this.key, required this.playlistId});

  final _i44.Key? key;

  final String playlistId;

  @override
  String toString() {
    return 'PlaylistRouteArgs{key: $key, playlistId: $playlistId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PlaylistRouteArgs) return false;
    return key == other.key && playlistId == other.playlistId;
  }

  @override
  int get hashCode => key.hashCode ^ playlistId.hashCode;
}

/// generated route for
/// [_i20.PodcastPage]
class PodcastRoute extends _i43.PageRouteInfo<PodcastRouteArgs> {
  PodcastRoute({
    _i44.Key? key,
    required String podcastId,
    String? playQueueId,
    List<_i43.PageRouteInfo>? children,
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

  static _i43.PageInfo page = _i43.PageInfo(
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
      return _i20.PodcastPage(
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

  final _i44.Key? key;

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
/// [_i21.ReaderPage]
class ReaderRoute extends _i43.PageRouteInfo<ReaderRouteArgs> {
  ReaderRoute({
    _i45.Key? key,
    required String bookId,
    required String mediaFileId,
    String? nodeUrl,
    String? title,
    int? chapter,
    bool readAloud = false,
    List<_i43.PageRouteInfo>? children,
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

  static _i43.PageInfo page = _i43.PageInfo(
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
      return _i21.ReaderPage(
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

  final _i45.Key? key;

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
/// [_i22.RemoteControlPage]
class RemoteControlRoute extends _i43.PageRouteInfo<RemoteControlRouteArgs> {
  RemoteControlRoute({
    _i44.Key? key,
    required String serverName,
    required String playQueueId,
    List<_i43.PageRouteInfo>? children,
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

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<RemoteControlRouteArgs>(
        orElse: () => RemoteControlRouteArgs(
          serverName: pathParams.getString('serverName'),
          playQueueId: pathParams.getString('playQueueId'),
        ),
      );
      return _i22.RemoteControlPage(
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

  final _i44.Key? key;

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
/// [_i23.SearchPage]
class SearchRoute extends _i43.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    _i44.Key? key,
    String? libraryId,
    String? query,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         SearchRoute.name,
         args: SearchRouteArgs(key: key, libraryId: libraryId, query: query),
         rawQueryParams: {'libraryId': libraryId, 'q': query},
         initialChildren: children,
       );

  static const String name = 'SearchRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<SearchRouteArgs>(
        orElse: () => SearchRouteArgs(
          libraryId: queryParams.optString('libraryId'),
          query: queryParams.optString('q'),
        ),
      );
      return _i23.SearchPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        libraryId: args.libraryId,
        query: args.query,
      );
    },
  );
}

class SearchRouteArgs {
  const SearchRouteArgs({this.key, this.libraryId, this.query});

  final _i44.Key? key;

  final String? libraryId;

  final String? query;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, libraryId: $libraryId, query: $query}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SearchRouteArgs) return false;
    return key == other.key &&
        libraryId == other.libraryId &&
        query == other.query;
  }

  @override
  int get hashCode => key.hashCode ^ libraryId.hashCode ^ query.hashCode;
}

/// generated route for
/// [_i24.SeriesPage]
class SeriesRoute extends _i43.PageRouteInfo<SeriesRouteArgs> {
  SeriesRoute({
    _i44.Key? key,
    required String seriesId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         SeriesRoute.name,
         args: SeriesRouteArgs(key: key, seriesId: seriesId),
         rawPathParams: {'seriesId': seriesId},
         initialChildren: children,
       );

  static const String name = 'SeriesRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SeriesRouteArgs>(
        orElse: () =>
            SeriesRouteArgs(seriesId: pathParams.getString('seriesId')),
      );
      return _i24.SeriesPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        seriesId: args.seriesId,
      );
    },
  );
}

class SeriesRouteArgs {
  const SeriesRouteArgs({this.key, required this.seriesId});

  final _i44.Key? key;

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
/// [_i25.ServerActivityPage]
class ServerActivityRoute extends _i43.PageRouteInfo<ServerActivityRouteArgs> {
  ServerActivityRoute({_i44.Key? key, List<_i43.PageRouteInfo>? children})
    : super(
        ServerActivityRoute.name,
        args: ServerActivityRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'ServerActivityRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerActivityRouteArgs>(
        orElse: () => ServerActivityRouteArgs(),
      );
      return _i25.ServerActivityPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerActivityRouteArgs {
  const ServerActivityRouteArgs({this.key});

  final _i44.Key? key;

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
/// [_i26.ServerDownloadSettingsPage]
class ServerDownloadSettingsRoute
    extends _i43.PageRouteInfo<ServerDownloadSettingsRouteArgs> {
  ServerDownloadSettingsRoute({
    _i44.Key? key,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         ServerDownloadSettingsRoute.name,
         args: ServerDownloadSettingsRouteArgs(key: key),
         initialChildren: children,
       );

  static const String name = 'ServerDownloadSettingsRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerDownloadSettingsRouteArgs>(
        orElse: () => ServerDownloadSettingsRouteArgs(),
      );
      return _i26.ServerDownloadSettingsPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerDownloadSettingsRouteArgs {
  const ServerDownloadSettingsRouteArgs({this.key});

  final _i44.Key? key;

  @override
  String toString() {
    return 'ServerDownloadSettingsRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerDownloadSettingsRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i26.ServerDownloadsPage]
class ServerDownloadsRoute
    extends _i43.PageRouteInfo<ServerDownloadsRouteArgs> {
  ServerDownloadsRoute({_i44.Key? key, List<_i43.PageRouteInfo>? children})
    : super(
        ServerDownloadsRoute.name,
        args: ServerDownloadsRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'ServerDownloadsRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerDownloadsRouteArgs>(
        orElse: () => ServerDownloadsRouteArgs(),
      );
      return _i26.ServerDownloadsPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerDownloadsRouteArgs {
  const ServerDownloadsRouteArgs({this.key});

  final _i44.Key? key;

  @override
  String toString() {
    return 'ServerDownloadsRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerDownloadsRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i27.ServerHomeContentPage]
class ServerHomeContentRoute
    extends _i43.PageRouteInfo<ServerHomeContentRouteArgs> {
  ServerHomeContentRoute({_i44.Key? key, List<_i43.PageRouteInfo>? children})
    : super(
        ServerHomeContentRoute.name,
        args: ServerHomeContentRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'ServerHomeContentRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerHomeContentRouteArgs>(
        orElse: () => ServerHomeContentRouteArgs(),
      );
      return _i27.ServerHomeContentPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerHomeContentRouteArgs {
  const ServerHomeContentRouteArgs({this.key});

  final _i44.Key? key;

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
/// [_i28.ServerHomeOverviewPage]
class ServerHomeOverviewRoute
    extends _i43.PageRouteInfo<ServerHomeOverviewRouteArgs> {
  ServerHomeOverviewRoute({_i44.Key? key, List<_i43.PageRouteInfo>? children})
    : super(
        ServerHomeOverviewRoute.name,
        args: ServerHomeOverviewRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'ServerHomeOverviewRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerHomeOverviewRouteArgs>(
        orElse: () => ServerHomeOverviewRouteArgs(),
      );
      return _i28.ServerHomeOverviewPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerHomeOverviewRouteArgs {
  const ServerHomeOverviewRouteArgs({this.key});

  final _i44.Key? key;

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
/// [_i29.ServerHomePage]
class ServerHomeRoute extends _i43.PageRouteInfo<ServerHomeRouteArgs> {
  ServerHomeRoute({
    _i44.Key? key,
    required String serverName,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         ServerHomeRoute.name,
         args: ServerHomeRouteArgs(key: key, serverName: serverName),
         rawPathParams: {'serverName': serverName},
         initialChildren: children,
       );

  static const String name = 'ServerHomeRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerHomeRouteArgs>(
        orElse: () =>
            ServerHomeRouteArgs(serverName: pathParams.getString('serverName')),
      );
      return _i29.ServerHomePage(key: args.key, serverName: args.serverName);
    },
  );
}

class ServerHomeRouteArgs {
  const ServerHomeRouteArgs({this.key, required this.serverName});

  final _i44.Key? key;

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
/// [_i26.ServerLocalVideoPage]
class ServerLocalVideoRoute
    extends _i43.PageRouteInfo<ServerLocalVideoRouteArgs> {
  ServerLocalVideoRoute({_i44.Key? key, List<_i43.PageRouteInfo>? children})
    : super(
        ServerLocalVideoRoute.name,
        args: ServerLocalVideoRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'ServerLocalVideoRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerLocalVideoRouteArgs>(
        orElse: () => ServerLocalVideoRouteArgs(),
      );
      return _i26.ServerLocalVideoPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerLocalVideoRouteArgs {
  const ServerLocalVideoRouteArgs({this.key});

  final _i44.Key? key;

  @override
  String toString() {
    return 'ServerLocalVideoRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerLocalVideoRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i30.ServerNowPlayingPage]
class ServerNowPlayingRoute
    extends _i43.PageRouteInfo<ServerNowPlayingRouteArgs> {
  ServerNowPlayingRoute({_i44.Key? key, List<_i43.PageRouteInfo>? children})
    : super(
        ServerNowPlayingRoute.name,
        args: ServerNowPlayingRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'ServerNowPlayingRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerNowPlayingRouteArgs>(
        orElse: () => ServerNowPlayingRouteArgs(),
      );
      return _i30.ServerNowPlayingPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerNowPlayingRouteArgs {
  const ServerNowPlayingRouteArgs({this.key});

  final _i44.Key? key;

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
/// [_i31.ServerSettingsAboutPage]
class ServerSettingsAboutRoute
    extends _i43.PageRouteInfo<ServerSettingsAboutRouteArgs> {
  ServerSettingsAboutRoute({_i44.Key? key, List<_i43.PageRouteInfo>? children})
    : super(
        ServerSettingsAboutRoute.name,
        args: ServerSettingsAboutRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'ServerSettingsAboutRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerSettingsAboutRouteArgs>(
        orElse: () => ServerSettingsAboutRouteArgs(),
      );
      return _i31.ServerSettingsAboutPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerSettingsAboutRouteArgs {
  const ServerSettingsAboutRouteArgs({this.key});

  final _i44.Key? key;

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
/// [_i32.ServerSettingsClusterPage]
class ServerSettingsClusterRoute
    extends _i43.PageRouteInfo<ServerSettingsClusterRouteArgs> {
  ServerSettingsClusterRoute({
    _i44.Key? key,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         ServerSettingsClusterRoute.name,
         args: ServerSettingsClusterRouteArgs(key: key),
         initialChildren: children,
       );

  static const String name = 'ServerSettingsClusterRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerSettingsClusterRouteArgs>(
        orElse: () => ServerSettingsClusterRouteArgs(),
      );
      return _i32.ServerSettingsClusterPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerSettingsClusterRouteArgs {
  const ServerSettingsClusterRouteArgs({this.key});

  final _i44.Key? key;

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
/// [_i33.ServerSettingsDevicesPage]
class ServerSettingsDevicesRoute
    extends _i43.PageRouteInfo<ServerSettingsDevicesRouteArgs> {
  ServerSettingsDevicesRoute({
    _i44.Key? key,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         ServerSettingsDevicesRoute.name,
         args: ServerSettingsDevicesRouteArgs(key: key),
         initialChildren: children,
       );

  static const String name = 'ServerSettingsDevicesRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerSettingsDevicesRouteArgs>(
        orElse: () => ServerSettingsDevicesRouteArgs(),
      );
      return _i33.ServerSettingsDevicesPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerSettingsDevicesRouteArgs {
  const ServerSettingsDevicesRouteArgs({this.key});

  final _i44.Key? key;

  @override
  String toString() {
    return 'ServerSettingsDevicesRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerSettingsDevicesRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i34.ServerSettingsLanguagePage]
class ServerSettingsLanguageRoute
    extends _i43.PageRouteInfo<ServerSettingsLanguageRouteArgs> {
  ServerSettingsLanguageRoute({
    _i44.Key? key,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         ServerSettingsLanguageRoute.name,
         args: ServerSettingsLanguageRouteArgs(key: key),
         initialChildren: children,
       );

  static const String name = 'ServerSettingsLanguageRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerSettingsLanguageRouteArgs>(
        orElse: () => ServerSettingsLanguageRouteArgs(),
      );
      return _i34.ServerSettingsLanguagePage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerSettingsLanguageRouteArgs {
  const ServerSettingsLanguageRouteArgs({this.key});

  final _i44.Key? key;

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
/// [_i35.ServerSettingsPage]
class ServerSettingsRoute extends _i43.PageRouteInfo<ServerSettingsRouteArgs> {
  ServerSettingsRoute({_i45.Key? key, List<_i43.PageRouteInfo>? children})
    : super(
        ServerSettingsRoute.name,
        args: ServerSettingsRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'ServerSettingsRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerSettingsRouteArgs>(
        orElse: () => ServerSettingsRouteArgs(),
      );
      return _i35.ServerSettingsPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerSettingsRouteArgs {
  const ServerSettingsRouteArgs({this.key});

  final _i45.Key? key;

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
/// [_i36.ServerSettingsPlaybackPage]
class ServerSettingsPlaybackRoute
    extends _i43.PageRouteInfo<ServerSettingsPlaybackRouteArgs> {
  ServerSettingsPlaybackRoute({
    _i45.Key? key,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         ServerSettingsPlaybackRoute.name,
         args: ServerSettingsPlaybackRouteArgs(key: key),
         initialChildren: children,
       );

  static const String name = 'ServerSettingsPlaybackRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerSettingsPlaybackRouteArgs>(
        orElse: () => ServerSettingsPlaybackRouteArgs(),
      );
      return _i36.ServerSettingsPlaybackPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerSettingsPlaybackRouteArgs {
  const ServerSettingsPlaybackRouteArgs({this.key});

  final _i45.Key? key;

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
/// [_i37.ServerSettingsSharingPage]
class ServerSettingsSharingRoute
    extends _i43.PageRouteInfo<ServerSettingsSharingRouteArgs> {
  ServerSettingsSharingRoute({
    _i44.Key? key,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         ServerSettingsSharingRoute.name,
         args: ServerSettingsSharingRouteArgs(key: key),
         initialChildren: children,
       );

  static const String name = 'ServerSettingsSharingRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerSettingsSharingRouteArgs>(
        orElse: () => ServerSettingsSharingRouteArgs(),
      );
      return _i37.ServerSettingsSharingPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerSettingsSharingRouteArgs {
  const ServerSettingsSharingRouteArgs({this.key});

  final _i44.Key? key;

  @override
  String toString() {
    return 'ServerSettingsSharingRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerSettingsSharingRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i38.ShowEpisodePage]
class ShowEpisodeRoute extends _i43.PageRouteInfo<ShowEpisodeRouteArgs> {
  ShowEpisodeRoute({
    _i44.Key? key,
    required String showId,
    required String episodeId,
    String? playQueueId,
    List<_i43.PageRouteInfo>? children,
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

  static _i43.PageInfo page = _i43.PageInfo(
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
      return _i38.ShowEpisodePage(
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

  final _i44.Key? key;

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
/// [_i39.ShowHomePage]
class ShowHomeRoute extends _i43.PageRouteInfo<ShowHomeRouteArgs> {
  ShowHomeRoute({
    _i44.Key? key,
    String? libraryId,
    String? view,
    String? kind,
    String? layout,
    String? filter,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         ShowHomeRoute.name,
         args: ShowHomeRouteArgs(
           key: key,
           libraryId: libraryId,
           view: view,
           kind: kind,
           layout: layout,
           filter: filter,
         ),
         rawQueryParams: {
           'libraryId': libraryId,
           'view': view,
           'kind': kind,
           'layout': layout,
           'filter': filter,
         },
         initialChildren: children,
       );

  static const String name = 'ShowHomeRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<ShowHomeRouteArgs>(
        orElse: () => ShowHomeRouteArgs(
          libraryId: queryParams.optString('libraryId'),
          view: queryParams.optString('view'),
          kind: queryParams.optString('kind'),
          layout: queryParams.optString('layout'),
          filter: queryParams.optString('filter'),
        ),
      );
      return _i39.ShowHomePage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        libraryId: args.libraryId,
        view: args.view,
        kind: args.kind,
        layout: args.layout,
        filter: args.filter,
      );
    },
  );
}

class ShowHomeRouteArgs {
  const ShowHomeRouteArgs({
    this.key,
    this.libraryId,
    this.view,
    this.kind,
    this.layout,
    this.filter,
  });

  final _i44.Key? key;

  final String? libraryId;

  final String? view;

  final String? kind;

  final String? layout;

  final String? filter;

  @override
  String toString() {
    return 'ShowHomeRouteArgs{key: $key, libraryId: $libraryId, view: $view, kind: $kind, layout: $layout, filter: $filter}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ShowHomeRouteArgs) return false;
    return key == other.key &&
        libraryId == other.libraryId &&
        view == other.view &&
        kind == other.kind &&
        layout == other.layout &&
        filter == other.filter;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      libraryId.hashCode ^
      view.hashCode ^
      kind.hashCode ^
      layout.hashCode ^
      filter.hashCode;
}

/// generated route for
/// [_i40.ShowOverviewContentPage]
class ShowOverviewContentRoute
    extends _i43.PageRouteInfo<ShowOverviewContentRouteArgs> {
  ShowOverviewContentRoute({
    _i44.Key? key,
    required String showId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         ShowOverviewContentRoute.name,
         args: ShowOverviewContentRouteArgs(key: key, showId: showId),
         rawPathParams: {'showId': showId},
         initialChildren: children,
       );

  static const String name = 'ShowOverviewContentRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowOverviewContentRouteArgs>(
        orElse: () => ShowOverviewContentRouteArgs(
          showId: pathParams.getString('showId'),
        ),
      );
      return _i40.ShowOverviewContentPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        showId: args.showId,
      );
    },
  );
}

class ShowOverviewContentRouteArgs {
  const ShowOverviewContentRouteArgs({this.key, required this.showId});

  final _i44.Key? key;

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
/// [_i41.ShowOverviewPage]
class ShowOverviewRoute extends _i43.PageRouteInfo<ShowOverviewRouteArgs> {
  ShowOverviewRoute({
    _i44.Key? key,
    required String showId,
    List<_i43.PageRouteInfo>? children,
  }) : super(
         ShowOverviewRoute.name,
         args: ShowOverviewRouteArgs(key: key, showId: showId),
         rawPathParams: {'showId': showId},
         initialChildren: children,
       );

  static const String name = 'ShowOverviewRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowOverviewRouteArgs>(
        orElse: () =>
            ShowOverviewRouteArgs(showId: pathParams.getString('showId')),
      );
      return _i41.ShowOverviewPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        showId: args.showId,
      );
    },
  );
}

class ShowOverviewRouteArgs {
  const ShowOverviewRouteArgs({this.key, required this.showId});

  final _i44.Key? key;

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

/// generated route for
/// [_i42.SleepTimerSettingsPage]
class SleepTimerSettingsRoute extends _i43.PageRouteInfo<void> {
  const SleepTimerSettingsRoute({List<_i43.PageRouteInfo>? children})
    : super(SleepTimerSettingsRoute.name, initialChildren: children);

  static const String name = 'SleepTimerSettingsRoute';

  static _i43.PageInfo page = _i43.PageInfo(
    name,
    builder: (data) {
      return const _i42.SleepTimerSettingsPage();
    },
  );
}
