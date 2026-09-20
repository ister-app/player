---
description: Naslag van de service-singletons per server in de Ister-player, van serverdiscovery en OIDC-login tot play queues, instellingen en zoeken.
---

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

## Admin-uploadstack — `lib/utils/upload/`

`UploadApi` is de REST-client voor de `/library-upload/**`-endpoints van de server. Anders dan elke andere REST-aanroep in de player authenticeert hij met het **bearer-token** van de login (`LoginManager.getToken`), niet met een stream-token: de server weigert stream-tokens voor schrijven in een library. Er wordt alleen GET en POST gebruikt, omdat de web-build een node cross-origin aanroept en de CORS van de server niets anders toestaat. De directory-lijst gaat naar de server zelf; preview, sessie en chunks gaan naar de `nodeUrl` van de gekozen directory, want een chunk wordt geschreven waar hij aankomt.

`UploadSource` abstraheert de gekozen map achter een conditional import: `upload_source_io.dart` (desktop, `file_picker` + `dart:io`), `upload_source_web.dart` (`<input webkitdirectory>` via `package:web`, met `File.slice` per chunk) en een stub. Bestanden worden altijd per bereik gelezen. Android en iOS lopen via `upload_source_native.dart` en het platformkanaal `app.ister.player/upload_source` (`UploadSourceChannel` in `android/.../UploadSourceChannel.kt` en in `ios/Runner/AppDelegate.swift`): een gekozen mapboom is daar een storage-access-framework-URI of een security-scoped map die `dart:io` niet mag opsommen of lezen, dus de native kant somt hem op en deelt byte-bereiken uit (1 MiB per aanroep, om kanaalberichten klein te houden). Zolang een runner actief is houdt de pagina een `ScreenWakelock`-token vast; er is bewust geen foreground-service — een stilgezette upload hervat.

`UploadRunner` (een `ChangeNotifier`) verplaatst de bytes: een paar bestanden parallel, die elk hun chunk-raster aflopen en sturen wat de server nog niet heeft — op `receivedBytes` voor lokale directories, op partnummer voor S3. Hij herhaalt transportfouten, 5xx en 429 met backoff, volgt bij een 409 de offset van de server, en houdt de voortgang per bestand op het item bij zodat pauze → start nooit een chunk opnieuw stuurt. `AdminUploadPage` onthoudt de lopende sessie per server in `SharedPreferencesAsync`, zodat je na een herstart verder kunt zodra dezelfde map opnieuw gekozen is (gematcht op relatief pad en grootte).

## AppMessenger — `lib/utils/AppMessenger.dart`

`showAppSnackBar` voor context-loze singletons zoals `MediaPlayerHandler`. Een no-op wanneer er geen messenger gemount is, en daarmee veilig tijdens headless audio-service-opstart.
