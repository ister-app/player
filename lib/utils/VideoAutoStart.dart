/// Whether an episode/movie page should start (or resume) playback on its own
/// instead of showing the cover with a play button.
///
/// Opening a video from browsing never autoplays. The surface shows right away
/// only when the page is (re-)opened for the queue that is already playing —
/// the queue auto-advanced to the next episode, the mini player was tapped, a
/// watch-along/handoff brought the page up ([routeQueueId] matches the
/// handler's queue) — or when the handler already has this very item loaded
/// ([isCurrentVideo]).
bool shouldAutoStartVideo({
  required String? routeQueueId,
  required String? handlerQueueId,
  required bool isCurrentVideo,
}) {
  if (isCurrentVideo) return true;
  return routeQueueId != null && routeQueueId == handlerQueueId;
}
