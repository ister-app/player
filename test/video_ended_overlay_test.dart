import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/components/RelatedShowsRow.dart';
import 'package:player/components/video_controls/VideoEndedOverlay.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/graphql/fragmentEpisode.graphql.dart';
import 'package:player/graphql/fragmentMovie.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/PlatformService.dart';
import 'package:player/utils/QueueEnd.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// The end screen a video surface shows once its queue played out.
const _server = 'test-server';

Widget _app(Widget home) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(body: SizedBox(width: 800, height: 600, child: home)),
    );

Fragment$fragmentEpisode _episode() => Fragment$fragmentEpisode(
      id: 'ep-1',
      number: 1,
      $show: Fragment$fragmentEpisode$show(id: 'show-1'),
    );

Fragment$fragmentMovie _movie() =>
    Fragment$fragmentMovie(id: 'movie-1', name: 'The Movie', releaseYear: 2020);

QueueEndedInfo _ended({bool episode = true}) {
  final item = Fragment$fragmentPlayQueue$playQueueItems(
    accessible: true,
    id: 'item-1',
    position: 1,
    episode: episode ? _episode() : null,
    movie: episode ? null : _movie(),
  );
  return QueueEndedInfo(
    serverName: _server,
    client: ClientManager.getClientForUrl(_server).value,
    playQueue: Fragment$fragmentPlayQueue(
      id: 'pq-1',
      currentItemId: 'item-1',
      progressInMilliseconds: 0,
      shuffle: false,
      sourceType: episode
          ? Enum$PlayQueueSourceType.SHOW
          : Enum$PlayQueueSourceType.MOVIE,
      sourceExhausted: true,
      controlAllowedUserIds: const [],
      playQueueItems: [item],
    ),
    lastItem: item,
    lastMediaItem: MediaItem(
      id: MediaItemId(
              _server,
              episode ? IsterMediaTypes.episode : IsterMediaTypes.movie,
              'item-1')
          .toString(),
      title: episode ? 'Pilot' : 'The Movie',
    ),
    episode: episode ? _episode() : null,
    movie: episode ? null : _movie(),
  );
}

/// Answers the related-shows query with one show.
MockClient _fakeGraphQL(List<String> operations) => MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      Map<String, dynamic> payload;
      if (query.contains('relatedShows')) {
        operations.add('relatedShows');
        payload = {
          'data': {
            '__typename': 'Query',
            'showById': {
              '__typename': 'Show',
              'id': 'show-1',
              'related': [
                {
                  '__typename': 'Show',
                  'id': 'show-2',
                  'name': 'Other Show',
                  'releaseYear': 2001,
                  'images': <Object>[],
                  'metadata': null,
                }
              ],
            }
          }
        };
      } else {
        operations.add('other');
        payload = {
          'data': {'__typename': 'Query'}
        };
      }
      return http.Response(json.encode(payload), 200,
          headers: {'content-type': 'application/json'});
    });

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('com.alexmercerind/media_kit_video'),
          (call) async => null);
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;
  late List<String> operations;

  setUp(() async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    operations = [];
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql',
              httpClient: _fakeGraphQL(operations)),
          cache: GraphQLCache(),
        );
    handler.queueEnded.value = null;
  });

  tearDown(() async {
    handler.queueEnded.value = null;
    await PlatformService.setTvModeOverride(null);
    ClientManager.testClientBuilder = null;
  });

  testWidgets('an ended episode offers watch again, back and related shows',
      (tester) async {
    handler.queueEnded.value = _ended();
    await tester.pumpWidget(_app(const VideoEndedOverlay()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byKey(VideoEndedOverlay.overlayKey), findsOneWidget);
    expect(find.byKey(VideoEndedOverlay.watchAgainKey), findsOneWidget);
    expect(find.byKey(VideoEndedOverlay.backKey), findsOneWidget);
    expect(find.byKey(VideoEndedOverlay.suggestionsKey), findsOneWidget);
    expect(operations, contains('relatedShows'),
        reason: 'no GraphQLProvider above the overlay: the row brings the '
            'server client itself');
    expect(find.text('Other Show'), findsOneWidget);
  });

  testWidgets('back leaves the ended state as an own stop', (tester) async {
    handler.queueEnded.value = _ended(episode: false);
    final closeRequestsBefore = handler.closePlaybackRequest.value;
    await tester.pumpWidget(_app(const VideoEndedOverlay()));
    await tester.pump();

    await tester.tap(find.byKey(VideoEndedOverlay.backKey));
    await tester.pump();

    expect(handler.queueEnded.value, isNull);
    expect(handler.closePlaybackRequest.value, closeRequestsBefore + 1);
    expect(handler.lastPlaybackCloseKeepsPage, isTrue);
    expect(find.byKey(VideoEndedOverlay.overlayKey), findsNothing);
  });

  testWidgets('a movie gets no suggestions', (tester) async {
    handler.queueEnded.value = _ended(episode: false);
    await tester.pumpWidget(_app(const VideoEndedOverlay()));
    await tester.pump();

    expect(find.byKey(VideoEndedOverlay.watchAgainKey), findsOneWidget);
    expect(find.byKey(VideoEndedOverlay.suggestionsKey), findsNothing);
    expect(operations, isNot(contains('relatedShows')));
  });

  testWidgets('without actions only the title shows (embedded on TV)',
      (tester) async {
    handler.queueEnded.value = _ended();
    await tester
        .pumpWidget(_app(const VideoEndedOverlay(showActions: false)));
    await tester.pump();

    expect(find.byKey(VideoEndedOverlay.overlayKey), findsOneWidget);
    expect(find.text('Pilot'), findsOneWidget);
    expect(find.byKey(VideoEndedOverlay.watchAgainKey), findsNothing);
    expect(find.byKey(VideoEndedOverlay.suggestionsKey), findsNothing);
  });

  testWidgets('on TV watch again takes focus', (tester) async {
    await PlatformService.setTvModeOverride(true);
    handler.queueEnded.value = _ended(episode: false);
    await tester.pumpWidget(_app(const VideoEndedOverlay()));
    await tester.pump();

    final focus =
        Focus.of(tester.element(find.byKey(VideoEndedOverlay.watchAgainKey)));
    expect(focus.hasFocus, isTrue);
  });

  testWidgets('nothing renders for an ended audio queue or no end',
      (tester) async {
    await tester.pumpWidget(_app(const VideoEndedOverlay()));
    await tester.pump();
    expect(find.byKey(VideoEndedOverlay.overlayKey), findsNothing);
  });

  testWidgets('the related row hands a tapped show to onShowTap',
      (tester) async {
    final tapped = <String>[];
    await tester.pumpWidget(_app(RelatedShowsRow(
      serverName: _server,
      showId: 'show-1',
      header: 'Custom header',
      onShowTap: tapped.add,
    )));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Custom header'), findsOneWidget);
    await tester.tap(find.text('Other Show'));
    await tester.pump();
    expect(tapped, ['show-2']);
  });
}
