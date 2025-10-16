import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/components/LanguagesFormField.dart';

import '../l10n/app_localizations.dart';
import '../utils/LanguagePreferences.dart';

@RoutePage()
class ServerSettingsPage extends StatefulWidget {
  final String serverName;

  const ServerSettingsPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  @override
  State<ServerSettingsPage> createState() => _ServerSettingsPageState();
}

class _ServerSettingsPageState extends State<ServerSettingsPage> {
  final List<String> _spokenLanguages = [];
  final List<String> _subtitleLanguages = [];

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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settings),
      ),
      body: FutureBuilder<void>(
        future: _loadSavedPreferences(),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: [
              Text(loc.preferredSpoken),
              LanguageFormField(
                initialValue: _spokenLanguages,
                onChanged: _handleSpokenChanged,
              ),
              const SizedBox(height: 24),
              Text(loc.preferredSubtitle),
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