import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/download/DownloadForegroundController.dart';
import 'package:player/utils/download/DownloadService.dart';

/// Keeps the process alive on Android while downloads run, through a
/// `dataSync` foreground service with a progress notification.
///
/// The service carries no work of its own: it is started without a task
/// callback, so no task isolate is spawned and the downloads keep running in
/// the main isolate — the service only pins the process and owns the
/// notification. Swiping the app away stops it (and the downloads), which
/// resume on the next launch; Android 15 caps dataSync services at ~6 hours
/// a day, after which the start request fails and is simply logged — the
/// Dart loop continues while the app is in the foreground.
class DownloadForegroundService {
  DownloadForegroundService._();

  static DownloadForegroundController? _controller;

  static bool get supported => !kIsWeb && Platform.isAndroid;

  static Future<void> install({DownloadService? service}) async {
    if (!supported || _controller != null) return;
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'app.ister.player.channel.downloads',
        channelName: 'Downloads',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(showNotification: false),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        allowAutoRestart: false,
        stopWithTask: true,
      ),
    );
    _controller = DownloadForegroundController(
      service: service ?? DownloadService.instance,
      start: (title, text) async {
        try {
          if (await FlutterForegroundTask.isRunningService) return true;
          final result = await FlutterForegroundTask.startService(
            serviceTypes: [ForegroundServiceTypes.dataSync],
            notificationTitle: title,
            notificationText: text,
          );
          if (result is ServiceRequestFailure) {
            LoggerService().logger.w(
                'download foreground service start refused: ${result.error}');
            return false;
          }
          return true;
        } catch (e) {
          // Refused starts (background, dataSync quota) are not fatal: the
          // download loop itself is unaffected and the start is retried.
          LoggerService().logger.w('download foreground service start failed: $e');
          return false;
        }
      },
      update: (title, text) => _guard('update', () async {
        if (!await FlutterForegroundTask.isRunningService) return;
        await FlutterForegroundTask.updateService(
            notificationTitle: title, notificationText: text);
      }),
      stop: () => _guard('stop', () async {
        if (!await FlutterForegroundTask.isRunningService) return;
        await FlutterForegroundTask.stopService();
      }),
    )..attach();
  }

  static Future<void> _guard(String what, Future<void> Function() body) async {
    try {
      await body();
    } catch (e) {
      // A refused start (dataSync quota, missing permission) is not fatal:
      // the download loop itself is unaffected.
      LoggerService().logger.w('download foreground service $what failed: $e');
    }
  }
}
