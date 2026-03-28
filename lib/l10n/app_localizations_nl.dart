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
  String get goToShow => 'Ga naar show';

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
  String get transcode => 'Transcoderen';

  @override
  String get transcodeDescription =>
      'Stream server-side hercoderen (altijd aan voor web)';
}
