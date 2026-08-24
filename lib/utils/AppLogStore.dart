import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import 'AppVersion.dart';

/// Rolling on-disk copy of everything [Logger] emits, so a crash can be
/// diagnosed from the *next* run — the settings page exports it via
/// "Save error log".
///
/// Follows the DownloadStore conventions: [rootOverride] is the test seam,
/// and the path_provider lookup is never awaited on a UI path — under
/// `flutter test` it never completes, so events simply stay in the memory
/// buffer until [install] resolves (or forever, harmlessly, in tests).
class AppLogStore {
  AppLogStore({
    this.rootOverride,
    int maxFileBytes = 1024 * 1024,
    this.maxExportBytes = 2 * 1024 * 1024,
  }) : output = RotatingFileOutput(maxFileBytes: maxFileBytes);

  static final AppLogStore instance = AppLogStore();

  final Directory? rootOverride;

  /// Cap on the exported bytes (old + current generation); the tail wins.
  final int maxExportBytes;

  final RotatingFileOutput output;

  Future<void>? _installing;

  /// Resolves the log directory and attaches the file output. Fire-and-forget
  /// from main(); a no-op on web. Never throws — logging must never take the
  /// app down, so on any failure the log stays memory-only.
  Future<void> install() {
    if (kIsWeb) return Future.value();
    return _installing ??= () async {
      try {
        final root = rootOverride ??
            Directory('${(await getApplicationSupportDirectory()).path}/logs');
        await root.create(recursive: true);
        var version = 'unknown';
        try {
          version = await appVersionString();
        } catch (_) {
          // No platform channel (tests) — keep the placeholder.
        }
        output.attach(
          root,
          '==== Ister Player session ${DateTime.now().toIso8601String()} '
          '| $version | ${defaultTargetPlatform.name} ====',
        );
      } catch (_) {}
    }();
  }

  /// The log content to save: old generation + current file + any lines still
  /// waiting in the memory buffer, capped to [maxExportBytes]. Null on web or
  /// when nothing has been logged yet.
  Future<Uint8List?> exportBytes() async {
    if (kIsWeb) return null;
    final text = output.exportText();
    if (text.isEmpty) return null;
    var bytes = utf8.encode(text);
    if (bytes.length > maxExportBytes) {
      bytes = Uint8List.sublistView(bytes, bytes.length - maxExportBytes);
    }
    return bytes;
  }
}

/// Appends log events to `ister.log`, rotating one old generation
/// (`ister.log.1`) past [maxFileBytes]. Before [attach] — and forever under
/// `flutter test` — events collect in a bounded memory buffer instead.
class RotatingFileOutput extends LogOutput {
  RotatingFileOutput({required this.maxFileBytes});

  static const int _maxBufferedEvents = 200;
  static final RegExp _ansi = RegExp('\x1B\\[[0-9;]*m');

  final int maxFileBytes;

  final List<String> _buffer = [];
  Directory? _dir;
  File? _file;
  int _size = 0;

  @override
  void output(OutputEvent event) {
    if (event.lines.isEmpty) return;
    // The console printer's ANSI colors don't belong in a file.
    final lines =
        event.lines.map((line) => line.replaceAll(_ansi, '')).toList();
    lines[0] = '${DateTime.now().toIso8601String()} ${lines[0]}';
    final chunk = lines.join('\n');
    if (_dir == null) {
      _buffer.add(chunk);
      if (_buffer.length > _maxBufferedEvents) _buffer.removeAt(0);
      return;
    }
    _write('$chunk\n');
  }

  void attach(Directory dir, String header) {
    _dir = dir;
    final file = File('${dir.path}/ister.log');
    _file = file;
    try {
      _size = file.existsSync() ? file.lengthSync() : 0;
    } catch (_) {
      _size = 0;
    }
    final pending = _buffer.toList();
    _buffer.clear();
    _write('${[header, ...pending].join('\n')}\n');
  }

  void _write(String chunk) {
    if (_file == null) return;
    try {
      if (_size > maxFileBytes) _rotate();
      _file!.writeAsStringSync(chunk, mode: FileMode.append);
      _size += chunk.length;
    } catch (_) {}
  }

  void _rotate() {
    final dir = _dir!;
    final old = File('${dir.path}/ister.log.1');
    try {
      if (old.existsSync()) old.deleteSync();
      _file!.renameSync(old.path);
    } catch (_) {}
    _file = File('${dir.path}/ister.log');
    _size = 0;
  }

  /// Old generation + current file + still-buffered lines, in that order.
  String exportText() {
    final parts = <String>[];
    final dir = _dir;
    if (dir != null) {
      for (final name in ['ister.log.1', 'ister.log']) {
        try {
          final file = File('${dir.path}/$name');
          if (file.existsSync()) parts.add(file.readAsStringSync());
        } catch (_) {}
      }
    }
    if (_buffer.isNotEmpty) parts.add('${_buffer.join('\n')}\n');
    return parts.join();
  }
}
