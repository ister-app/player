import 'package:flutter/material.dart';
import 'package:player/graphql/schema.graphql.dart';

import '../l10n/app_localizations.dart';
import '../utils/DevicePreferences.dart';
import '../utils/DeviceService.dart';

/// Icon for a registered device's platform, shared by the picker and the
/// devices settings page.
IconData devicePlatformIcon(Enum$DevicePlatform platform) {
  switch (platform) {
    case Enum$DevicePlatform.ANDROID:
    case Enum$DevicePlatform.IOS:
      return Icons.smartphone;
    case Enum$DevicePlatform.ANDROID_TV:
      return Icons.tv;
    case Enum$DevicePlatform.WEB:
      return Icons.language;
    case Enum$DevicePlatform.LINUX:
    case Enum$DevicePlatform.MACOS:
    case Enum$DevicePlatform.WINDOWS:
      return Icons.computer;
    case Enum$DevicePlatform.OTHER:
    case Enum$DevicePlatform.$unknown:
      return Icons.devices_other;
  }
}

/// "Play on device…": picks one of the user's other online devices and starts
/// [mediaId] there. [mediaId] is the *source* (movie/show/album/podcast/book id
/// matching [mediaType]'s item kind) and [startId] the item to start at — the
/// same pair the createPlayQueue mutation takes on the receiving device.
Future<void> playOnDevice(
  BuildContext context, {
  required String serverName,
  required Enum$MediaType mediaType,
  required String mediaId,
  String? startId,
}) async {
  final loc = AppLocalizations.of(context)!;
  final device = await showDevicePickerSheet(context,
      serverName: serverName, title: loc.devicePlayOn);
  if (device == null || !context.mounted) return;
  final accepted = await DeviceService.instance.sendCommand(
    serverName,
    deviceId: device.deviceId,
    command: Enum$DeviceCommandType.PLAY_MEDIA,
    mediaType: mediaType,
    mediaId: mediaId,
    startId: startId,
  );
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(accepted
          ? loc.deviceCommandSent(device.name)
          : loc.deviceCommandFailed)));
}

/// Bottom sheet that picks one of the user's OTHER online devices as a command
/// target (play on / hand off to / listen along on). This device itself and
/// offline devices are not offered — the server refuses offline targets anyway.
/// Resolves to the chosen device, or null when dismissed.
Future<DeviceInfo?> showDevicePickerSheet(
  BuildContext context, {
  required String serverName,
  required String title,
}) {
  return showModalBottomSheet<DeviceInfo>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => _DevicePickerSheet(
      serverName: serverName,
      title: title,
    ),
  );
}

class _DevicePickerSheet extends StatefulWidget {
  const _DevicePickerSheet({required this.serverName, required this.title});

  final String serverName;
  final String title;

  @override
  State<_DevicePickerSheet> createState() => _DevicePickerSheetState();
}

class _DevicePickerSheetState extends State<_DevicePickerSheet> {
  List<DeviceInfo>? _devices;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final ownId = await DevicePreferences.getDeviceId();
      final devices = await DeviceService.instance.myDevices(widget.serverName);
      if (!mounted) return;
      setState(() => _devices = devices
          .where((d) => d.online && d.deviceId != ownId)
          .toList());
    } catch (_) {
      if (!mounted) return;
      setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final devices = _devices;

    Widget body;
    if (_failed) {
      body = Padding(
        padding: const EdgeInsets.all(24),
        child: Center(child: Text(loc.deviceCouldNotLoad)),
      );
    } else if (devices == null) {
      body = const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (devices.isEmpty) {
      body = Padding(
        padding: const EdgeInsets.all(24),
        child: Center(child: Text(loc.devicePickerNoDevicesOnline)),
      );
    } else {
      body = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Text(widget.title,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          for (final device in devices)
            ListTile(
              leading: Icon(devicePlatformIcon(device.platform)),
              title: Text(device.name,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => Navigator.of(context).pop(device),
            ),
        ],
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: body,
      ),
    );
  }
}
