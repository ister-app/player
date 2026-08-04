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
  String appVersion(String version) {
    return 'Version $version';
  }

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
  String get usersAndAccess => 'Users & access';

  @override
  String get libraryVisibility => 'Library visibility';

  @override
  String get visibleToEveryone => 'Visible to everyone';

  @override
  String get restrictedLibrarySubtitle => 'Restricted — only granted users';

  @override
  String get adminLabel => 'Admin';

  @override
  String get noUsersYet =>
      'No users yet — a user appears here after their first login.';

  @override
  String get adminRoleNote =>
      'Admins always see every library. The admin role itself is assigned in the identity provider (e.g. Keycloak).';

  @override
  String get changeNotSaved => 'Could not save the change';

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
  String get goToAuthor => 'Go to author';

  @override
  String get listen => 'Listen';

  @override
  String get read => 'Read';

  @override
  String get readAloud => 'Read aloud';

  @override
  String get howDoYouWantToRead => 'How do you want to read this?';

  @override
  String get startReading => 'Start reading';

  @override
  String get continueReading => 'Continue reading';

  @override
  String get chapters => 'Chapters';

  @override
  String get chapter => 'Chapter';

  @override
  String get episodes => 'Episodes';

  @override
  String get addPodcast => 'Add podcast';

  @override
  String get addPodcastHint => 'Search, or paste a feed URL';

  @override
  String get subscribeFailed => 'Could not subscribe to this feed';

  @override
  String get unsubscribe => 'Unsubscribe';

  @override
  String get download => 'Download';

  @override
  String get downloadStarted =>
      'Download started — the episode appears shortly';

  @override
  String get downloadFailed => 'Download request failed';

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
  String get maxQuality => 'Maximum quality';

  @override
  String get maxQualityDescription =>
      'Highest quality the server prepares for you';

  @override
  String get qualityAuto => 'Automatic';

  @override
  String get play => 'Play';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get songs => 'Songs';

  @override
  String get albums => 'Albums';

  @override
  String get books => 'Books';

  @override
  String get newestFirst => 'Newest first';

  @override
  String get oldestFirst => 'Oldest first';

  @override
  String get sortOrderFailed => 'Could not change the sort order';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortNameAsc => 'Name (A–Z)';

  @override
  String get sortNameDesc => 'Name (Z–A)';

  @override
  String get sortDateAddedNewest => 'Date added (newest first)';

  @override
  String get sortDateAddedOldest => 'Date added (oldest first)';

  @override
  String get sortReleaseYearNewest => 'Release year (newest first)';

  @override
  String get sortReleaseYearOldest => 'Release year (oldest first)';

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
  String get rate => 'Rate';

  @override
  String get yourRating => 'Your rating';

  @override
  String ratingValue(int value) {
    return '$value/10';
  }

  @override
  String get ratingFailed => 'Could not save your rating';

  @override
  String get appearsIn => 'Appears in';

  @override
  String get personNotFound => 'Person not found';

  @override
  String get readMore => 'Read more';

  @override
  String get mostPlayedTracks => 'Most played';

  @override
  String get recentlyPlayedTracks => 'Last played';

  @override
  String get highestRatedTracks => 'Highest rated';

  @override
  String get viewDiscover => 'Discover';

  @override
  String get goToAlbum => 'Go to album';

  @override
  String get browseKindAlbums => 'Albums';

  @override
  String get browseKindArtists => 'Artists';

  @override
  String get browseKindTracks => 'Tracks';

  @override
  String get browseKindShows => 'Shows';

  @override
  String get browseKindEpisodes => 'Episodes';

  @override
  String get viewAsGrid => 'Grid view';

  @override
  String get viewAsList => 'List view';

  @override
  String get sortAirDateNewest => 'Air date (newest first)';

  @override
  String get sortAirDateOldest => 'Air date (oldest first)';

  @override
  String get viewBrowse => 'Browse';

  @override
  String get projectWebsite => 'Website';

  @override
  String get projectSourceCode => 'Source code on GitHub';

  @override
  String get showAll => 'Show all';

  @override
  String get allAlbums => 'All albums';

  @override
  String get allBooks => 'All books';

  @override
  String get allPodcasts => 'All podcasts';

  @override
  String get recentlyAdded => 'Recently added';

  @override
  String get recentlyPlayed => 'Last played';

  @override
  String get mostPlayed => 'Most played';

  @override
  String get highestRated => 'Highest rated';

  @override
  String get recentlyRead => 'Recently read';

  @override
  String playCountTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Played $count times',
      one: 'Played once',
    );
    return '$_temp0';
  }

  @override
  String get showMore => 'Show more';

  @override
  String get playedJustNow => 'Just now';

  @override
  String hoursAgoShort(int count) {
    return '$count hr ago';
  }

  @override
  String daysAgoShort(int count) {
    return '$count d ago';
  }

  @override
  String weeksAgoShort(int count) {
    return '$count wk ago';
  }

  @override
  String monthsAgoShort(int count) {
    return '$count mo ago';
  }

  @override
  String yearsAgoShort(int count) {
    return '$count yr ago';
  }

  @override
  String get showLess => 'Show less';

  @override
  String discHeader(int number) {
    return 'Disc $number';
  }

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count songs',
      one: '1 song',
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
  String bookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count books',
      one: '1 book',
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

  @override
  String get sessionEnded => 'Session ended';

  @override
  String get addToSession => 'Add to session';

  @override
  String get chooseSession => 'Choose a session';

  @override
  String get playNext => 'Play next';

  @override
  String get addToEndOfQueue => 'Add to end of queue';

  @override
  String get addedToSession => 'Added to session';

  @override
  String get addToSessionFailed => 'Adding to session failed';

  @override
  String get remotePlay => 'Resumed via remote control';

  @override
  String get remotePause => 'Paused via remote control';

  @override
  String get remoteNext => 'Next via remote control';

  @override
  String get remotePrevious => 'Previous via remote control';

  @override
  String get remoteSeek => 'Position changed via remote control';

  @override
  String get remoteSkipToItem => 'Queue item selected via remote control';

  @override
  String get remoteQueueChanged => 'Queue updated via remote control';

  @override
  String get tableOfContents => 'Contents';

  @override
  String get readerSettings => 'Reading settings';

  @override
  String get fontSize => 'Font size';

  @override
  String get readerTheme => 'Theme';

  @override
  String get readerThemeLight => 'Light';

  @override
  String get readerThemeSepia => 'Sepia';

  @override
  String get readerThemeDark => 'Dark';

  @override
  String get lineHeight => 'Line spacing';

  @override
  String get pageMargins => 'Margins';

  @override
  String get readerFont => 'Font';

  @override
  String get readerFontStandard => 'Book default';

  @override
  String get readerFontSerif => 'Serif';

  @override
  String get readerFontSans => 'Sans';

  @override
  String get enterFullscreen => 'Fullscreen';

  @override
  String get exitFullscreen => 'Exit fullscreen';

  @override
  String get couldNotLoadBook => 'Could not load the book';

  @override
  String get noReadAloudForChapter => 'This chapter has no read-aloud audio';

  @override
  String get bookMayNotDisplayCorrectly =>
      'This book has a fixed layout and may not display correctly';

  @override
  String get previousChapter => 'Previous chapter';

  @override
  String get nextChapter => 'Next chapter';

  @override
  String get couldNotLoadComic => 'Could not load the comic';

  @override
  String pageOfPages(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get readingDirectionRtl => 'Read right-to-left (manga)';

  @override
  String pageRangeOfPages(int from, int to, int total) {
    return 'Page $from-$to of $total';
  }

  @override
  String get goToSeries => 'Go to series';

  @override
  String get volumes => 'Volumes';

  @override
  String get fitWidth => 'Fit width';

  @override
  String get fitPage => 'Fit page';

  @override
  String get pageOverview => 'Pages';

  @override
  String get spreadModeAuto => 'Pages per view: automatic';

  @override
  String get spreadModeSingle => 'Pages per view: single';

  @override
  String get spreadModeDouble => 'Pages per view: double';

  @override
  String get nextVolume => 'Next volume';

  @override
  String get readingDirection => 'Reading direction';

  @override
  String readingDirectionDefault(String direction) {
    return 'Default ($direction)';
  }

  @override
  String get readingDirectionLtr => 'Left-to-right';

  @override
  String get readingDirectionRtlShort => 'Right-to-left';

  @override
  String get couldNotSaveReadingDirection =>
      'Could not save the reading direction';

  @override
  String sourceAttribution(String sources) {
    return 'Source: $sources';
  }

  @override
  String get aboutAttributions => 'About & data sources';

  @override
  String get attributionsIntro =>
      'Metadata and artwork on this server are provided by the following external sources:';

  @override
  String attributionLicense(String license) {
    return 'License: $license';
  }

  @override
  String get attributionsUnavailable =>
      'The server does not report its data sources yet.';

  @override
  String get openSourceLicenses => 'Open-source licenses';

  @override
  String get sharingSettings => 'Sharing & privacy';

  @override
  String get sharingSettingsSubtitle => 'Who can see and control what you play';

  @override
  String get nowPlayingVisibility => 'Now playing';

  @override
  String get nowPlayingVisibilityDescription =>
      'Who can see what you are currently playing';

  @override
  String get remoteControlSharing => 'Remote control';

  @override
  String get remoteControlSharingDescription =>
      'Who can control your playback from their device';

  @override
  String get sharingScopeEveryone => 'Everyone';

  @override
  String get sharingScopePrivate => 'Only me';

  @override
  String get sharingScopeAllowlist => 'Specific people';

  @override
  String get sharingScopeSameAsNowPlaying => 'Same as now playing';

  @override
  String get sharingChoosePeople => 'Choose people';

  @override
  String get sharingNoOtherUsers =>
      'There are no other users to share with yet.';

  @override
  String get sharingCouldNotLoad => 'Could not load sharing settings.';

  @override
  String get sharingCouldNotSave => 'Could not save sharing settings';

  @override
  String get sessionSharingTitle => 'Who can control this session';

  @override
  String get sessionSharingUseDefault => 'Use my default';

  @override
  String get shareThisSession => 'Share this session';

  @override
  String get sleepTimer => 'Sleep timer';

  @override
  String sleepTimerMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String sleepTimerRemaining(String time) {
    return '$time remaining';
  }

  @override
  String get sleepTimerCancel => 'Cancel timer';

  @override
  String get sleepTimerExtend => '+15 min';

  @override
  String get sleepTimerCustom => 'Custom…';

  @override
  String get sleepTimerCustomDuration => 'Custom duration';

  @override
  String get sleepTimerMinutesLabel => 'Minutes';

  @override
  String get sleepTimerAuto => 'Automatic sleep timer';

  @override
  String get sleepTimerAutoDescription =>
      'Start the sleep timer automatically when playback begins between these times';

  @override
  String get sleepTimerFrom => 'From';

  @override
  String get sleepTimerUntil => 'Until';

  @override
  String get sleepTimerDefaultDuration => 'Default duration';

  @override
  String get sleepTimerDeviceOnly => 'Applies to this device only';

  @override
  String get customFilter => 'Custom filter';

  @override
  String get filterMatchAll => 'Match all of the following';

  @override
  String get filterMatchAny => 'Match any of the following';

  @override
  String get filterAddCondition => 'Add condition';

  @override
  String get filterAddSubgroup => 'Add subgroup';

  @override
  String get filterClear => 'Clear filter';

  @override
  String get filterApply => 'Apply';

  @override
  String get filterSaveAsView => 'Save as view';

  @override
  String get filterLimitTo => 'Limit to';

  @override
  String filterActiveChip(int count) {
    return 'Filter ($count)';
  }

  @override
  String get filterViewNameLabel => 'Name';

  @override
  String get filterSavedViews => 'Views';

  @override
  String get filterDeleteView => 'Delete view';

  @override
  String get filterValueHint => 'Value';

  @override
  String get filterDateHint => 'YYYY-MM-DD';

  @override
  String get filterValueTrue => 'Yes';

  @override
  String get filterValueFalse => 'No';

  @override
  String get filterPlayResults => 'Play results';

  @override
  String get filterViewSaveFailed => 'Saving the view failed';

  @override
  String get filterSaveAsPlaylist => 'Save as playlist';

  @override
  String filterPlaylistCreated(String name) {
    return 'Playlist \"$name\" created';
  }

  @override
  String get filterPlaylistOpen => 'Open';

  @override
  String get filterPlaylistSaveFailed => 'Creating the playlist failed';

  @override
  String get filterFieldTitle => 'Title';

  @override
  String get filterFieldArtistName => 'Artist';

  @override
  String get filterFieldAlbumName => 'Album';

  @override
  String get filterFieldReleaseYear => 'Year';

  @override
  String get filterFieldBirthYear => 'Birth year';

  @override
  String get filterFieldGenre => 'Genre';

  @override
  String get filterFieldRating => 'Rating';

  @override
  String get filterFieldPlayCount => 'Play count';

  @override
  String get filterFieldLastPlayedAt => 'Last played';

  @override
  String get filterFieldDuration => 'Duration (minutes)';

  @override
  String get filterFieldWatched => 'Watched';

  @override
  String get filterFieldDateAdded => 'Date added';

  @override
  String get filterOpContains => 'contains';

  @override
  String get filterOpNotContains => 'does not contain';

  @override
  String get filterOpEquals => 'is';

  @override
  String get filterOpNotEquals => 'is not';

  @override
  String get filterOpLessThan => 'less than';

  @override
  String get filterOpGreaterThan => 'greater than';

  @override
  String get filterOpBefore => 'before';

  @override
  String get filterOpAfter => 'after';

  @override
  String get filterOpInLastDays => 'in the last (days)';

  @override
  String get filterOpIsSet => 'is set';

  @override
  String get filterOpIsNotSet => 'is not set';

  @override
  String get followListenAlong => 'Listen along';

  @override
  String get followingBadge => 'Listening along';

  @override
  String get followQueueUnavailable =>
      'Can\'t listen along — this session is no longer available';

  @override
  String get followNoLibraryAccess =>
      'Can\'t listen along — you don\'t have access to this queue\'s library';

  @override
  String followTrackNotAvailable(String title) {
    return '\'$title\' isn\'t available for you — waiting for the next track';
  }

  @override
  String get followLeaderStopped =>
      'Listening along ended — the session stopped';

  @override
  String followersListening(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count devices listening along',
      one: '1 device listening along',
    );
    return '$_temp0';
  }

  @override
  String get stopListeningAlong => 'Stop listening along';

  @override
  String get tightSyncToggle => 'In sync in the same room';

  @override
  String outputLatencySlider(int ms) {
    return 'Audio delay of this device: $ms ms';
  }

  @override
  String get playlists => 'Playlists';

  @override
  String get newPlaylist => 'New playlist';

  @override
  String get editPlaylist => 'Edit playlist';

  @override
  String get deletePlaylist => 'Delete playlist';

  @override
  String deletePlaylistConfirm(String name) {
    return 'Delete playlist \'$name\'? Anything currently playing keeps playing.';
  }

  @override
  String get playlistName => 'Name';

  @override
  String get smartPlaylist => 'Smart playlist';

  @override
  String get smartPlaylistDescription =>
      'The contents follow a filter you define';

  @override
  String get manualPlaylist => 'Playlist';

  @override
  String get manualPlaylistDescription => 'You pick the items yourself';

  @override
  String get addToPlaylist => 'Add to playlist';

  @override
  String get addedToPlaylist => 'Added to playlist';

  @override
  String get addToPlaylistFailed => 'Could not add to the playlist';

  @override
  String get noPlaylistsYet => 'No playlists yet';

  @override
  String get playlistEmpty =>
      'This playlist is empty. Add items from their context menu.';

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
  String get removeFromPlaylist => 'Remove from playlist';

  @override
  String get editFilter => 'Edit filter';
}
