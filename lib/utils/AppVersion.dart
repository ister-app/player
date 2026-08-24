import 'package:package_info_plus/package_info_plus.dart';

Future<String>? _cached;

/// The app version as shown to users: `1.2.3+45`, plus the baked-in git
/// commit in parens when the build carried `--dart-define=GIT_COMMIT=…`.
Future<String> appVersionString() {
  return _cached ??= () async {
    final info = await PackageInfo.fromPlatform();
    const commit = String.fromEnvironment('GIT_COMMIT', defaultValue: '');
    var version = '${info.version}+${info.buildNumber}';
    if (commit.isNotEmpty) {
      version = '$version ($commit)';
    }
    return version;
  }();
}
