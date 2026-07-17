# Epub-lezer

De lezer is **native, puur Flutter** — geen webview (Linux heeft er geen). Hij leeft in `lib/utils/epub/`, `lib/pages/ReaderPage.dart` en `lib/components/reader/`. Hij rendert één hoofdstuk tegelijk als een scrollende blokkenlijst, synchroniseert de leespositie met de server (inclusief de audioboekkoppeling) en speelt EPUB 3-voorleesaudio af.

## EpubResourceClient — `lib/utils/epub/EpubResourceClient.dart`

De epub wordt nooit in zijn geheel gedownload. Individuele entries worden lui opgehaald via het `/epub/{mediaFileId}/resource/`-endpoint van de node, geauthenticeerd met stream-tokens (`StreamTokenService`) en bewaard in een LRU-cache.

## EpubPackage — `lib/utils/epub/EpubPackage.dart`

De server bewaart geen spine of inhoudsopgave, dus de client parset de boekstructuur zelf: `container.xml`, het OPF-packagedocument, en het EPUB 3-nav-document of de NCX-fallback.

## ChapterContent en de blok-locator

`ChapterContent` (`lib/utils/epub/ChapterContent.dart`) splitst een hoofdstuk in top-level blokken; de **blokindex is de locatorcoördinaat**. Posities staan in het opake `readingLocation`-veld van de server als:

```
ister:v1;spine=…;block=…
```

`EpubLocator.tryParse` (`lib/utils/epub/EpubLocator.dart`) wijst de epubcfi-strings van de oude weblezer bewust af; die vallen dan terug op de voortgangsfractie — oude posities degraderen netjes in plaats van verkeerd op te lossen.

## ReadingSyncService — `lib/utils/epub/ReadingSyncService.dart`

Voortgangssync gebruikt het REST-paar `GET /book-progress` en een **gedebouncede** `POST /reading-progress` — *niet* de GraphQL-mutatie `updateReadingProgress`. REST draagt de audioboek-hoofdstukkoppeling die de server spiegelt, zodat lezen en luisteren op dezelfde plek hervatten.

De audio⇄tekst-koppeling is **zin-exact** via de SMIL-tijdlijn (`lib/utils/epub/SmilDocument.dart`) wanneer de duur daarvan overeenkomt met de duur van het audioboekhoofdstuk, en geïnterpoleerd in de andere gevallen.

## ReadAloudController — `lib/utils/epub/ReadAloudController.dart`

Speelt EPUB 3-media-overlays af op een **eigen** `media_kit` `Player` (per zin clip-gescheduled) en pauzeert `MediaPlayerHandler` bij de start, zodat de twee nooit om de uitvoer vechten. `ChapterView` (`lib/components/reader/`) markeert de actuele zin.

## ReaderPage — `lib/pages/ReaderPage.dart`

Bindt alles samen: zonder `chapter`-queryparam opent het boek op de opgeslagen leespositie — of op de audioboekpositie wanneer die nieuwer is; mét, op dat hoofdstuk (gematcht tegen de inhoudsopgave, met de spine als fallback). `readAloud` start de media-overlay-audio zodra het hoofdstuk getoond wordt. Ondersteunende delen: `ReaderBookController`, `ReaderPreferences`, `ReaderSettingsSheet`, `ReaderTocDrawer`.

## Striplezer, in het kort

`ComicReaderPage` (`lib/pages/ComicReaderPage.dart`) met een eigen stack in `lib/utils/comic/`: pagina-afbeeldingen in een swipende `PageView`, één *spread* per weergave (één pagina, of twee naast elkaar op een brede viewport), pinch-zoom, rechts-naar-links lezen dat per serie bewaard blijft, een miniatuurstrook, D-pad-/toetsenbordpaging en voortgangssync via `ComicSyncService`. Formaat-blind door `ComicPageSource`: cbz-pagina's streamen van de node (`ComicResourceClient`), pdf-pagina's worden lokaal gerenderd (`PdfPageSource`).
