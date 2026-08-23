import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/pages/DownloadSettingsPage.dart';
import 'package:player/pages/DownloadsPage.dart';
import 'package:player/pages/LocalVideoPage.dart';

/// The downloads pages inside the server shell (mini player, navigation
/// bar), reached from the settings tab. The same pages also live on the root
/// router (`/downloads/:serverName`) for when the server is unreachable and
/// the shell cannot render.
@RoutePage()
class ServerDownloadsPage extends StatelessWidget {
  const ServerDownloadsPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  final String serverName;

  @override
  Widget build(BuildContext context) =>
      DownloadsPage(serverName: serverName, inShell: true);
}

@RoutePage()
class ServerDownloadSettingsPage extends StatelessWidget {
  const ServerDownloadSettingsPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  final String serverName;

  @override
  Widget build(BuildContext context) =>
      DownloadSettingsPage(serverName: serverName, inShell: true);
}

@RoutePage()
class ServerLocalVideoPage extends StatelessWidget {
  const ServerLocalVideoPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  final String serverName;

  @override
  Widget build(BuildContext context) => LocalVideoPage(serverName: serverName);
}
