import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/games/GameApi.dart';
import 'package:player/utils/games/GameInstallStore.dart';

import 'SavePathResolver.dart';
import 'SaveSnapshot.dart';

/// What the sync found before a launch.
enum SavePullOutcome {
  /// Nothing newer on the server; local saves stay.
  upToDate,

  /// The server head was downloaded and unpacked.
  downloaded,

  /// The server has a newer head *and* the local saves changed since the last
  /// sync: the caller must ask the user ([SaveSyncService.resolveConflict]).
  conflict,

  /// No save locations are known for this game.
  noSlots,
}

class SavePullResult {
  const SavePullResult(this.outcome, {this.serverHead, this.localFingerprint});
  final SavePullOutcome outcome;
  final GameSaveInfo? serverHead;
  final String? localFingerprint;
}

/// Keeps a game's local save folders and the server's snapshots in step.
/// Before a launch the newer side wins unless both changed (a conflict the
/// user settles); after a launch the local folders are zipped and uploaded as
/// the next version, with the version the client started from as the base so
/// the server can detect a device that played in between.
class SaveSyncService {
  SaveSyncService({required this.api, required this.store, required this.serverName, required this.deviceName});

  final GameApi api;
  final GameInstallStore store;
  final String serverName;
  final String deviceName;

  /// Downloads the server head when it is newer than what this device synced
  /// last. Returns [SavePullOutcome.conflict] when local files changed too.
  Future<SavePullResult> pull(GameInstall install, List<SaveSlot> slots) async {
    if (slots.isEmpty) return const SavePullResult(SavePullOutcome.noSlots);
    final saves = await api.saves(install.gameId);
    if (saves.isEmpty) return const SavePullResult(SavePullOutcome.upToDate);
    final head = saves.first;
    final fingerprint = await Isolate.run(() => SaveSnapshot.fingerprint(slots));
    if (head.version <= install.lastSaveVersion) {
      return SavePullResult(SavePullOutcome.upToDate, serverHead: head, localFingerprint: fingerprint);
    }
    final localChanged = install.lastSaveSha != null && install.lastSaveSha != fingerprint;
    if (localChanged) {
      return SavePullResult(SavePullOutcome.conflict, serverHead: head, localFingerprint: fingerprint);
    }
    await applyServerHead(install, slots, head);
    return SavePullResult(SavePullOutcome.downloaded, serverHead: head);
  }

  /// Downloads and unpacks [head] over the local slots.
  Future<void> applyServerHead(GameInstall install, List<SaveSlot> slots, GameSaveInfo head) async {
    final zip = File('${install.tmpDir.path}${Platform.pathSeparator}save-v${head.version}.zip');
    await api.downloadSave(install.gameId, head.version, zip);
    await Isolate.run(() => SaveSnapshot.unpack(zip, slots));
    install.lastSaveVersion = head.version;
    install.lastSaveSha = await Isolate.run(() => SaveSnapshot.fingerprint(slots));
    await store.put(serverName, install);
    try {
      await zip.delete();
    } catch (_) {}
  }

  /// Records the slots' current content as what was last synced, after the
  /// slot list changed (a pull created folders the plan did not know).
  Future<void> refreshFingerprint(GameInstall install, List<SaveSlot> slots) async {
    install.lastSaveSha = await Isolate.run(() => SaveSnapshot.fingerprint(slots));
    await store.put(serverName, install);
  }

  /// Uploads the local saves as a new version. Returns null when nothing
  /// changed since the last sync (no upload needed). Throws
  /// [GameSaveConflict] when the server head moved; [force] overrides.
  Future<GameSaveInfo?> push(GameInstall install, List<SaveSlot> slots, {bool force = false, String? note}) async {
    if (slots.isEmpty) return null;
    final fingerprint = await Isolate.run(() => SaveSnapshot.fingerprint(slots));
    if (!force && fingerprint == install.lastSaveSha) return null;
    final zip = File('${install.tmpDir.path}${Platform.pathSeparator}save-upload.zip');
    final sha = await Isolate.run(() => SaveSnapshot.pack(slots, zip));
    if (sha == null) return null;
    try {
      final uploaded = await api.uploadSave(install.gameId, zip,
          baseVersion: install.lastSaveVersion, force: force, device: deviceName, note: note, sha256: sha);
      install.lastSaveVersion = uploaded.version;
      install.lastSaveSha = fingerprint;
      await store.put(serverName, install);
      await _clearOutbox(install);
      return uploaded;
    } on GameSaveConflict {
      rethrow;
    } catch (e) {
      // Network gone: keep the zip for the next attempt (replayOutbox).
      LoggerService().logger.w('Save upload failed for ${install.gameId}: $e');
      await install.savesDir.create(recursive: true);
      final outbox = File('${install.dir}${Platform.pathSeparator}outbox-${DateTime.now().millisecondsSinceEpoch}.zip');
      await zip.copy(outbox.path);
      rethrow;
    } finally {
      try {
        await zip.delete();
      } catch (_) {}
    }
  }

  /// Re-sends snapshots a previous session could not upload. Best effort.
  Future<void> replayOutbox(GameInstall install) async {
    final dir = Directory(install.dir);
    if (!await dir.exists()) return;
    final pending = <File>[];
    await for (final entity in dir.list()) {
      if (entity is File && entity.uri.pathSegments.last.startsWith('outbox-')) pending.add(entity);
    }
    pending.sort((a, b) => a.path.compareTo(b.path));
    for (final zip in pending) {
      try {
        final uploaded = await api.uploadSave(install.gameId, zip,
            baseVersion: install.lastSaveVersion, force: true, device: deviceName, note: 'queued upload');
        install.lastSaveVersion = uploaded.version;
        await store.put(serverName, install);
        await zip.delete();
      } catch (e) {
        LoggerService().logger.w('Outbox replay failed for ${install.gameId}: $e');
        return;
      }
    }
  }

  Future<void> _clearOutbox(GameInstall install) async {
    final dir = Directory(install.dir);
    if (!await dir.exists()) return;
    await for (final entity in dir.list()) {
      if (entity is File && entity.uri.pathSegments.last.startsWith('outbox-')) {
        try {
          await entity.delete();
        } catch (_) {}
      }
    }
  }
}
