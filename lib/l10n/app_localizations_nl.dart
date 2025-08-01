// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get watchNext => 'Kijk verder';

  @override
  String get recentlyAddedShows => 'Recent toegevoegde series';

  @override
  String season(num number) {
    return 'Seizoen $number';
  }

  @override
  String episode(Object number) {
    return 'Aflevering $number';
  }

  @override
  String episodePrefix(Object number) {
    return 'A$number';
  }
}
