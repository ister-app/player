import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/components/LanguagePreferenceList.dart';
import 'package:player/components/SettingsSection.dart';

import '../l10n/app_localizations.dart';
import '../utils/LanguagePreferences.dart';
import '../utils/PlaybackPreferences.dart';

@RoutePage()
class ServerSettingsLanguagePage extends StatefulWidget {
  const ServerSettingsLanguagePage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  final String serverName;

  @override
  State<ServerSettingsLanguagePage> createState() =>
      _ServerSettingsLanguagePageState();
}

class _ServerSettingsLanguagePageState
    extends State<ServerSettingsLanguagePage> {
  List<String> _spokenLanguages = const [];
  List<String> _subtitleLanguages = const [];
  bool _hideSubtitlesMatchingAudio = false;
  late Future<void> _preferencesFuture;

  @override
  void initState() {
    super.initState();
    _preferencesFuture = _loadSavedPreferences();
  }

  Future<void> _loadSavedPreferences() async {
    _spokenLanguages = await LanguagePreferences.getSpokenLanguages(
        serverName: widget.serverName);
    _subtitleLanguages = await LanguagePreferences.getSubtitleLanguages(
        serverName: widget.serverName);
    _hideSubtitlesMatchingAudio =
        await PlaybackPreferences.getHideSubtitlesMatchingAudio(
            serverName: widget.serverName);
  }

  /// Shows the new value right away, then writes it through. The server is the
  /// source of truth, so a rejected save has to put the old one back — silently
  /// leaving the UI on a value the server never accepted is the worse lie.
  Future<void> _save<T>(
    T next,
    T previous,
    void Function(T) apply,
    Future<void> Function(T) write,
  ) async {
    setState(() => apply(next));
    try {
      await write(next);
    } catch (_) {
      if (!mounted) return;
      setState(() => apply(previous));
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(loc.languageSaveFailed)));
    }
  }

  void _handleSpokenChanged(List<String> newList) {
    _save(
      newList,
      _spokenLanguages,
      (value) => _spokenLanguages = value,
      (value) => LanguagePreferences.setSpokenLanguages(value,
          serverName: widget.serverName),
    );
  }

  void _handleSubtitleChanged(List<String> newList) {
    _save(
      newList,
      _subtitleLanguages,
      (value) => _subtitleLanguages = value,
      (value) => LanguagePreferences.setSubtitleLanguages(value,
          serverName: widget.serverName),
    );
  }

  void _handleHideMatchingChanged(bool value) {
    _save(
      value,
      _hideSubtitlesMatchingAudio,
      (v) => _hideSubtitlesMatchingAudio = v,
      (v) => PlaybackPreferences.setHideSubtitlesMatchingAudio(v,
          serverName: widget.serverName),
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
            return SettingsErrorState(
              message: loc.couldNotLoad,
              detailsLabel: loc.errorDetails,
              details: loc.loadError(snapshot.error!),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              SettingsIntro(loc.languageAppliesToServer(widget.serverName)),
              SettingsSectionLabel(loc.preferredSpoken),
              SettingsHint(loc.languagePriorityHintSpoken),
              SettingsCard(children: [
                LanguagePreferenceList(
                  keyPrefix: 'spoken',
                  values: _spokenLanguages,
                  emptyHint: loc.noSpokenPreference,
                  onChanged: _handleSpokenChanged,
                ),
              ]),
              SettingsSectionLabel(loc.preferredSubtitle),
              SettingsHint(loc.languagePriorityHintSubtitle),
              SettingsCard(children: [
                LanguagePreferenceList(
                  keyPrefix: 'subtitle',
                  values: _subtitleLanguages,
                  emptyHint: loc.noSubtitlePreference,
                  onChanged: _handleSubtitleChanged,
                ),
              ]),
              const SizedBox(height: 16),
              SettingsCard(children: [
                SwitchListTile(
                  key: const ValueKey('hide-subtitles-matching-audio'),
                  secondary: const Icon(Icons.subtitles_off_outlined),
                  title: Text(loc.hideSubtitlesMatchingAudio),
                  subtitle: Text(loc.hideSubtitlesMatchingAudioDescription),
                  value: _hideSubtitlesMatchingAudio,
                  onChanged: _handleHideMatchingChanged,
                ),
              ]),
            ],
          );
        },
      ),
    );
  }
}
