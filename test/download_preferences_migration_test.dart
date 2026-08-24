import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/ServerStore.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadPreferences.dart';
import 'package:player/utils/download/DownloadStore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _a = 'localhost:8080/api';
const _b = 'other:8080/api';

String _legacyKey(String server) =>
    'downloads_unmetered_only_${DownloadStore.slug(server)}';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferencesAsync prefs;

  setUpAll(() {
    // One platform instance for the whole file: SharedPreferencesAsync binds
    // to the platform it was built against, and DownloadPreferences keeps a
    // static one — swapping the platform per test would leave it writing to
    // the previous store.
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    prefs = SharedPreferencesAsync();
  });

  setUp(() async {
    await prefs.clear();
    await ServerStore.add(_a);
    await ServerStore.add(_b);
  });

  test('no legacy value keeps the default', () async {
    await DownloadPreferences.migrateNetworkPolicy();
    expect(await DownloadPreferences.getNetworkPolicy(),
        DownloadNetworkPolicy.automaticUnmeteredOnly);
  });

  test('legacy "on" for every server keeps the default', () async {
    await prefs.setBool(_legacyKey(_a), true);
    await prefs.setBool(_legacyKey(_b), true);
    await DownloadPreferences.migrateNetworkPolicy();
    expect(await DownloadPreferences.getNetworkPolicy(),
        DownloadNetworkPolicy.automaticUnmeteredOnly);
    expect(await prefs.getBool(_legacyKey(_a)), isNull);
  });

  test('one server with the switch off becomes "any connection"', () async {
    await prefs.setBool(_legacyKey(_a), true);
    await prefs.setBool(_legacyKey(_b), false);
    await DownloadPreferences.migrateNetworkPolicy();
    expect(await DownloadPreferences.getNetworkPolicy(),
        DownloadNetworkPolicy.any);
    expect(await prefs.getBool(_legacyKey(_b)), isNull);
  });

  test('an existing choice is never overwritten', () async {
    await DownloadPreferences.setNetworkPolicy(
        DownloadNetworkPolicy.allUnmeteredOnly);
    await prefs.setBool(_legacyKey(_a), false);
    await DownloadPreferences.migrateNetworkPolicy();
    expect(await DownloadPreferences.getNetworkPolicy(),
        DownloadNetworkPolicy.allUnmeteredOnly);
  });

  test('an unknown stored value falls back to the default', () async {
    await prefs.setString('downloads_network_policy', 'bogus');
    expect(await DownloadPreferences.getNetworkPolicy(),
        DownloadNetworkPolicy.automaticUnmeteredOnly);
  });
}
