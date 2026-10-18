import 'package:player/graphql/schema.graphql.dart';

import '../../l10n/app_localizations.dart';

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
}
