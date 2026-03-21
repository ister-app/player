import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/components/LanguagesFormField.dart';

import '../l10n/app_localizations.dart';
import '../utils/LanguagePreferences.dart';

@RoutePage()
class ServerSettingsLanguagePage extends StatefulWidget {
  const ServerSettingsLanguagePage({
    super.key,
    @PathParam.inherit('serverName') required String serverName,
  });

  @override
  State<ServerSettingsLanguagePage> createState() =>
      _ServerSettingsLanguagePageState();
}

class _ServerSettingsLanguagePageState
    extends State<ServerSettingsLanguagePage> {
  final List<String> _spokenLanguages = [];
  final List<String> _subtitleLanguages = [];
  late Future<void> _preferencesFuture;

  @override
  void initState() {
    super.initState();
    _preferencesFuture = _loadSavedPreferences();
  }

  Future<void> _loadSavedPreferences() async {
    final spoken = await LanguagePreferences.getSpokenLanguages();
    final subtitle = await LanguagePreferences.getSubtitleLanguages();

    _spokenLanguages
      ..clear()
      ..addAll(spoken);
    _subtitleLanguages
      ..clear()
      ..addAll(subtitle);
  }

  void _handleSpokenChanged(List<String> newList) {
    LanguagePreferences.setSpokenLanguages(newList);
    setState(() => _spokenLanguages
      ..clear()
      ..addAll(newList));
  }

  void _handleSubtitleChanged(List<String> newList) {
    LanguagePreferences.setSubtitleLanguages(newList);
    setState(() => _subtitleLanguages
      ..clear()
      ..addAll(newList));
  }

  Widget _sectionLabel(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 16.0, bottom: 4.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.languageSettings),
      ),
      body: FutureBuilder<void>(
        future: _preferencesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                loc.loadError(snapshot.error!),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _sectionLabel(context, loc.preferredSpoken),
              Card(
                child: LanguageFormField(
                  initialValue: _spokenLanguages,
                  onChanged: _handleSpokenChanged,
                ),
              ),
              _sectionLabel(context, loc.preferredSubtitle),
              Card(
                child: LanguageFormField(
                  initialValue: _subtitleLanguages,
                  onChanged: _handleSubtitleChanged,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
