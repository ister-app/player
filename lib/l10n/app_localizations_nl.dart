// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get library => 'Bibliotheek';

  @override
  String get settings => 'Instellingen';

  @override
  String appVersion(String version) {
    return 'Versie $version';
  }

  @override
  String get preferredSpoken => 'Voorkeurstaal voor gesproken audio:';

  @override
  String get preferredSubtitle => 'Voorkeurstaal voor ondertiteling:';

  @override
  String loadError(Object error) {
    return 'Kan voorkeuren niet laden: $error';
  }

  @override
  String get selectLanguage => 'Selecteer een taal';

  @override
  String error(Object error) {
    return 'Fout: $error';
  }

  @override
  String get noLanguagesFound => 'Geen talen gevonden.';

  @override
  String get searchHint => 'Zoek naar een taal...';

  @override
  String get noLanguageFound => 'Geen taal gevonden!';

  @override
  String get refreshPage => 'Vernieuw pagina';

  @override
  String get scanLibrary => 'Scan bibliotheek';

  @override
  String get analyzeLibrary => 'Analyseer bibliotheek';

  @override
  String get reindexSearch => 'Zoekindex herbouwen';

  @override
  String get analyzeAllLibraries => 'Alle bibliotheken';

  @override
  String get management => 'Beheer';

  @override
  String get usersAndAccess => 'Gebruikers & toegang';

  @override
  String get libraryVisibility => 'Bibliotheek-zichtbaarheid';

  @override
  String get visibleToEveryone => 'Voor iedereen zichtbaar';

  @override
  String get restrictedLibrarySubtitle =>
      'Beperkt — alleen toegewezen gebruikers';

  @override
  String get adminLabel => 'Admin';

  @override
  String get noUsersYet =>
      'Nog geen gebruikers — een gebruiker verschijnt hier na de eerste login.';

  @override
  String get adminRoleNote =>
      'Admins zien altijd alle bibliotheken. De adminrol zelf wordt toegekend in de identity provider (bijv. Keycloak).';

  @override
  String get changeNotSaved => 'Wijziging kon niet worden opgeslagen';

  @override
  String taskStarted(String task) {
    return 'Gestart: $task';
  }

  @override
  String taskFailed(String task) {
    return 'Mislukt: $task';
  }

  @override
  String get goToShow => 'Ga naar show';

  @override
  String get goToArtist => 'Ga naar artiest';

  @override
  String get goToAuthor => 'Ga naar auteur';

  @override
  String get listen => 'Luisteren';

  @override
  String get read => 'Lezen';

  @override
  String get readAloud => 'Meelezen';

  @override
  String get howDoYouWantToRead => 'Hoe wil je dit lezen?';

  @override
  String get startReading => 'Start met lezen';

  @override
  String get continueReading => 'Ga verder met lezen';

  @override
  String get chapters => 'Hoofdstukken';

  @override
  String get chapter => 'Hoofdstuk';

  @override
  String get episodes => 'Afleveringen';

  @override
  String get addPodcast => 'Podcast toevoegen';

  @override
  String get addPodcastHint => 'Zoek, of plak een feed-URL';

  @override
  String get subscribeFailed => 'Abonneren op deze feed is mislukt';

  @override
  String get unsubscribe => 'Abonnement opzeggen';

  @override
  String get download => 'Downloaden';

  @override
  String get watchNext => 'Blijf kijken';

  @override
  String get recentlyAddedShows => 'Onlangs toegevoegde shows';

  @override
  String season(int number) {
    return 'Seizoen $number';
  }

  @override
  String episode(int number) {
    return 'Aflevering $number';
  }

  @override
  String episodePrefix(int number) {
    return 'A$number';
  }

  @override
  String combinedFileWith(String others) {
    return 'Gecombineerd bestand met $others';
  }

  @override
  String get serverUnreachable => 'Server niet bereikbaar';

  @override
  String get backToServerOverview => 'Terug naar serveroverzicht';

  @override
  String get close => 'Sluiten';

  @override
  String get json => 'JSON';

  @override
  String get rawData => 'Raw data';

  @override
  String get nodes => 'Nodes';

  @override
  String get server => 'Server';

  @override
  String get serverSettingsSubtitle => 'Nodes, activiteit en onderhoud';

  @override
  String get languageSettings => 'Taalinstellingen';

  @override
  String get loginTitle => 'Aanmelden';

  @override
  String loginDescription(Object serverName) {
    return 'Meld je aan om toegang te krijgen tot $serverName';
  }

  @override
  String loginButton(Object serverName) {
    return 'Aanmelden bij $serverName';
  }

  @override
  String get playbackSettings => 'Afspeelinstelling';

  @override
  String get directPlay => 'Direct afspelen';

  @override
  String get directPlayDescription =>
      'Origineel bestand streamen zonder transcodering';

  @override
  String get autoSkipIntro => 'Intro\'s automatisch overslaan';

  @override
  String get autoSkipIntroDescription =>
      'Spring zonder vragen voorbij gedetecteerde intro\'s';

  @override
  String get skipIntro => 'Intro overslaan';

  @override
  String skipIntroCountdown(int seconds) {
    return 'Intro overslaan ($seconds)';
  }

  @override
  String get nextEpisode => 'Volgende aflevering';

  @override
  String get analyzeMedia => 'Analyseer media';

  @override
  String get switchServer => 'Wissel van server';

  @override
  String get servers => 'Servers';

  @override
  String get noRecentItems => 'Geen recente items';

  @override
  String get noSeason => 'Geen seizoen';

  @override
  String get addServer => 'Voeg een server toe';

  @override
  String get noServersAdded => 'Nog geen servers toegevoegd';

  @override
  String get noSeasonsFound => 'Geen seizoenen gevonden';

  @override
  String get trackAuto => 'Auto';

  @override
  String get trackNone => 'Geen';

  @override
  String get noShowFound => 'Geen show gevonden';

  @override
  String get deviceFlowInstructions =>
      'Ga naar de onderstaande URL op een ander apparaat en voer de code in:';

  @override
  String get transcode => 'Transcoderen';

  @override
  String get transcodeDescription =>
      'Stream server-side hercoderen (altijd aan voor web)';

  @override
  String get maxQuality => 'Maximale kwaliteit';

  @override
  String get maxQualityDescription =>
      'Hoogste kwaliteit die de server voor je klaarzet';

  @override
  String get qualityAuto => 'Automatisch';

  @override
  String get play => 'Afspelen';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get songs => 'Nummers';

  @override
  String get albums => 'Albums';

  @override
  String get books => 'Boeken';

  @override
  String get newestFirst => 'Nieuwste eerst';

  @override
  String get oldestFirst => 'Oudste eerst';

  @override
  String get sortOrderFailed => 'Kon de sorteervolgorde niet wijzigen';

  @override
  String get sortBy => 'Sorteren op';

  @override
  String get sortByName => 'Naam';

  @override
  String get sortByDateAdded => 'Toegevoegd';

  @override
  String get sortByReleaseYear => 'Releasejaar';

  @override
  String get artists => 'Artiesten';

  @override
  String get switchLibrary => 'Bibliotheek wisselen';

  @override
  String get description => 'Beschrijving';

  @override
  String get previousTracks => 'TERUG NAAR';

  @override
  String get upNext => 'HIERNA';

  @override
  String get noPreviousTracks => 'Geen vorige nummers';

  @override
  String get noNextTracks => 'Geen volgende nummers';

  @override
  String get cast => 'Cast';

  @override
  String get rate => 'Beoordelen';

  @override
  String get yourRating => 'Jouw beoordeling';

  @override
  String ratingValue(int value) {
    return '$value/10';
  }

  @override
  String get ratingFailed => 'Kon je beoordeling niet opslaan';

  @override
  String get appearsIn => 'Verschijnt in';

  @override
  String get appearsOn => 'Verschijnt op';

  @override
  String get personNotFound => 'Persoon niet gevonden';

  @override
  String get readMore => 'Lees meer';

  @override
  String get mostPlayedTracks => 'Meest afgespeeld';

  @override
  String get recentlyPlayedTracks => 'Laatst afgespeeld';

  @override
  String get highestRatedTracks => 'Hoogst beoordeeld';

  @override
  String get viewDiscover => 'Ontdekken';

  @override
  String get goToAlbum => 'Ga naar album';

  @override
  String get browseKindAlbums => 'Albums';

  @override
  String get browseKindArtists => 'Artiesten';

  @override
  String get browseKindTracks => 'Nummers';

  @override
  String get browseKindShows => 'Series';

  @override
  String get browseKindEpisodes => 'Afleveringen';

  @override
  String get viewAsGrid => 'Rasterweergave';

  @override
  String get viewAsList => 'Lijstweergave';

  @override
  String get sortByAirDate => 'Uitzenddatum';

  @override
  String get viewBrowse => 'Bladeren';

  @override
  String get projectWebsite => 'Website';

  @override
  String get projectSourceCode => 'Broncode op GitHub';

  @override
  String get showAll => 'Toon alles';

  @override
  String get allAlbums => 'Alle albums';

  @override
  String get allBooks => 'Alle boeken';

  @override
  String get allPodcasts => 'Alle podcasts';

  @override
  String get recentlyAdded => 'Recent toegevoegd';

  @override
  String get recentlyPlayed => 'Laatst afgespeeld';

  @override
  String get mostPlayed => 'Meest afgespeeld';

  @override
  String get highestRated => 'Hoogst beoordeeld';

  @override
  String get recentlyRead => 'Recent gelezen';

  @override
  String playCountTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count keer afgespeeld',
      one: '1 keer afgespeeld',
    );
    return '$_temp0';
  }

  @override
  String get showMore => 'Toon meer';

  @override
  String get playedJustNow => 'Zojuist';

  @override
  String get playbackHistory => 'Afspeelgeschiedenis';

  @override
  String get markPlayedNow => 'Markeren als zojuist afgespeeld';

  @override
  String get playbackHistoryEmpty => 'Nog niet afgespeeld';

  @override
  String get playbackHistoryDeleteBookHint =>
      'Verwijderen wist je leesvoortgang.';

  @override
  String get deleteHistoryEntry => 'Regel verwijderen';

  @override
  String hoursAgoShort(int count) {
    return '$count uur geleden';
  }

  @override
  String daysAgoShort(int count) {
    return '$count d geleden';
  }

  @override
  String weeksAgoShort(int count) {
    return '$count wk geleden';
  }

  @override
  String monthsAgoShort(int count) {
    return '$count mnd geleden';
  }

  @override
  String yearsAgoShort(int count) {
    return '$count jr geleden';
  }

  @override
  String get showLess => 'Toon minder';

  @override
  String discHeader(int number) {
    return 'Cd $number';
  }

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nummers',
      one: '1 nummer',
    );
    return '$_temp0';
  }

  @override
  String albumStats(String tracks, String duration) {
    return '$tracks • $duration';
  }

  @override
  String episodeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count afleveringen',
      one: '1 aflevering',
    );
    return '$_temp0';
  }

  @override
  String albumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count albums',
      one: '1 album',
    );
    return '$_temp0';
  }

  @override
  String bookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count boeken',
      one: '1 boek',
    );
    return '$_temp0';
  }

  @override
  String movieCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count films',
      one: '1 film',
    );
    return '$_temp0';
  }

  @override
  String showCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count series',
      one: '1 serie',
    );
    return '$_temp0';
  }

  @override
  String get search => 'Zoeken';

  @override
  String get noResults => 'Geen resultaten';

  @override
  String get movie => 'Film';

  @override
  String get show => 'Serie';

  @override
  String get artist => 'Artiest';

  @override
  String get typeEpisode => 'Aflevering';

  @override
  String get typePerson => 'Persoon';

  @override
  String get typeAlbum => 'Album';

  @override
  String get typeTrack => 'Nummer';

  @override
  String get searchInDescription => 'In beschrijving';

  @override
  String get searchThisLibrary => 'Deze bibliotheek';

  @override
  String get searchAllLibraries => 'Alle bibliotheken';

  @override
  String get addToQueue => 'Aan wachtrij toevoegen';

  @override
  String get removeFromQueue => 'Uit wachtrij verwijderen';

  @override
  String get shufflePlay => 'Shuffle afspelen';

  @override
  String get trackNotPlayable =>
      'Dit nummer kan nog niet worden afgespeeld — het is niet geanalyseerd';

  @override
  String skippedTrackNoFile(String title) {
    return '‘$title’ overgeslagen — nog niet geanalyseerd';
  }

  @override
  String skippedTrackPlaybackFailed(String title) {
    return '‘$title’ overgeslagen — kon niet worden afgespeeld';
  }

  @override
  String get nowPlaying => 'Speelt nu';

  @override
  String get noActiveSessions => 'Geen actieve afspeelsessies';

  @override
  String get queues => 'Wachtrijen';

  @override
  String queueDepth(int depth) {
    return 'Diepte $depth';
  }

  @override
  String consumers(int count) {
    return '$count consumers';
  }

  @override
  String get recentFailures => 'Recente fouten';

  @override
  String get noRecentFailures => 'Geen recente fouten';

  @override
  String processedCount(int count) {
    return '$count verwerkt';
  }

  @override
  String failedCount(int count) {
    return '$count mislukt';
  }

  @override
  String get idle => 'Inactief';

  @override
  String get busyNow => 'Nu bezig met';

  @override
  String get queuedWork => 'Wachtrij';

  @override
  String get allQueuesEmpty => 'Alle wachtrijen zijn leeg';

  @override
  String get queueDetails => 'Wachtrijdetails';

  @override
  String get serverIdle => 'De server is inactief';

  @override
  String get serverIdleSubtitle =>
      'Er wordt niets verwerkt en er staat geen werk in de wachtrij.';

  @override
  String lastSeenAgo(String time) {
    return 'Laatst gezien $time';
  }

  @override
  String get backgroundTag => 'achtergrond';

  @override
  String get transcodesTag => 'Transcoderen';

  @override
  String get activityKindAnalyzeFile => 'Mediabestand analyseren';

  @override
  String get activityKindScan => 'Zoeken naar nieuwe bestanden';

  @override
  String get activityKindAnalyzeLibrary => 'Bibliotheek analyseren';

  @override
  String get activityKindMetadata => 'Metadata ophalen';

  @override
  String get activityKindImportFiles => 'Bestanden importeren';

  @override
  String get activityKindArtwork => 'Afbeeldingen verwerken';

  @override
  String get activityKindTranscode => 'Transcoderen';

  @override
  String get activityKindPodcast => 'Podcasts bijwerken';

  @override
  String get activityKindContinueWatching => 'Verder kijken bijwerken';

  @override
  String get activityKindSegments => 'Intro\'s en outro\'s detecteren';

  @override
  String get activityKindSearchIndex => 'Zoekindex bijwerken';

  @override
  String get activityKindOther => 'Bezig';

  @override
  String activityQueuedAnalyzeFile(int count) {
    return 'Nog $count bestanden analyseren';
  }

  @override
  String activityQueuedScan(int count) {
    return '$count scantaken in de wachtrij';
  }

  @override
  String activityQueuedMetadata(int count) {
    return '$count items wachten op metadata';
  }

  @override
  String activityQueuedArtwork(int count) {
    return 'Nog $count afbeeldingen verwerken';
  }

  @override
  String activityQueuedTranscode(int count) {
    return '$count transcodeertaken in de wachtrij';
  }

  @override
  String activityQueuedSegments(int count) {
    return 'Nog $count seizoenen controleren op intro\'s';
  }

  @override
  String activityQueuedGeneric(int count, String label) {
    return '$count in de wachtrij — $label';
  }

  @override
  String get activityStepProbe => 'Streams lezen';

  @override
  String get activityStepCrop => 'Zwarte balken detecteren';

  @override
  String get activityStepSubtitles => 'Ondertitels uitpakken';

  @override
  String get activityStepBoundaries => 'Afleveringsgrenzen bepalen';

  @override
  String get activityStepStill => 'Achtergrondafbeelding maken';

  @override
  String get activityStepFingerprint => 'Audio fingerprinten';

  @override
  String get activityStepMatch => 'Intro\'s en outro\'s vergelijken';

  @override
  String get activityStepTranscode => 'Transcoderen';

  @override
  String relativeSecondsAgo(int count) {
    return '${count}s geleden';
  }

  @override
  String relativeMinutesAgo(int count) {
    return '$count min geleden';
  }

  @override
  String relativeHoursAgo(int count) {
    return '$count uur geleden';
  }

  @override
  String relativeDaysAgo(int count) {
    return '$count dagen geleden';
  }

  @override
  String get statePlaying => 'Speelt af';

  @override
  String get statePaused => 'Gepauzeerd';

  @override
  String get liveUpdatesUnavailable =>
      'Live updates onderbroken — opnieuw verbinden';

  @override
  String get sessionEnded => 'Sessie beëindigd';

  @override
  String get addToSession => 'Toevoegen aan sessie';

  @override
  String get chooseSession => 'Kies een sessie';

  @override
  String get playNext => 'Hierna afspelen';

  @override
  String get addToEndOfQueue => 'Achteraan toevoegen';

  @override
  String get addedToSession => 'Toegevoegd aan sessie';

  @override
  String get addToSessionFailed => 'Toevoegen aan sessie mislukt';

  @override
  String get remotePlay => 'Hervat via afstandsbediening';

  @override
  String get remotePause => 'Gepauzeerd via afstandsbediening';

  @override
  String get remoteNext => 'Volgende via afstandsbediening';

  @override
  String get remotePrevious => 'Vorige via afstandsbediening';

  @override
  String get remoteSeek => 'Positie gewijzigd via afstandsbediening';

  @override
  String get remoteSkipToItem => 'Ander item gekozen via afstandsbediening';

  @override
  String get remoteQueueChanged => 'Wachtrij bijgewerkt via afstandsbediening';

  @override
  String get remoteStop => 'Afspelen gestopt via afstandsbediening';

  @override
  String get stopPlayback => 'Afspelen stoppen';

  @override
  String get moreOptions => 'Meer opties';

  @override
  String get showQueue => 'Wachtrij tonen';

  @override
  String get tableOfContents => 'Inhoud';

  @override
  String get readerSettings => 'Leesinstellingen';

  @override
  String get fontSize => 'Lettergrootte';

  @override
  String get readerTheme => 'Thema';

  @override
  String get readerThemeLight => 'Licht';

  @override
  String get readerThemeSepia => 'Sepia';

  @override
  String get readerThemeDark => 'Donker';

  @override
  String get lineHeight => 'Regelafstand';

  @override
  String get pageMargins => 'Marges';

  @override
  String get readerFont => 'Lettertype';

  @override
  String get readerFontStandard => 'Boekstandaard';

  @override
  String get readerFontSerif => 'Serif';

  @override
  String get readerFontSans => 'Sans';

  @override
  String get enterFullscreen => 'Volledig scherm';

  @override
  String get exitFullscreen => 'Volledig scherm verlaten';

  @override
  String get couldNotLoadBook => 'Het boek kon niet worden geladen';

  @override
  String get noReadAloudForChapter => 'Dit hoofdstuk heeft geen voorleesaudio';

  @override
  String get bookMayNotDisplayCorrectly =>
      'Dit boek heeft een vaste opmaak en wordt mogelijk niet goed weergegeven';

  @override
  String get previousChapter => 'Vorig hoofdstuk';

  @override
  String get nextChapter => 'Volgend hoofdstuk';

  @override
  String get couldNotLoadComic => 'Kon de strip niet laden';

  @override
  String pageOfPages(int current, int total) {
    return 'Pagina $current van $total';
  }

  @override
  String get readingDirectionRtl => 'Van rechts naar links lezen (manga)';

  @override
  String pageRangeOfPages(int from, int to, int total) {
    return 'Pagina $from-$to van $total';
  }

  @override
  String get goToSeries => 'Ga naar serie';

  @override
  String get volumes => 'Delen';

  @override
  String get fitWidth => 'Breedte passend';

  @override
  String get fitPage => 'Pagina passend';

  @override
  String get pageOverview => 'Pagina\'s';

  @override
  String get spreadModeAuto => 'Pagina\'s per weergave: automatisch';

  @override
  String get spreadModeSingle => 'Pagina\'s per weergave: één';

  @override
  String get spreadModeDouble => 'Pagina\'s per weergave: twee';

  @override
  String get nextVolume => 'Volgend deel';

  @override
  String get readingDirection => 'Leesrichting';

  @override
  String readingDirectionDefault(String direction) {
    return 'Standaard ($direction)';
  }

  @override
  String get readingDirectionLtr => 'Links naar rechts';

  @override
  String get readingDirectionRtlShort => 'Rechts naar links';

  @override
  String get couldNotSaveReadingDirection => 'Kon de leesrichting niet opslaan';

  @override
  String sourceAttribution(String sources) {
    return 'Bron: $sources';
  }

  @override
  String get aboutAttributions => 'Over & bronvermelding';

  @override
  String get attributionsIntro =>
      'Metadata en afbeeldingen op deze server zijn afkomstig van de volgende externe bronnen:';

  @override
  String attributionLicense(String license) {
    return 'Licentie: $license';
  }

  @override
  String get attributionsUnavailable =>
      'De server meldt zijn bronnen nog niet.';

  @override
  String get openSourceLicenses => 'Open-source licenties';

  @override
  String get sharingSettings => 'Delen & privacy';

  @override
  String get sharingSettingsSubtitle => 'Wie ziet en bedient wat je afspeelt';

  @override
  String get nowPlayingVisibility => 'Nu speelt';

  @override
  String get nowPlayingVisibilityDescription =>
      'Wie kan zien wat je nu afspeelt';

  @override
  String get remoteControlSharing => 'Afstandsbediening';

  @override
  String get remoteControlSharingDescription =>
      'Wie jouw afspelen kan bedienen vanaf hun apparaat';

  @override
  String get sharingScopeEveryone => 'Iedereen';

  @override
  String get sharingScopePrivate => 'Alleen ik';

  @override
  String get sharingScopeAllowlist => 'Bepaalde mensen';

  @override
  String get sharingScopeSameAsNowPlaying => 'Zelfde als nu speelt';

  @override
  String get sharingChoosePeople => 'Kies mensen';

  @override
  String get sharingNoOtherUsers =>
      'Er zijn nog geen andere gebruikers om mee te delen.';

  @override
  String get sharingCouldNotLoad => 'Kon de deelinstellingen niet laden.';

  @override
  String get sharingCouldNotSave => 'Kon de deelinstellingen niet opslaan';

  @override
  String get sessionSharingTitle => 'Wie mag deze sessie bedienen';

  @override
  String get sessionSharingUseDefault => 'Mijn standaard gebruiken';

  @override
  String get shareThisSession => 'Deze sessie delen';

  @override
  String get sleepTimer => 'Slaaptimer';

  @override
  String sleepTimerMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String sleepTimerRemaining(String time) {
    return '$time resterend';
  }

  @override
  String get sleepTimerCancel => 'Timer annuleren';

  @override
  String get sleepTimerExtend => '+15 min';

  @override
  String get sleepTimerCustom => 'Aangepast…';

  @override
  String get sleepTimerCustomDuration => 'Aangepaste duur';

  @override
  String get sleepTimerMinutesLabel => 'Minuten';

  @override
  String get sleepTimerAuto => 'Automatische slaaptimer';

  @override
  String get sleepTimerAutoDescription =>
      'Start de slaaptimer automatisch wanneer het afspelen tussen deze tijden begint';

  @override
  String get sleepTimerFrom => 'Vanaf';

  @override
  String get sleepTimerUntil => 'Tot';

  @override
  String get sleepTimerDefaultDuration => 'Standaardduur';

  @override
  String get sleepTimerDeviceOnly => 'Geldt alleen voor dit apparaat';

  @override
  String sleepTimerStartedMessage(int minutes) {
    return 'Slaaptimer gestart: afspelen pauzeert over $minutes min';
  }

  @override
  String get sleepTimerExpiredMessage =>
      'Slaaptimer afgelopen: afspelen gepauzeerd';

  @override
  String get sleepTimerAfterDuration => 'Na een tijd';

  @override
  String get sleepTimerAfterItems => 'Na een aantal items';

  @override
  String sleepTimerItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: 'Dit item',
    );
    return '$_temp0';
  }

  @override
  String sleepTimerItemsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nog $count items',
      one: 'Nog 1 item',
    );
    return '$_temp0';
  }

  @override
  String sleepTimerItemsShort(int count) {
    return '$count×';
  }

  @override
  String get sleepTimerItemsCount => 'Aantal items';

  @override
  String sleepTimerItemsStartedMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Slaaptimer gestart: afspelen pauzeert na $count items',
      one: 'Slaaptimer gestart: afspelen pauzeert na dit item',
    );
    return '$_temp0';
  }

  @override
  String get customFilter => 'Custom filter';

  @override
  String get filterMatchAll => 'Overeenkomen met al het volgende';

  @override
  String get filterMatchAny => 'Overeenkomen met een van de volgende';

  @override
  String get filterAddCondition => 'Voorwaarde toevoegen';

  @override
  String get filterAddSubgroup => 'Subgroep toevoegen';

  @override
  String get filterClear => 'Filter wissen';

  @override
  String get filterApply => 'Toepassen';

  @override
  String get filterSaveAsView => 'Opslaan als view';

  @override
  String get filterLimitTo => 'Limiteer tot';

  @override
  String filterActiveChip(int count) {
    return 'Filter ($count)';
  }

  @override
  String get filterViewNameLabel => 'Naam';

  @override
  String get filterSavedViews => 'Views';

  @override
  String get filterDeleteView => 'View verwijderen';

  @override
  String get filterValueHint => 'Waarde';

  @override
  String get filterDateHint => 'JJJJ-MM-DD';

  @override
  String get filterValueTrue => 'Ja';

  @override
  String get filterValueFalse => 'Nee';

  @override
  String get filterPlayResults => 'Resultaten afspelen';

  @override
  String get filterViewSaveFailed => 'View opslaan mislukt';

  @override
  String get filterSaveAsPlaylist => 'Opslaan als afspeellijst';

  @override
  String filterPlaylistCreated(String name) {
    return 'Afspeellijst \"$name\" aangemaakt';
  }

  @override
  String get filterPlaylistOpen => 'Openen';

  @override
  String get filterPlaylistSaveFailed => 'Afspeellijst aanmaken mislukt';

  @override
  String get filterFieldTitle => 'Titel';

  @override
  String get filterFieldArtistName => 'Artiest';

  @override
  String get filterFieldAlbumName => 'Album';

  @override
  String get filterFieldReleaseYear => 'Jaar';

  @override
  String get filterFieldBirthYear => 'Geboortejaar';

  @override
  String get filterFieldGenre => 'Genre';

  @override
  String get filterFieldRating => 'Beoordeling';

  @override
  String get filterFieldPlayCount => 'Aantal keer gespeeld';

  @override
  String get filterFieldLastPlayedAt => 'Laatst gespeeld';

  @override
  String get filterFieldDuration => 'Duur (minuten)';

  @override
  String get filterFieldWatched => 'Gezien';

  @override
  String get filterFieldDateAdded => 'Datum toegevoegd';

  @override
  String get filterOpContains => 'bevat';

  @override
  String get filterOpNotContains => 'bevat niet';

  @override
  String get filterOpEquals => 'is';

  @override
  String get filterOpNotEquals => 'is niet';

  @override
  String get filterOpLessThan => 'kleiner dan';

  @override
  String get filterOpGreaterThan => 'groter dan';

  @override
  String get filterOpBefore => 'voor';

  @override
  String get filterOpAfter => 'na';

  @override
  String get filterOpInLastDays => 'in de laatste (dagen)';

  @override
  String get filterOpIsSet => 'is ingevuld';

  @override
  String get filterOpIsNotSet => 'is niet ingevuld';

  @override
  String get followListenAlong => 'Luister mee';

  @override
  String get listenTogetherTitle => 'Samen luisteren';

  @override
  String get watchTogetherTitle => 'Samen kijken';

  @override
  String get followWatchAlong => 'Kijk mee';

  @override
  String get watchingBadge => 'Kijkt mee';

  @override
  String get stopWatchingAlong => 'Stop met meekijken';

  @override
  String get followingBadge => 'Luistert mee';

  @override
  String get followControlDenied => 'Je kunt deze sessie niet bedienen';

  @override
  String get followQueueUnavailable =>
      'Kan niet meeluisteren — deze sessie is niet meer beschikbaar';

  @override
  String get followNoLibraryAccess =>
      'Kan niet meeluisteren — je hebt geen toegang tot de bibliotheek van deze wachtrij';

  @override
  String followTrackNotAvailable(String title) {
    return '\'$title\' is voor jou niet beschikbaar — wacht op het volgende nummer';
  }

  @override
  String get followLeaderStopped =>
      'Meeluisteren gestopt — de sessie is beëindigd';

  @override
  String followersListening(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apparaten luisteren mee',
      one: '1 apparaat luistert mee',
    );
    return '$_temp0';
  }

  @override
  String get followersSheetTitle => 'Luistert mee';

  @override
  String get followersNone => 'Er luistert nu niemand mee';

  @override
  String get followersCouldNotLoad => 'Kon de meeluisteraars niet laden';

  @override
  String get followerUnknownUser => 'Onbekende gebruiker';

  @override
  String get followerUnknownDevice => 'Onbekend apparaat';

  @override
  String get followerRemove => 'Verwijderen';

  @override
  String get followerRemoveUser => 'Al hun apparaten verwijderen';

  @override
  String followerRemoveConfirm(String name) {
    return '$name laten stoppen met meeluisteren?';
  }

  @override
  String followerRemoved(String name) {
    return '$name luistert niet meer mee';
  }

  @override
  String get followerRemoveFailed => 'Kon deze meeluisteraar niet verwijderen';

  @override
  String get followerRemovedByOwner =>
      'De eigenaar van de sessie heeft je meeluisteren beëindigd';

  @override
  String get stopListeningAlong => 'Stop met meeluisteren';

  @override
  String get tightSyncToggle => 'Synchroon in dezelfde kamer';

  @override
  String outputLatencySlider(int ms) {
    return 'Geluidsvertraging van dit apparaat: $ms ms';
  }

  @override
  String get playlists => 'Afspeellijsten';

  @override
  String get newPlaylist => 'Nieuwe afspeellijst';

  @override
  String get editPlaylist => 'Afspeellijst bewerken';

  @override
  String get deletePlaylist => 'Afspeellijst verwijderen';

  @override
  String deletePlaylistConfirm(String name) {
    return 'Afspeellijst \'$name\' verwijderen? Wat nu speelt, speelt gewoon door.';
  }

  @override
  String get playlistName => 'Naam';

  @override
  String get smartPlaylist => 'Slimme afspeellijst';

  @override
  String get smartPlaylistDescription =>
      'De inhoud volgt een filter dat je zelf instelt';

  @override
  String get manualPlaylist => 'Afspeellijst';

  @override
  String get manualPlaylistDescription => 'Je kiest zelf de items';

  @override
  String get addToPlaylist => 'Toevoegen aan afspeellijst';

  @override
  String get addedToPlaylist => 'Toegevoegd aan afspeellijst';

  @override
  String get addToPlaylistFailed =>
      'Toevoegen aan de afspeellijst is niet gelukt';

  @override
  String get noPlaylistsYet => 'Nog geen afspeellijsten';

  @override
  String get playlistEmpty =>
      'Deze afspeellijst is leeg. Voeg items toe via hun contextmenu.';

  @override
  String playlistItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get removeFromPlaylist => 'Uit afspeellijst verwijderen';

  @override
  String get editFilter => 'Filter bewerken';

  @override
  String get devicesTitle => 'Apparaten';

  @override
  String get devicesSubtitle =>
      'Je apparaten, afspelen op of overdragen naar een ander apparaat';

  @override
  String get deviceThisDevice => 'Dit apparaat';

  @override
  String get deviceOnlineNow => 'Online';

  @override
  String get deviceLastSeenUnknown => 'Laatst online: onbekend';

  @override
  String deviceLastSeenMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuten',
      one: '1 minuut',
    );
    return 'Laatst online $_temp0 geleden';
  }

  @override
  String deviceLastSeenHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uur',
      one: '1 uur',
    );
    return 'Laatst online $_temp0 geleden';
  }

  @override
  String deviceLastSeenDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagen',
      one: '1 dag',
    );
    return 'Laatst online $_temp0 geleden';
  }

  @override
  String deviceNowPlaying(String title) {
    return 'Speelt nu: $title';
  }

  @override
  String get deviceRename => 'Hernoemen';

  @override
  String get deviceRemove => 'Verwijderen';

  @override
  String deviceRemoveConfirm(String name) {
    return 'Apparaat \'$name\' verwijderen?';
  }

  @override
  String deviceRemoveThisDeviceConfirm(String name) {
    return 'Dit apparaat (\'$name\') verwijderen? Het registreert zichzelf opnieuw bij de volgende start van de app.';
  }

  @override
  String get deviceCouldNotLoad =>
      'Kan apparaten niet laden. Mogelijk ondersteunt de server ze nog niet.';

  @override
  String get deviceCouldNotSave => 'Kan de wijziging niet opslaan.';

  @override
  String get deviceNoDevices => 'Nog geen apparaten geregistreerd.';

  @override
  String get devicePlayOn => 'Afspelen op apparaat…';

  @override
  String get deviceMoveQueue => 'Afspelen verplaatsen naar apparaat…';

  @override
  String get deviceListenAlongOn => 'Meeluisteren op apparaat…';

  @override
  String get devicePickerNoDevicesOnline =>
      'Geen van je andere apparaten is online.';

  @override
  String deviceCommandSent(String name) {
    return 'Verstuurd naar $name';
  }

  @override
  String get deviceCommandFailed =>
      'Het apparaat accepteerde de opdracht niet. Mogelijk is het net offline gegaan.';

  @override
  String get devicePullQueueHere => 'Op dit apparaat afspelen';

  @override
  String get devicePullRequested =>
      'Afspelen wordt naar dit apparaat verplaatst…';

  @override
  String get mediaNotReady =>
      'Dit item kan nog niet worden afgespeeld — het mediabestand wordt nog verwerkt.';

  @override
  String get pause => 'Pauzeren';

  @override
  String get skipNext => 'Volgende';

  @override
  String get skipPrevious => 'Vorige';

  @override
  String get audioAndSubtitles => 'Audio en ondertiteling';

  @override
  String get audioTrackLabel => 'Audio';

  @override
  String get subtitlesTrackLabel => 'Ondertitels';

  @override
  String get mute => 'Dempen';

  @override
  String get unmute => 'Dempen opheffen';

  @override
  String get subtitlesUnsupportedImageBased =>
      'Ondertitels niet ondersteund (beeldgebaseerd)';

  @override
  String get zoomToFill => 'Scherm vullen';

  @override
  String get zoomToFit => 'Passend weergeven';

  @override
  String get fetchToServerStarted =>
      'Download gestart — de aflevering verschijnt zo';

  @override
  String get fetchToServerFailed => 'Downloadverzoek mislukt';

  @override
  String get fetchToServer => 'Ophalen naar server';

  @override
  String get downloads => 'Downloads';

  @override
  String get downloadsSubtitle => 'Media opgeslagen op dit apparaat';

  @override
  String get downloadSettings => 'Downloadinstellingen';

  @override
  String get downloadAlbum => 'Album downloaden';

  @override
  String get downloadAudiobook => 'Luisterboek downloaden';

  @override
  String get downloadNextUnwatched => 'Volgende onbekeken downloaden…';

  @override
  String get downloadNextUnlistened => 'Volgende onbeluisterde downloaden…';

  @override
  String get downloadNextDialogTitle => 'De volgende afleveringen downloaden';

  @override
  String get downloadNextDialogHint => 'Aantal afleveringen';

  @override
  String downloadQueued(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items in de downloadwachtrij',
      one: '1 item in de downloadwachtrij',
    );
    return '$_temp0';
  }

  @override
  String get downloadNothingToDownload => 'Niets om te downloaden';

  @override
  String get cancelDownload => 'Download annuleren';

  @override
  String get removeDownload => 'Download verwijderen';

  @override
  String get retryDownload => 'Download opnieuw proberen';

  @override
  String downloadFailedLocal(String error) {
    return 'Download mislukt: $error';
  }

  @override
  String get downloadNoSpace => 'Niet genoeg opslagruimte';

  @override
  String get downloadStatusQueued => 'In wachtrij';

  @override
  String get downloadStatusDownloading => 'Bezig met downloaden';

  @override
  String get downloadStatusFailed => 'Mislukt';

  @override
  String get downloadStatusComplete => 'Gedownload';

  @override
  String get pauseAllDownloads => 'Downloads pauzeren';

  @override
  String get resumeAllDownloads => 'Downloads hervatten';

  @override
  String get clearAllDownloads => 'Alle downloads verwijderen';

  @override
  String get clearAllDownloadsConfirm =>
      'Alle downloads van deze server op dit apparaat verwijderen?';

  @override
  String storageUsed(String size) {
    return '$size in gebruik';
  }

  @override
  String downloadItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get noDownloadsYet => 'Nog geen downloads';

  @override
  String get noDownloadsHint =>
      'Gebruik \"Download\" in het menu van een film, aflevering, nummer, album, podcastaflevering of luisterboek.';

  @override
  String get videoDownloadQuality => 'Videokwaliteit bij downloaden';

  @override
  String get videoDownloadQualityDescription =>
      'Origineel kopieert het bestand; bij 720p/480p codeert de server eerst om (trager, kleiner)';

  @override
  String get audioDownloadQuality => 'Audiokwaliteit bij downloaden';

  @override
  String get qualityOriginal => 'Origineel';

  @override
  String get qualityCompact => 'Compact (192 kbit/s)';

  @override
  String get downloadSubtitles => 'Ondertitels downloaden';

  @override
  String get downloadNetworkPolicy => 'Downloaden via';

  @override
  String get downloadNetworkPolicySubtitle =>
      'Geldt voor dit apparaat, voor alle servers';

  @override
  String get downloadNetworkPolicyAny => 'Elke verbinding';

  @override
  String get downloadNetworkPolicyAutomatic =>
      'Automatische downloads alleen zonder datalimiet';

  @override
  String get downloadNetworkPolicyAll =>
      'Alleen verbindingen zonder datalimiet';

  @override
  String get downloadsWaitingForNetwork =>
      'Wacht op een verbinding zonder datalimiet';

  @override
  String get concurrentDownloads => 'Gelijktijdige downloads';

  @override
  String get defaultNextCount =>
      'Standaard voor \"volgende afleveringen downloaden\"';

  @override
  String get autoNextTitle => 'Volgende afleveringen gedownload houden';

  @override
  String get autoNextDescription =>
      'Zodra je een aflevering hebt bekeken wordt die download verwijderd en wordt de volgende onbekeken aflevering opgehaald, zodat je er altijd een paar klaar hebt staan.';

  @override
  String get autoNextOff => 'Uit';

  @override
  String get autoNextDisabled => 'Automatisch downloaden uitgezet';

  @override
  String autoNextEnabled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'De volgende $count afleveringen worden automatisch gedownload',
      one: 'De volgende aflevering wordt automatisch gedownload',
    );
    return '$_temp0';
  }

  @override
  String get autoNextFailed =>
      'Server niet bereikbaar; deze serie wordt later bijgewerkt';

  @override
  String autoNextFollowing(int count) {
    return 'Automatisch · $count vooruit';
  }

  @override
  String get openDownloads => 'Downloads openen';

  @override
  String get offlineMode => 'Offline';

  @override
  String get playOffline => 'Afspelen';

  @override
  String get cancel => 'Annuleren';

  @override
  String get syncOfflineProgress => 'Offline voortgang synchroniseren';

  @override
  String offlineProgressSynced(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count afspeelbeurten gesynchroniseerd',
      one: '1 afspeelbeurt gesynchroniseerd',
      zero: 'Niets te synchroniseren',
    );
    return '$_temp0';
  }

  @override
  String downloadsForServer(String server) {
    return 'Downloads · $server';
  }

  @override
  String get musicCache => 'Muziekcache';

  @override
  String get musicCacheEnabled =>
      'Recent afgespeelde muziek op dit apparaat bewaren';

  @override
  String get musicCacheDescription =>
      'De recentst afgespeelde nummers worden automatisch gedownload en de oudste verwijderd zodra een limiet is bereikt. Handmatige downloads worden nooit verwijderd.';

  @override
  String get musicCacheMaxTracks => 'Maximaal aantal nummers';

  @override
  String get musicCacheMaxSize => 'Maximale grootte';

  @override
  String get musicCacheQuality => 'Cachekwaliteit';

  @override
  String get fillCacheNow => 'Cache nu vullen';

  @override
  String get clearMusicCache => 'Gecachte muziek verwijderen';

  @override
  String get musicCacheDisableKeep => 'Bestanden bewaren';

  @override
  String get musicCacheDisableRemove => 'Bestanden verwijderen';

  @override
  String get musicCacheDisableTitle => 'Gecachte muziek bewaren?';

  @override
  String get musicCacheDisableBody =>
      'De cache wordt niet meer gevuld. De nummers die al op dit apparaat staan kunnen blijven of nu verwijderd worden.';

  @override
  String get cachedDownloads => 'Muziekcache';

  @override
  String get downloadNotificationTitle => 'Bezig met downloaden';

  @override
  String downloadNotificationText(int count, int percent) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count downloads · $percent%',
      one: '1 download · $percent%',
    );
    return '$_temp0';
  }

  @override
  String get downloadEpub => 'Boek downloaden (EPUB)';

  @override
  String get downloadComic => 'Strip downloaden';

  @override
  String get readAloudEdition => 'voorleeseditie';

  @override
  String musicCacheFillQueued(int queued, int evicted) {
    String _temp0 = intl.Intl.pluralLogic(
      queued,
      locale: localeName,
      other: '$queued nummers in de downloadwachtrij',
      one: '1 nummer in de downloadwachtrij',
      zero: 'Niets nieuws om te downloaden',
    );
    String _temp1 = intl.Intl.pluralLogic(
      evicted,
      locale: localeName,
      other: ', $evicted verwijderd',
      one: ', 1 verwijderd',
      zero: '',
    );
    return '$_temp0$_temp1';
  }

  @override
  String get musicCacheNoHistory =>
      'Nog geen afspeelhistorie — de cache vult zich met nummers die je minstens 30 seconden afspeelt';

  @override
  String get musicCacheUpToDate => 'De muziekcache is bijgewerkt';

  @override
  String get musicCacheFillBusy => 'De cache wordt al bijgewerkt';

  @override
  String get downloadRetryLater =>
      'Netwerkprobleem — wordt automatisch opnieuw geprobeerd';

  @override
  String downloadResumeAt(String position) {
    return 'hervatten bij $position';
  }

  @override
  String seasonEpisodeLabel(int season, int episode) {
    return 'Seizoen $season · Aflevering $episode';
  }

  @override
  String get welcomeTitle => 'Welkom bij Ister';

  @override
  String get welcomeBody =>
      'Voeg je eigen Ister-mediaserver toe om te kijken, luisteren en lezen.';

  @override
  String get addServerTitle => 'Server toevoegen';

  @override
  String get serverAddressLabel => 'Serveradres';

  @override
  String get serverAddressExamples =>
      'Bijvoorbeeld media.example.com of 192.168.1.10:8080/api';

  @override
  String get serverAddressInvalid => 'Voer een serveradres zonder spaties in';

  @override
  String get connect => 'Verbinden';

  @override
  String connecting(Object server) {
    return 'Verbinden met $server…';
  }

  @override
  String get serverFound => 'Server gevonden';

  @override
  String get addAndSignIn => 'Toevoegen en aanmelden';

  @override
  String get notAnIsterServer =>
      'Op dit adres is geen Ister-server gevonden. Controleer het adres — meestal is het hetzelfde als in de browser.';

  @override
  String serverUnreachableHint(Object server) {
    return '$server is niet bereikbaar. Controleer het adres en je netwerkverbinding.';
  }

  @override
  String get serverAlreadyAdded => 'Deze server staat al in je lijst.';

  @override
  String get open => 'Openen';

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get removeServer => 'Verwijderen';

  @override
  String removeServerTitle(Object server) {
    return '$server verwijderen?';
  }

  @override
  String get removeServerBody =>
      'De server wordt van dit apparaat verwijderd, samen met je aanmelding. Je gegevens op de server blijven staan.';

  @override
  String get statusConnected => 'Verbonden';

  @override
  String get statusUnreachable => 'Niet bereikbaar';

  @override
  String get statusOfflineAvailable => 'Offline beschikbaar';

  @override
  String get chooseAnotherServer => 'Andere server kiezen';

  @override
  String get loginExplanation =>
      'Je gaat naar de aanmeldpagina van deze server en komt daarna automatisch terug in de app.';

  @override
  String get waitingForLogin => 'Wachten op aanmelding…';

  @override
  String get addServerMenu => 'Server toevoegen…';

  @override
  String get serverUnreachableBody =>
      'De app kan deze server niet bereiken. Controleer je netwerkverbinding, of open wat je eerder hebt gedownload.';

  @override
  String connectingTo(Object server) {
    return 'Verbinden met $server…';
  }

  @override
  String get saveErrorLog => 'Foutenlog opslaan';

  @override
  String get saveErrorLogSubtitle =>
      'Sla het app-log op als bestand voor probleemonderzoek';

  @override
  String get errorLogSaved => 'Log opgeslagen';

  @override
  String errorLogSaveFailed(Object error) {
    return 'Log opslaan mislukt: $error';
  }

  @override
  String get errorLogEmpty => 'Er is nog geen log om op te slaan';
}
