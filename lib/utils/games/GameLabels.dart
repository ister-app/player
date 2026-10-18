import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/download/DownloadHttp.dart';

import '../../l10n/app_localizations.dart';
import 'GameApi.dart';

/// Display names for the game enums. Platform names are product names and the
/// same in every language; the forms are described through the localizations.
class GameLabels {
  GameLabels._();

  static String platform(Enum$GamePlatform platform) {
    switch (platform) {
      case Enum$GamePlatform.NES:
        return 'NES';
      case Enum$GamePlatform.SNES:
        return 'SNES';
      case Enum$GamePlatform.N64:
        return 'Nintendo 64';
      case Enum$GamePlatform.GB:
        return 'Game Boy';
      case Enum$GamePlatform.GBC:
        return 'Game Boy Color';
      case Enum$GamePlatform.GBA:
        return 'Game Boy Advance';
      case Enum$GamePlatform.NDS:
        return 'Nintendo DS';
      case Enum$GamePlatform.PSX:
        return 'PlayStation';
      case Enum$GamePlatform.PS2:
        return 'PlayStation 2';
      case Enum$GamePlatform.PS3:
        return 'PlayStation 3';
      case Enum$GamePlatform.GC:
        return 'GameCube';
      case Enum$GamePlatform.WII:
        return 'Wii';
      case Enum$GamePlatform.PC:
        return 'Windows';
      case Enum$GamePlatform.LINUX:
        return 'Linux';
      case Enum$GamePlatform.STEAM:
        return 'Steam';
      case Enum$GamePlatform.$unknown:
        return '?';
    }
  }

  /// [platform] by its enum name as the install store keeps it.
  static String platformName(String name) =>
      platform(Enum$GamePlatform.values.firstWhere((p) => p.name == name, orElse: () => Enum$GamePlatform.$unknown));

  static String form(AppLocalizations loc, Enum$GameForm form) {
    switch (form) {
      case Enum$GameForm.ROM:
        return loc.gameFormRom;
      case Enum$GameForm.PS3_FOLDER:
        return loc.gameFormPs3Folder;
      case Enum$GameForm.PC_PORTABLE_ZIP:
        return loc.gameFormPcZip;
      case Enum$GameForm.PC_LINUX_INSTALLER:
        return loc.gameFormLinuxInstaller;
      case Enum$GameForm.PC_LINUX_PORTABLE:
        return loc.gameFormLinuxPortable;
      case Enum$GameForm.STEAM:
        return loc.gameFormSteam;
      case Enum$GameForm.$unknown:
        return '?';
    }
  }

  /// [form] by its enum name as the upload preview and the install store carry it.
  static String formName(AppLocalizations loc, String name) =>
      form(loc, Enum$GameForm.values.firstWhere((f) => f.name == name, orElse: () => Enum$GameForm.$unknown));

  /// "1.2 GB" style size for the game page and install dialogs.
  static String bytes(num bytes) {
    const units = ['B', 'kB', 'MB', 'GB', 'TB'];
    var value = bytes.toDouble();
    var unit = 0;
    while (value >= 1000 && unit < units.length - 1) {
      value /= 1000;
      unit++;
    }
    final digits = value >= 100 || unit == 0 ? 0 : 1;
    return '${value.toStringAsFixed(digits)} ${units[unit]}';
  }

  /// "2 h 15 min" / "12 min" / "< 1 min" for accumulated play time.
  static String playTime(AppLocalizations loc, num milliseconds) {
    final minutes = (milliseconds / 60000).round();
    if (minutes < 1) return loc.gamePlayTimeUnderMinute;
    if (minutes < 60) return loc.gamePlayTimeMinutes(minutes);
    return loc.gamePlayTimeHours(minutes ~/ 60, minutes % 60);
  }

  /// "2 h 15 min" / "12 min" / "40 s" for estimates and elapsed times.
  static String duration(AppLocalizations loc, Duration d) {
    if (d.inHours >= 1) return loc.durationHoursMinutes(d.inHours, d.inMinutes % 60);
    if (d.inMinutes >= 1) return loc.durationMinutes(d.inMinutes);
    return loc.durationSeconds(d.inSeconds);
  }

  /// "2026-10-18 14:05" in local time, for save versions and sessions.
  static String dateTime(DateTime? at) {
    if (at == null) return '';
    final date = at.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)} ${two(date.hour)}:${two(date.minute)}';
  }

  /// A user-facing line for an install error: the short keys the service
  /// records (`no-space`, `unreachable`, `gone`) and the exceptions that
  /// surface directly get their own wording; anything else is shown as is.
  static String installError(AppLocalizations loc, Object error) {
    final key = switch (error) {
      DownloadFailure(noSpace: true) => 'no-space',
      DownloadFailure(transient: true) => 'unreachable',
      GameApiException(statusCode: 404) => 'gone',
      GameApiException(isTransient: true) => 'unreachable',
      _ => error.toString(),
    };
    return switch (key) {
      'no-space' => loc.gameErrorNoSpace,
      'unreachable' => loc.gameErrorUnreachable,
      'gone' => loc.gameErrorGone,
      _ => loc.gameInstallFailed(key),
    };
  }
}
