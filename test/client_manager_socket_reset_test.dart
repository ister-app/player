import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  test('resetWebSockets pulses disconnect then connect per server', () async {
    const server = 'sock-server';
    WellKnownService.cacheForTest(
      server,
      const WellKnownInfo(
        name: 'Sock server',
        oidcUrl: 'https://oidc.example/.well-known/openid-configuration',
        serverUrl: 'https://sock.example/api',
      ),
    );
    addTearDown(() => ClientManager.removeClient(server));

    // The real client builder wires the toggle stream into the socket config.
    ClientManager.getClientForUrl(server);
    final events = <ToggleConnectionState>[];
    final toggles = ClientManager.socketToggleStreamFor(server);
    expect(toggles, isNotNull);
    final subscription = toggles!.listen(events.add);
    addTearDown(subscription.cancel);

    await ClientManager.resetWebSockets();
    // Let the buffered stream events deliver.
    await Future<void>.delayed(Duration.zero);

    expect(events, [
      ToggleConnectionState.disconnect,
      ToggleConnectionState.connect,
    ]);
  });
}
