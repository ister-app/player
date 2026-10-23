import '../../games/steam/Vdf.dart';

/// What the scanner needs from a Steam `appmanifest_<appid>.acf`.
class SteamAppManifest {
  const SteamAppManifest({
    required this.appId,
    required this.name,
    required this.installDir,
    required this.stateFlags,
    required this.sizeOnDisk,
  });

  final int appId;
  final String name;
  final String installDir;
  final int stateFlags;
  final int? sizeOnDisk;

  static final RegExp fileName = RegExp(r'^appmanifest_(\d+)\.acf$', caseSensitive: false);

  /// Steam's own tooling and runtimes, which live in a library as apps but
  /// are no games.
  static const runtimeAppIds = {
    228980, // Steamworks Common Redistributables
    250820, // SteamVR
    1070560, 1391110, 1628350, // Steam Linux Runtime (scout, soldier, sniper)
    1887720, 1493710, 2180100, 1245040, 1420170, 1580130, 858280, 961940, 1054830, 1113280, 1161040, // Proton builds
  };

  /// Null when the manifest lacks the fields the scanner needs.
  static SteamAppManifest? parse(String text) {
    try {
      final body = Vdf.body(Vdf.parse(text));
      final appId = Vdf.integer(body, 'appid');
      final installDir = Vdf.string(body, 'installdir')?.trim();
      if (appId == null || installDir == null || installDir.isEmpty) return null;
      return SteamAppManifest(
        appId: appId,
        name: Vdf.string(body, 'name')?.trim() ?? installDir,
        installDir: installDir,
        stateFlags: Vdf.integer(body, 'StateFlags') ?? 0,
        sizeOnDisk: Vdf.integer(body, 'SizeOnDisk'),
      );
    } on FormatException {
      return null;
    }
  }

  /// `StateFlags` 4 = fully installed; anything with an update or download
  /// pending (2, 1026, …) would upload a half-written tree.
  bool get isFullyInstalled => stateFlags == 4;

  bool get isRuntimeOrRedist {
    if (runtimeAppIds.contains(appId)) return true;
    final lower = name.toLowerCase();
    final dir = installDir.toLowerCase();
    return lower.startsWith('proton') ||
        lower.startsWith('steam linux runtime') ||
        lower.startsWith('legacy steam runtime') ||
        lower.startsWith('steamworks') ||
        lower == 'steamvr' ||
        dir.startsWith('proton') ||
        dir.startsWith('steamlinuxruntime') ||
        dir.startsWith('legacysteamruntime') ||
        dir.startsWith('steamworks shared');
  }
}
