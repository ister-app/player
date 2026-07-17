# Afspeelpijplijn

Het pad van een tik op "afspelen" tot gesynchroniseerde voortgang op de server. Zie het [afspeelflow-diagram](../diagrams/playback-flow.md).

## Play queues — `lib/utils/PlayQueueService.dart`

Elke afspeelsessie wordt gedragen door een play queue aan de serverkant. `PlayQueueService` maakt, haalt en werkt ze bij en broadcast bijgewerkte queues op een `StreamController<Fragment$fragmentPlayQueue>`; UI zoals `RecentCarouselView` abonneert zich voor live voortgang. De geünificeerde `createPlayQueue`-mutatie dekt alle contentsoorten; de queue kan aan de serverkant groeien (`sourceExhausted`).

## MediaPlayerHandler — `lib/utils/MediaPlayerHandler.dart`

Een singleton die `BaseAudioHandler` uit `audio_service` uitbreidt en één `media_kit` `Player` omhult. Hij behandelt **elk** afspeelbaar soort — afleveringen, films, albumtracks, podcastafleveringen en audioboekhoofdstukken. Elk soort heeft zijn eigen ingang (`startPlayQueue`, `startPlayQueueForMovie`, `startPlayQueueForAlbum`, `startPlayQueueForBook`, `startPlayQueueForPodcast`, plus `startLibraryShuffle`/`startAlbumShuffle`); het niet-null-veld van het queue-item bepaalt het soort.

Kerngedrag:

- **Hervatten van langlopende audio** — podcasts en audioboeken hervatten op hun opgeslagen voortgang, tenzij ze al tot het einde zijn afgespeeld.
- **Trackselectie** — audio- en ondertiteltracks worden gekozen op basis van de taalvoorkeuren van de gebruiker (`UserSettingsService`).
- **Stall-watchdog** — vastgelopen HLS-loads worden heropend op de positie van het stream-openen. Dit compenseert ook de in-video-bediening, die de handler omzeilt; alle app-UI moet `handler.play()/pause()` aanroepen.
- **Voortgangssync** — gedrosseld tot ruwweg 10 seconden positieverschil, geflusht bij pauze/stop, en bewaakt met een generatieteller (`_syncGeneration`) zodat een nog onderweg zijnd sync-antwoord een intussen uitgevoerde skip niet kan terugdraaien.
- `musicPlayerOpen` voorkomt het dubbel pushen van de muziekspeler-overlay.
- Snackbars vanuit de handler lopen via `AppMessenger.showAppSnackBar` (veilig zonder gemounte messenger).

## Reactieve state

De afspeelstatus stroomt naar buiten via `audio_service` `BehaviorSubject`-streams. UI-componenten doen `listen()` in `initState` en annuleren in `dispose`. Gebruik `positionSecondsStream` in plaats van de ruwe positiestream — die emit per frame en veroorzaakt rebuild-stormen.

## Stream-tokens op media-URL's

Media- en afbeeldings-URL's zijn niet bearer-geauthenticeerd; `StreamTokenService` hangt er kortlevende stream-tokens per server aan. De tokens verversen zichzelf op timers met een minimale vertraging en retry-bij-falen, zodat lange afspeelsessies hun tokenketen nooit geruisloos kwijtraken.

## Achtergrondaudio op Android

`audio_service` levert de notificatiebediening en de `MediaSession`-integratie. Twee zwaarbevochten regels voor Android 16, dat het opnieuw verwerven van een foreground service of audiofocus vanuit de achtergrond blokkeert:

- De foreground service blijft in leven tijdens pauze (`androidStopForegroundOnPause: false`).
- Audiofocus wordt vastgehouden over trackovergangen heen.

mpv krijgt bovendien reconnect-/netwerktime-outopties zodat HLS-streams op de achtergrond netwerkhaperingen overleven.

## Multi-server-valkuil

Het spelende medium kan bij een *andere* server horen dan de server waarin gebladerd wordt. Los bij navigatie vanuit de afspeel-UI (bijvoorbeeld mini-player → album) de server op via de handler / `MediaItemId` (`lib/dto/MediaItemId.dart`, dat `serverName;type;id` codeert), nooit via de huidige route.

## Android Auto / browse-tree

`IsterMediaService` (`lib/dto/IsterMediaService.dart`) draagt de audio-service-browse-tree voor Android Auto; dankzij `MediaItemId` is elk browse-tree-item over servers heen zelfbeschrijvend.
