# Navigation and routes

Navigation uses `auto_route` with typed, generated routes. The tree lives in `lib/routes/AppRouter.dart` (`@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')`); `auto_route_generator` writes `AppRouter.gr.dart` — run `dart run build_runner build` after changing the tree or adding a `@RoutePage()`.

## The route tree

Also available as a [mermaid diagram](../diagrams/route-tree.md).

```text
/                                        HomeRoute
/player                                  MusicPlayerRoute        (transparent overlay)
/remote/:serverName/:playQueueId         RemoteControlRoute      (transparent overlay)
/server/:serverName                      ServerHomeRoute
├── ''                                   ServerHomeOverviewRoute (initial)
│   ├── '' → redirect to 'home'
│   ├── home                             ServerHomeContentRoute
│   ├── library                          ShowHomeRoute
│   └── settings                         ServerSettingsRoute
├── settings/languages                   ServerSettingsLanguageRoute   [guard]
├── settings/cluster                     ServerSettingsClusterRoute    [guard]
├── settings/playback                    ServerSettingsPlaybackRoute   [guard]
├── settings/nowplaying                  ServerNowPlayingRoute         [guard]
├── settings/activity                    ServerActivityRoute           [guard]
├── shows/:showId                        ShowOverviewRoute             [guard]
│   ├── overview                         ShowOverviewContentRoute (initial)
│   └── episodes/:episodeId              ShowEpisodeRoute
├── search                               SearchRoute                   [guard]
├── movies/:movieId                      MovieRoute                    [guard]
├── albums/:albumId                      AlbumRoute                    [guard]
├── books/:bookId                        BookRoute                     [guard]
├── books/:bookId/read/:mediaFileId      ReaderRoute                   [guard]
├── books/:bookId/comic/:mediaFileId     ComicReaderRoute              [guard]
├── series/:seriesId                     SeriesRoute                   [guard]
├── podcasts/:podcastId                  PodcastRoute                  [guard]
└── persons/:personId                    PersonRoute                   [guard]
```

## Path parameters and inheritance

Route params such as `:serverName`, `:showId`, `:episodeId` travel in the path. Child pages receive the current server without re-declaring it in every path segment via `@PathParam.inherit('serverName')` on their constructors. Reader routes additionally take `@QueryParam`s (`nodeUrl`, `title`, `chapter`, `page`, …).

**Navigate with typed routes, never `pushPath`:** a server identifier can contain a path itself (`localhost:8080/api`), which breaks URL-based deep links. The integration-test harness's `enterServerShell`/`pushRoute` helpers follow the same rule.

## Deep-link guard

`ServerChildDeepLinkGuard` (`lib/routes/ServerChildDeepLinkGuard.dart`) is attached to every server child outside the overview tabs. When a deep link opens such a route directly, the guard checks whether `ServerHomeOverviewRoute` is on the stack and pushes it first, so the back button always lands on the server home instead of exiting the app.

## Transparent player overlays

`MusicPlayerRoute` (`/player`) and `RemoteControlRoute` (`/remote/…`, party mode) are `CustomRoute`s on the **root** router with `opaque: false`, a transparent barrier and zero-duration transitions. Both render the shared `PlayerView` (`lib/components/PlayerView.dart`) — slide-up/drag-dismiss, portrait/landscape layouts, accent colour, queue tabs — through a `PlayerViewController` adapter (local `MediaPlayerHandler` vs. remote session subscriptions). Because they sit on the root stack they cover nested server routes and the mini player.

Two guards around these overlays:

- `MediaPlayerHandler.musicPlayerOpen` prevents pushing the music player twice.
- The back button must play the slide-down animation, not pop instantly. `_MusicPlayerAwareDelegate` in `AppRouter.dart` overrides `popRoute`: if `PlayerView.activeBackHandler` is non-null, it invokes that dismiss handler and swallows the pop; otherwise back behaves normally.
