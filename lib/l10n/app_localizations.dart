import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl')
  ];

  /// Home as in start page
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Library of shows/films/music
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// Title of the settings page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// App version shown in settings
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);

  /// No description provided for @preferredSpoken.
  ///
  /// In en, this message translates to:
  /// **'Preferred spoken languages:'**
  String get preferredSpoken;

  /// No description provided for @preferredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Preferred subtitle languages:'**
  String get preferredSubtitle;

  /// Error message shown when the preferences cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Failed to load preferences: {error}'**
  String loadError(Object error);

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select a Language'**
  String get selectLanguage;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error(Object error);

  /// No description provided for @noLanguagesFound.
  ///
  /// In en, this message translates to:
  /// **'No languages found.'**
  String get noLanguagesFound;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a language...'**
  String get searchHint;

  /// No description provided for @noLanguageFound.
  ///
  /// In en, this message translates to:
  /// **'No Language Found!'**
  String get noLanguageFound;

  /// Refresh data of this page.
  ///
  /// In en, this message translates to:
  /// **'Refresh page'**
  String get refreshPage;

  /// Text in list tile when clicked it will trigger a library scan.
  ///
  /// In en, this message translates to:
  /// **'Scan library'**
  String get scanLibrary;

  /// Text in list tile when clicked it will trigger a analyze scan.
  ///
  /// In en, this message translates to:
  /// **'Analyze library'**
  String get analyzeLibrary;

  /// Management action that rebuilds the search index on the server.
  ///
  /// In en, this message translates to:
  /// **'Reindex search'**
  String get reindexSearch;

  /// Option in the analyze picker that analyzes every library at once (the overarching analyzeLibrary action).
  ///
  /// In en, this message translates to:
  /// **'All libraries'**
  String get analyzeAllLibraries;

  /// Section header for administrative server actions (scan, analyze, reindex).
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get management;

  /// Settings tile and page title for the admin page that manages users and their library access.
  ///
  /// In en, this message translates to:
  /// **'Users & access'**
  String get usersAndAccess;

  /// Settings tile and page title for the admin page that manages which libraries everyone can see.
  ///
  /// In en, this message translates to:
  /// **'Library visibility'**
  String get libraryVisibility;

  /// Switch label/subtitle for a library every user may see.
  ///
  /// In en, this message translates to:
  /// **'Visible to everyone'**
  String get visibleToEveryone;

  /// Subtitle for a library only visible to explicitly granted users (and admins).
  ///
  /// In en, this message translates to:
  /// **'Restricted — only granted users'**
  String get restrictedLibrarySubtitle;

  /// Badge on a user row marking that user as an administrator.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminLabel;

  /// Empty state of the admin users list.
  ///
  /// In en, this message translates to:
  /// **'No users yet — a user appears here after their first login.'**
  String get noUsersYet;

  /// Footnote on the admin pages explaining where the admin role is managed.
  ///
  /// In en, this message translates to:
  /// **'Admins always see every library. The admin role itself is assigned in the identity provider (e.g. Keycloak).'**
  String get adminRoleNote;

  /// Toast shown when toggling library access or visibility failed on the server.
  ///
  /// In en, this message translates to:
  /// **'Could not save the change'**
  String get changeNotSaved;

  /// Confirmation toast shown when a management task was triggered on the server.
  ///
  /// In en, this message translates to:
  /// **'Started: {task}'**
  String taskStarted(String task);

  /// Toast shown when a management task could not be triggered on the server.
  ///
  /// In en, this message translates to:
  /// **'Failed: {task}'**
  String taskFailed(String task);

  /// In menu archor an item when clicked go to show of that item.
  ///
  /// In en, this message translates to:
  /// **'Go to show'**
  String get goToShow;

  /// In context menu an item when clicked navigates to the artist page.
  ///
  /// In en, this message translates to:
  /// **'Go to artist'**
  String get goToArtist;

  /// In context menu of a book, navigates to the author page.
  ///
  /// In en, this message translates to:
  /// **'Go to author'**
  String get goToAuthor;

  /// Button on the book page that starts audiobook playback.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get listen;

  /// Button on the book page that opens the epub reader.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// Button on the book page that opens the reader with read-aloud audio.
  ///
  /// In en, this message translates to:
  /// **'Read aloud'**
  String get readAloud;

  /// Title of the sheet asking whether to listen, read or read along.
  ///
  /// In en, this message translates to:
  /// **'How do you want to read this?'**
  String get howDoYouWantToRead;

  /// Button on the book page for a book that hasn't been started yet.
  ///
  /// In en, this message translates to:
  /// **'Start reading'**
  String get startReading;

  /// Button on the book page for a book that is already in progress.
  ///
  /// In en, this message translates to:
  /// **'Continue reading'**
  String get continueReading;

  /// Heading above the audiobook chapter list.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chapters;

  /// Fallback chapter title prefix, e.g. 'Chapter 5'.
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get chapter;

  /// Heading above the podcast episode list.
  ///
  /// In en, this message translates to:
  /// **'Episodes'**
  String get episodes;

  /// Title of the add-podcast sheet and its toolbar action.
  ///
  /// In en, this message translates to:
  /// **'Add podcast'**
  String get addPodcast;

  /// Hint text in the add-podcast input field.
  ///
  /// In en, this message translates to:
  /// **'Search, or paste a feed URL'**
  String get addPodcastHint;

  /// Snackbar when the subscribe mutation failed.
  ///
  /// In en, this message translates to:
  /// **'Could not subscribe to this feed'**
  String get subscribeFailed;

  /// Menu item on the podcast page.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribe'**
  String get unsubscribe;

  /// Tooltip on the episode download button.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// Snackbar after requesting an episode download.
  ///
  /// In en, this message translates to:
  /// **'Download started — the episode appears shortly'**
  String get downloadStarted;

  /// Snackbar when requesting an episode download failed.
  ///
  /// In en, this message translates to:
  /// **'Download request failed'**
  String get downloadFailed;

  /// Text above recently watched media
  ///
  /// In en, this message translates to:
  /// **'Continue watching'**
  String get watchNext;

  /// Text above recently added shows
  ///
  /// In en, this message translates to:
  /// **'Recently added shows'**
  String get recentlyAddedShows;

  /// Season with a number of the season after
  ///
  /// In en, this message translates to:
  /// **'Season {number}'**
  String season(int number);

  /// Episode with a number of the episode after
  ///
  /// In en, this message translates to:
  /// **'Episode {number}'**
  String episode(int number);

  /// The firtst letter of the word episode. After this is the episode number.
  ///
  /// In en, this message translates to:
  /// **'E{number}'**
  String episodePrefix(int number);

  /// Title shown when the server cannot be reached
  ///
  /// In en, this message translates to:
  /// **'Server unreachable'**
  String get serverUnreachable;

  /// Button label to navigate back to the server list
  ///
  /// In en, this message translates to:
  /// **'Back to server overview'**
  String get backToServerOverview;

  /// Close a dialog
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @json.
  ///
  /// In en, this message translates to:
  /// **'JSON'**
  String get json;

  /// No description provided for @rawData.
  ///
  /// In en, this message translates to:
  /// **'Raw data'**
  String get rawData;

  /// No description provided for @nodes.
  ///
  /// In en, this message translates to:
  /// **'Nodes'**
  String get nodes;

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language settings'**
  String get languageSettings;

  /// Title on the login screen
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// Explanation text on the login screen
  ///
  /// In en, this message translates to:
  /// **'Sign in to access {serverName}'**
  String loginDescription(Object serverName);

  /// Label on the login button
  ///
  /// In en, this message translates to:
  /// **'Sign in with {serverName}'**
  String loginButton(Object serverName);

  /// Title of the playback settings subpage
  ///
  /// In en, this message translates to:
  /// **'Playback settings'**
  String get playbackSettings;

  /// Label for the direct play toggle
  ///
  /// In en, this message translates to:
  /// **'Direct play'**
  String get directPlay;

  /// Subtitle for the direct play toggle
  ///
  /// In en, this message translates to:
  /// **'Stream the original file without transcoding'**
  String get directPlayDescription;

  /// Menu item to trigger media analysis for an episode, movie or show
  ///
  /// In en, this message translates to:
  /// **'Analyze media'**
  String get analyzeMedia;

  /// Menu item to navigate back to the server list
  ///
  /// In en, this message translates to:
  /// **'Switch server'**
  String get switchServer;

  /// Title of the server list / home page
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get servers;

  /// Shown when the recently watched list is empty
  ///
  /// In en, this message translates to:
  /// **'No recent items'**
  String get noRecentItems;

  /// Shown when a season cannot be found
  ///
  /// In en, this message translates to:
  /// **'No season'**
  String get noSeason;

  /// Hint text in the add-server text field
  ///
  /// In en, this message translates to:
  /// **'Add a server'**
  String get addServer;

  /// Shown when no servers have been added
  ///
  /// In en, this message translates to:
  /// **'No servers added yet'**
  String get noServersAdded;

  /// Shown when a show has no seasons
  ///
  /// In en, this message translates to:
  /// **'No seasons found'**
  String get noSeasonsFound;

  /// Label for the automatic audio track option
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get trackAuto;

  /// Label for the 'no subtitle' option
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get trackNone;

  /// Shown when a show cannot be found
  ///
  /// In en, this message translates to:
  /// **'No show found'**
  String get noShowFound;

  /// Instructions shown on Android TV during device authorization flow
  ///
  /// In en, this message translates to:
  /// **'Go to the URL below on another device and enter the code:'**
  String get deviceFlowInstructions;

  /// Label for the transcode toggle in playback settings
  ///
  /// In en, this message translates to:
  /// **'Transcode'**
  String get transcode;

  /// Subtitle for the transcode toggle
  ///
  /// In en, this message translates to:
  /// **'Re-encode the stream server-side (always on for web)'**
  String get transcodeDescription;

  /// Title of the maximum video quality picker
  ///
  /// In en, this message translates to:
  /// **'Maximum quality'**
  String get maxQuality;

  /// Subtitle for the maximum video quality picker
  ///
  /// In en, this message translates to:
  /// **'Highest quality the server prepares for you'**
  String get maxQualityDescription;

  /// Value of the quality picker meaning: no cap
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get qualityAuto;

  /// Button label to start playback
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// Shuffle toggle / shuffle-play action
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get shuffle;

  /// Section header for the list of tracks on an album page
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get songs;

  /// Section header for the list of albums on an artist page
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albums;

  /// Section header for the list of books on a person page
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get books;

  /// Podcast overflow menu: sort the episode list newest to oldest
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get newestFirst;

  /// Podcast overflow menu: sort the episode list oldest to newest
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get oldestFirst;

  /// Snackbar shown when saving the podcast episode sort order failed
  ///
  /// In en, this message translates to:
  /// **'Could not change the sort order'**
  String get sortOrderFailed;

  /// Tooltip for the library grid sort menu button
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// Library sort option: by name, ascending
  ///
  /// In en, this message translates to:
  /// **'Name (A–Z)'**
  String get sortNameAsc;

  /// Library sort option: by name, descending
  ///
  /// In en, this message translates to:
  /// **'Name (Z–A)'**
  String get sortNameDesc;

  /// Library sort option: by date added, newest first
  ///
  /// In en, this message translates to:
  /// **'Date added (newest first)'**
  String get sortDateAddedNewest;

  /// Library sort option: by date added, oldest first
  ///
  /// In en, this message translates to:
  /// **'Date added (oldest first)'**
  String get sortDateAddedOldest;

  /// Library sort option: by release year, newest first
  ///
  /// In en, this message translates to:
  /// **'Release year (newest first)'**
  String get sortReleaseYearNewest;

  /// Library sort option: by release year, oldest first
  ///
  /// In en, this message translates to:
  /// **'Release year (oldest first)'**
  String get sortReleaseYearOldest;

  /// Browse category for the artists in a music library (also used in Android Auto)
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get artists;

  /// Android Auto browse item that lists the available music libraries to pick from
  ///
  /// In en, this message translates to:
  /// **'Switch library'**
  String get switchLibrary;

  /// Section header for the description of an album or artist
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Tab label in the music player for previously played tracks
  ///
  /// In en, this message translates to:
  /// **'BACK TO'**
  String get previousTracks;

  /// Tab label in the music player for upcoming tracks
  ///
  /// In en, this message translates to:
  /// **'UP NEXT'**
  String get upNext;

  /// Shown in the music player when there are no previously played tracks
  ///
  /// In en, this message translates to:
  /// **'No previous tracks'**
  String get noPreviousTracks;

  /// Shown in the music player when there are no upcoming tracks
  ///
  /// In en, this message translates to:
  /// **'No upcoming tracks'**
  String get noNextTracks;

  /// Section header for the list of actors in a movie, show or episode
  ///
  /// In en, this message translates to:
  /// **'Cast'**
  String get cast;

  /// Menu item / dialog title for setting a personal 1-10 rating on a media item
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// Label shown above the star rating control on a detail page
  ///
  /// In en, this message translates to:
  /// **'Your rating'**
  String get yourRating;

  /// Compact display of a 1-10 rating next to the stars
  ///
  /// In en, this message translates to:
  /// **'{value}/10'**
  String ratingValue(int value);

  /// Toast shown when saving a rating to the server fails
  ///
  /// In en, this message translates to:
  /// **'Could not save your rating'**
  String get ratingFailed;

  /// Section header on a person page listing the movies and shows they appear in
  ///
  /// In en, this message translates to:
  /// **'Appears in'**
  String get appearsIn;

  /// Number of episodes a person appears in, shown on the show tile in their filmography
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 episode} other{{count} episodes}}'**
  String episodeCount(int count);

  /// Number of albums by a person, shown in the person page hero subtitle
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 album} other{{count} albums}}'**
  String albumCount(int count);

  /// Number of books by a person, shown in the person page hero subtitle
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 book} other{{count} books}}'**
  String bookCount(int count);

  /// Number of movies a person appears in, shown in the person page hero subtitle
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 movie} other{{count} movies}}'**
  String movieCount(int count);

  /// Number of shows a person appears in, shown in the person page hero subtitle
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 show} other{{count} shows}}'**
  String showCount(int count);

  /// Search field hint and page title
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Shown when a search returns nothing
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// Label for a movie search result
  ///
  /// In en, this message translates to:
  /// **'Movie'**
  String get movie;

  /// Label for a show search result
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// Label for a person/artist search result
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get artist;

  /// Type label (badge) for an episode search result
  ///
  /// In en, this message translates to:
  /// **'Episode'**
  String get typeEpisode;

  /// Type label (badge) for a person search result
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get typePerson;

  /// Type label (badge) for an album search result
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get typeAlbum;

  /// Type label (badge) for a track search result
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get typeTrack;

  /// Small hint on a search result when the query matched the description rather than the title
  ///
  /// In en, this message translates to:
  /// **'In description'**
  String get searchInDescription;

  /// Toggle option to limit search to the current library
  ///
  /// In en, this message translates to:
  /// **'This library'**
  String get searchThisLibrary;

  /// Toggle option to search across every library
  ///
  /// In en, this message translates to:
  /// **'All libraries'**
  String get searchAllLibraries;

  /// Context menu action to append an item to the play queue
  ///
  /// In en, this message translates to:
  /// **'Add to queue'**
  String get addToQueue;

  /// Action to remove an item from the play queue
  ///
  /// In en, this message translates to:
  /// **'Remove from queue'**
  String get removeFromQueue;

  /// Action to play an entire library in shuffled order
  ///
  /// In en, this message translates to:
  /// **'Shuffle play'**
  String get shufflePlay;

  /// Shown when the user tries to play a track that has no media file
  ///
  /// In en, this message translates to:
  /// **'This track can\'t be played yet — it hasn\'t been analysed'**
  String get trackNotPlayable;

  /// Toast shown when an unplayable track is auto-skipped in the queue
  ///
  /// In en, this message translates to:
  /// **'Skipped ‘{title}’ — not analysed yet'**
  String skippedTrackNoFile(String title);

  /// Toast shown when a track is auto-skipped because its stream failed to start (e.g. a server-side transcode that never delivers segments)
  ///
  /// In en, this message translates to:
  /// **'Skipped ‘{title}’ — could not be played'**
  String skippedTrackPlaybackFailed(String title);

  /// No description provided for @nowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Now playing'**
  String get nowPlaying;

  /// No description provided for @serverActivity.
  ///
  /// In en, this message translates to:
  /// **'Server activity'**
  String get serverActivity;

  /// No description provided for @noActiveSessions.
  ///
  /// In en, this message translates to:
  /// **'No active playback sessions'**
  String get noActiveSessions;

  /// No description provided for @queues.
  ///
  /// In en, this message translates to:
  /// **'Queues'**
  String get queues;

  /// No description provided for @queueDepth.
  ///
  /// In en, this message translates to:
  /// **'Depth {depth}'**
  String queueDepth(int depth);

  /// No description provided for @consumers.
  ///
  /// In en, this message translates to:
  /// **'{count} consumers'**
  String consumers(int count);

  /// No description provided for @recentFailures.
  ///
  /// In en, this message translates to:
  /// **'Recent failures'**
  String get recentFailures;

  /// No description provided for @noRecentFailures.
  ///
  /// In en, this message translates to:
  /// **'No recent failures'**
  String get noRecentFailures;

  /// No description provided for @processedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} processed'**
  String processedCount(int count);

  /// No description provided for @failedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} failed'**
  String failedCount(int count);

  /// No description provided for @idle.
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get idle;

  /// No description provided for @statePlaying.
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get statePlaying;

  /// No description provided for @statePaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get statePaused;

  /// No description provided for @liveUpdatesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Live updates interrupted — reconnecting'**
  String get liveUpdatesUnavailable;

  /// No description provided for @sessionEnded.
  ///
  /// In en, this message translates to:
  /// **'Session ended'**
  String get sessionEnded;

  /// No description provided for @addToSession.
  ///
  /// In en, this message translates to:
  /// **'Add to session'**
  String get addToSession;

  /// No description provided for @chooseSession.
  ///
  /// In en, this message translates to:
  /// **'Choose a session'**
  String get chooseSession;

  /// No description provided for @playNext.
  ///
  /// In en, this message translates to:
  /// **'Play next'**
  String get playNext;

  /// No description provided for @addToEndOfQueue.
  ///
  /// In en, this message translates to:
  /// **'Add to end of queue'**
  String get addToEndOfQueue;

  /// No description provided for @addedToSession.
  ///
  /// In en, this message translates to:
  /// **'Added to session'**
  String get addedToSession;

  /// No description provided for @addToSessionFailed.
  ///
  /// In en, this message translates to:
  /// **'Adding to session failed'**
  String get addToSessionFailed;

  /// No description provided for @remotePlay.
  ///
  /// In en, this message translates to:
  /// **'Resumed via remote control'**
  String get remotePlay;

  /// No description provided for @remotePause.
  ///
  /// In en, this message translates to:
  /// **'Paused via remote control'**
  String get remotePause;

  /// No description provided for @remoteNext.
  ///
  /// In en, this message translates to:
  /// **'Next via remote control'**
  String get remoteNext;

  /// No description provided for @remotePrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous via remote control'**
  String get remotePrevious;

  /// No description provided for @remoteSeek.
  ///
  /// In en, this message translates to:
  /// **'Position changed via remote control'**
  String get remoteSeek;

  /// No description provided for @remoteSkipToItem.
  ///
  /// In en, this message translates to:
  /// **'Queue item selected via remote control'**
  String get remoteSkipToItem;

  /// No description provided for @remoteQueueChanged.
  ///
  /// In en, this message translates to:
  /// **'Queue updated via remote control'**
  String get remoteQueueChanged;

  /// No description provided for @tableOfContents.
  ///
  /// In en, this message translates to:
  /// **'Contents'**
  String get tableOfContents;

  /// No description provided for @readerSettings.
  ///
  /// In en, this message translates to:
  /// **'Reading settings'**
  String get readerSettings;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get fontSize;

  /// No description provided for @readerTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get readerTheme;

  /// No description provided for @readerThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get readerThemeLight;

  /// No description provided for @readerThemeSepia.
  ///
  /// In en, this message translates to:
  /// **'Sepia'**
  String get readerThemeSepia;

  /// No description provided for @readerThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get readerThemeDark;

  /// No description provided for @couldNotLoadBook.
  ///
  /// In en, this message translates to:
  /// **'Could not load the book'**
  String get couldNotLoadBook;

  /// No description provided for @noReadAloudForChapter.
  ///
  /// In en, this message translates to:
  /// **'This chapter has no read-aloud audio'**
  String get noReadAloudForChapter;

  /// No description provided for @bookMayNotDisplayCorrectly.
  ///
  /// In en, this message translates to:
  /// **'This book has a fixed layout and may not display correctly'**
  String get bookMayNotDisplayCorrectly;

  /// No description provided for @previousChapter.
  ///
  /// In en, this message translates to:
  /// **'Previous chapter'**
  String get previousChapter;

  /// No description provided for @nextChapter.
  ///
  /// In en, this message translates to:
  /// **'Next chapter'**
  String get nextChapter;

  /// No description provided for @couldNotLoadComic.
  ///
  /// In en, this message translates to:
  /// **'Could not load the comic'**
  String get couldNotLoadComic;

  /// No description provided for @pageOfPages.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String pageOfPages(int current, int total);

  /// No description provided for @readingDirectionRtl.
  ///
  /// In en, this message translates to:
  /// **'Read right-to-left (manga)'**
  String get readingDirectionRtl;

  /// No description provided for @pageRangeOfPages.
  ///
  /// In en, this message translates to:
  /// **'Page {from}-{to} of {total}'**
  String pageRangeOfPages(int from, int to, int total);

  /// No description provided for @goToSeries.
  ///
  /// In en, this message translates to:
  /// **'Go to series'**
  String get goToSeries;

  /// No description provided for @volumes.
  ///
  /// In en, this message translates to:
  /// **'Volumes'**
  String get volumes;

  /// No description provided for @fitWidth.
  ///
  /// In en, this message translates to:
  /// **'Fit width'**
  String get fitWidth;

  /// No description provided for @fitPage.
  ///
  /// In en, this message translates to:
  /// **'Fit page'**
  String get fitPage;

  /// No description provided for @pageOverview.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get pageOverview;

  /// No description provided for @spreadModeAuto.
  ///
  /// In en, this message translates to:
  /// **'Pages per view: automatic'**
  String get spreadModeAuto;

  /// No description provided for @spreadModeSingle.
  ///
  /// In en, this message translates to:
  /// **'Pages per view: single'**
  String get spreadModeSingle;

  /// No description provided for @spreadModeDouble.
  ///
  /// In en, this message translates to:
  /// **'Pages per view: double'**
  String get spreadModeDouble;

  /// No description provided for @nextVolume.
  ///
  /// In en, this message translates to:
  /// **'Next volume'**
  String get nextVolume;

  /// No description provided for @readingDirection.
  ///
  /// In en, this message translates to:
  /// **'Reading direction'**
  String get readingDirection;

  /// Segment label for the series' detected reading direction; {direction} is the LTR/RTL abbreviation.
  ///
  /// In en, this message translates to:
  /// **'Default ({direction})'**
  String readingDirectionDefault(String direction);

  /// No description provided for @readingDirectionLtr.
  ///
  /// In en, this message translates to:
  /// **'Left-to-right'**
  String get readingDirectionLtr;

  /// No description provided for @readingDirectionRtlShort.
  ///
  /// In en, this message translates to:
  /// **'Right-to-left'**
  String get readingDirectionRtlShort;

  /// No description provided for @couldNotSaveReadingDirection.
  ///
  /// In en, this message translates to:
  /// **'Could not save the reading direction'**
  String get couldNotSaveReadingDirection;

  /// Per-item credit line naming the external metadata/artwork providers, e.g. "Source: TMDB · Wikipedia".
  ///
  /// In en, this message translates to:
  /// **'Source: {sources}'**
  String sourceAttribution(String sources);

  /// No description provided for @aboutAttributions.
  ///
  /// In en, this message translates to:
  /// **'About & data sources'**
  String get aboutAttributions;

  /// No description provided for @attributionsIntro.
  ///
  /// In en, this message translates to:
  /// **'Metadata and artwork on this server are provided by the following external sources:'**
  String get attributionsIntro;

  /// No description provided for @attributionLicense.
  ///
  /// In en, this message translates to:
  /// **'License: {license}'**
  String attributionLicense(String license);

  /// No description provided for @attributionsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The server does not report its data sources yet.'**
  String get attributionsUnavailable;

  /// No description provided for @openSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get openSourceLicenses;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
