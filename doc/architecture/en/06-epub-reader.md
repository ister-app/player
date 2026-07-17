# Epub reader

The reader is **native, pure Flutter** — no webview (Linux has none). It lives in `lib/utils/epub/`, `lib/pages/ReaderPage.dart` and `lib/components/reader/`. It renders one chapter at a time as a scrolling block list, syncs the reading position with the server (including the audiobook mapping) and plays EPUB 3 read-aloud audio.

## EpubResourceClient — `lib/utils/epub/EpubResourceClient.dart`

The epub is never downloaded whole. Individual entries are fetched lazily through the node's `/epub/{mediaFileId}/resource/` endpoint, authenticated with stream tokens (`StreamTokenService`) and held in an LRU cache.

## EpubPackage — `lib/utils/epub/EpubPackage.dart`

The server persists no spine or TOC, so the client parses the book structure itself: `container.xml`, the OPF package document, and the EPUB 3 nav document or NCX fallback.

## ChapterContent and the block locator

`ChapterContent` (`lib/utils/epub/ChapterContent.dart`) splits a chapter into top-level blocks; the **block index is the locator coordinate**. Positions are stored in the server's opaque `readingLocation` field as:

```
ister:v1;spine=…;block=…
```

`EpubLocator.tryParse` (`lib/utils/epub/EpubLocator.dart`) deliberately rejects the old web reader's epubcfi strings, which then fall back to the progress fraction — old positions degrade gracefully instead of mis-resolving.

## ReadingSyncService — `lib/utils/epub/ReadingSyncService.dart`

Progress sync uses the REST pair `GET /book-progress` and a **debounced** `POST /reading-progress` — *not* the GraphQL `updateReadingProgress` mutation. REST carries the audiobook chapter mapping the server mirrors, so reading and listening resume at the same place.

The audio⇄text mapping is **sentence-exact** via the SMIL timeline (`lib/utils/epub/SmilDocument.dart`) when that timeline's duration matches the audiobook chapter duration, and interpolated otherwise.

## ReadAloudController — `lib/utils/epub/ReadAloudController.dart`

Plays EPUB 3 media overlays on a **dedicated** `media_kit` `Player` (clip-scheduled per sentence) and pauses `MediaPlayerHandler` when it starts, so the two never fight over output. `ChapterView` (`lib/components/reader/`) highlights the current sentence.

## ReaderPage — `lib/pages/ReaderPage.dart`

Ties it together: without a `chapter` query param the book opens at the saved reading position — or at the audiobook position when that is newer; with one, at that chapter (matched against the TOC, falling back to the spine). `readAloud` starts media-overlay audio as soon as the chapter is displayed. Supporting pieces: `ReaderBookController`, `ReaderPreferences`, `ReaderSettingsSheet`, `ReaderTocDrawer`.

## Comic reader, in brief

`ComicReaderPage` (`lib/pages/ComicReaderPage.dart`) with its own stack in `lib/utils/comic/`: page images in a swiping `PageView`, one *spread* per view (one page, or two on a wide viewport), pinch-zoom, right-to-left reading persisted per series, a thumbnail strip, D-pad/keyboard paging, and progress sync via `ComicSyncService`. It is format-blind through `ComicPageSource`: cbz pages stream off the node (`ComicResourceClient`), pdf pages are rendered locally (`PdfPageSource`).
