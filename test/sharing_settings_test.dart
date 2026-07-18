import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/ServerSettingsSharingPage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/SharingSettingsService.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';

Map<String, dynamic> _sharing({
  String nowPlaying = 'EVERYONE',
  String control = 'PRIVATE',
  List<String> view = const [],
  List<String> ctrl = const [],
}) =>
    {
      '__typename': 'PlaybackSharingSettings',
      'nowPlayingScope': nowPlaying,
      'controlScope': control,
      'nowPlayingAllowedUserIds': view,
      'controlAllowedUserIds': ctrl,
    };

/// Routes on query text: the sharing settings query, the shareable-users query and the update
/// mutation (which echoes its input back as the stored settings).
MockClient _fakeGraphQL({List<Map<String, dynamic>>? mutations}) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      Map<String, dynamic> payload;
      if (query.contains('updatePlaybackSharingSettings')) {
        final input =
            (body['variables'] as Map<String, dynamic>)['input'] as Map<String, dynamic>;
        mutations?.add(input);
        payload = {
          'data': {
            '__typename': 'Mutation',
            'updatePlaybackSharingSettings': _sharing(
              nowPlaying: input['nowPlayingScope'] as String,
              control: input['controlScope'] as String,
              view: List<String>.from(input['nowPlayingAllowedUserIds'] as List),
              ctrl: List<String>.from(input['controlAllowedUserIds'] as List),
            ),
          }
        };
      } else if (query.contains('playbackSharingSettings')) {
        payload = {
          'data': {
            '__typename': 'Query',
            'playbackSharingSettings': _sharing(),
          }
        };
      } else if (query.contains('shareableUsers')) {
        payload = {
          'data': {
            '__typename': 'Query',
            'shareableUsers': [
              {'__typename': 'ShareableUser', 'id': 'user-2', 'name': 'Kees'},
              {'__typename': 'ShareableUser', 'id': 'user-3', 'name': 'Anna'},
            ],
          }
        };
      } else {
        payload = {
          'data': {'__typename': 'Query'}
        };
      }
      return http.Response(json.encode(payload), 200,
          headers: {'content-type': 'application/json'});
    });

Widget _app(Widget home) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: home,
    );

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    SharingSettingsService().invalidate(_server);
  });

  tearDown(() {
    ClientManager.testClientBuilder = null;
  });

  void useClient(http.Client client) {
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql', httpClient: client),
          cache: GraphQLCache(),
        );
  }

  testWidgets('renders the default scopes (everyone / only me)', (tester) async {
    useClient(_fakeGraphQL());
    await tester.pumpWidget(
        _app(const ServerSettingsSharingPage(serverName: _server)));
    await tester.pumpAndSettle();

    expect(find.text('Now playing'), findsOneWidget);
    expect(find.text('Remote control'), findsOneWidget);
    // now-playing default EVERYONE, control default PRIVATE
    expect(find.text('Everyone'), findsOneWidget);
    expect(find.text('Only me'), findsOneWidget);
    // No allowlist pickers while neither scope is "Specific people".
    expect(find.byType(CheckboxListTile), findsNothing);
  });

  testWidgets('switching now-playing to specific people saves and reveals the picker',
      (tester) async {
    final mutations = <Map<String, dynamic>>[];
    useClient(_fakeGraphQL(mutations: mutations));
    await tester.pumpWidget(
        _app(const ServerSettingsSharingPage(serverName: _server)));
    await tester.pumpAndSettle();

    // Open the now-playing dropdown and pick "Specific people".
    await tester.tap(find.byType(DropdownButton<Enum$SharingScope>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Specific people').last);
    await tester.pumpAndSettle();

    expect(mutations, isNotEmpty);
    expect(mutations.last['nowPlayingScope'], 'ALLOWLIST');

    // The allowlist picker now lists the other users.
    expect(find.text('Kees'), findsOneWidget);
    expect(find.text('Anna'), findsOneWidget);

    // Ticking a user saves the allowlist with that id.
    await tester.tap(find.text('Kees'));
    await tester.pumpAndSettle();
    expect(mutations.last['nowPlayingScope'], 'ALLOWLIST');
    expect(mutations.last['nowPlayingAllowedUserIds'], contains('user-2'));
  });

  testWidgets('shows an error when sharing settings cannot load', (tester) async {
    useClient(MockClient((_) async => http.Response('down', 500)));
    await tester.pumpWidget(
        _app(const ServerSettingsSharingPage(serverName: _server)));
    await tester.pumpAndSettle();

    expect(find.text('Could not load sharing settings.'), findsOneWidget);
  });
}
