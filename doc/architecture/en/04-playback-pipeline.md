# Playback pipeline

The path from a tap on "play" to synced progress on the server. See the [playback-flow diagram](../diagrams/playback-flow.md).

## Play queues — `lib/utils/PlayQueueService.dart`

Every playback session is backed by a server-side play queue. `PlayQueueService` creates, fetches and updates them and broadcasts updated queues on a `StreamController<Fragment$fragmentPlayQueue>`; UI such as `RecentCarouselView` subscribes for live progress. The unified `createPlayQueue` mutation covers all content kinds; the queue can grow server-side (`sourceExhausted`).

## MediaPlayerHandler — `lib/utils/MediaPlayerHandler.dart`

A singleton extending `BaseAudioHandler` from `audio_service`, wrapping one `media_kit` `Player`. It handles **every** playable kind — episodes, movies, album tracks, podcast episodes and audiobook chapters. Each kind has its own entry point (`startPlayQueue`, `startPlayQueueForMovie`, `startPlayQueueForAlbum`, `startPlayQueueForBook`, `startPlayQueueForPodcast`, plus `startLibraryShuffle`/`startAlbumShuffle`); the queue item's non-null field discriminates the kind.

Key behaviours:

- **Resume for long-form audio** — podcasts and audiobooks resume at their recorded progress unless they already played to the end.
- **Track selection** — audio/subtitle tracks are chosen from the user's language preferences (`UserSettingsService`).
- **Stall watchdog** — hung HLS loads are re-opened at the stream-open position. This also compensates for the in-video controls, which bypass the handler; all app UI must call `handler.play()/pause()`.
- **Progress sync** — throttled to roughly 10 seconds of position delta, flushed on pause/stop, and guarded by a generation counter (`_syncGeneration`) so an in-flight sync response cannot revert a skip that happened meanwhile.
- `musicPlayerOpen` guards against double-pushing the music player overlay.
- Snackbars from the handler go through `AppMessenger.showAppSnackBar` (safe without a mounted messenger).

## Reactive state

Playback state flows out through `audio_service` `BehaviorSubject` streams. UI components `listen()` in `initState` and cancel in `dispose`. Prefer `positionSecondsStream` over the raw position stream — the raw one emits per frame and causes rebuild storms.

## Stream tokens on media URLs

Media and image URLs are not bearer-authenticated; `StreamTokenService` appends short-lived per-server stream tokens instead. The tokens self-refresh on timers with a minimum delay and retry-on-failure, so long playback sessions never lose their token chain silently.

## Background audio on Android

`audio_service` provides the notification controls and `MediaSession` integration. Two hard-won rules for Android 16, which blocks re-acquiring a foreground service or audio focus from the background:

- The foreground service stays alive while paused (`androidStopForegroundOnPause: false`).
- Audio focus is held across track gaps.

mpv additionally gets reconnect/network-timeout options so backgrounded HLS streams survive network hiccups.

## Multi-server caveat

The playing media can belong to a *different* server than the one being browsed. When navigating from playback UI (mini player → album, for example), resolve the server from the handler / `MediaItemId` (`lib/dto/MediaItemId.dart`, which encodes `serverName;type;id`), never from the current route.

## Android Auto / browse tree

`IsterMediaService` (`lib/dto/IsterMediaService.dart`) backs the audio-service browse tree for Android Auto; `MediaItemId` makes every browse-tree item self-describing across servers.
