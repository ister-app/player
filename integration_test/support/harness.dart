import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' show PlatformDispatcher;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/VideoCoverView.dart';
import 'package:player/main.dart' as app;
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LoginManager.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'hang_watchdog.dart';

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

final Map<bool, String> _cachedTokens = {};
final Map<bool, DateTime> _cachedTokenMintedAt = {};

/// Mints a client-credentials JWT at the mock issuer: roles=[user] by default,
/// roles=[user, admin] with [admin] (mock-oidc maps the scope to the claims).
Future<String> mintToken({bool admin = false}) async {
  final cached = _cachedTokens[admin];
  if (cached != null &&
      DateTime.now().difference(_cachedTokenMintedAt[admin]!) <
          const Duration(minutes: 45)) {
    return cached;
  }
  final scope = admin ? 'ister-admin' : 'ister';
  final client = HttpClient();
  try {
    final request = await client.postUrl(Uri.parse(testTokenUrl));
    request.headers.set(HttpHeaders.hostHeader, _issuerHost);
    request.headers.contentType =
        ContentType('application', 'x-www-form-urlencoded');
    request.write(
        'grant_type=client_credentials&client_id=e2e&client_secret=e2e-secret&scope=$scope');
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode != 200) {
      throw StateError('token endpoint returned ${response.statusCode}: $body');
    }
    final token = jsonDecode(body)['access_token'] as String?;
    if (token == null) throw StateError('no access_token in: $body');
    _cachedTokens[admin] = token;
    _cachedTokenMintedAt[admin] = DateTime.now();
    return token;
  } finally {
    client.close();
  }
}

bool _appBooted = false;

/// Marks a step of the test on stderr, live, and feeds the hang watchdog
/// (see hang_watchdog.dart). Call it at every stop of a test: when a test
/// hangs, the last traced step is the one thing the CI log has to go on.
void trace(String step) => traceStep(step);

/// The scheduler's view for the watchdog report: a pump that never returns
/// shows up as a frame that stays scheduled and never gets produced.
Map<String, Object?> _schedulerState() {
  final scheduler = SchedulerBinding.instance;
  return {
    'phase': scheduler.schedulerPhase.name,
    'hasScheduledFrame': scheduler.hasScheduledFrame,
    'framesEnabled': scheduler.framesEnabled,
  };
}

/// Installs the token seam, optionally seeds the server list, and boots the
/// real app (once per process). The app always starts on the server overview:
/// the deep-link entry cannot express a server identifier containing a path
/// (its "/" splits the route), so tests enter via [enterServerShell] instead.
Future<void> bootApp(
  WidgetTester tester, {
  bool seedServer = true,
  bool admin = false,
}) async {
  LoginManager.testTokenProvider = (_) => mintToken(admin: admin);
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
  await startHangWatchdog(extraState: _schedulerState);
  trace('bootApp: starting the app');
  await app.main();
  _traceUncaughtErrors();
  await tester.pump();
  trace('bootApp: first frame pumped');
}

/// The last error the app reported, for the message of a stalled [pumpOrFail].
String? _lastReportedError;

/// Mirrors every reported error into the trace, live. The app installs its own
/// FlutterError.onError / PlatformDispatcher.onError in main() (logging to the
/// in-app log store, then chaining to the handler it found — the test
/// binding's, here), which is why these wrap *after* app.main(). A
/// `flutter test -d linux` run only prints the app's console once the test has
/// finished, so while a test is stuck the error that ended it is the one thing
/// the CI log never shows. Note that a test failure (`fail`, a timeout in
/// [pumpUntil]) also passes through here: the binding reports the uncaught
/// error through FlutterError before completing the test.
void _traceUncaughtErrors() {
  final appOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    _lastReportedError = details.exceptionAsString();
    trace('FlutterError: ${_oneLine(details.exceptionAsString())}'
        '${_topFrames(details.stack)}');
    appOnError?.call(details);
  };
  final appDispatcherOnError = PlatformDispatcher.instance.onError;
  PlatformDispatcher.instance.onError = (error, stack) {
    _lastReportedError = error.toString();
    trace('uncaught: ${_oneLine(error.toString())}${_topFrames(stack)}');
    return appDispatcherOnError?.call(error, stack) ?? false;
  };
}

String _oneLine(String text) {
  final flat = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  return flat.length > 400 ? '${flat.substring(0, 400)}…' : flat;
}

String _topFrames(StackTrace? stack) {
  if (stack == null) return '';
  final frames = stack
      .toString()
      .split('\n')
      .where((l) => l.trim().isNotEmpty)
      .take(4)
      .map((l) => l.trim())
      .join(' | ');
  return frames.isEmpty ? '' : '\n    at $frames';
}

/// How long one [WidgetTester.pump] may take before the frame loop counts as
/// dead. On the live binding a pump resolves when the engine delivers the next
/// frame; a frame normally follows within milliseconds of the requested delay.
const Duration framePumpTimeout = Duration(seconds: 30);

/// [WidgetTester.pump] that fails the test instead of waiting forever when no
/// frame comes. The live test binding completes a pump from handleDrawFrame,
/// so an engine that stops delivering frames (or a frame that throws past the
/// binding's own state checks) leaves the pump's future pending for good, and
/// the test then sits silent until the CI's 12-minute kill. The watchdog only
/// *reports* that state; failing here ends the test, which is also what gets
/// the buffered app output (the real exception among it) printed.
Future<void> pumpOrFail(WidgetTester tester, [Duration? duration]) {
  return tester.pump(duration).timeout(framePumpTimeout, onTimeout: () {
    fail('no frame for ${framePumpTimeout.inSeconds}s: the frame loop is '
        'dead (scheduler: ${_schedulerState()}; last reported error: '
        '${_lastReportedError ?? 'none'})');
  });
}

/// From the server overview, opens the (seeded) server's card and waits for
/// its home shell. The card's onTap is invoked directly because Skeletonizer's
/// snapshot layers make a synthesized pointer tap land on the wrong render
/// object while the well-known fetch is settling.
Future<void> enterServerShell(WidgetTester tester) async {
  trace('enterServerShell');
  await pumpUntilFound(tester, find.textContaining('http://'),
      timeout: const Duration(seconds: 30));
  final tile = tester.widget<ListTile>(find.byType(ListTile).first);
  if (tile.onTap == null) fail('server card is not tappable');
  tile.onTap!();
  await waitForServerShell(tester);
}

/// Waits for a server's home shell (bottom bar or rail) to be on screen.
Future<void> waitForServerShell(WidgetTester tester) async {
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
  trace('waiting for $finder');
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await pumpOrFail(tester, const Duration(milliseconds: 200));
    if (finder.evaluate().isNotEmpty) return;
  }
  fail('Timed out after $timeout waiting for $finder');
}

/// The play button on an episode/movie page's cover. Video never autoplays
/// from browsing: the page shows the artwork with this button first.
final Finder videoPlayButton = find.byKey(VideoCoverView.playButtonKey);

/// Starts playback on an episode/movie page that was just pushed: waits for
/// the cover's play button and taps it.
Future<void> tapVideoPlay(
  WidgetTester tester, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  await pumpUntilFound(tester, videoPlayButton, timeout: timeout);
  await tester.tap(videoPlayButton);
  await tester.pump(const Duration(milliseconds: 200));
}

/// Pumps frames until [condition] returns true, or fails after [timeout].
Future<void> pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 30),
  String description = 'condition',
}) async {
  trace('waiting for $description');
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await pumpOrFail(tester, const Duration(milliseconds: 200));
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
///
/// FetchPolicy.noCache on both paths: these calls probe *server* state, so the
/// app's normalized cache must not touch them in either direction. With
/// networkOnly the default cache reread replaced fresh network data with the
/// stale cached entity — a movie whose page had cached `watchStatus: []`
/// polled as empty forever, no matter what the server had by then.
Future<Map<String, dynamic>> gqlRaw(String document,
    {Map<String, dynamic> variables = const {}}) async {
  final client = await appClient();
  final result = document.trimLeft().startsWith('mutation')
      ? await client.mutate(MutationOptions(
          document: gql(document),
          variables: variables,
          fetchPolicy: FetchPolicy.noCache))
      : await client.query(QueryOptions(
          document: gql(document),
          variables: variables,
          fetchPolicy: FetchPolicy.noCache));
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
  trace('pushRoute ${route.routeName}');
  final context = tester.element(find.byType(Scaffold).last);
  final future = AutoRouter.of(context).push(route);
  await tester.pump();
  // The route future completes when the page pops; don't await it here.
  unawaited(future);
}
