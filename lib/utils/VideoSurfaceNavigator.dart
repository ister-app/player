import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

/// Navigates to the page that hosts the currently-playing video. Unlike music,
/// video has no separate full-screen route — the episode/movie page is the
/// player — so we (re-)open that page. Playback keeps running; the page's
/// startPlayQueue detects the same item and just resumes it. Used by the mini
/// player's tap and by follow mode's "keep the screen on the video" requests.
void openCurrentVideoPage(BuildContext context) {
  final handler = MediaPlayerHandler.instance;
  final playingServer = handler.serverName;
  if (playingServer == null) return;

  PageRouteInfo? route;
  final episode = handler.episode;
  final movie = handler.movie;
  if (episode != null && episode.$show != null) {
    route = ShowOverviewRoute(
      showId: episode.$show!.id,
      children: [
        ShowEpisodeRoute(
          showId: episode.$show!.id,
          episodeId: episode.id,
          playQueueId: handler.playQueue?.id,
        ),
      ],
    );
  } else if (movie != null) {
    route = MovieRoute(
      movieId: movie.id,
      playQueueId: handler.playQueue?.id,
    );
  }
  if (route == null) return;

  // The video can play from a different server than the one being browsed: a
  // same-server route inherits :serverName in place, a cross-server one needs
  // the full ServerHomeRoute.
  final currentServer =
      context.routeData.inheritedPathParams.optString('serverName');
  if (currentServer == playingServer) {
    AutoRouter.of(context).navigate(route);
  } else {
    AutoRouter.of(context)
        .root
        .navigate(ServerHomeRoute(serverName: playingServer, children: [route]));
  }
}
