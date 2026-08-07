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

/// The video routes: the pages that host a video surface rather than a
/// separate full-screen player route.
const _videoRouteNames = {MovieRoute.name, ShowEpisodeRoute.name};

/// Closes the video page(s) on top of the stack — the counterpart of
/// [openCurrentVideoPage], used when playback ended on this device for good
/// (the watch-along leader stopped, or the queue moved to another device) and
/// leaving a dead player surface on screen would be wrong.
///
/// Only pops while a video page is actually the topmost route: a video page
/// buried under something else (or in an inactive tab) is left alone, so this
/// can never yank a page out from under the user.
void closeCurrentVideoPage(BuildContext context) {
  // Nullable lookup: this runs from a global listener, which can fire from a
  // context outside any router (tests, headless audio-service startup).
  final root = StackRouterScope.of(context)?.controller.root;
  if (root == null) return;
  while (_videoRouteNames.contains(root.topRoute.name)) {
    final topMost = root.topMostRouter();
    if (topMost is! StackRouter || !topMost.removeLast()) break;
  }
}
