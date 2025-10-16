import 'package:flutter/services.dart';

import 'LanguageData.dart';

class LanguageService {
  // Private constructor
  LanguageService._privateConstructor();

  // Singleton instance
  static final LanguageService _instance =
      LanguageService._privateConstructor();

  // Factory constructor to return the single instance
  factory LanguageService() {
    return _instance;
  }

  List<LanguageData>? _cache;

  Future<List<LanguageData>> loadLanguageData() async {
    if (_cache == null) {
      final String response =
          await rootBundle.loadString('assets/iso-639-3.tab');
      final List<String> lines = response.split('\n');
      _cache = [];

      // Skip the first line
      for (var i = 1; i < lines.length; i++) {
        var line = lines[i];
        if (line.trim().isNotEmpty) {
          List<String> fields = line.split('\t');
          _cache!.add(LanguageData.fromCsv(fields));
        }
      }
    }
    return _cache!;
  }

  // The getLanguageData method with a nullable return type
  Future<LanguageData?> getLanguageData(String query) async {
    // Ensure data is loaded
    _cache ??= await loadLanguageData();

    // Finding the matching LanguageData
    return _cache!.where(
      (data) =>
          data.id == query ||
          data.part2b == query ||
          data.part2t == query ||
          data.part1 == query,
    ).firstOrNull;
  }

  Future<List<LanguageData>> getAllLanguages() async {
    // Ensure data is loaded
    _cache ??= await loadLanguageData();
    return _cache!; // Return all cached languages
  }
}
