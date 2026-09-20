import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/SettingsSection.dart';
import '../l10n/app_localizations.dart';
import '../utils/LoggerService.dart';
import '../utils/ScreenWakelock.dart';
import '../utils/WellKnownService.dart';
import '../utils/upload/UploadApi.dart';
import '../utils/upload/UploadModels.dart';
import '../utils/upload/UploadRunner.dart';
import '../utils/upload/UploadSource.dart';
import 'DownloadsPage.dart' show formatBytes;

/// Admin-only: upload a folder of media into a library directory. Three
/// stages on one page — where and what, the server's preview of how every
/// file will be recognised, and the transfer itself.
///
/// The server decides everything that matters (where a file lands, whether
/// the scanner picks it up, whether it exists); this page only shows it and
/// moves the bytes.
@RoutePage()
class AdminUploadPage extends StatefulWidget {
  final String serverName;

  /// Test seams.
  final UploadApi? api;
  final Future<UploadSourceFolder?> Function()? pickFolder;

  const AdminUploadPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    this.api,
    this.pickFolder,
  });

  @override
  State<AdminUploadPage> createState() => _AdminUploadPageState();
}

class _AdminUploadPageState extends State<AdminUploadPage> {
  late final UploadApi _api = widget.api ?? UploadApi(widget.serverName);
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  final _targetParent = TextEditingController();
  final _rootName = TextEditingController();
  Timer? _previewDebounce;

  List<UploadDirectory>? _directories;
  Object? _loadError;
  String? _libraryId;
  UploadDirectory? _directory;
  UploadSourceFolder? _folder;
  bool _keepFolder = true;
  bool _overwrite = false;
  bool _onlyProblems = false;

  UploadPreview? _preview;
  bool _previewing = false;
  String? _previewError;
  int _previewGeneration = 0;

  UploadRunner? _runner;
  bool _starting = false;

  /// Held while bytes are moving: a phone that dims and suspends the app stops
  /// the upload. Nothing is lost then — it resumes — but it should not happen
  /// merely because nobody touched the screen.
  ScreenWakelockToken? _wakelock;

  /// An upload from an earlier run of the app that the server still holds open.
  ({String sessionId, String nodeUrl, bool s3})? _unfinished;

  String get _prefsKey => 'upload_session_${widget.serverName}';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _previewDebounce?.cancel();
    _runner?.removeListener(_onRunnerChanged);
    _runner?.pause();
    _wakelock?.release();
    _targetParent.dispose();
    _rootName.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final info = WellKnownService.getCached(widget.serverName) ?? await WellKnownService.lastKnown(widget.serverName);
      final directories = await _api.directories(info?.serverUrl ?? widget.serverName);
      await _loadUnfinished();
      if (!mounted) return;
      setState(() {
        _directories = directories ?? const [];
        _loadError = null;
        final libraries = _libraries();
        if (libraries.length == 1) _selectLibrary(libraries.first.libraryId);
      });
    } catch (e) {
      LoggerService().logger.e('Upload directories failed: $e');
      if (mounted) setState(() => _loadError = e);
    }
  }

  Future<void> _loadUnfinished() async {
    final raw = await _prefs.getString(_prefsKey);
    if (raw == null) return;
    try {
      final json = (jsonDecode(raw) as Map).cast<String, dynamic>();
      final session = await _api.session(json['nodeUrl'] as String, json['sessionId'] as String);
      if (session.status == 'ACTIVE' && session.files.any((f) => f.isActive)) {
        _unfinished = (sessionId: session.sessionId, nodeUrl: json['nodeUrl'] as String, s3: json['s3'] == true);
        return;
      }
    } catch (e) {
      LoggerService().logger.w('Stored upload session is gone: $e');
    }
    await _prefs.remove(_prefsKey);
  }

  Future<void> _remember(String sessionId, String nodeUrl, bool s3) async {
    await _prefs.setString(_prefsKey, jsonEncode({'sessionId': sessionId, 'nodeUrl': nodeUrl, 's3': s3}));
  }

  Future<void> _forget() => _prefs.remove(_prefsKey);

  /// One entry per library, in the order the server listed the directories.
  List<UploadDirectory> _libraries() {
    final seen = <String>{};
    return [
      for (final d in _directories ?? const <UploadDirectory>[])
        if (seen.add(d.libraryId)) d
    ];
  }

  void _selectLibrary(String? libraryId) {
    _libraryId = libraryId;
    final candidates = (_directories ?? []).where((d) => d.libraryId == libraryId && d.writable).toList();
    _directory = candidates.length == 1 ? candidates.first : null;
    _schedulePreview();
  }

  // ---- preview ----------------------------------------------------------------------------------

  List<({String relativePath, int size})> _entries() =>
      [for (final f in _folder?.files ?? const <UploadSourceFile>[]) (relativePath: f.relativePath, size: f.size)];

  String? get _effectiveRootName => _keepFolder ? _rootName.text.trim() : null;

  void _schedulePreview() {
    _previewDebounce?.cancel();
    _previewDebounce = Timer(const Duration(milliseconds: 400), _runPreview);
  }

  Future<void> _runPreview() async {
    final directory = _directory;
    final folder = _folder;
    if (directory == null || folder == null || directory.nodeUrl == null) {
      setState(() => _preview = null);
      return;
    }
    final generation = ++_previewGeneration;
    setState(() {
      _previewing = true;
      _previewError = null;
    });
    try {
      final preview = await _api.preview(directory.nodeUrl!,
          directoryId: directory.id,
          targetParent: _targetParent.text.trim(),
          rootName: _effectiveRootName,
          overwrite: _overwrite,
          entries: _entries());
      if (!mounted || generation != _previewGeneration) return;
      setState(() {
        _preview = preview;
        _previewing = false;
      });
    } catch (e) {
      if (!mounted || generation != _previewGeneration) return;
      setState(() {
        _preview = null;
        _previewing = false;
        _previewError = e is UploadApiException ? e.message : e.toString();
      });
    }
  }

  Future<void> _pickFolder() async {
    final folder = await (widget.pickFolder ?? pickUploadFolder)();
    if (folder == null || !mounted) return;
    setState(() {
      _folder = folder;
      _rootName.text = folder.name;
    });
    _runPreview();
  }

  // ---- transfer ---------------------------------------------------------------------------------

  Future<void> _start() async {
    final directory = _directory!;
    final folder = _folder!;
    setState(() => _starting = true);
    try {
      final session = await _api.createSession(directory.nodeUrl!,
          directoryId: directory.id,
          targetParent: _targetParent.text.trim(),
          rootName: _effectiveRootName,
          overwrite: _overwrite,
          entries: _entries());
      final s3 = directory.storageKind == 'S3';
      await _remember(session.sessionId, directory.nodeUrl!, s3);
      _run(session, directory.nodeUrl!, s3, folder);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e is UploadApiException ? e.message : e.toString())));
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  void _run(UploadSession session, String nodeUrl, bool s3, UploadSourceFolder folder) {
    final runner = UploadRunner(
      api: _api,
      nodeUrl: nodeUrl,
      session: session,
      // path AND size: after a restart the admin may pick a folder that merely looks alike
      sources: {
        for (final f in folder.files)
          if (session.files.any((s) => s.relativePath == f.relativePath && s.size == f.size)) f.relativePath: f
      },
      partsAddressedByNumber: s3,
    )..addListener(_onRunnerChanged);
    setState(() {
      _runner = runner;
      _unfinished = null;
    });
    runner.start();
  }

  void _onRunnerChanged() {
    if (!mounted) return;
    final runner = _runner;
    if (runner != null && runner.isFinished && runner.failedCount == 0) _forget();
    if (runner != null && runner.isRunning) {
      _wakelock ??= ScreenWakelock.acquire();
    } else {
      _wakelock?.release();
      _wakelock = null;
    }
    setState(() {});
  }

  Future<void> _resumeUnfinished() async {
    final unfinished = _unfinished!;
    final folder = await (widget.pickFolder ?? pickUploadFolder)();
    if (folder == null || !mounted) return;
    try {
      final session = await _api.session(unfinished.nodeUrl, unfinished.sessionId);
      _run(session, unfinished.nodeUrl, unfinished.s3, folder);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _cancelUnfinished() async {
    final unfinished = _unfinished!;
    try {
      await _api.abort(unfinished.nodeUrl, unfinished.sessionId);
    } catch (e) {
      LoggerService().logger.w('Abort of stored upload failed: $e');
    }
    await _forget();
    if (mounted) setState(() => _unfinished = null);
  }

  Future<void> _confirmCancel() async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(loc.uploadCancelConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(loc.cancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(loc.uploadCancelUpload)),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _runner?.cancel();
    } catch (e) {
      LoggerService().logger.w('Upload cancel failed: $e');
    }
    await _forget();
  }

  void _reset() {
    _runner?.removeListener(_onRunnerChanged);
    setState(() {
      _runner = null;
      _folder = null;
      _preview = null;
      _rootName.clear();
    });
    _load();
  }

  // ---- build ------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.uploadMedia)),
      body: _body(loc),
    );
  }

  Widget _body(AppLocalizations loc) {
    if (!uploadSourceSupported && widget.pickFolder == null) {
      return SettingsEmptyState(icon: Icons.upload_outlined, title: loc.uploadMedia, message: loc.uploadNotSupportedHere);
    }
    if (_loadError != null) {
      return SettingsErrorState(
          message: loc.couldNotLoad, detailsLabel: loc.errorDetails, details: _loadError.toString());
    }
    if (_directories == null) return const Center(child: CircularProgressIndicator());
    if (_runner != null) return _progress(loc, _runner!);
    if (_directories!.isEmpty) {
      return SettingsEmptyState(icon: Icons.folder_off_outlined, title: loc.uploadNoDirectories);
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SettingsIntro(loc.uploadIntro),
        if (_unfinished != null) _unfinishedCard(loc),
        _targetCard(loc),
        const SizedBox(height: 16),
        _sourceCard(loc),
        if (_folder != null && _directory != null) ...[
          const SizedBox(height: 16),
          _previewCard(loc),
        ],
      ],
    );
  }

  Widget _unfinishedCard(AppLocalizations loc) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: SettingsCard(children: [
          ListTile(
            key: const ValueKey('upload-unfinished'),
            leading: const Icon(Icons.history),
            title: Text(loc.uploadUnfinishedTitle),
            subtitle: Text(loc.uploadUnfinishedBody),
          ),
          OverflowBar(alignment: MainAxisAlignment.end, children: [
            TextButton(onPressed: _cancelUnfinished, child: Text(loc.uploadCancelUpload)),
            FilledButton.tonal(onPressed: _resumeUnfinished, child: Text(loc.uploadPickFolder)),
            const SizedBox(width: 8),
          ]),
        ]),
      );

  Widget _targetCard(AppLocalizations loc) {
    final libraries = _libraries();
    final directories = _directories!.where((d) => d.libraryId == _libraryId).toList();
    return SettingsCard(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: DropdownButtonFormField<String>(
          key: const ValueKey('upload-library'),
          initialValue: _libraryId,
          decoration: InputDecoration(labelText: loc.uploadLibrary),
          items: [for (final l in libraries) DropdownMenuItem(value: l.libraryId, child: Text(l.libraryName))],
          onChanged: (value) => setState(() => _selectLibrary(value)),
        ),
      ),
      if (_libraryId != null)
        RadioGroup<String>(
          groupValue: _directory?.id,
          onChanged: (id) => setState(() {
            _directory = directories.firstWhere((d) => d.id == id);
            _schedulePreview();
          }),
          child: Column(children: [
            for (final d in directories)
              RadioListTile<String>(
                key: ValueKey('upload-directory-${d.name}'),
                value: d.id,
                enabled: d.writable,
                title: Text(d.name),
                subtitle: Text(d.writable
                    ? (d.freeBytes == null
                        ? '${d.storageKind} · ${d.nodeName ?? ''}'
                        : loc.uploadDirectoryFree(formatBytes(d.freeBytes!), d.nodeName ?? ''))
                    : loc.uploadDirectoryNotWritable),
              ),
          ]),
        ),
      if (_directory != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: TextField(
            key: const ValueKey('upload-target-parent'),
            controller: _targetParent,
            decoration: InputDecoration(labelText: loc.uploadTargetParent, helperText: loc.uploadTargetParentHint, helperMaxLines: 2),
            onChanged: (_) => _schedulePreview(),
          ),
        ),
    ]);
  }

  Widget _sourceCard(AppLocalizations loc) {
    final folder = _folder;
    return SettingsCard(children: [
      ListTile(
        key: const ValueKey('upload-pick-folder'),
        leading: const Icon(Icons.folder_open_outlined),
        title: Text(folder == null
            ? loc.uploadPickFolder
            : loc.uploadPickedFolder(folder.name, folder.files.length, formatBytes(folder.totalBytes))),
        trailing: const Icon(Icons.chevron_right),
        enabled: _directory != null,
        onTap: _pickFolder,
      ),
      if (folder != null) ...[
        SwitchListTile(
          key: const ValueKey('upload-keep-folder'),
          title: Text(loc.uploadKeepFolder),
          subtitle: Text(loc.uploadKeepFolderSubtitle),
          value: _keepFolder,
          onChanged: (value) => setState(() {
            _keepFolder = value;
            _schedulePreview();
          }),
        ),
        if (_keepFolder)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              key: const ValueKey('upload-root-name'),
              controller: _rootName,
              decoration: InputDecoration(labelText: loc.uploadFolderName),
              onChanged: (_) => _schedulePreview(),
            ),
          ),
        SwitchListTile(
          key: const ValueKey('upload-overwrite'),
          title: Text(loc.uploadOverwrite),
          subtitle: Text(loc.uploadOverwriteSubtitle),
          value: _overwrite,
          onChanged: (value) => setState(() {
            _overwrite = value;
            _schedulePreview();
          }),
        ),
      ],
    ]);
  }

  Widget _previewCard(AppLocalizations loc) {
    final theme = Theme.of(context);
    final preview = _preview;
    if (_previewError != null) {
      return SettingsCard(children: [
        ListTile(leading: Icon(Icons.error_outline, color: theme.colorScheme.error), title: Text(_previewError!)),
      ]);
    }
    if (preview == null) {
      return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
    }
    final entries = _onlyProblems
        ? preview.entries.where((e) => !_willUpload(e)).toList()
        : preview.entries;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SettingsSectionLabel(loc.uploadPreviewTitle),
      SettingsCard(children: [
        for (final root in preview.roots)
          ListTile(
            dense: true,
            leading: Icon(root.level == 'NONE' ? Icons.warning_amber_outlined : Icons.folder_outlined,
                color: root.level == 'NONE' ? theme.colorScheme.error : null),
            title: Text(root.level == 'NONE'
                ? loc.uploadRootLevelNone(root.name)
                : loc.uploadRootLevel(root.name, root.level)),
          ),
        ListTile(
          key: const ValueKey('upload-preview-summary'),
          title: Text(preview.uploadFiles == 0
              ? loc.uploadNothingToUpload
              : loc.uploadPreviewSummary(preview.uploadFiles, formatBytes(preview.uploadBytes))),
          trailing: _previewing ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : null,
        ),
        SwitchListTile(
          dense: true,
          title: Text(loc.uploadShowOnlyProblems),
          value: _onlyProblems,
          onChanged: (value) => setState(() => _onlyProblems = value),
        ),
      ]),
      const SizedBox(height: 12),
      FilledButton.icon(
        key: const ValueKey('upload-start'),
        onPressed: preview.uploadFiles == 0 || _starting || _previewing ? null : _start,
        icon: const Icon(Icons.upload),
        label: Text(loc.uploadStart),
      ),
      const SizedBox(height: 12),
      SettingsCard(children: [for (final entry in entries) _previewTile(loc, theme, entry)]),
    ]);
  }

  bool _willUpload(UploadPreviewEntry entry) =>
      entry.status == UploadPreviewStatus.recognised || (entry.status == UploadPreviewStatus.exists && _overwrite);

  Widget _previewTile(AppLocalizations loc, ThemeData theme, UploadPreviewEntry entry) {
    final (IconData icon, Color color, String label) = switch (entry.status) {
      UploadPreviewStatus.recognised => (Icons.check_circle_outline, theme.colorScheme.primary, loc.uploadStatusRecognised),
      UploadPreviewStatus.exists => _overwrite
          ? (Icons.published_with_changes, theme.colorScheme.tertiary, loc.uploadStatusWillOverwrite)
          : (Icons.file_present_outlined, theme.disabledColor, loc.uploadStatusExists),
      UploadPreviewStatus.busy => (Icons.hourglass_empty, theme.disabledColor, loc.uploadStatusBusy),
      UploadPreviewStatus.invalid => (Icons.error_outline, theme.colorScheme.error, loc.uploadStatusInvalid),
      UploadPreviewStatus.duplicate => (Icons.copy_all_outlined, theme.disabledColor, loc.uploadStatusDuplicate),
      UploadPreviewStatus.ignored => (Icons.block, theme.disabledColor, loc.uploadStatusIgnored),
    };
    final detail = switch (entry.status) {
      UploadPreviewStatus.recognised || UploadPreviewStatus.exists => entry.recognition?.summary() ?? '',
      UploadPreviewStatus.ignored => entry.ignoreReason == 'FOLDER_NOT_SCANNED'
          ? loc.uploadIgnoredFolder(entry.detail ?? '')
          : loc.uploadIgnoredUnsupported,
      UploadPreviewStatus.invalid => entry.detail ?? '',
      _ => '',
    };
    return ListTile(
      dense: true,
      leading: Icon(icon, color: color),
      title: Text(entry.relativePath, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(detail.isEmpty ? label : '$label · $detail', maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: Text(formatBytes(entry.size), style: theme.textTheme.bodySmall),
    );
  }

  Widget _progress(AppLocalizations loc, UploadRunner runner) {
    final theme = Theme.of(context);
    final total = runner.totalBytes;
    final finished = runner.isFinished;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SettingsCard(children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(
                finished
                    ? (runner.failedCount == 0 ? loc.uploadFinished : loc.uploadFinishedWithFailures(runner.failedCount))
                    : loc.uploadProgress(formatBytes(runner.sentBytes), formatBytes(total)),
                key: const ValueKey('upload-progress-label'),
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: total == 0 ? 1 : runner.sentBytes / total),
              const SizedBox(height: 12),
              OverflowBar(alignment: MainAxisAlignment.end, spacing: 8, children: [
                if (!finished)
                  TextButton(onPressed: _confirmCancel, child: Text(loc.uploadCancelUpload)),
                if (!finished && runner.isRunning && !runner.isPaused)
                  FilledButton.tonal(onPressed: runner.pause, child: Text(loc.pause)),
                if (!finished && !runner.isRunning)
                  FilledButton(onPressed: runner.start, child: Text(loc.uploadResume)),
                if (!runner.isRunning && runner.failedCount > 0)
                  FilledButton.tonal(
                    onPressed: () {
                      runner.retryFailed();
                      runner.start();
                    },
                    child: Text(loc.uploadRetryFailed(runner.failedCount)),
                  ),
                if (finished) FilledButton(onPressed: _reset, child: Text(loc.uploadAnother)),
              ]),
            ]),
          ),
        ]),
        const SizedBox(height: 16),
        SettingsCard(children: [for (final item in runner.items) _itemTile(loc, theme, item)]),
      ],
    );
  }

  Widget _itemTile(AppLocalizations loc, ThemeData theme, UploadItem item) {
    final size = item.state.size;
    final subtitle = switch (item.phase) {
      UploadItemPhase.queued => loc.uploadPhaseQueued,
      UploadItemPhase.uploading => loc.uploadProgress(formatBytes(item.sentBytes), formatBytes(size)),
      UploadItemPhase.completing => loc.uploadPhaseCompleting,
      UploadItemPhase.done => loc.uploadPhaseDone,
      UploadItemPhase.skipped => loc.uploadPhaseSkipped,
      UploadItemPhase.failed => item.error == null ? loc.uploadPhaseFailed : '${loc.uploadPhaseFailed} · ${item.error}',
    };
    return ListTile(
      dense: true,
      leading: switch (item.phase) {
        UploadItemPhase.done => Icon(Icons.check_circle_outline, color: theme.colorScheme.primary),
        UploadItemPhase.skipped => Icon(Icons.file_present_outlined, color: theme.disabledColor),
        UploadItemPhase.failed => Icon(Icons.error_outline, color: theme.colorScheme.error),
        UploadItemPhase.queued => Icon(Icons.schedule, color: theme.disabledColor),
        _ => SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 3, value: size == 0 ? null : item.sentBytes / size)),
      },
      title: Text(item.state.relativePath, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
    );
  }
}
