// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/foundation.dart' as _i9;
import 'package:flutter/material.dart' as _i8;
import 'package:player/pages/HomePage.dart' as _i1;
import 'package:player/pages/ServerHomeContentPage.dart' as _i2;
import 'package:player/pages/ServerHomePage.dart' as _i3;
import 'package:player/pages/ShowEpisodePage.dart' as _i4;
import 'package:player/pages/ShowOverviewContentPage.dart' as _i5;
import 'package:player/pages/ShowOverviewPage.dart' as _i6;

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
      : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomePage();
    },
  );
}

/// generated route for
/// [_i2.ServerHomeContentPage]
class ServerHomeContentRoute
    extends _i7.PageRouteInfo<ServerHomeContentRouteArgs> {
  ServerHomeContentRoute({_i8.Key? key, List<_i7.PageRouteInfo>? children})
      : super(
          ServerHomeContentRoute.name,
          args: ServerHomeContentRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServerHomeContentRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerHomeContentRouteArgs>(
        orElse: () => ServerHomeContentRouteArgs(),
      );
      return _i2.ServerHomeContentPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
      );
    },
  );
}

class ServerHomeContentRouteArgs {
  const ServerHomeContentRouteArgs({this.key});

  final _i8.Key? key;

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
/// [_i3.ServerHomePage]
class ServerHomeRoute extends _i7.PageRouteInfo<ServerHomeRouteArgs> {
  ServerHomeRoute({
    _i8.Key? key,
    required String serverName,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          ServerHomeRoute.name,
          args: ServerHomeRouteArgs(key: key, serverName: serverName),
          rawPathParams: {'serverName': serverName},
          initialChildren: children,
        );

  static const String name = 'ServerHomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerHomeRouteArgs>(
        orElse: () =>
            ServerHomeRouteArgs(serverName: pathParams.getString('serverName')),
      );
      return _i3.ServerHomePage(key: args.key, serverName: args.serverName);
    },
  );
}

class ServerHomeRouteArgs {
  const ServerHomeRouteArgs({this.key, required this.serverName});

  final _i8.Key? key;

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
/// [_i4.ShowEpisodePage]
class ShowEpisodeRoute extends _i7.PageRouteInfo<ShowEpisodeRouteArgs> {
  ShowEpisodeRoute({
    _i9.Key? key,
    required String showId,
    required String episodeId,
    String? playQueueId,
    List<_i7.PageRouteInfo>? children,
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

  static _i7.PageInfo page = _i7.PageInfo(
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
      return _i4.ShowEpisodePage(
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

  final _i9.Key? key;

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
/// [_i5.ShowOverviewContentPage]
class ShowOverviewContentRoute
    extends _i7.PageRouteInfo<ShowOverviewContentRouteArgs> {
  ShowOverviewContentRoute({
    _i8.Key? key,
    required String showId,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          ShowOverviewContentRoute.name,
          args: ShowOverviewContentRouteArgs(key: key, showId: showId),
          rawPathParams: {'showId': showId},
          initialChildren: children,
        );

  static const String name = 'ShowOverviewContentRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowOverviewContentRouteArgs>(
        orElse: () => ShowOverviewContentRouteArgs(
          showId: pathParams.getString('showId'),
        ),
      );
      return _i5.ShowOverviewContentPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        showId: args.showId,
      );
    },
  );
}

class ShowOverviewContentRouteArgs {
  const ShowOverviewContentRouteArgs({this.key, required this.showId});

  final _i8.Key? key;

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
/// [_i6.ShowOverviewPage]
class ShowOverviewRoute extends _i7.PageRouteInfo<ShowOverviewRouteArgs> {
  ShowOverviewRoute({
    _i8.Key? key,
    required String showId,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          ShowOverviewRoute.name,
          args: ShowOverviewRouteArgs(key: key, showId: showId),
          rawPathParams: {'showId': showId},
          initialChildren: children,
        );

  static const String name = 'ShowOverviewRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowOverviewRouteArgs>(
        orElse: () =>
            ShowOverviewRouteArgs(showId: pathParams.getString('showId')),
      );
      return _i6.ShowOverviewPage(
        key: args.key,
        serverName: pathParams.getString('serverName'),
        showId: args.showId,
      );
    },
  );
}

class ShowOverviewRouteArgs {
  const ShowOverviewRouteArgs({this.key, required this.showId});

  final _i8.Key? key;

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
