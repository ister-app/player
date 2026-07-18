import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/AdminLibrariesPage.dart';
import 'package:player/pages/AdminUsersPage.dart';
import 'package:player/pages/ServerSettingsClusterPage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/PermissionsService.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';

Map<String, dynamic> _me(bool isAdmin) => {
      '__typename': 'Me',
      'id': 'user-1',
      'name': 'Gerben',
      'email': 'gerben@example.org',
      'isAdmin': isAdmin,
    };

Map<String, dynamic> _users() => {
      '__typename': 'Query',
      'users': [
        {
          '__typename': 'User',
          'id': 'user-1',
          'name': 'Gerben',
          'email': 'gerben@example.org',
          'isAdmin': true,
          'grantedLibraries': [],
        },
        {
          '__typename': 'User',
          'id': 'user-2',
          'name': 'Kees',
          'email': 'kees@example.org',
          'isAdmin': false,
          'grantedLibraries': [
            {
              '__typename': 'Library',
              'id': 'lib-2',
              'name': 'Anime',
              'type': 'SHOW',
            }
          ],
        },
      ],
    };

Map<String, dynamic> _adminLibraries() => {
      '__typename': 'Query',
      'libraries': [
        {
          '__typename': 'Library',
          'id': 'lib-1',
          'name': 'Movies',
          'type': 'MOVIE',
          'visibleToAll': true,
        },
        {
          '__typename': 'Library',
          'id': 'lib-2',
          'name': 'Anime',
          'type': 'SHOW',
          'visibleToAll': false,
        },
      ],
    };

/// Routes on query text: me, users, adminLibraries and the two mutations.
MockClient _fakeGraphQL({
  bool isAdmin = false,
  bool meUnsupported = false,
  List<Map<String, dynamic>>? mutations,
}) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      Map<String, dynamic> payload;
      if (query.contains('setLibraryVisibleToAll') ||
          query.contains('setUserLibraryAccess')) {
        mutations?.add(body['variables'] as Map<String, dynamic>);
        final field = query.contains('setLibraryVisibleToAll')
            ? 'setLibraryVisibleToAll'
            : 'setUserLibraryAccess';
        payload = {
          'data': {'__typename': 'Mutation', field: true}
        };
      } else if (query.contains('me {')) {
        payload = meUnsupported
            ? {
                'errors': [
                  {
                    'message':
                        "Validation error (FieldUndefined@[me]) : Field 'me' in type 'Query' is undefined"
                  }
                ]
              }
            : {
                'data': {'__typename': 'Query', 'me': _me(isAdmin)}
              };
      } else if (query.contains('users {')) {
        payload = {'data': _users()};
      } else if (query.contains('visibleToAll')) {
        payload = {'data': _adminLibraries()};
      } else if (query.contains('getServerInfo')) {
        payload = {
          'data': {
            '__typename': 'Query',
            'getServerInfo': {
              '__typename': 'ServerInfo',
              'name': 'test',
              'openIdUrl': 'https://idp.example',
              'url': 'https://api.example',
              'nodes': [],
            },
          }
        };
      } else {
        // shared libraries query et al.
        payload = {
          'data': {'__typename': 'Query', 'libraries': []}
        };
      }
      return http.Response(
        json.encode(payload),
        200,
        headers: {'content-type': 'application/json'},
      );
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
    PermissionsService().invalidate(_server);
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

  group('PermissionsService', () {
    test('resolves admin from the me query and caches it', () async {
      useClient(_fakeGraphQL(isAdmin: true));
      expect(await PermissionsService().adminStatusFor(_server),
          AdminStatus.admin);
      expect(PermissionsService().cachedStatusFor(_server), AdminStatus.admin);
    });

    test('resolves notAdmin for a regular user', () async {
      useClient(_fakeGraphQL(isAdmin: false));
      expect(await PermissionsService().adminStatusFor(_server),
          AdminStatus.notAdmin);
    });

    test('an old server without the me query yields unknown', () async {
      useClient(_fakeGraphQL(meUnsupported: true));
      expect(await PermissionsService().adminStatusFor(_server),
          AdminStatus.unknown);
    });

    test('falls back to the local cache when the server is unreachable',
        () async {
      useClient(_fakeGraphQL(isAdmin: true));
      await PermissionsService().adminStatusFor(_server);

      PermissionsService().invalidate(_server);
      ClientManager.clients.clear();
      useClient(MockClient((_) async => http.Response('down', 500)));
      expect(await PermissionsService().adminStatusFor(_server),
          AdminStatus.admin);
    });
  });

  group('ServerSettingsClusterPage gating', () {
    testWidgets('hides the management section for a non-admin',
        (tester) async {
      useClient(_fakeGraphQL(isAdmin: false));
      await tester.pumpWidget(
          _app(const ServerSettingsClusterPage(serverName: _server)));
      await tester.pumpAndSettle();

      expect(find.text('Management'), findsNothing);
      expect(find.text('Scan library'), findsNothing);
    });

    testWidgets('shows the management section for an admin', (tester) async {
      useClient(_fakeGraphQL(isAdmin: true));
      await tester.pumpWidget(
          _app(const ServerSettingsClusterPage(serverName: _server)));
      await tester.pumpAndSettle();

      expect(find.text('Management'), findsOneWidget);
      expect(find.text('Scan library'), findsOneWidget);
    });

    testWidgets('keeps the management section on an old server (unknown)',
        (tester) async {
      useClient(_fakeGraphQL(meUnsupported: true));
      await tester.pumpWidget(
          _app(const ServerSettingsClusterPage(serverName: _server)));
      await tester.pumpAndSettle();

      expect(find.text('Management'), findsOneWidget);
    });
  });

  group('Admin pages', () {
    testWidgets('AdminUsersPage lists users with an admin badge',
        (tester) async {
      useClient(_fakeGraphQL(isAdmin: true));
      await tester.pumpWidget(_app(const AdminUsersPage(serverName: _server)));
      await tester.pumpAndSettle();

      expect(find.text('Gerben'), findsOneWidget);
      expect(find.text('Kees'), findsOneWidget);
      expect(find.text('Admin'), findsOneWidget); // only Gerben is admin
    });

    testWidgets(
        'AdminLibrariesPage toggles visibleToAll through the mutation',
        (tester) async {
      final mutations = <Map<String, dynamic>>[];
      useClient(_fakeGraphQL(isAdmin: true, mutations: mutations));
      await tester
          .pumpWidget(_app(const AdminLibrariesPage(serverName: _server)));
      await tester.pumpAndSettle();

      expect(find.text('Movies'), findsOneWidget);
      expect(find.text('Anime'), findsOneWidget);
      expect(find.text('Restricted — only granted users'), findsOneWidget);

      await tester.tap(find.byType(Switch).last);
      await tester.pumpAndSettle();

      expect(mutations, hasLength(1));
      expect(mutations.single['libraryId'], 'lib-2');
      expect(mutations.single['visibleToAll'], true);
    });
  });
}
