import 'package:logger/logger.dart';

import 'AppLogStore.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  final Logger logger;

  factory LoggerService() {
    return _instance;
  }

  LoggerService._internal()
      : logger = Logger(
          // The default DevelopmentFilter drops every event in release builds,
          // which silently turns the exported error log into headers-only.
          filter: ProductionFilter(),
          output: MultiOutput([ConsoleOutput(), AppLogStore.instance.output]),
        );
}
