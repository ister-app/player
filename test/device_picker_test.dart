import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/DevicePickerSheet.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/DevicePreferences.dart';
import 'package:player/utils/DeviceService.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';

Map<String, dynamic> _device(String id, String name, {bool online = true}) => {
      '__typename': 'Device',
      'deviceId': id,
      'name': name,
      'platform': 'ANDROID',
      'online': online,
      'lastSeenAt': '2026-08-04T10:00:00Z',
      'createdAt': '2026-08-01T10:00:00Z',
    };

MockClient _fakeGraphQL(List<Map<String, dynamic>> devices) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      final payload = query.contains('myDevices')
          ? {
              'data': {'__typename': 'Query', 'myDevices': devices}
            }
          : {
              'data': {'__typename': 'Query'}
            };
      return http.Response(json.encode(payload), 200,
          headers: {'content-type': 'application/json'});
    });

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

  Future<DeviceInfo?> openPicker(WidgetTester tester) async {
    DeviceInfo? picked;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            picked = await showDevicePickerSheet(context,
                serverName: _server, title: 'Play on device…');
          },
          child: const Text('open'),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return picked;
  }

  testWidgets('offers only other online devices', (tester) async {
    final ownId = await DevicePreferences.getDeviceId();
    useClient(_fakeGraphQL([
      _device(ownId, 'This laptop'),
      _device('tv', 'Woonkamer-tv'),
      _device('phone', 'Telefoon', online: false),
    ]));

    await openPicker(tester);

    expect(find.text('Woonkamer-tv'), findsOneWidget);
    expect(find.text('This laptop'), findsNothing,
        reason: 'the picker never offers the device it runs on');
    expect(find.text('Telefoon'), findsNothing,
        reason: 'offline devices cannot receive commands');
  });

  testWidgets('shows an empty state when no other device is online',
      (tester) async {
    final ownId = await DevicePreferences.getDeviceId();
    useClient(_fakeGraphQL([
      _device(ownId, 'This laptop'),
      _device('phone', 'Telefoon', online: false),
    ]));

    await openPicker(tester);

    expect(find.text('None of your other devices are online.'), findsOneWidget);
  });

  testWidgets('resolves to the tapped device', (tester) async {
    useClient(_fakeGraphQL([_device('tv', 'Woonkamer-tv')]));

    DeviceInfo? picked;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            picked = await showDevicePickerSheet(context,
                serverName: _server, title: 'Play on device…');
          },
          child: const Text('open'),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Woonkamer-tv'));
    await tester.pumpAndSettle();

    expect(picked?.deviceId, 'tv');
    expect(picked?.name, 'Woonkamer-tv');
  });
}
