// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i21;
import 'package:flutter/foundation.dart' as _i23;
import 'package:flutter/material.dart' as _i22;
import 'package:player/pages/AlbumPage.dart' as _i1;
import 'package:player/pages/HomePage.dart' as _i2;
import 'package:player/pages/MoviePage.dart' as _i3;
import 'package:player/pages/MusicPlayerPage.dart' as _i4;
import 'package:player/pages/PersonPage.dart' as _i5;
import 'package:player/pages/RemoteControlPage.dart' as _i6;
import 'package:player/pages/SearchPage.dart' as _i7;
import 'package:player/pages/ServerActivityPage.dart' as _i8;
import 'package:player/pages/ServerHomeContentPage.dart' as _i9;
import 'package:player/pages/ServerHomeOverviewPage.dart' as _i10;
import 'package:player/pages/ServerHomePage.dart' as _i11;
import 'package:player/pages/ServerNowPlayingPage.dart' as _i12;
import 'package:player/pages/ServerSettingsClusterPage.dart' as _i13;
import 'package:player/pages/ServerSettingsLanguagePage.dart' as _i14;
import 'package:player/pages/ServerSettingsPage.dart' as _i15;
import 'package:player/pages/ServerSettingsPlaybackPage.dart' as _i16;
import 'package:player/pages/ShowEpisodePage.dart' as _i17;
import 'package:player/pages/ShowHomePage.dart' as _i18;
import 'package:player/pages/ShowOverviewContentPage.dart' as _i19;
import 'package:player/pages/ShowOverviewPage.dart' as _i20;

/// generated route for
/// [_i1.AlbumPage]
class AlbumRoute extends _i21.PageRouteInfo<AlbumRouteArgs> {
  AlbumRoute({
    _i22.Key? key,
    required String albumId,
    String? playQueueId,
    List<_i21.PageRouteInfo>? children,
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

  static _i21.PageInfo page = _i21.PageInfo(
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
      return _i1.AlbumPage(
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

  final _i22.Key? key;

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
/// [_i2.HomePage]
class HomeRoute extends _i21.PageRouteInfo<void> {
  const HomeRoute({List<_i21.PageRouteInfo>? children})
      : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomePage();
    },
  );
}

/// generated route for
/// [_i3.MoviePage]
class MovieRoute extends _i21.PageRouteInfo<MovieRouteArgs> {
  MovieRoute({
    _i22.Key? key,
    required String movieId,
    String? playQueueId,
    List<_i21.PageRouteInfo>? children,
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

  static _i21.PageInfo page = _i21.PageInfo(
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
      return _i3.MoviePage(
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

  final _i22.Key? key;

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
/// [_i4.MusicPlayerPage]
class MusicPlayerRoute extends _i21.PageRouteInfo<void> {
  const MusicPlayerRoute({List<_i21.PageRouteInfo>? children})
      : super(MusicPlayerRoute.name, initialChildren: children);

  static const String name = 'MusicPlayerRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i4.MusicPlayerPage();
    },
  );
}

/// generated route for
/// [_i5.PersonPage]
class PersonRoute extends _i21.PageRouteInfo<PersonRouteArgs> {
  PersonRoute({
    _i22.Key? key,
    required String personId,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          PersonRoute.name,
          args: PersonRouteArgs(key: key, personId: personId),
          rawPathParams: {'personId': personId},
          initialChildren: children,
        );

  static const String name = 'PersonRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PersonRouteArgs>(
        orElse: () =>
            PersonRouteArgs(personId: pathParams.getString('personId')),
      );
      return _i5.PersonPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        personId: args.personId,
      );
    },
  );
}

class PersonRouteArgs {
  const PersonRouteArgs({this.key, required this.personId});

  final _i22.Key? key;

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
/// [_i6.RemoteControlPage]
class RemoteControlRoute extends _i21.PageRouteInfo<RemoteControlRouteArgs> {
  RemoteControlRoute({
    _i22.Key? key,
    required String playQueueId,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          RemoteControlRoute.name,
          args: RemoteControlRouteArgs(key: key, playQueueId: playQueueId),
          rawPathParams: {'playQueueId': playQueueId},
          initialChildren: children,
        );

  static const String name = 'RemoteControlRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<RemoteControlRouteArgs>(
        orElse: () => RemoteControlRouteArgs(
          playQueueId: pathParams.getString('playQueueId'),
        ),
      );
      return _i6.RemoteControlPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        playQueueId: args.playQueueId,
      );
    },
  );
}

class RemoteControlRouteArgs {
  const RemoteControlRouteArgs({this.key, required this.playQueueId});

  final _i22.Key? key;

  final String playQueueId;

  @override
  String toString() {
    return 'RemoteControlRouteArgs{key: $key, playQueueId: $playQueueId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RemoteControlRouteArgs) return false;
    return key == other.key && playQueueId == other.playQueueId;
  }

  @override
  int get hashCode => key.hashCode ^ playQueueId.hashCode;
}

/// generated route for
/// [_i7.SearchPage]
class SearchRoute extends _i21.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    _i22.Key? key,
    String? libraryId,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(key: key, libraryId: libraryId),
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SearchRouteArgs>(
        orElse: () => SearchRouteArgs(),
      );
      return _i7.SearchPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        libraryId: args.libraryId,
      );
    },
  );
}

class SearchRouteArgs {
  const SearchRouteArgs({this.key, this.libraryId});

  final _i22.Key? key;

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
/// [_i8.ServerActivityPage]
class ServerActivityRoute extends _i21.PageRouteInfo<ServerActivityRouteArgs> {
  ServerActivityRoute({_i22.Key? key, List<_i21.PageRouteInfo>? children})
      : super(
          ServerActivityRoute.name,
          args: ServerActivityRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServerActivityRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerActivityRouteArgs>(
        orElse: () => ServerActivityRouteArgs(),
      );
      return _i8.ServerActivityPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerActivityRouteArgs {
  const ServerActivityRouteArgs({this.key});

  final _i22.Key? key;

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
/// [_i9.ServerHomeContentPage]
class ServerHomeContentRoute
    extends _i21.PageRouteInfo<ServerHomeContentRouteArgs> {
  ServerHomeContentRoute({_i22.Key? key, List<_i21.PageRouteInfo>? children})
      : super(
          ServerHomeContentRoute.name,
          args: ServerHomeContentRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServerHomeContentRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerHomeContentRouteArgs>(
        orElse: () => ServerHomeContentRouteArgs(),
      );
      return _i9.ServerHomeContentPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerHomeContentRouteArgs {
  const ServerHomeContentRouteArgs({this.key});

  final _i22.Key? key;

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
/// [_i10.ServerHomeOverviewPage]
class ServerHomeOverviewRoute
    extends _i21.PageRouteInfo<ServerHomeOverviewRouteArgs> {
  ServerHomeOverviewRoute({_i22.Key? key, List<_i21.PageRouteInfo>? children})
      : super(
          ServerHomeOverviewRoute.name,
          args: ServerHomeOverviewRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServerHomeOverviewRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerHomeOverviewRouteArgs>(
        orElse: () => ServerHomeOverviewRouteArgs(),
      );
      return _i10.ServerHomeOverviewPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerHomeOverviewRouteArgs {
  const ServerHomeOverviewRouteArgs({this.key});

  final _i22.Key? key;

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
/// [_i11.ServerHomePage]
class ServerHomeRoute extends _i21.PageRouteInfo<ServerHomeRouteArgs> {
  ServerHomeRoute({
    _i22.Key? key,
    required String serverName,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          ServerHomeRoute.name,
          args: ServerHomeRouteArgs(key: key, serverName: serverName),
          rawPathParams: {'serverName': serverName},
          initialChildren: children,
        );

  static const String name = 'ServerHomeRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerHomeRouteArgs>(
        orElse: () =>
            ServerHomeRouteArgs(serverName: pathParams.getString('serverName')),
      );
      return _i11.ServerHomePage(key: args.key, serverName: args.serverName);
    },
  );
}

class ServerHomeRouteArgs {
  const ServerHomeRouteArgs({this.key, required this.serverName});

  final _i22.Key? key;

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
/// [_i12.ServerNowPlayingPage]
class ServerNowPlayingRoute
    extends _i21.PageRouteInfo<ServerNowPlayingRouteArgs> {
  ServerNowPlayingRoute({_i22.Key? key, List<_i21.PageRouteInfo>? children})
      : super(
          ServerNowPlayingRoute.name,
          args: ServerNowPlayingRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServerNowPlayingRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerNowPlayingRouteArgs>(
        orElse: () => ServerNowPlayingRouteArgs(),
      );
      return _i12.ServerNowPlayingPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerNowPlayingRouteArgs {
  const ServerNowPlayingRouteArgs({this.key});

  final _i22.Key? key;

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
/// [_i13.ServerSettingsClusterPage]
class ServerSettingsClusterRoute
    extends _i21.PageRouteInfo<ServerSettingsClusterRouteArgs> {
  ServerSettingsClusterRoute({
    _i22.Key? key,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          ServerSettingsClusterRoute.name,
          args: ServerSettingsClusterRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServerSettingsClusterRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerSettingsClusterRouteArgs>(
        orElse: () => ServerSettingsClusterRouteArgs(),
      );
      return _i13.ServerSettingsClusterPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerSettingsClusterRouteArgs {
  const ServerSettingsClusterRouteArgs({this.key});

  final _i22.Key? key;

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
/// [_i14.ServerSettingsLanguagePage]
class ServerSettingsLanguageRoute
    extends _i21.PageRouteInfo<ServerSettingsLanguageRouteArgs> {
  ServerSettingsLanguageRoute({
    _i22.Key? key,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          ServerSettingsLanguageRoute.name,
          args: ServerSettingsLanguageRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServerSettingsLanguageRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerSettingsLanguageRouteArgs>(
        orElse: () => ServerSettingsLanguageRouteArgs(),
      );
      return _i14.ServerSettingsLanguagePage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerSettingsLanguageRouteArgs {
  const ServerSettingsLanguageRouteArgs({this.key});

  final _i22.Key? key;

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
/// [_i15.ServerSettingsPage]
class ServerSettingsRoute extends _i21.PageRouteInfo<ServerSettingsRouteArgs> {
  ServerSettingsRoute({_i23.Key? key, List<_i21.PageRouteInfo>? children})
      : super(
          ServerSettingsRoute.name,
          args: ServerSettingsRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServerSettingsRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerSettingsRouteArgs>(
        orElse: () => ServerSettingsRouteArgs(),
      );
      return _i15.ServerSettingsPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerSettingsRouteArgs {
  const ServerSettingsRouteArgs({this.key});

  final _i23.Key? key;

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
/// [_i16.ServerSettingsPlaybackPage]
class ServerSettingsPlaybackRoute
    extends _i21.PageRouteInfo<ServerSettingsPlaybackRouteArgs> {
  ServerSettingsPlaybackRoute({
    _i23.Key? key,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          ServerSettingsPlaybackRoute.name,
          args: ServerSettingsPlaybackRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServerSettingsPlaybackRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerSettingsPlaybackRouteArgs>(
        orElse: () => ServerSettingsPlaybackRouteArgs(),
      );
      return _i16.ServerSettingsPlaybackPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerSettingsPlaybackRouteArgs {
  const ServerSettingsPlaybackRouteArgs({this.key});

  final _i23.Key? key;

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
/// [_i17.ShowEpisodePage]
class ShowEpisodeRoute extends _i21.PageRouteInfo<ShowEpisodeRouteArgs> {
  ShowEpisodeRoute({
    _i22.Key? key,
    required String showId,
    required String episodeId,
    String? playQueueId,
    List<_i21.PageRouteInfo>? children,
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

  static _i21.PageInfo page = _i21.PageInfo(
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
      return _i17.ShowEpisodePage(
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

  final _i22.Key? key;

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
/// [_i18.ShowHomePage]
class ShowHomeRoute extends _i21.PageRouteInfo<ShowHomeRouteArgs> {
  ShowHomeRoute({_i22.Key? key, List<_i21.PageRouteInfo>? children})
      : super(
          ShowHomeRoute.name,
          args: ShowHomeRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ShowHomeRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowHomeRouteArgs>(
        orElse: () => ShowHomeRouteArgs(),
      );
      return _i18.ShowHomePage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ShowHomeRouteArgs {
  const ShowHomeRouteArgs({this.key});

  final _i22.Key? key;

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
/// [_i19.ShowOverviewContentPage]
class ShowOverviewContentRoute
    extends _i21.PageRouteInfo<ShowOverviewContentRouteArgs> {
  ShowOverviewContentRoute({
    _i22.Key? key,
    required String showId,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          ShowOverviewContentRoute.name,
          args: ShowOverviewContentRouteArgs(key: key, showId: showId),
          rawPathParams: {'showId': showId},
          initialChildren: children,
        );

  static const String name = 'ShowOverviewContentRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowOverviewContentRouteArgs>(
        orElse: () => ShowOverviewContentRouteArgs(
          showId: pathParams.getString('showId'),
        ),
      );
      return _i19.ShowOverviewContentPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        showId: args.showId,
      );
    },
  );
}

class ShowOverviewContentRouteArgs {
  const ShowOverviewContentRouteArgs({this.key, required this.showId});

  final _i22.Key? key;

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
/// [_i20.ShowOverviewPage]
class ShowOverviewRoute extends _i21.PageRouteInfo<ShowOverviewRouteArgs> {
  ShowOverviewRoute({
    _i22.Key? key,
    required String showId,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          ShowOverviewRoute.name,
          args: ShowOverviewRouteArgs(key: key, showId: showId),
          rawPathParams: {'showId': showId},
          initialChildren: children,
        );

  static const String name = 'ShowOverviewRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowOverviewRouteArgs>(
        orElse: () =>
            ShowOverviewRouteArgs(showId: pathParams.getString('showId')),
      );
      return _i20.ShowOverviewPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        showId: args.showId,
      );
    },
  );
}

class ShowOverviewRouteArgs {
  const ShowOverviewRouteArgs({this.key, required this.showId});

  final _i22.Key? key;

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
