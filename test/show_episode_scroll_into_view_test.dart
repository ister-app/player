import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/graphql/fragmentEpisode.graphql.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/ShowEpisodePage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:visibility_detector/visibility_detector.dart';

const _server = 'test-server';

Fragment$fragmentEpisode _episode(String id) => Fragment$fragmentEpisode(
      id: id,
      number: 1,
      $show: Fragment$fragmentEpisode$show(id: 'show-1'),
      mediaFile: [
        Fragment$fragmentMediaFiles(
          id: 'mf-$id',
          path: '/media/$id.mkv',
          size: 1,
          durationInMilliseconds: 2400000,
          directory: Fragment$fragmentMediaFiles$directory(
            node: Fragment$fragmentMediaFiles$directory$node(
                url: 'http://node.example'),
          ),
        ),
      ],
    );

http.Response _json(Map<String, dynamic> data) => http.Response(
    json.encode({'data': data}), 200,
    headers: {'content-type': 'application/json'});

/// The show overview keeps the episode page (with the video surface) at the
/// top of one long scroll view, with the season list below it. Picking an
/// episode far down that list must scroll the player back into view.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  MockClient fakeGraphQL() => MockClient((request) async {
        final body = json.decode(request.body) as Map<String, dynamic>;
        final query = body['query'] as String? ?? '';
        if (query.trimLeft().startsWith('subscription')) {
          return http.Response(
              json.encode({
                'errors': [
                  {'message': 'no subscriptions in test'}
                ]
              }),
              200,
              headers: {'content-type': 'application/json'});
        }
        if (query.contains('episodeById')) {
          final id = (body['variables'] as Map<String, dynamic>)['id'] as String;
          return _json({
            '__typename': 'Query',
            'episodeById': _episode(id).toJson(),
          });
        }
        return _json({'__typename': 'Query'});
      });

  GraphQLClient client() => GraphQLClient(
        link: HttpLink('https://api.example/graphql', httpClient: fakeGraphQL()),
        cache: GraphQLCache(),
      );

  Widget overview(ScrollController controller, String episodeId) =>
      GraphQLProvider(
        client: ValueNotifier(client()),
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: Scaffold(
            body: SingleChildScrollView(
              controller: controller,
              child: Column(children: [
                ShowEpisodePage(
                  serverName: _server,
                  showId: 'show-1',
                  episodeId: episodeId,
                ),
                // Stands in for the season list below the episode page.
                const SizedBox(height: 2000),
              ]),
            ),
          ),
        ),
      );

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  setUp(() async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    ClientManager.testClientBuilder = (_) => client();
    await MediaPlayerHandler.instance
        .endPlaybackLocally(flushProgress: false);
  });

  testWidgets('picking another episode scrolls the player back into view',
      (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(overview(controller, 'ep-1'));
    await settle(tester);

    // Reading the season list far below the player.
    controller.jumpTo(800);
    await tester.pump();
    expect(controller.offset, 800);

    // Tapping an episode there updates the page in place with the new id.
    await tester.pumpWidget(overview(controller, 'ep-2'));
    await settle(tester);

    expect(controller.offset, lessThan(1),
        reason: 'the overview must scroll up to the video surface');
  });
}
