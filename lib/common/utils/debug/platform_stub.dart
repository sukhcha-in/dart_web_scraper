import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Web stub for printing logs
void printLog(String message, bool debug, {LogColor color = LogColor.reset}) {
  if (!debug) return;
  // On web, just print
  print(message);
}

void saveCacheLog(String html, bool debug) {
  // No file ops on web
}
