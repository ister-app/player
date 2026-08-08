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

  /// Shown on the person page when the person does not exist or is not accessible
  ///
  /// In en, this message translates to:
  /// **'Person not found'**
  String get personNotFound;

  /// Toggle expanding a clamped long description to its full text
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// Section header on the artist page for the user's most played tracks
  ///
  /// In en, this message translates to:
  /// **'Most played'**
  String get mostPlayedTracks;

  /// Section header on the artist page for the user's most recently played tracks
  ///
  /// In en, this message translates to:
  /// **'Last played'**
  String get recentlyPlayedTracks;

  /// Section header on the artist page for the user's highest rated tracks
  ///
  /// In en, this message translates to:
  /// **'Highest rated'**
  String get highestRatedTracks;

  /// Library view switch: the carousel-based discover view
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get viewDiscover;

  /// In context menu an item when clicked navigates to the album page.
  ///
  /// In en, this message translates to:
  /// **'Go to album'**
  String get goToAlbum;

  /// Browse kind pill: list the albums of a music library
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get browseKindAlbums;

  /// Browse kind pill: list the artists of a music library
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get browseKindArtists;

  /// Browse kind pill: list every track of a music library
  ///
  /// In en, this message translates to:
  /// **'Tracks'**
  String get browseKindTracks;

  /// Browse kind pill: list the shows of a show library
  ///
  /// In en, this message translates to:
  /// **'Shows'**
  String get browseKindShows;

  /// Browse kind pill: list every episode of a show library
  ///
  /// In en, this message translates to:
  /// **'Episodes'**
  String get browseKindEpisodes;

  /// Tooltip of the layout toggle while the list layout is active
  ///
  /// In en, this message translates to:
  /// **'Grid view'**
  String get viewAsGrid;

  /// Tooltip of the layout toggle while the grid layout is active
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get viewAsList;

  /// Episode sort option: by air date, newest first
  ///
  /// In en, this message translates to:
  /// **'Air date (newest first)'**
  String get sortAirDateNewest;

  /// Episode sort option: by air date, oldest first
  ///
  /// In en, this message translates to:
  /// **'Air date (oldest first)'**
  String get sortAirDateOldest;

  /// Library view switch: the sortable grid view
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get viewBrowse;

  /// About page: link to the Ister project website
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get projectWebsite;

  /// About page: link to the Ister GitHub organisation
  ///
  /// In en, this message translates to:
  /// **'Source code on GitHub'**
  String get projectSourceCode;

  /// Tooltip/semantics of a tappable carousel header opening the row's full vertical list
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get showAll;

  /// Android Auto: folder closing the albums tab that opens the full alphabetical album list
  ///
  /// In en, this message translates to:
  /// **'All albums'**
  String get allAlbums;

  /// Android Auto: section title of the full book list below the discover groups
  ///
  /// In en, this message translates to:
  /// **'All books'**
  String get allBooks;

  /// Android Auto: section title of the full podcast list below the discover groups
  ///
  /// In en, this message translates to:
  /// **'All podcasts'**
  String get allPodcasts;

  /// Discover row of the library's newest items
  ///
  /// In en, this message translates to:
  /// **'Recently added'**
  String get recentlyAdded;

  /// Discover row of the user's most recently played items
  ///
  /// In en, this message translates to:
  /// **'Last played'**
  String get recentlyPlayed;

  /// Discover row of the user's most played items
  ///
  /// In en, this message translates to:
  /// **'Most played'**
  String get mostPlayed;

  /// Discover row of the user's highest rated items
  ///
  /// In en, this message translates to:
  /// **'Highest rated'**
  String get highestRated;

  /// Discover row of the user's most recently read books or series
  ///
  /// In en, this message translates to:
  /// **'Recently read'**
  String get recentlyRead;

  /// Tooltip/semantics label for the play-count badge in the most-played track list
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Played once} other{Played {count} times}}'**
  String playCountTimes(int count);

  /// Toggle expanding a collapsed track list to all its items
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// Relative time in the last-played track list for plays within the past hour
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get playedJustNow;

  /// Compact relative time: hours
  ///
  /// In en, this message translates to:
  /// **'{count} hr ago'**
  String hoursAgoShort(int count);

  /// Compact relative time: days
  ///
  /// In en, this message translates to:
  /// **'{count} d ago'**
  String daysAgoShort(int count);

  /// Compact relative time: weeks
  ///
  /// In en, this message translates to:
  /// **'{count} wk ago'**
  String weeksAgoShort(int count);

  /// Compact relative time: months
  ///
  /// In en, this message translates to:
  /// **'{count} mo ago'**
  String monthsAgoShort(int count);

  /// Compact relative time: years
  ///
  /// In en, this message translates to:
  /// **'{count} yr ago'**
  String yearsAgoShort(int count);

  /// Toggle collapsing an expanded long description back to a few lines
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// Header above the tracks of one disc on a multi-disc album page
  ///
  /// In en, this message translates to:
  /// **'Disc {number}'**
  String discHeader(int number);

  /// Number of songs on an album, shown next to the play button
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 song} other{{count} songs}}'**
  String trackCount(int count);

  /// Album summary next to the play button: song count and total duration
  ///
  /// In en, this message translates to:
  /// **'{tracks} • {duration}'**
  String albumStats(String tracks, String duration);

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

  /// No description provided for @remoteStop.
  ///
  /// In en, this message translates to:
  /// **'Playback stopped via remote control'**
  String get remoteStop;

  /// Tooltip/label for the stop button that ends the session and dismisses the mini player
  ///
  /// In en, this message translates to:
  /// **'Stop playback'**
  String get stopPlayback;

  /// Tooltip for the overflow (...) button in the player opening the less-used actions sheet
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// Tooltip for the bottom-bar button that scrolls the full player to the queue lists
  ///
  /// In en, this message translates to:
  /// **'Show queue'**
  String get showQueue;

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

  /// No description provided for @lineHeight.
  ///
  /// In en, this message translates to:
  /// **'Line spacing'**
  String get lineHeight;

  /// No description provided for @pageMargins.
  ///
  /// In en, this message translates to:
  /// **'Margins'**
  String get pageMargins;

  /// No description provided for @readerFont.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get readerFont;

  /// No description provided for @readerFontStandard.
  ///
  /// In en, this message translates to:
  /// **'Book default'**
  String get readerFontStandard;

  /// No description provided for @readerFontSerif.
  ///
  /// In en, this message translates to:
  /// **'Serif'**
  String get readerFontSerif;

  /// No description provided for @readerFontSans.
  ///
  /// In en, this message translates to:
  /// **'Sans'**
  String get readerFontSans;

  /// No description provided for @enterFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen'**
  String get enterFullscreen;

  /// No description provided for @exitFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Exit fullscreen'**
  String get exitFullscreen;

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

  /// Title of the sharing/privacy settings subpage and its tile
  ///
  /// In en, this message translates to:
  /// **'Sharing & privacy'**
  String get sharingSettings;

  /// Subtitle for the sharing settings tile
  ///
  /// In en, this message translates to:
  /// **'Who can see and control what you play'**
  String get sharingSettingsSubtitle;

  /// Section header for who may see your active playback sessions
  ///
  /// In en, this message translates to:
  /// **'Now playing'**
  String get nowPlayingVisibility;

  /// Description under the now-playing visibility section
  ///
  /// In en, this message translates to:
  /// **'Who can see what you are currently playing'**
  String get nowPlayingVisibilityDescription;

  /// Section header for who may remote-control your sessions
  ///
  /// In en, this message translates to:
  /// **'Remote control'**
  String get remoteControlSharing;

  /// Description under the remote-control sharing section
  ///
  /// In en, this message translates to:
  /// **'Who can control your playback from their device'**
  String get remoteControlSharingDescription;

  /// Sharing scope: visible to or controllable by every user
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get sharingScopeEveryone;

  /// Sharing scope: private, nobody but the owner
  ///
  /// In en, this message translates to:
  /// **'Only me'**
  String get sharingScopePrivate;

  /// Sharing scope: only a chosen list of users
  ///
  /// In en, this message translates to:
  /// **'Specific people'**
  String get sharingScopeAllowlist;

  /// Remote-control scope that mirrors the now-playing audience
  ///
  /// In en, this message translates to:
  /// **'Same as now playing'**
  String get sharingScopeSameAsNowPlaying;

  /// Header above the user allowlist selector
  ///
  /// In en, this message translates to:
  /// **'Choose people'**
  String get sharingChoosePeople;

  /// Shown when the server has no other users to pick for an allowlist
  ///
  /// In en, this message translates to:
  /// **'There are no other users to share with yet.'**
  String get sharingNoOtherUsers;

  /// Error shown when the sharing settings fail to load (e.g. older server)
  ///
  /// In en, this message translates to:
  /// **'Could not load sharing settings.'**
  String get sharingCouldNotLoad;

  /// Error shown when saving sharing settings fails
  ///
  /// In en, this message translates to:
  /// **'Could not save sharing settings'**
  String get sharingCouldNotSave;

  /// Title of the per-session remote-control sharing sheet
  ///
  /// In en, this message translates to:
  /// **'Who can control this session'**
  String get sessionSharingTitle;

  /// Per-session option to fall back to the account-level remote-control setting
  ///
  /// In en, this message translates to:
  /// **'Use my default'**
  String get sessionSharingUseDefault;

  /// Menu action opening the per-session sharing sheet
  ///
  /// In en, this message translates to:
  /// **'Share this session'**
  String get shareThisSession;

  /// Name of the sleep timer feature; button tooltip, sheet title and settings tile
  ///
  /// In en, this message translates to:
  /// **'Sleep timer'**
  String get sleepTimer;

  /// Preset chip label for a sleep timer duration
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String sleepTimerMinutes(int minutes);

  /// Countdown line in the sleep timer sheet, e.g. '14:59 remaining'
  ///
  /// In en, this message translates to:
  /// **'{time} remaining'**
  String sleepTimerRemaining(String time);

  /// Button that cancels a running sleep timer
  ///
  /// In en, this message translates to:
  /// **'Cancel timer'**
  String get sleepTimerCancel;

  /// Button that adds 15 minutes to a running sleep timer
  ///
  /// In en, this message translates to:
  /// **'+15 min'**
  String get sleepTimerExtend;

  /// Chip opening a dialog to enter a custom sleep timer duration
  ///
  /// In en, this message translates to:
  /// **'Custom…'**
  String get sleepTimerCustom;

  /// Title of the custom sleep timer duration dialog
  ///
  /// In en, this message translates to:
  /// **'Custom duration'**
  String get sleepTimerCustomDuration;

  /// Label of the minutes input in the custom duration dialog
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get sleepTimerMinutesLabel;

  /// Settings switch enabling the automatic sleep timer window
  ///
  /// In en, this message translates to:
  /// **'Automatic sleep timer'**
  String get sleepTimerAuto;

  /// Subtitle explaining the automatic sleep timer switch
  ///
  /// In en, this message translates to:
  /// **'Start the sleep timer automatically when playback begins between these times'**
  String get sleepTimerAutoDescription;

  /// Settings tile for the start of the automatic sleep timer window
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get sleepTimerFrom;

  /// Settings tile for the end of the automatic sleep timer window
  ///
  /// In en, this message translates to:
  /// **'Until'**
  String get sleepTimerUntil;

  /// Settings tile for the duration an automatically started sleep timer runs
  ///
  /// In en, this message translates to:
  /// **'Default duration'**
  String get sleepTimerDefaultDuration;

  /// Note that sleep timer settings are not synced to the server
  ///
  /// In en, this message translates to:
  /// **'Applies to this device only'**
  String get sleepTimerDeviceOnly;

  /// Snackbar shown when a sleep timer is armed, manually or automatically
  ///
  /// In en, this message translates to:
  /// **'Sleep timer started: playback pauses in {minutes} min'**
  String sleepTimerStartedMessage(int minutes);

  /// Snackbar shown when the sleep timer runs out and stops playback
  ///
  /// In en, this message translates to:
  /// **'Sleep timer ended: playback paused'**
  String get sleepTimerExpiredMessage;

  /// Heading above the duration presets in the sleep timer sheet
  ///
  /// In en, this message translates to:
  /// **'After a while'**
  String get sleepTimerAfterDuration;

  /// Heading above the item-count presets in the sleep timer sheet
  ///
  /// In en, this message translates to:
  /// **'After a number of items'**
  String get sleepTimerAfterItems;

  /// Preset chip for stopping after a number of media items
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{This item} other{{count} items}}'**
  String sleepTimerItems(int count);

  /// Status line in the sleep timer sheet while counting items
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item left} other{{count} items left}}'**
  String sleepTimerItemsRemaining(int count);

  /// Compact badge under the player's sleep timer button while counting items
  ///
  /// In en, this message translates to:
  /// **'{count}×'**
  String sleepTimerItemsShort(int count);

  /// Label of the input in the custom item-count dialog
  ///
  /// In en, this message translates to:
  /// **'Number of items'**
  String get sleepTimerItemsCount;

  /// Snackbar shown when an item-counting sleep timer is armed
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Sleep timer started: playback pauses after this item} other{Sleep timer started: playback pauses after {count} items}}'**
  String sleepTimerItemsStartedMessage(int count);

  /// Tooltip/label of the filter button in the library browse bar
  ///
  /// In en, this message translates to:
  /// **'Custom filter'**
  String get customFilter;

  /// Filter builder: AND mode of a group
  ///
  /// In en, this message translates to:
  /// **'Match all of the following'**
  String get filterMatchAll;

  /// Filter builder: OR mode of a group
  ///
  /// In en, this message translates to:
  /// **'Match any of the following'**
  String get filterMatchAny;

  /// Filter builder: the + button tooltip
  ///
  /// In en, this message translates to:
  /// **'Add condition'**
  String get filterAddCondition;

  /// Filter builder menu: add a nested condition group
  ///
  /// In en, this message translates to:
  /// **'Add subgroup'**
  String get filterAddSubgroup;

  /// Filter builder menu: remove all conditions
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get filterClear;

  /// Filter builder: apply button
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get filterApply;

  /// Filter builder menu: save the filter as a named view
  ///
  /// In en, this message translates to:
  /// **'Save as view'**
  String get filterSaveAsView;

  /// Filter builder: label of the maximum-results field
  ///
  /// In en, this message translates to:
  /// **'Limit to'**
  String get filterLimitTo;

  /// Chip showing the active filter with its condition count
  ///
  /// In en, this message translates to:
  /// **'Filter ({count})'**
  String filterActiveChip(int count);

  /// Save-as-view dialog: name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get filterViewNameLabel;

  /// Filter sheet: header of the saved views section
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get filterSavedViews;

  /// Filter sheet: delete a saved view
  ///
  /// In en, this message translates to:
  /// **'Delete view'**
  String get filterDeleteView;

  /// Filter builder: hint of the value input
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get filterValueHint;

  /// Filter builder: hint of a date value input
  ///
  /// In en, this message translates to:
  /// **'YYYY-MM-DD'**
  String get filterDateHint;

  /// Filter builder: boolean value true
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get filterValueTrue;

  /// Filter builder: boolean value false
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get filterValueFalse;

  /// Play the filtered results as a queue
  ///
  /// In en, this message translates to:
  /// **'Play results'**
  String get filterPlayResults;

  /// Snackbar when createSavedView fails
  ///
  /// In en, this message translates to:
  /// **'Saving the view failed'**
  String get filterViewSaveFailed;

  /// Turn the active browse filter into a smart playlist
  ///
  /// In en, this message translates to:
  /// **'Save as playlist'**
  String get filterSaveAsPlaylist;

  /// Snackbar after creating a smart playlist from the browse filter
  ///
  /// In en, this message translates to:
  /// **'Playlist \"{name}\" created'**
  String filterPlaylistCreated(String name);

  /// Snackbar action opening the freshly created playlist
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get filterPlaylistOpen;

  /// Snackbar when createPlaylist from the browse filter fails
  ///
  /// In en, this message translates to:
  /// **'Creating the playlist failed'**
  String get filterPlaylistSaveFailed;

  /// Filter field label
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get filterFieldTitle;

  /// Filter field label
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get filterFieldArtistName;

  /// Filter field label
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get filterFieldAlbumName;

  /// Filter field label
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get filterFieldReleaseYear;

  /// Filter field label
  ///
  /// In en, this message translates to:
  /// **'Birth year'**
  String get filterFieldBirthYear;

  /// Filter field label
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get filterFieldGenre;

  /// Filter field label
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get filterFieldRating;

  /// Filter field label
  ///
  /// In en, this message translates to:
  /// **'Play count'**
  String get filterFieldPlayCount;

  /// Filter field label
  ///
  /// In en, this message translates to:
  /// **'Last played'**
  String get filterFieldLastPlayedAt;

  /// Filter field label; value is entered in minutes
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get filterFieldDuration;

  /// Filter field label
  ///
  /// In en, this message translates to:
  /// **'Watched'**
  String get filterFieldWatched;

  /// Filter field label
  ///
  /// In en, this message translates to:
  /// **'Date added'**
  String get filterFieldDateAdded;

  /// Filter operator label
  ///
  /// In en, this message translates to:
  /// **'contains'**
  String get filterOpContains;

  /// Filter operator label
  ///
  /// In en, this message translates to:
  /// **'does not contain'**
  String get filterOpNotContains;

  /// Filter operator label
  ///
  /// In en, this message translates to:
  /// **'is'**
  String get filterOpEquals;

  /// Filter operator label
  ///
  /// In en, this message translates to:
  /// **'is not'**
  String get filterOpNotEquals;

  /// Filter operator label
  ///
  /// In en, this message translates to:
  /// **'less than'**
  String get filterOpLessThan;

  /// Filter operator label
  ///
  /// In en, this message translates to:
  /// **'greater than'**
  String get filterOpGreaterThan;

  /// Filter operator label
  ///
  /// In en, this message translates to:
  /// **'before'**
  String get filterOpBefore;

  /// Filter operator label
  ///
  /// In en, this message translates to:
  /// **'after'**
  String get filterOpAfter;

  /// Filter operator label; the value is a number of days
  ///
  /// In en, this message translates to:
  /// **'in the last (days)'**
  String get filterOpInLastDays;

  /// Filter operator label
  ///
  /// In en, this message translates to:
  /// **'is set'**
  String get filterOpIsSet;

  /// Filter operator label
  ///
  /// In en, this message translates to:
  /// **'is not set'**
  String get filterOpIsNotSet;

  /// Action to start following another device's playback session on this device
  ///
  /// In en, this message translates to:
  /// **'Listen along'**
  String get followListenAlong;

  /// Title of the listen-together sheet, and of the buttons that open it
  ///
  /// In en, this message translates to:
  /// **'Listen together'**
  String get listenTogetherTitle;

  /// Title of the listen-together sheet and its opening buttons when the session plays a movie/episode
  ///
  /// In en, this message translates to:
  /// **'Watch together'**
  String get watchTogetherTitle;

  /// Join button label when the session plays a movie/episode
  ///
  /// In en, this message translates to:
  /// **'Watch along'**
  String get followWatchAlong;

  /// Indicator shown while this device follows a session that plays a movie/episode
  ///
  /// In en, this message translates to:
  /// **'Watching along'**
  String get watchingBadge;

  /// Stop-following button label when the session plays a movie/episode
  ///
  /// In en, this message translates to:
  /// **'Stop watching along'**
  String get stopWatchingAlong;

  /// Indicator shown while this device follows another device's session
  ///
  /// In en, this message translates to:
  /// **'Listening along'**
  String get followingBadge;

  /// Toast when starting to follow fails because the session stopped or the caller lost control permission
  ///
  /// In en, this message translates to:
  /// **'Can\'t listen along — this session is no longer available'**
  String get followQueueUnavailable;

  /// Toast when starting to follow fails because the caller's library access does not cover the queue's source
  ///
  /// In en, this message translates to:
  /// **'Can\'t listen along — you don\'t have access to this queue\'s library'**
  String get followNoLibraryAccess;

  /// Toast on a following device when the current item cannot be streamed with this user's library access; the device stays silent until the session owner moves on
  ///
  /// In en, this message translates to:
  /// **'\'{title}\' isn\'t available for you — waiting for the next track'**
  String followTrackNotAvailable(String title);

  /// Toast when the followed session disappears (owner stopped playing or the session timed out)
  ///
  /// In en, this message translates to:
  /// **'Listening along ended — the session stopped'**
  String get followLeaderStopped;

  /// Follower count on a now-playing session card
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 device listening along} other{{count} devices listening along}}'**
  String followersListening(int count);

  /// Title of the sheet listing the devices that listen along with your session, grouped per user
  ///
  /// In en, this message translates to:
  /// **'Listening along'**
  String get followersSheetTitle;

  /// Empty state of the listeners sheet
  ///
  /// In en, this message translates to:
  /// **'Nobody is listening along right now'**
  String get followersNone;

  /// Error state of the listeners sheet, also shown on a server that does not know the query yet
  ///
  /// In en, this message translates to:
  /// **'Could not load the listeners'**
  String get followersCouldNotLoad;

  /// Fallback name for a follower whose user name the server did not report
  ///
  /// In en, this message translates to:
  /// **'Unknown user'**
  String get followerUnknownUser;

  /// Fallback name for a following device that never registered itself
  ///
  /// In en, this message translates to:
  /// **'Unknown device'**
  String get followerUnknownDevice;

  /// Action that kicks one device off your session
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get followerRemove;

  /// Action that kicks every device of one user off your session
  ///
  /// In en, this message translates to:
  /// **'Remove all their devices'**
  String get followerRemoveUser;

  /// Confirmation before kicking a follower; name is a device or a user name
  ///
  /// In en, this message translates to:
  /// **'Stop {name} from listening along?'**
  String followerRemoveConfirm(String name);

  /// Toast after kicking a follower
  ///
  /// In en, this message translates to:
  /// **'{name} is no longer listening along'**
  String followerRemoved(String name);

  /// Toast when kicking a follower failed
  ///
  /// In en, this message translates to:
  /// **'Could not remove that listener'**
  String get followerRemoveFailed;

  /// Toast on the follower's device after it was kicked off a session
  ///
  /// In en, this message translates to:
  /// **'The session owner ended your listening along'**
  String get followerRemovedByOwner;

  /// Action to leave follow mode on this device
  ///
  /// In en, this message translates to:
  /// **'Stop listening along'**
  String get stopListeningAlong;

  /// Switch on a following device: discipline playback tightly against the leader's clock so both devices can play audibly in the same room
  ///
  /// In en, this message translates to:
  /// **'In sync in the same room'**
  String get tightSyncToggle;

  /// Label of the output-latency slider for tight sync; the user tunes it until the echo between devices disappears (Bluetooth adds unmeasurable delay)
  ///
  /// In en, this message translates to:
  /// **'Audio delay of this device: {ms} ms'**
  String outputLatencySlider(int ms);

  /// Discover row header and playlist list page title
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlists;

  /// No description provided for @newPlaylist.
  ///
  /// In en, this message translates to:
  /// **'New playlist'**
  String get newPlaylist;

  /// No description provided for @editPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Edit playlist'**
  String get editPlaylist;

  /// No description provided for @deletePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Delete playlist'**
  String get deletePlaylist;

  /// No description provided for @deletePlaylistConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete playlist \'{name}\'? Anything currently playing keeps playing.'**
  String deletePlaylistConfirm(String name);

  /// No description provided for @playlistName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get playlistName;

  /// No description provided for @smartPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Smart playlist'**
  String get smartPlaylist;

  /// No description provided for @smartPlaylistDescription.
  ///
  /// In en, this message translates to:
  /// **'The contents follow a filter you define'**
  String get smartPlaylistDescription;

  /// No description provided for @manualPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Playlist'**
  String get manualPlaylist;

  /// No description provided for @manualPlaylistDescription.
  ///
  /// In en, this message translates to:
  /// **'You pick the items yourself'**
  String get manualPlaylistDescription;

  /// No description provided for @addToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add to playlist'**
  String get addToPlaylist;

  /// No description provided for @addedToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Added to playlist'**
  String get addedToPlaylist;

  /// No description provided for @addToPlaylistFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not add to the playlist'**
  String get addToPlaylistFailed;

  /// No description provided for @noPlaylistsYet.
  ///
  /// In en, this message translates to:
  /// **'No playlists yet'**
  String get noPlaylistsYet;

  /// No description provided for @playlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'This playlist is empty. Add items from their context menu.'**
  String get playlistEmpty;

  /// No description provided for @playlistItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String playlistItemCount(int count);

  /// No description provided for @removeFromPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Remove from playlist'**
  String get removeFromPlaylist;

  /// No description provided for @editFilter.
  ///
  /// In en, this message translates to:
  /// **'Edit filter'**
  String get editFilter;

  /// Settings tile + page title for the user's registered devices
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devicesTitle;

  /// Subtitle of the devices tile on the settings page
  ///
  /// In en, this message translates to:
  /// **'Your devices, play on or hand off to another device'**
  String get devicesSubtitle;

  /// Chip marking the row of the device the app runs on
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get deviceThisDevice;

  /// Last-seen label when the device is online right now
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get deviceOnlineNow;

  /// Last-seen label when the server sent no usable timestamp
  ///
  /// In en, this message translates to:
  /// **'Last online: unknown'**
  String get deviceLastSeenUnknown;

  /// No description provided for @deviceLastSeenMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'Last online {count, plural, =1{1 minute} other{{count} minutes}} ago'**
  String deviceLastSeenMinutesAgo(int count);

  /// No description provided for @deviceLastSeenHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'Last online {count, plural, =1{1 hour} other{{count} hours}} ago'**
  String deviceLastSeenHoursAgo(int count);

  /// No description provided for @deviceLastSeenDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Last online {count, plural, =1{1 day} other{{count} days}} ago'**
  String deviceLastSeenDaysAgo(int count);

  /// Device row subtitle while that device is playing something
  ///
  /// In en, this message translates to:
  /// **'Now playing: {title}'**
  String deviceNowPlaying(String title);

  /// Menu item + dialog title to rename a device
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get deviceRename;

  /// Menu item + confirm button to remove a device
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get deviceRemove;

  /// No description provided for @deviceRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove device \'{name}\'?'**
  String deviceRemoveConfirm(String name);

  /// No description provided for @deviceRemoveThisDeviceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this device (\'{name}\')? It re-registers itself the next time the app starts.'**
  String deviceRemoveThisDeviceConfirm(String name);

  /// Devices page error state, also shown against older servers
  ///
  /// In en, this message translates to:
  /// **'Could not load devices. The server may not support them yet.'**
  String get deviceCouldNotLoad;

  /// Snackbar when a device rename/remove fails
  ///
  /// In en, this message translates to:
  /// **'Could not save the change.'**
  String get deviceCouldNotSave;

  /// Devices page empty state
  ///
  /// In en, this message translates to:
  /// **'No devices registered yet.'**
  String get deviceNoDevices;

  /// Context action that plays an item on another of your devices
  ///
  /// In en, this message translates to:
  /// **'Play on device…'**
  String get devicePlayOn;

  /// Player menu action that hands the queue off to another device
  ///
  /// In en, this message translates to:
  /// **'Move playback to device…'**
  String get deviceMoveQueue;

  /// Action that makes another of your devices join this queue in follow mode
  ///
  /// In en, this message translates to:
  /// **'Listen along on device…'**
  String get deviceListenAlongOn;

  /// Device picker empty state
  ///
  /// In en, this message translates to:
  /// **'None of your other devices are online.'**
  String get devicePickerNoDevicesOnline;

  /// Snackbar after a device command was accepted
  ///
  /// In en, this message translates to:
  /// **'Sent to {name}'**
  String deviceCommandSent(String name);

  /// Snackbar when the server refuses a device command
  ///
  /// In en, this message translates to:
  /// **'The device did not accept the command. It may have just gone offline.'**
  String get deviceCommandFailed;
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
