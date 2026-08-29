import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/TvModeTile.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/PlatformService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

Widget _wrap(Widget home) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(body: home),
    );

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    PlatformService.resetForTesting();
  });

  tearDown(PlatformService.resetForTesting);

  group('PlatformService TV mode', () {
    test('override wins over auto-detection and round-trips storage',
        () async {
      await PlatformService.ensureInitialized();
      final autoDetected = PlatformService.isTvModeSync;

      await PlatformService.setTvModeOverride(true);
      expect(PlatformService.isTvModeSync, isTrue);
      expect(await PlatformService.getTvModeOverride(), isTrue);

      // A fresh process (cache dropped) reads the persisted override back.
      PlatformService.resetForTesting();
      expect(await PlatformService.getTvModeOverride(), isTrue);
      expect(PlatformService.isTvModeSync, isTrue);

      await PlatformService.setTvModeOverride(null);
      expect(PlatformService.isTvModeSync, autoDetected);
      expect(
        await SharedPreferencesAsync().getBool('tv_mode_override'),
        isNull,
      );
    });
  });

  group('TvModeTile', () {
    testWidgets('flipping the switch stores the override and notes restart',
        (tester) async {
      await PlatformService.ensureInitialized();
      await tester.pumpWidget(_wrap(const TvModeTile()));

      final tile = find.byKey(const ValueKey('settings-tile-tv-mode'));
      expect(tile, findsOneWidget);
      expect(tester.widget<SwitchListTile>(tile).value, isFalse);

      await tester.tap(tile);
      await tester.pump();

      expect(tester.widget<SwitchListTile>(tile).value, isTrue);
      expect(await PlatformService.getTvModeOverride(), isTrue);
      expect(PlatformService.isTvModeSync, isTrue);
      // Restart note appears as a snackbar.
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
