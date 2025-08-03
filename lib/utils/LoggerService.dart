import 'package:logger/logger.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  final Logger logger;

  factory LoggerService() {
    return _instance;
  }

  LoggerService._internal() : logger = Logger();
}
