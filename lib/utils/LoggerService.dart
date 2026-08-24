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
          output: MultiOutput([ConsoleOutput(), AppLogStore.instance.output]),
        );
}
