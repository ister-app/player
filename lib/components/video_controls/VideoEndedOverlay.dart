import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../routes/AppRouter.gr.dart';
import '../../utils/ImageTypes.dart';
import '../../utils/ImageUtil.dart';
import '../../utils/MediaPlayerHandler.dart';
import '../../utils/PlatformService.dart';
import '../../utils/QueueEnd.dart';
import '../IsterPlayer.dart';
import '../RelatedShowsRow.dart';
import '../TvFocusable.dart';
import '../VideoCoverView.dart';

/// The end screen of a video surface: shown over the (torn down) player once
/// the queue played out — [MediaPlayerHandler.queueEnded] holds an episode or
/// movie. The cover art of what ended, "watch again", a way back to the page's
/// cover, and for an episode the shows related to its show.
///
/// Lives in the controls stack, so it renders embedded and in media_kit's
/// fullscreen copy alike; fullscreen stays open (on TV it is the only
/// surface). Nothing starts on its own — no autoplay — the viewer picks.
class VideoEndedOverlay extends StatelessWidget {
  const VideoEndedOverlay({super.key, this.showActions = true});

  static const Key overlayKey = Key('video-ended-overlay');
  static const Key watchAgainKey = Key('video-ended-watch-again');
  static const Key backKey = Key('video-ended-back');
  static const Key suggestionsKey = Key('video-ended-suggestions');

  /// False where the surface itself is one big tap target that replays
  /// (embedded on TV): then only the title shows, no buttons.
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final handler = MediaPlayerHandler.instance;
    return ValueListenableBuilder<QueueEndedInfo?>(
      valueListenable: handler.queueEnded,
      builder: (context, ended, _) {
        if (ended == null || !ended.isVideo) return const SizedBox.shrink();
        final loc = AppLocalizations.of(context);
        if (loc == null) return const SizedBox.shrink();
        return _EndedBody(
            key: overlayKey, ended: ended, showActions: showActions);
      },
    );
  }
}

class _EndedBody extends StatelessWidget {
  const _EndedBody({super.key, required this.ended, required this.showActions});

  final QueueEndedInfo ended;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final handler = MediaPlayerHandler.instance;
    final textTheme = Theme.of(context).textTheme;
    final episode = ended.episode;
    final showId = episode?.$show?.id;
    final image = ImageUtil.getImageByType(
        episode?.images ?? ended.movie?.images, ImageTypes.background);
    final tv = PlatformService.isTvModeSync;

    return Stack(
      fit: StackFit.expand,
      children: [
        VideoCoverView(
          image: image,
          artUri: image == null ? ended.lastMediaItem.artUri : null,
          serverName: ended.serverName,
        ),
        const ColoredBox(color: Colors.black54),
        // Dark surface: every control here sits on the video, like the
        // rest of the chrome.
        Theme(
          data: Theme.of(context).copyWith(brightness: Brightness.dark),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    loc.queueEndedTitle,
                    textAlign: TextAlign.center,
                    style: textTheme.labelLarge?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ended.lastMediaItem.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style:
                        textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                  if (showActions) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        TvFocusable(
                          onTap: () => unawaited(handler.replayEndedQueue()),
                          autofocus: tv,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24)),
                          child: FilledButton.icon(
                            key: VideoEndedOverlay.watchAgainKey,
                            onPressed: () =>
                                unawaited(handler.replayEndedQueue()),
                            icon: const Icon(Icons.replay),
                            label: Text(loc.watchAgain),
                          ),
                        ),
                        TvFocusable(
                          onTap: handler.dismissQueueEnd,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24)),
                          child: OutlinedButton.icon(
                            key: VideoEndedOverlay.backKey,
                            onPressed: handler.dismissQueueEnd,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white70),
                            ),
                            icon: const Icon(Icons.arrow_back),
                            label: Text(episode != null
                                ? loc.backToShow
                                : loc.backToLibrary),
                          ),
                        ),
                      ],
                    ),
                    // Movies have no server-side relation yet (a
                    // `Movie.related` would slot in right here); episodes
                    // get the shows comparable to theirs.
                    if (showId != null) ...[
                      const SizedBox(height: 16),
                      DefaultTextStyle.merge(
                        style: const TextStyle(color: Colors.white),
                        child: RelatedShowsRow(
                          key: VideoEndedOverlay.suggestionsKey,
                          serverName: ended.serverName,
                          showId: showId,
                          limit: 8,
                          header: loc.youMightAlsoLike,
                          onShowTap: (id) =>
                              _openShow(context, ended.serverName, id),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Leaves the ended state and opens the picked show: fullscreen first (the
  /// route sits on the root navigator, above everything), then the page's
  /// cover falls back via [MediaPlayerHandler.dismissQueueEnd], then the
  /// show's overview on its server — the cross-server form, since the
  /// video may come from a server other than the one being browsed.
  Future<void> _openShow(
      BuildContext context, String serverName, String showId) async {
    final router = AutoRouter.of(context).root;
    final exitFullscreen = IsterPlayer.activeFullscreenExitHandler;
    if (exitFullscreen != null) await exitFullscreen();
    MediaPlayerHandler.instance.dismissQueueEnd();
    unawaited(router.navigate(ServerHomeRoute(
        serverName: serverName,
        children: [ShowOverviewRoute(showId: showId)])));
  }
}
