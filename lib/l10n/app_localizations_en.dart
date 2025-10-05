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
  String get refreshPage => 'Refresh page';

  @override
  String get scanLibrary => 'Scan library';

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
