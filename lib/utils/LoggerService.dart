import 'package:logger/logger.dart';

import 'AppLogStore.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  final Logger logger;

  /// Same exported log, no console: for lines the caller already printed
  /// itself (mpv's output), which the console would otherwise show twice.
  final Logger fileLogger;

  factory LoggerService() {
    return _instance;
  }

  LoggerService._internal()
      : logger = Logger(
          // The default DevelopmentFilter drops every event in release builds,
          // which silently turns the exported error log into headers-only.
          filter: ProductionFilter(),
          output: MultiOutput([ConsoleOutput(), AppLogStore.instance.output]),
        ),
        fileLogger = Logger(
          filter: ProductionFilter(),
          output: AppLogStore.instance.output,
        );
}
