// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get refreshPage => 'Herlaad pagina';

  @override
  String get scanLibrary => 'Scan bibliotheek';

  @override
  String get watchNext => 'Kijk verder';

  @override
  String get recentlyAddedShows => 'Recent toegevoegde series';

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
  String get close => 'Sluit';

  @override
  String get json => 'JSON';

  @override
  String get rawData => 'Raw data';
}
