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

  /// In menu archor an item when clicked go to show of that item.
  ///
  /// In en, this message translates to:
  /// **'Go to show'**
  String get goToShow;

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
