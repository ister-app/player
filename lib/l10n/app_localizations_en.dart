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
  String get reindexSearch => 'Reindex search';

  @override
  String get analyzeAllLibraries => 'All libraries';

  @override
  String get management => 'Management';

  @override
  String taskStarted(String task) {
    return 'Started: $task';
  }

  @override
  String taskFailed(String task) {
    return 'Failed: $task';
  }

  @override
  String get goToShow => 'Go to show';

  @override
  String get goToArtist => 'Go to artist';

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
  String get deviceFlowInstructions =>
      'Go to the URL below on another device and enter the code:';

  @override
  String get transcode => 'Transcode';

  @override
  String get transcodeDescription =>
      'Re-encode the stream server-side (always on for web)';

  @override
  String get play => 'Play';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get songs => 'Songs';

  @override
  String get albums => 'Albums';

  @override
  String get artists => 'Artists';

  @override
  String get switchLibrary => 'Switch library';

  @override
  String get description => 'Description';

  @override
  String get previousTracks => 'BACK TO';

  @override
  String get upNext => 'UP NEXT';

  @override
  String get noPreviousTracks => 'No previous tracks';

  @override
  String get noNextTracks => 'No upcoming tracks';

  @override
  String get cast => 'Cast';

  @override
  String get appearsIn => 'Appears in';

  @override
  String episodeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count episodes',
      one: '1 episode',
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
      other: '$count movies',
      one: '1 movie',
    );
    return '$_temp0';
  }

  @override
  String showCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shows',
      one: '1 show',
    );
    return '$_temp0';
  }

  @override
  String get search => 'Search';

  @override
  String get noResults => 'No results';

  @override
  String get movie => 'Movie';

  @override
  String get show => 'Show';

  @override
  String get artist => 'Artist';

  @override
  String get typeEpisode => 'Episode';

  @override
  String get typePerson => 'Person';

  @override
  String get typeAlbum => 'Album';

  @override
  String get typeTrack => 'Track';

  @override
  String get searchInDescription => 'In description';

  @override
  String get searchThisLibrary => 'This library';

  @override
  String get searchAllLibraries => 'All libraries';

  @override
  String get addToQueue => 'Add to queue';

  @override
  String get removeFromQueue => 'Remove from queue';

  @override
  String get shufflePlay => 'Shuffle play';

  @override
  String get trackNotPlayable =>
      'This track can\'t be played yet — it hasn\'t been analysed';

  @override
  String skippedTrackNoFile(String title) {
    return 'Skipped ‘$title’ — not analysed yet';
  }

  @override
  String skippedTrackPlaybackFailed(String title) {
    return 'Skipped ‘$title’ — could not be played';
  }

  @override
  String get nowPlaying => 'Now playing';

  @override
  String get serverActivity => 'Server activity';

  @override
  String get noActiveSessions => 'No active playback sessions';

  @override
  String get queues => 'Queues';

  @override
  String queueDepth(int depth) {
    return 'Depth $depth';
  }

  @override
  String consumers(int count) {
    return '$count consumers';
  }

  @override
  String get recentFailures => 'Recent failures';

  @override
  String get noRecentFailures => 'No recent failures';

  @override
  String processedCount(int count) {
    return '$count processed';
  }

  @override
  String failedCount(int count) {
    return '$count failed';
  }

  @override
  String get idle => 'Idle';

  @override
  String get statePlaying => 'Playing';

  @override
  String get statePaused => 'Paused';

  @override
  String get liveUpdatesUnavailable =>
      'Live updates interrupted — reconnecting';
}
