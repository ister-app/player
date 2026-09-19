import 'dart:io' show Platform;

import 'package:audio_service_mpris/audio_service_mpris.dart';
import 'package:audio_service_platform_interface/audio_service_platform_interface.dart';

/// Declares what the MPRIS object can do. audio_service itself only publishes
/// state and metadata; every capability flag (and the identity a desktop shell
/// shows) comes from here, and they all default to false — without this call
/// the media controls are inert and GNOME never lists the player.
void configureMpris() {
  if (!Platform.isLinux) return;
  AudioServiceMpris.init(
    dBusName: 'app.ister.player',
    identity: 'Ister Player',
    // Basename of the installed .desktop file, so the shell shows our name
    // and icon instead of a bare bus name.
    desktopEntry: 'app.ister.Player',
    canControl: true,
    canPlay: true,
    canPause: true,
    canGoNext: true,
    canGoPrevious: true,
  );
}

/// Drops the MPRIS bus name until something actually plays. GNOME lists every
/// player that claims `CanPlay`, regardless of its playback status, so without
/// this the media control sits in the shell from app start onwards with
/// nothing loaded. The plugin re-requests the name on the next state update.
Future<void> hideMprisUntilPlayback() async {
  if (!Platform.isLinux) return;
  await AudioServicePlatform.instance.stopService(const StopServiceRequest());
}
