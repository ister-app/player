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

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
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
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: [
              _sectionHeader(context, loc.preferredSpoken),
              LanguageFormField(
                initialValue: _spokenLanguages,
                onChanged: _handleSpokenChanged,
              ),
              const SizedBox(height: 8),
              const Divider(),
              _sectionHeader(context, loc.preferredSubtitle),
              LanguageFormField(
                initialValue: _subtitleLanguages,
                onChanged: _handleSubtitleChanged,
              ),
            ],
          );
        },
      ),
    );
  }
}
