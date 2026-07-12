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
  String get chapters => 'Hoofdstukken';

  @override
  String get chapter => 'Hoofdstuk';

  @override
  String get couldNotOpenReader => 'Kon de reader niet openen';

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
  String get play => 'Afspelen';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get songs => 'Nummers';

  @override
  String get albums => 'Albums';

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
}
