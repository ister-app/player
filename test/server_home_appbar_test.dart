import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/ServerHomeContentPage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// The home tab's app bar: refresh is a direct button (no more overflow
/// menu), and the title is the server switcher — tapping the server name
/// lists the configured servers plus the way back to the server overview.
const _server = 'test-server';

MockClient _fakeGraphQL() => MockClient((request) async => http.Response(
      json.encode({
        'data': {'__typename': 'Query'}
      }),
      200,
      headers: {'content-type': 'application/json'},
    ));

Widget _wrap(Widget child, http.Client client) => GraphQLProvider(
      client: ValueNotifier(GraphQLClient(
        link: HttpLink('https://api.example/graphql', httpClient: client),
        cache: GraphQLCache(),
      )),
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: child,
      ),
    );

Future<void> _pump(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
}

void main() {
  setUp(() async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    await SharedPreferencesAsync()
        .setStringList('servers', [_server, 'other-server']);
    WellKnownService.cacheForTest(
        _server,
        const WellKnownInfo(
            name: 'Test Server', oidcUrl: 'o', serverUrl: 's'));
    WellKnownService.cacheForTest(
        'other-server',
        const WellKnownInfo(
            name: 'Other Server', oidcUrl: 'o', serverUrl: 's'));
  });

  testWidgets('refresh is a direct button and the overflow menu is gone',
      (tester) async {
    await tester.pumpWidget(
        _wrap(const ServerHomeContentPage(serverName: _server), _fakeGraphQL()));
    await _pump(tester);

    expect(find.byIcon(Icons.refresh), findsOneWidget);
    expect(find.byIcon(Icons.more_vert), findsNothing);
  });

  testWidgets('the title switcher lists servers and the overview entry',
      (tester) async {
    await tester.pumpWidget(
        _wrap(const ServerHomeContentPage(serverName: _server), _fakeGraphQL()));
    await _pump(tester);

    // The title shows the friendly name, not the raw identifier.
    expect(find.text('Test Server'), findsOneWidget);
    expect(find.text(_server), findsNothing);

    await tester.tap(find.text('Test Server'));
    await tester.pumpAndSettle();

    expect(find.text('Other Server'), findsOneWidget);
    expect(find.text('Back to server overview'), findsOneWidget);
    // The current server is marked, not tappable into a self-switch.
    expect(find.byIcon(Icons.check), findsOneWidget);
  });
}
