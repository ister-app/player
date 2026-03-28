// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get library => 'Library';

  @override
  String get settings => 'Settings';

  @override
  String get preferredSpoken => 'Preferred spoken languages:';

  @override
  String get preferredSubtitle => 'Preferred subtitle languages:';

  @override
  String loadError(Object error) {
    return 'Failed to load preferences: $error';
  }

  @override
  String get selectLanguage => 'Select a Language';

  @override
  String error(Object error) {
    return 'Error: $error';
  }

  @override
  String get noLanguagesFound => 'No languages found.';

  @override
  String get searchHint => 'Search for a language...';

  @override
  String get noLanguageFound => 'No Language Found!';

  @override
  String get refreshPage => 'Refresh page';

  @override
  String get scanLibrary => 'Scan library';

  @override
  String get analyzeLibrary => 'Analyze library';

  @override
  String get goToShow => 'Go to show';

  @override
  String get watchNext => 'Continue watching';

  @override
  String get recentlyAddedShows => 'Recently added shows';

  @override
  String season(int number) {
    return 'Season $number';
  }

  @override
  String episode(int number) {
    return 'Episode $number';
  }

  @override
  String episodePrefix(int number) {
    return 'E$number';
  }

  @override
  String get serverUnreachable => 'Server unreachable';

  @override
  String get backToServerOverview => 'Back to server overview';

  @override
  String get close => 'Close';

  @override
  String get json => 'JSON';

  @override
  String get rawData => 'Raw data';

  @override
  String get nodes => 'Nodes';

  @override
  String get server => 'Server';

  @override
  String get languageSettings => 'Language settings';

  @override
  String get loginTitle => 'Sign in';

  @override
  String loginDescription(Object serverName) {
    return 'Sign in to access $serverName';
  }

  @override
  String loginButton(Object serverName) {
    return 'Sign in with $serverName';
  }

  @override
  String get playbackSettings => 'Playback settings';

  @override
  String get directPlay => 'Direct play';

  @override
  String get directPlayDescription =>
      'Stream the original file without transcoding';

  @override
  String get analyzeMedia => 'Analyze media';

  @override
  String get switchServer => 'Switch server';

  @override
  String get servers => 'Servers';

  @override
  String get noRecentItems => 'No recent items';

  @override
  String get noSeason => 'No season';

  @override
  String get addServer => 'Add a server';

  @override
  String get noServersAdded => 'No servers added yet';

  @override
  String get noSeasonsFound => 'No seasons found';

  @override
  String get trackAuto => 'Auto';

  @override
  String get trackNone => 'None';

  @override
  String get noShowFound => 'No show found';

  @override
  String get transcode => 'Transcode';

  @override
  String get transcodeDescription =>
      'Re-encode the stream server-side (always on for web)';
}
