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
  String get downloadStarted =>
      'Download gestart — de aflevering verschijnt zo';

  @override
  String get downloadFailed => 'Downloadverzoek mislukt';

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
  String get sortNameAsc => 'Naam (A–Z)';

  @override
  String get sortNameDesc => 'Naam (Z–A)';

  @override
  String get sortDateAddedNewest => 'Toegevoegd (nieuwste eerst)';

  @override
  String get sortDateAddedOldest => 'Toegevoegd (oudste eerst)';

  @override
  String get sortReleaseYearNewest => 'Releasejaar (nieuwste eerst)';

  @override
  String get sortReleaseYearOldest => 'Releasejaar (oudste eerst)';

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
  String get sortAirDateNewest => 'Uitzenddatum (nieuwste eerst)';

  @override
  String get sortAirDateOldest => 'Uitzenddatum (oudste eerst)';

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
  String get serverActivity => 'Serveractiviteit';

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
  String get followingBadge => 'Luistert mee';

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
}
