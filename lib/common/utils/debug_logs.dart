import 'dart:io';
import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Used to print logs in console
void printLog(String message, bool debug, {LogColor color = LogColor.reset}) {
  if (!debug) return;

  const Map<LogColor, String> colors = {
    LogColor.reset: '\x1B[0m',
    LogColor.black: '\x1B[30m',
    LogColor.red: '\x1B[31m',
    LogColor.green: '\x1B[32m',
    LogColor.yellow: '\x1B[33m',
    LogColor.blue: '\x1B[34m',
    LogColor.magenta: '\x1B[35m',
    LogColor.cyan: '\x1B[36m',
    LogColor.white: '\x1B[37m',
    LogColor.orange: '\x1B[38;5;208m',
  };

  stdout.write('${colors[color]}$message\n${colors[LogColor.reset]}');
}

/// Save cache to /cache folder in root of this project
void saveCacheLog(String html, bool debug) {
  if (!debug) return;
  try {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String rootPath = findRootDirectory(Directory.current.path);

    File cache = File('$rootPath/cache/cache.html');
    String cacheHtml = cache.readAsStringSync();

    File file = File('$rootPath/cache/$timestamp.html');
    file.writeAsStringSync(cacheHtml);

    cache.writeAsStringSync(html, mode: FileMode.write);
  } catch (e) {
    printLog(
      'Unable to save file to /cache folder',
      debug,
      color: LogColor.red,
    );
  }
}
