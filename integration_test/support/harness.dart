import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/main.dart' as app;
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LoginManager.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The server identifier as typed into the app. The kind cluster's ister-server
/// service is expected on localhost:8080 via kubectl port-forward; the chart's
/// default server.url advertises exactly that. The "/api" path is needed because
/// without an ingress (which serves /.well-known/ister at the root) the server
/// itself only answers under its /api prefix.
const String testServer =
    String.fromEnvironment('ISTER_SERVER', defaultValue: 'localhost:8080/api');

/// Token endpoint of the mock OIDC issuer (mock-oauth2-server), port-forwarded
/// from the cluster. The Host header below makes the minted `iss` claim match
/// the OIDC_URL the server validates against.
const String testTokenUrl = String.fromEnvironment('ISTER_TOKEN_URL',
    defaultValue: 'http://localhost:18081/default/token');

const String _issuerHost = 'mock-oidc:8080';

String? _cachedToken;
DateTime? _cachedTokenMintedAt;

/// Mints a client-credentials JWT with roles=[user] at the mock issuer.
Future<String> mintToken() async {
  final cached = _cachedToken;
  if (cached != null &&
      DateTime.now().difference(_cachedTokenMintedAt!) <
          const Duration(minutes: 45)) {
    return cached;
  }
  final client = HttpClient();
  try {
    final request = await client.postUrl(Uri.parse(testTokenUrl));
    request.headers.set(HttpHeaders.hostHeader, _issuerHost);
    request.headers.contentType =
        ContentType('application', 'x-www-form-urlencoded');
    request.write(
        'grant_type=client_credentials&client_id=e2e&client_secret=e2e-secret&scope=ister');
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode != 200) {
      throw StateError('token endpoint returned ${response.statusCode}: $body');
    }
    final token = jsonDecode(body)['access_token'] as String?;
    if (token == null) throw StateError('no access_token in: $body');
    _cachedToken = token;
    _cachedTokenMintedAt = DateTime.now();
    return token;
  } finally {
    client.close();
  }
}

bool _appBooted = false;

/// Installs the token seam, optionally seeds the server list, and boots the
/// real app (once per process). The app always starts on the server overview:
/// the deep-link entry cannot express a server identifier containing a path
/// (its "/" splits the route), so tests enter via [enterServerShell] instead.
Future<void> bootApp(
  WidgetTester tester, {
  bool seedServer = true,
}) async {
  LoginManager.testTokenProvider = (_) => mintToken();
  final prefs = SharedPreferencesAsync();
  await prefs.remove('currentServer');
  if (seedServer) {
    final servers = await prefs.getStringList('servers') ?? [];
    if (!servers.contains(testServer)) {
      servers.add(testServer);
      await prefs.setStringList('servers', servers);
    }
  } else {
    await prefs.remove('servers');
  }
  if (_appBooted) {
    fail('bootApp may only run once per test process; '
        'keep one testWidgets per integration test file');
  }
  _appBooted = true;
  await app.main();
  await tester.pump();
}

/// From the server overview, opens the (seeded) server's card and waits for
/// its home shell. The card's onTap is invoked directly because Skeletonizer's
/// snapshot layers make a synthesized pointer tap land on the wrong render
/// object while the well-known fetch is settling.
Future<void> enterServerShell(WidgetTester tester) async {
  await pumpUntilFound(tester, find.textContaining('http://'),
      timeout: const Duration(seconds: 30));
  final tile = tester.widget<ListTile>(find.byType(ListTile).first);
  if (tile.onTap == null) fail('server card is not tappable');
  tile.onTap!();
  await pumpUntil(
    tester,
    () =>
        find.byType(NavigationBar).evaluate().isNotEmpty ||
        find.byType(NavigationRail).evaluate().isNotEmpty,
    timeout: const Duration(seconds: 60),
    description: 'the server home shell (NavigationBar/NavigationRail)',
  );
}

/// Pumps frames until [finder] matches, or fails after [timeout].
Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 200));
    if (finder.evaluate().isNotEmpty) return;
  }
  fail('Timed out after $timeout waiting for $finder');
}

/// Pumps frames until [condition] returns true, or fails after [timeout].
Future<void> pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 30),
  String description = 'condition',
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 200));
    if (condition()) return;
  }
  final texts = find
      .byType(Text)
      .evaluate()
      .map((e) => (e.widget as Text).data)
      .whereType<String>()
      .toList();
  fail('Timed out after $timeout waiting for $description; '
      'visible texts: $texts');
}

/// The app's own GraphQL client for [testServer]; ensures the well-known info
/// is cached first so ClientManager can build it.
Future<GraphQLClient> appClient() async {
  final info = await WellKnownService.fetch(testServer);
  if (info == null) {
    throw StateError('/.well-known/ister not reachable for $testServer — '
        'is the port-forward running?');
  }
  return ClientManager.getClientForUrl(testServer).value;
}

/// Runs a raw GraphQL query/mutation through the app's client and returns the
/// data map. Fails the test on errors.
Future<Map<String, dynamic>> gqlRaw(String document,
    {Map<String, dynamic> variables = const {}}) async {
  final client = await appClient();
  final result = document.trimLeft().startsWith('mutation')
      ? await client.mutate(
          MutationOptions(document: gql(document), variables: variables))
      : await client.query(QueryOptions(
          document: gql(document),
          variables: variables,
          fetchPolicy: FetchPolicy.networkOnly));
  if (result.hasException) {
    fail('GraphQL failed: ${result.exception} for $document');
  }
  return result.data!;
}

/// GET against the server REST API (same base URL the app uses) with the
/// minted JWT. Returns the decoded JSON body.
Future<dynamic> restGet(String pathAndQuery) async {
  final info = WellKnownService.getCached(testServer) ??
      await WellKnownService.fetch(testServer);
  final token = await mintToken();
  final client = HttpClient();
  try {
    final request =
        await client.getUrl(Uri.parse('${info!.serverUrl}$pathAndQuery'));
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode != 200) {
      throw StateError('GET $pathAndQuery -> ${response.statusCode}: $body');
    }
    return jsonDecode(body);
  } finally {
    client.close();
  }
}

/// Pushes a typed route (e.g. `MovieRoute(movieId: ...)`) the same way the
/// app's own tiles do: from a context inside the server shell, so the
/// `serverName` path param is inherited. Call after [enterServerShell].
Future<void> pushRoute(WidgetTester tester, PageRouteInfo route) async {
  final context = tester.element(find.byType(Scaffold).last);
  final future = AutoRouter.of(context).push(route);
  await tester.pump();
  // The route future completes when the page pops; don't await it here.
  unawaited(future);
}
