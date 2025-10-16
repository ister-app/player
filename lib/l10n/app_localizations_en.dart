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
  String get close => 'Close';

  @override
  String get json => 'JSON';

  @override
  String get rawData => 'Raw data';
}
