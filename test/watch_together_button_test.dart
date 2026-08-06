import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/components/WatchTogetherButton.dart';
import 'package:player/graphql/fragmentMovie.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';

Widget _app(Widget home) => MaterialApp(
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
  TestWidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    handler.serverName = null;
    handler.playQueue = null;
    handler.movie = null;
    handler.episode = null;
  });

  tearDown(() {
    handler.serverName = null;
    handler.playQueue = null;
    handler.movie = null;
    handler.episode = null;
  });

  void installPlayingMovie() {
    handler.serverName = _server;
    handler.playQueue = Fragment$fragmentPlayQueue(
      id: 'pq-1',
      progressInMilliseconds: 0,
      shuffle: false,
      sourceExhausted: true,
      controlAllowedUserIds: const [],
    );
    handler.movie = Fragment$fragmentMovie(
        id: 'movie-1', name: 'The Movie', releaseYear: 2020);
  }

  testWidgets('renders nothing without a live video queue', (tester) async {
    await tester.pumpWidget(_app(const WatchTogetherButton()));
    expect(find.byIcon(Icons.connected_tv), findsNothing);
  });

  testWidgets('shows for the playing video and respects the page match',
      (tester) async {
    installPlayingMovie();

    await tester.pumpWidget(_app(const WatchTogetherButton()));
    expect(find.byIcon(Icons.connected_tv), findsOneWidget);

    // A page hosting a different movie hides it.
    await tester.pumpWidget(_app(WatchTogetherButton(
        matches: (handler) => handler.movie?.id == 'movie-other')));
    expect(find.byIcon(Icons.connected_tv), findsNothing);

    // The page hosting the playing movie shows it.
    await tester.pumpWidget(_app(WatchTogetherButton(
        matches: (handler) => handler.movie?.id == 'movie-1')));
    expect(find.byIcon(Icons.connected_tv), findsOneWidget);
  });
}
