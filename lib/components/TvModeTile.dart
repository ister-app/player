import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/PlatformService.dart';

/// Settings switch for controller-driven TV mode on desktop: focus
/// highlights, directional navigation and TV video controls, aimed at HTPCs
/// and SteamOS devices. Auto-detection (gamescope session) fills the initial
/// value; flipping the switch stores an explicit override. The native window
/// chrome and the app-wide navigation mode are set up at startup, so a change
/// only fully applies after a restart.
class TvModeTile extends StatefulWidget {
  const TvModeTile({super.key});

  @override
  State<TvModeTile> createState() => _TvModeTileState();
}

class _TvModeTileState extends State<TvModeTile> {
  bool _value = PlatformService.isTvModeSync;

  Future<void> _toggle(bool value) async {
    setState(() => _value = value);
    await PlatformService.setTvModeOverride(value);
    if (!mounted) return;
    final loc = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.tvModeRestartNote)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SwitchListTile(
      key: const ValueKey('settings-tile-tv-mode'),
      secondary: const Icon(Icons.tv),
      title: Text(loc.tvModeTitle),
      subtitle: Text(loc.tvModeSubtitle),
      value: _value,
      onChanged: _toggle,
    );
  }
}
