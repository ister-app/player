import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// The system can destroy `AudioService` while the Flutter engine survives.
/// The recreated service starts with an empty media session, and audio_service
/// pushes `mediaItem`/`queue` only when they *change* — so without an explicit
/// re-publish the notification keeps working buttons but loses its title,
/// artwork and progress bar. These tests pin the Dart half of that recovery.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // No video output plugin in a widget test: answer the texture-create call
  // with null so the handler's VideoController setup idles. The
  // MissingPluginException it throws otherwise arrives asynchronously, so it
  // lands on whichever test happens to be running and reports that one as
  // "did not complete" — a flake that moves around and never names its cause.
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('com.alexmercerind/media_kit_video'),
          (call) async => null);
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;

  MediaItem item(String id) =>
      MediaItem(id: 'srv;track;$id', title: 'Track $id');

  GraphQLClient client() => GraphQLClient(
        link: HttpLink('https://api.example/graphql',
            httpClient: MockClient((_) async => http.Response(
                json.encode({
                  'data': {'__typename': 'Query'}
                }),
                200,
                headers: {'content-type': 'application/json'}))),
        cache: GraphQLCache(),
      );

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    ClientManager.testClientBuilder = (_) => client();
  });

  tearDown(() {
    handler.playQueue = null;
    handler.queue.add(const []);
    handler.mediaItem.add(null);
  });

  test('republishSession re-emits the current item and the queue', () async {
    final items = [item('1'), item('2')];
    handler.queue.add(items);
    handler.mediaItem.add(items.first);

    final republishedItems = <MediaItem?>[];
    final republishedQueues = <List<MediaItem>>[];
    final subs = [
      handler.mediaItem.skip(1).listen(republishedItems.add),
      handler.queue.skip(1).listen(republishedQueues.add),
    ];
    addTearDown(() {
      for (final sub in subs) {
        sub.cancel();
      }
    });

    handler.republishSession();
    await Future<void>.delayed(Duration.zero);

    expect(republishedItems, [items.first]);
    expect(republishedQueues, hasLength(1));
    expect(republishedQueues.single, items);
  });

  test('republishSession emits a fresh queue list, not the same instance',
      () async {
    final items = [item('1')];
    handler.queue.add(items);
    handler.mediaItem.add(items.first);

    handler.republishSession();

    // audio_service publishes per emission, so an identical instance would
    // still reach the platform — but reusing the list makes it far too easy
    // for a caller to mutate what was already handed out.
    expect(identical(handler.queue.value, items), isFalse);
    expect(handler.queue.value, items);
  });

  test('republishSession is a no-op with nothing loaded', () async {
    handler.queue.add(const []);
    handler.mediaItem.add(null);

    final emissions = <MediaItem?>[];
    final sub = handler.mediaItem.skip(1).listen(emissions.add);
    addTearDown(sub.cancel);

    handler.republishSession();
    await Future<void>.delayed(Duration.zero);

    expect(emissions, isEmpty);
  });

  test('play() re-publishes the session', () async {
    final items = [item('1')];
    handler.queue.add(items);
    handler.mediaItem.add(items.first);

    final republishedItems = <MediaItem?>[];
    final sub = handler.mediaItem.skip(1).listen(republishedItems.add);
    addTearDown(sub.cancel);

    await handler.play();
    await Future<void>.delayed(Duration.zero);

    expect(republishedItems, [items.first]);
  });
}
