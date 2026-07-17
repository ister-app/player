# Navigatie en routes

Navigatie gebruikt `auto_route` met getypeerde, gegenereerde routes. De boom staat in `lib/routes/AppRouter.dart` (`@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')`); `auto_route_generator` schrijft `AppRouter.gr.dart` — draai `dart run build_runner build` na wijzigingen aan de boom of het toevoegen van een `@RoutePage()`.

## De routeboom

Ook beschikbaar als [mermaid-diagram](../diagrams/route-tree.md).

```text
/                                        HomeRoute
/player                                  MusicPlayerRoute        (transparante overlay)
/remote/:serverName/:playQueueId         RemoteControlRoute      (transparante overlay)
/server/:serverName                      ServerHomeRoute
├── ''                                   ServerHomeOverviewRoute (initial)
│   ├── '' → redirect naar 'home'
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

## Path-parameters en overerving

Routeparams als `:serverName`, `:showId` en `:episodeId` reizen mee in het pad. Child-pages ontvangen de actuele server zonder hem in elk padsegment te herhalen via `@PathParam.inherit('serverName')` op hun constructor. De leesroutes nemen daarnaast `@QueryParam`s aan (`nodeUrl`, `title`, `chapter`, `page`, …).

**Navigeer met getypeerde routes, nooit met `pushPath`:** een serveridentifier kan zelf een pad bevatten (`localhost:8080/api`), wat URL-gebaseerde deep links breekt. De helpers `enterServerShell`/`pushRoute` van de integratietest-harness volgen dezelfde regel.

## Deep-link-guard

`ServerChildDeepLinkGuard` (`lib/routes/ServerChildDeepLinkGuard.dart`) hangt aan elk server-child buiten de overzichtstabbladen. Opent een deep link zo'n route direct, dan controleert de guard of `ServerHomeOverviewRoute` op de stack staat en pusht die zo nodig eerst — zodat de terugknop altijd op de serverhome uitkomt in plaats van de app te verlaten.

## Transparante speler-overlays

`MusicPlayerRoute` (`/player`) en `RemoteControlRoute` (`/remote/…`, party-modus) zijn `CustomRoute`s op de **root**-router met `opaque: false`, een transparante barrier en transities zonder duur. Beide renderen de gedeelde `PlayerView` (`lib/components/PlayerView.dart`) — slide-up/wegslepen, portret-/landschapslay-out, accentkleur, wachtrijtabbladen — via een `PlayerViewController`-adapter (lokale `MediaPlayerHandler` versus remote-sessie-abonnementen). Doordat ze op de root-stack staan, liggen ze boven de geneste serverroutes en de mini-player.

Twee waarborgen rond deze overlays:

- `MediaPlayerHandler.musicPlayerOpen` voorkomt dat de muziekspeler dubbel gepusht wordt.
- De terugknop moet de slide-down-animatie afspelen, niet direct poppen. `_MusicPlayerAwareDelegate` in `AppRouter.dart` overschrijft `popRoute`: is `PlayerView.activeBackHandler` niet null, dan roept hij die dismiss-handler aan en slikt de pop in; anders gedraagt terug zich normaal.
