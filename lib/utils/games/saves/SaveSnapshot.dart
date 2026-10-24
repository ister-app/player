import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';

import 'SavePathResolver.dart';

/// Builds and unpacks save snapshots. A snapshot zip holds every resolved
/// slot under its slot index (`0/<relative files>`, `1/...`) plus a
/// `snapshot.json` naming the templates, so the same zip restores correctly on
/// a machine whose roots differ. Pure file work; runs in an isolate by callers.
class SaveSnapshot {
  SaveSnapshot._();

  static const manifestName = 'snapshot.json';

  /// When any file in the slots last changed; null when the slots are empty.
  /// Hidden files are skipped the way [pack] skips them.
  static Future<DateTime?> newestModified(List<SaveSlot> slots) async {
    DateTime? newest;
    void consider(DateTime at) {
      if (newest == null || at.isAfter(newest!)) newest = at;
    }

    for (final slot in slots) {
      final type = FileSystemEntity.typeSync(slot.path, followLinks: false);
      if (type == FileSystemEntityType.file) {
        consider(await File(slot.path).lastModified());
      } else if (type == FileSystemEntityType.directory) {
        final dir = Directory(slot.path);
        await for (final entity in dir.list(recursive: true, followLinks: false)) {
          if (entity is! File) continue;
          // Hidden within the slot only: the slot itself may live under
          // `~/.var/app/...` or `~/.config`.
          if (_relative(dir, entity).split('/').any((s) => s.startsWith('.'))) continue;
          consider(await entity.lastModified());
        }
      }
    }
    return newest;
  }

  /// Zips the slots into [target]; returns the sha-256 (hex) or null when the
  /// slots hold no files at all (nothing to upload).
  static Future<String?> pack(List<SaveSlot> slots, File target) async {
    final archive = Archive();
    var files = 0;
    for (final slot in slots) {
      final type = FileSystemEntity.typeSync(slot.path, followLinks: false);
      if (type == FileSystemEntityType.file) {
        final file = File(slot.path);
        archive.addFile(ArchiveFile.bytes('${slot.index}/${_name(slot.path)}', await file.readAsBytes()));
        files++;
      } else if (type == FileSystemEntityType.directory) {
        final dir = Directory(slot.path);
        await for (final entity in dir.list(recursive: true, followLinks: false)) {
          if (entity is! File) continue;
          final relative = _relative(dir, entity);
          if (relative.split('/').any((s) => s.startsWith('.'))) continue;
          archive.addFile(ArchiveFile.bytes('${slot.index}/$relative', await entity.readAsBytes()));
          files++;
        }
      }
    }
    if (files == 0) return null;
    archive.addFile(ArchiveFile.string(manifestName, jsonEncode({
      'version': 1,
      'slots': [
        for (final slot in slots) {'index': slot.index, 'template': slot.template},
      ],
    })));
    final bytes = ZipEncoder().encode(archive);
    await target.parent.create(recursive: true);
    await target.writeAsBytes(bytes, flush: true);
    return sha256.convert(bytes).toString();
  }

  /// Restores a snapshot into the slots. Each `<index>/...` entry goes to the
  /// slot whose template `snapshot.json` names for that index — not the slot
  /// with that index here, since indices depend on which folders exist on
  /// the packing machine. An `rpcs3:<folder>` template with no slot of its
  /// own (a save folder this machine has not seen yet) is restored next to
  /// the game's `rpcs3:<title id>` slot. Entries of unknown slots and entries
  /// escaping their slot folder are skipped. A file slot takes the single
  /// entry.
  static Future<int> unpack(File zip, List<SaveSlot> slots) async {
    final archive = ZipDecoder().decodeBytes(await zip.readAsBytes());
    final resolve = _slotResolver(archive, slots);
    var written = 0;
    for (final entry in archive) {
      if (!entry.isFile || entry.name == manifestName) continue;
      final slash = entry.name.indexOf('/');
      if (slash <= 0) continue;
      final index = int.tryParse(entry.name.substring(0, slash));
      final slot = index == null ? null : resolve(index);
      if (slot == null) continue;
      final relative = entry.name.substring(slash + 1);
      if (relative.isEmpty || relative.split('/').any((s) => s == '..' || s.isEmpty)) continue;
      final slotIsFile = FileSystemEntity.typeSync(slot.path, followLinks: false) == FileSystemEntityType.file ||
          (!slot.path.endsWith('/') && !slot.path.endsWith(r'\') && _looksLikeFile(slot.template));
      final target = slotIsFile ? File(slot.path) : File('${slot.path}${Platform.pathSeparator}${relative.replaceAll('/', Platform.pathSeparator)}');
      await target.parent.create(recursive: true);
      await target.writeAsBytes(entry.readBytes() ?? const [], flush: true);
      written++;
    }
    return written;
  }

  /// Maps a packed slot index to a slot here, by template when the archive
  /// carries its manifest, by index for an archive without one.
  static SaveSlot? Function(int index) _slotResolver(Archive archive, List<SaveSlot> slots) {
    final byIndex = {for (final slot in slots) slot.index: slot};
    final manifest = archive.findFile(manifestName);
    if (manifest == null) return (index) => byIndex[index];
    final templateOf = <int, String>{};
    try {
      final json = jsonDecode(utf8.decode(manifest.readBytes() ?? const [])) as Map<String, dynamic>;
      for (final slot in json['slots'] as List) {
        final map = slot as Map<String, dynamic>;
        templateOf[(map['index'] as num).toInt()] = map['template'] as String;
      }
    } catch (_) {
      return (index) => byIndex[index];
    }
    final byTemplate = {for (final slot in slots) slot.template: slot};
    final rpcs3Root = slots.where((s) => s.template.startsWith('rpcs3:')).firstOrNull;
    return (index) {
      final template = templateOf[index];
      if (template == null) return null;
      final known = byTemplate[template];
      if (known != null) return known;
      if (rpcs3Root != null && template.startsWith('rpcs3:')) {
        final name = template.substring('rpcs3:'.length);
        if (name.isEmpty || name.contains('/') || name.contains(r'\') || name == '..') return null;
        final savedata = File(rpcs3Root.path).parent.path;
        return SaveSlot(index: index, path: '$savedata${Platform.pathSeparator}$name', template: template);
      }
      return null;
    };
  }

  /// A fingerprint of the slots' current content (paths, sizes, mtimes) to
  /// tell "changed since last sync" without hashing gigabytes.
  static Future<String> fingerprint(List<SaveSlot> slots) async {
    final lines = <String>[];
    for (final slot in slots) {
      final type = FileSystemEntity.typeSync(slot.path, followLinks: false);
      if (type == FileSystemEntityType.file) {
        final stat = await File(slot.path).stat();
        lines.add('${slot.index}|${stat.size}|${stat.modified.millisecondsSinceEpoch}');
      } else if (type == FileSystemEntityType.directory) {
        await for (final entity in Directory(slot.path).list(recursive: true, followLinks: false)) {
          if (entity is! File) continue;
          final stat = await entity.stat();
          lines.add('${slot.index}|${entity.path}|${stat.size}|${stat.modified.millisecondsSinceEpoch}');
        }
      }
    }
    lines.sort();
    return sha256.convert(utf8.encode(lines.join('\n'))).toString();
  }

  static String _relative(Directory dir, FileSystemEntity entity) =>
      entity.path.substring(dir.path.length).replaceAll(r'\', '/').replaceFirst(RegExp('^/'), '');

  static String _name(String path) => path.split(RegExp(r'[\\/]')).last;

  static bool _looksLikeFile(String template) {
    final last = template.split(RegExp(r'[\\/]')).last;
    return last.contains('.') && !last.startsWith('.') && !last.contains('*');
  }
}
