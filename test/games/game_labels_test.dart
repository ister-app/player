import 'package:flutter_test/flutter_test.dart';
import 'package:player/l10n/app_localizations_en.dart';
import 'package:player/utils/download/DownloadHttp.dart';
import 'package:player/utils/games/GameApi.dart';
import 'package:player/utils/games/GameLabels.dart';

void main() {
  final loc = AppLocalizationsEn();

  group('GameLabels.bytes', () {
    test('picks the unit and one decimal below 100', () {
      expect(GameLabels.bytes(0), '0 B');
      expect(GameLabels.bytes(999), '999 B');
      expect(GameLabels.bytes(1000), '1.0 kB');
      expect(GameLabels.bytes(1234567), '1.2 MB');
      expect(GameLabels.bytes(123456789), '123 MB');
      expect(GameLabels.bytes(48.3e9), '48.3 GB');
    });

    test('rounding never prints 1000 of a unit', () {
      expect(GameLabels.bytes(999960), '1.0 MB');
      expect(GameLabels.bytes(999999999), '1.0 GB');
      expect(GameLabels.bytes(99960), '100 kB');
    });

    test('stays in the largest unit', () {
      expect(GameLabels.bytes(5e15), '5000 TB');
    });
  });

  test('platformName falls back to a question mark for unknown names', () {
    expect(GameLabels.platformName('PS3'), 'PlayStation 3');
    expect(GameLabels.platformName('DREAMCAST'), '?');
  });

  test('formName falls back to a question mark for unknown names', () {
    expect(GameLabels.formName(loc, 'ROM'), loc.gameFormRom);
    expect(GameLabels.formName(loc, 'CARTRIDGE'), '?');
  });

  test('playTime rounds to minutes and splits hours', () {
    expect(GameLabels.playTime(loc, 20000), loc.gamePlayTimeUnderMinute);
    expect(GameLabels.playTime(loc, 12 * 60000), loc.gamePlayTimeMinutes(12));
    expect(GameLabels.playTime(loc, 135 * 60000), loc.gamePlayTimeHours(2, 15));
  });

  test('duration picks the largest fitting unit', () {
    expect(GameLabels.duration(loc, const Duration(seconds: 40)),
        loc.durationSeconds(40));
    expect(GameLabels.duration(loc, const Duration(minutes: 12, seconds: 59)),
        loc.durationMinutes(12));
    expect(GameLabels.duration(loc, const Duration(hours: 2, minutes: 15)),
        loc.durationHoursMinutes(2, 15));
  });

  test('dateTime pads and tolerates null', () {
    expect(GameLabels.dateTime(null), '');
    expect(GameLabels.dateTime(DateTime(2026, 3, 4, 5, 6)), '2026-03-04 05:06');
  });

  test('installError words the recorded keys', () {
    expect(GameLabels.installError(loc, 'no-space'), loc.gameErrorNoSpace);
    expect(GameLabels.installError(loc, 'unreachable'), loc.gameErrorUnreachable);
    expect(GameLabels.installError(loc, 'gone'), loc.gameErrorGone);
    expect(GameLabels.installError(loc, 'boom'), loc.gameInstallFailed('boom'));
  });

  test('installError words the exceptions that surface directly', () {
    expect(GameLabels.installError(loc, DownloadFailure('full', noSpace: true)),
        loc.gameErrorNoSpace);
    expect(GameLabels.installError(loc, DownloadFailure('reset', transient: true)),
        loc.gameErrorUnreachable);
    expect(GameLabels.installError(loc, GameApiException(404, 'gone')),
        loc.gameErrorGone);
    expect(GameLabels.installError(loc, GameApiException(503, 'busy')),
        loc.gameErrorUnreachable);
    expect(GameLabels.installError(loc, DownloadFailure('odd')),
        loc.gameInstallFailed('odd'));
  });
}
