import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/components/video_controls/ArtworkMenuButton.dart';
import 'package:player/graphql/fragmentMovie.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/AppMessenger.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/PermissionsService.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // No video output plugin in a widget test: answer the texture-create call with
  // null so the handler's VideoController setup idles instead of raising an
  // asynchronous MissingPluginException that keeps the suite from completing.
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('com.alexmercerind/media_kit_video'),
          (call) async => null);
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;

  http.Response jsonResponse(Map<String, dynamic> data) => http.Response(
    json.encode({'data': data}),
    200,
    headers: {'content-type': 'application/json'},
  );

  GraphQLClient meClient(bool isAdmin) => GraphQLClient(
    link: HttpLink(
      'https://api.example/graphql',
      httpClient: MockClient(
        (_) async => jsonResponse({
          '__typename': 'Query',
          'me': {
            '__typename': 'Me',
            'id': 'u',
            'name': 'G',
            'email': 'g@x',
            'isAdmin': isAdmin,
          },
        }),
      ),
    ),
    cache: GraphQLCache(),
  );

  Widget harness() => MaterialApp(
    scaffoldMessengerKey: rootScaffoldMessengerKey,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: const [Locale('en')],
    home: const Scaffold(body: Center(child: ArtworkMenuButton())),
  );

  setUp(() async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    PermissionsService().invalidate(_server);
    handler.serverName = _server;
    handler.movie = Fragment$fragmentMovie(
      id: 'movie-1',
      name: 'M',
      releaseYear: 2020,
    );
    handler.episode = null;
    handler.currentMediaFileId.value = 'mf-1';
  });

  tearDown(() {
    handler.movie = null;
    handler.currentMediaFileId.value = null;
  });

  testWidgets('hidden unless the login is a known admin', (tester) async {
    ClientManager.testClientBuilder = (_) => meClient(false);
    await PermissionsService().adminStatusFor(_server);
    await tester.pumpWidget(harness());
    expect(find.byKey(ArtworkMenuButton.buttonKey), findsNothing);

    PermissionsService().invalidate(_server);
    ClientManager.clients.clear();
    ClientManager.testClientBuilder = (_) => meClient(true);
    await PermissionsService().adminStatusFor(_server);
    // A fresh tree: the const button above would otherwise not rebuild.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(harness());
    expect(find.byKey(ArtworkMenuButton.buttonKey), findsOneWidget);
  });

  testWidgets('the sheet sends the current file position as a frame grab', (
    tester,
  ) async {
    ClientManager.testClientBuilder = (_) => meClient(true);
    await PermissionsService().adminStatusFor(_server);
    MutationOptions? sent;
    await tester.pumpWidget(
      MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: const [Locale('en')],
        home: Scaffold(
          body: Center(
            child: ArtworkMenuButton(
              mutate: (server, options) async {
                expect(server, _server);
                sent = options;
                return QueryResult(
                  options: options,
                  source: QueryResultSource.network,
                  data: {
                    'selectVideoFrame': {
                      '__typename': 'Image',
                      'id': 'img-f',
                      'type': 'BACKGROUND',
                      'selected': true,
                      'directory': {
                        '__typename': 'Directory',
                        'servingNode': {
                          '__typename': 'Node',
                          'url': 'http://n',
                        },
                      },
                    },
                  },
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(ArtworkMenuButton.buttonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ArtworkMenuButton.backgroundItemKey));
    await tester.pumpAndSettle();

    expect(sent, isNotNull);
    final vars = sent!.variables;
    expect(vars['target'], {'movieId': 'movie-1'});
    expect(vars['type'], Enum$ImageType.BACKGROUND.name);
    expect(vars['mediaFileId'], 'mf-1');
    // an idle player sits at 0; the point is that the file position is sent as is
    expect(vars['positionMs'], handler.player.state.position.inMilliseconds);
    expect(find.text('Artwork updated'), findsOneWidget);
  });
}
