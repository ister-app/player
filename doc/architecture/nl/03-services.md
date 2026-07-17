# Services

Alle services leven in `lib/utils/` als singletons (of statische, `Map`-gesleutelde state) en zijn **per server**: aanroepen krijgen een serveridentifier mee en interne state is daarop gesleuteld. Zie het [multi-server-diagram](../diagrams/multi-server.md) voor hoe de discovery-/auth-keten in elkaar grijpt.

## WellKnownService — `lib/utils/WellKnownService.dart`

Serverdiscovery. Haalt `/.well-known/ister` op — een document van drie regels: weergavenaam, OIDC-URL, server-URL — en cachet dat in het geheugen én in SharedPreferences.

**Invariant:** de in-memory cache moet gevuld zijn *voordat* `ClientManager.createClient` draait. UI-pagina's halen hem op als onderdeel van hun flow; voor headless sessieherstel van audio_service bootstrapt `LoginManager.waitForToken` hem.

## ClientManager — `lib/utils/ClientManager.dart`

Eén `GraphQLClient` per server, verpakt in een `ValueNotifier` zodat widgets kunnen herbouwen wanneer de client vervangen wordt. Auth-tokens worden geïnjecteerd via een `AuthLink` die `LoginManager.getToken` aanroept. `getHttpOrHttps` kiest alleen kaal `http` voor localhost-/IP-hosts.

## LoginManager — `lib/utils/LoginManager.dart`

OIDC-state per server, statisch en `Map`-gesleuteld. Elke `OidcUserManager` krijgt `id: serverUrl`, zodat servers nooit tokenopslag delen. Initialisatie wordt gededupliceerd via een futures-map en is na een fout opnieuw te proberen. Token-refresh wordt per server gededupliceerd — nodig omdat refresh-tokens roteren. `LoginManager.testTokenProvider` is een testseam die alleen onder `--dart-define=ISTER_TEST_MODE=true` geraadpleegd wordt.

## StreamTokenService — `lib/utils/StreamTokenService.dart`

Kortlevende stream-tokens per server, aangehecht aan media- en afbeeldings-URL's. Zelfverversende timers met een minimale vertraging en retry-bij-falen, zodat de verversketen nooit geruisloos sterft.

## PlayQueueService — `lib/utils/PlayQueueService.dart`

Haalt, maakt en werkt play queues bij op de server, en biedt een broadcast-`StreamController<Fragment$fragmentPlayQueue>` voor abonnees (bijv. live voortgang in `RecentCarouselView`). Lookup-helpers gebruiken `.where(...).firstOrNull` — items kunnen legitiem in een queue ontbreken, dus "repareer" dat niet naar `.first`.

## MediaPlayerHandler — `lib/utils/MediaPlayerHandler.dart`

De afspeel-singleton; uitgebreid behandeld in [hoofdstuk 4](04-playback-pipeline.md). Erft van `BaseAudioHandler` (`audio_service`), omhult de `media_kit` `Player` en behandelt elk afspeelbaar soort. De UI moet via `handler.play()/pause()` gaan.

## UserSettingsService — `lib/utils/UserSettingsService.dart`

De afspeelinstellingen van de gebruiker (gesproken/ondertitel-talen, direct play, transcoderen, maximale videohoogte) zoals de **server** ze opslaat — per gebruiker, per server, met een lokale cache. `LanguagePreferences` en `PlaybackPreferences` zijn dunne lees-/schrijffaçades erbovenop; roep die aan, nooit direct de GraphQL-mutatie. `LanguageService` levert de ISO 639-3-talentabel uit `assets/`.

## SearchService — `lib/utils/SearchService.dart`

Omhult de `search`-query. De server rangschikt over films, series, afleveringen, personen, albums en tracks heen en geeft een union terug; resultaten worden gematcht op `Query$search$search`-subtypen.

## ResilientSubscription — `lib/utils/ResilientSubscription.dart`

**Gebruik dit altijd voor GraphQL-subscriptions in plaats van `client.subscribe`.** De socketclient van het `graphql`-package abonneert alleen opnieuw wanneer de *socket* wegvalt; een door de server gestuurd `complete`-/`error`-frame sluit de Dart-stream geruisloos en voorgoed. `ResilientSubscription` opent hem met backoff opnieuw.

## PlatformService — `lib/utils/PlatformService.dart`

Gecachete Android TV-detectie (leanback). De UI vertakt erop voor focus-highlights en afstandsbedieningvriendelijke bediening; verpak widgets liever in `TvFocusable` dan lay-outs te vertakken.

## Epub-leesstack — `lib/utils/epub/`

`EpubResourceClient`, `EpubPackage`, `ChapterContent`, `EpubLocator`, `ReadingSyncService`, `ReadAloudController`, `SmilDocument`, plus `ReaderPage` en de widgets in `lib/components/reader/`. Uitgewerkt in [hoofdstuk 6](06-epub-reader.md). De striplezer heeft een parallelle stack in `lib/utils/comic/`.

## AppMessenger — `lib/utils/AppMessenger.dart`

`showAppSnackBar` voor context-loze singletons zoals `MediaPlayerHandler`. Een no-op wanneer er geen messenger gemount is, en daarmee veilig tijdens headless audio-service-opstart.
