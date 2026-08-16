import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/ServerSettingsDevicesPage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/DevicePreferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';

Map<String, dynamic> _device(
  String id, {
  String name = 'Laptop',
  String platform = 'LINUX',
  bool online = true,
  String lastSeenAt = '2026-08-04T10:00:00Z',
}) =>
    {
      '__typename': 'Device',
      'deviceId': id,
      'name': name,
      'platform': platform,
      'online': online,
      'lastSeenAt': lastSeenAt,
      'createdAt': '2026-08-01T10:00:00Z',
    };

/// Routes on query text: myDevices, the activity snapshot (empty), rename and remove.
MockClient _fakeGraphQL(List<Map<String, dynamic>> devices,
        {List<Map<String, dynamic>>? mutations}) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      final variables = body['variables'] as Map<String, dynamic>? ?? const {};
      Map<String, dynamic> payload;
      if (query.contains('renameDevice')) {
        mutations?.add({'renameDevice': variables});
        final renamed = devices
            .firstWhere((d) => d['deviceId'] == variables['deviceId'])
          ..['name'] = variables['name'];
        payload = {
          'data': {'__typename': 'Mutation', 'renameDevice': renamed}
        };
      } else if (query.contains('removeDevice')) {
        mutations?.add({'removeDevice': variables});
        devices.removeWhere((d) => d['deviceId'] == variables['deviceId']);
        payload = {
          'data': {'__typename': 'Mutation', 'removeDevice': true}
        };
      } else if (query.contains('myDevices')) {
        payload = {
          'data': {'__typename': 'Query', 'myDevices': devices}
        };
      } else if (query.contains('serverActivitySnapshot')) {
        payload = {
          'data': {
            '__typename': 'Query',
            'serverActivitySnapshot': {
              '__typename': 'ServerActivitySnapshot',
              'nodes': [],
              'queueStats': [],
              'recentFailures': [],
              'transcodes': [],
              'nowPlaying': [],
            },
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

  /// Unmounts the page so its periodic refresh timer is disposed.
  Future<void> unmount(WidgetTester tester) =>
      tester.pumpWidget(const SizedBox());

  testWidgets('lists devices with online dot, this-device chip and last seen',
      (tester) async {
    final ownId = await DevicePreferences.getDeviceId();
    useClient(_fakeGraphQL([
      _device(ownId, name: 'Mijn laptop', online: true),
      _device('other-device',
          name: 'Woonkamer',
          platform: 'ANDROID_TV',
          online: false,
          lastSeenAt:
              DateTime.now().toUtc().subtract(const Duration(hours: 3)).toIso8601String()),
    ]));
    await tester
        .pumpWidget(_app(const ServerSettingsDevicesPage(serverName: _server)));
    await tester.pumpAndSettle();

    expect(find.text('Mijn laptop'), findsOneWidget);
    expect(find.text('Woonkamer'), findsOneWidget);
    expect(find.text('This device'), findsOneWidget);
    expect(find.text('Online'), findsOneWidget);
    expect(find.text('Last online 3 hours ago'), findsOneWidget);

    await unmount(tester);
  });

  testWidgets('rename sends the mutation and shows the new name',
      (tester) async {
    final mutations = <Map<String, dynamic>>[];
    useClient(_fakeGraphQL([_device('other-device', name: 'Woonkamer')],
        mutations: mutations));
    await tester
        .pumpWidget(_app(const ServerSettingsDevicesPage(serverName: _server)));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rename'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'TV beneden');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(mutations.single['renameDevice']['name'], 'TV beneden');
    expect(find.text('TV beneden'), findsOneWidget);

    await unmount(tester);
  });

  testWidgets('remove asks for confirmation and drops the row',
      (tester) async {
    final mutations = <Map<String, dynamic>>[];
    useClient(_fakeGraphQL([_device('other-device', name: 'Woonkamer')],
        mutations: mutations));
    await tester
        .pumpWidget(_app(const ServerSettingsDevicesPage(serverName: _server)));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();
    expect(find.text("Remove device 'Woonkamer'?"), findsOneWidget);
    await tester.tap(find.text('Remove').last);
    await tester.pumpAndSettle();

    expect(mutations.single.containsKey('removeDevice'), isTrue);
    expect(find.text('Woonkamer'), findsNothing);
    expect(find.text('No devices registered yet.'), findsOneWidget);

    await unmount(tester);
  });

  testWidgets('shows the not-supported message when the query fails',
      (tester) async {
    useClient(MockClient((_) async => http.Response('down', 500)));
    await tester
        .pumpWidget(_app(const ServerSettingsDevicesPage(serverName: _server)));
    await tester.pumpAndSettle();

    expect(
        find.text('Could not load devices. The server may not support them yet.'),
        findsOneWidget);

    await unmount(tester);
  });
}
