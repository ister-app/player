import 'dart:io';

/// A resolved save location: the folder (or file) on this machine and the
/// index of the template it came from, which doubles as the top-level folder
/// name inside a snapshot zip (`<slot>/<relative>`), so a snapshot restores
/// into the right place on a machine where the roots differ.
class SaveSlot {
  const SaveSlot({required this.index, required this.path, required this.template});
  final int index;
  final String path;
  final String template;
}

/// Expands Ludusavi save-location templates for this machine. Placeholders
/// follow the manifest: `<base>` is the game's install folder, `<home>`,
/// `<winAppData>`, `<winLocalAppData>`, `<winDocuments>`, `<winPublic>`,
/// `<winProgramData>`, `<winDir>`, `<xdgData>`, `<xdgConfig>`, `<storeUserId>`,
/// `<root>` (the Steam root). On Linux a Windows placeholder resolves inside
/// the Proton prefix when one is known, else the template is skipped.
class SavePathResolver {
  SavePathResolver({
    required this.base,
    Map<String, String>? environment,
    this.protonDriveC,
    this.steamRoot,
    this.storeUserId,
    bool? isWindows,
  })  : _env = environment ?? Platform.environment,
        _isWindows = isWindows ?? Platform.isWindows;

  /// The game's install folder (`<base>`).
  final String base;
  final Map<String, String> _env;
  final bool _isWindows;

  /// `.../compatdata/<appid>/pfx/drive_c` for a Proton game on Linux.
  final String? protonDriveC;
  final String? steamRoot;
  final int? storeUserId;

  String get _home => _env['HOME'] ?? _env['USERPROFILE'] ?? '';

  /// Resolves the templates that apply to this OS. Globs (`*`, `**`) are
  /// expanded against the file system; templates that leave the user's
  /// home / the Proton prefix / the game folder are dropped for safety.
  Future<List<SaveSlot>> resolve(List<({String path, String? os})> templates) async {
    final slots = <SaveSlot>[];
    for (var i = 0; i < templates.length; i++) {
      final template = templates[i];
      if (!_appliesHere(template.os)) continue;
      final expanded = expand(template.path);
      if (expanded == null) continue;
      for (final path in await _glob(expanded)) {
        if (_allowed(path)) {
          slots.add(SaveSlot(index: i, path: path, template: template.path));
        }
      }
    }
    return slots;
  }

  bool _appliesHere(String? os) {
    if (os == null) return true;
    if (_isWindows) return os == 'windows';
    if (os == 'linux') return true;
    // A Windows game under Proton keeps Windows paths inside the prefix.
    return os == 'windows' && protonDriveC != null;
  }

  /// One template with its placeholders filled in; null when a placeholder
  /// has no value on this machine.
  String? expand(String template) {
    var out = template;
    final values = _placeholders();
    for (final entry in values.entries) {
      out = out.replaceAll(entry.key, entry.value ?? '\u0000');
    }
    if (out.contains('\u0000') || out.contains('<')) return null;
    if (_isWindows) return out.replaceAll('/', r'\');
    return out;
  }

  Map<String, String?> _placeholders() {
    final drive = protonDriveC;
    final user = _env['USERNAME'] ?? _env['USER'] ?? 'steamuser';
    String? win(String relativeToUser) {
      if (_isWindows) {
        final profile = _env['USERPROFILE'];
        return profile == null ? null : '$profile\\$relativeToUser';
      }
      return drive == null ? null : '$drive/users/steamuser/$relativeToUser';
    }
    return {
      '<base>': base,
      '<home>': _isWindows ? (_env['USERPROFILE']) : _home,
      '<root>': steamRoot,
      '<storeUserId>': storeUserId?.toString(),
      '<osUserName>': user,
      '<winAppData>': _isWindows ? _env['APPDATA'] : win('AppData/Roaming'),
      '<winLocalAppData>': _isWindows ? _env['LOCALAPPDATA'] : win('AppData/Local'),
      '<winLocalAppDataLow>': _isWindows ? (_env['USERPROFILE'] == null ? null : '${_env['USERPROFILE']}\\AppData\\LocalLow') : win('AppData/LocalLow'),
      '<winDocuments>': _isWindows ? (_env['USERPROFILE'] == null ? null : '${_env['USERPROFILE']}\\Documents') : win('Documents'),
      '<winPublic>': _isWindows ? (_env['PUBLIC'] ?? r'C:\Users\Public') : (drive == null ? null : '$drive/users/Public'),
      '<winProgramData>': _isWindows ? (_env['ProgramData'] ?? r'C:\ProgramData') : (drive == null ? null : '$drive/ProgramData'),
      '<winDir>': _isWindows ? (_env['windir'] ?? r'C:\Windows') : (drive == null ? null : '$drive/windows'),
      '<xdgData>': _isWindows ? null : (_env['XDG_DATA_HOME'] ?? '$_home/.local/share'),
      '<xdgConfig>': _isWindows ? null : (_env['XDG_CONFIG_HOME'] ?? '$_home/.config'),
    };
  }

  /// A path must live under one of the roots we own; anything else (a
  /// template pointing at `C:\`) is refused.
  bool _allowed(String path) {
    final roots = <String?>[base, _isWindows ? _env['USERPROFILE'] : _home, protonDriveC]
        .whereType<String>()
        .map(_norm)
        .toList();
    final normalized = _norm(path);
    return roots.any((root) => normalized == root || normalized.startsWith('$root/'));
  }

  static String _norm(String path) => path.replaceAll(r'\', '/').replaceAll(RegExp(r'/+$'), '').toLowerCase();

  /// Expands `*` / `**` segments against existing directories and files.
  Future<List<String>> _glob(String pattern) async {
    if (!pattern.contains('*')) return [pattern];
    final separator = _isWindows ? r'\' : '/';
    final segments = pattern.split(RegExp(r'[\\/]'));
    var current = <String>[segments.first.isEmpty ? separator : segments.first];
    for (final segment in segments.skip(1)) {
      final next = <String>[];
      for (final prefix in current) {
        final dir = Directory(prefix);
        if (!segment.contains('*')) {
          next.add(_join(prefix, segment, separator));
          continue;
        }
        if (!await dir.exists()) continue;
        final regex = RegExp('^${RegExp.escape(segment).replaceAll(r'\*\*', '.*').replaceAll(r'\*', '[^/\\\\]*')}\$');
        await for (final child in dir.list(followLinks: false)) {
          final name = child.uri.pathSegments.where((s) => s.isNotEmpty).last;
          if (regex.hasMatch(name)) next.add(_join(prefix, name, separator));
        }
      }
      current = next;
      if (current.isEmpty) break;
    }
    return current;
  }

  static String _join(String prefix, String segment, String separator) =>
      prefix.endsWith(separator) ? '$prefix$segment' : '$prefix$separator$segment';
}
