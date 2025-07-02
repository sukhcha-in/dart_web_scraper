import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Web platform implementation of debug logging.
///
/// This function provides debug logging for web platforms (browser environments).
/// Unlike the IO platform version, this implementation doesn't support color
/// coding since browsers don't typically support ANSI color codes in console output.
///
/// The function only outputs messages when debug mode is enabled, making it
/// safe to use in production code.
///
/// Parameters:
/// - [message]: The log message to print
/// - [debug]: Whether debug mode is enabled (only prints if true)
/// - [color]: Color parameter (ignored on web platform for compatibility)
///
/// Example:
/// ```dart
/// printLog('Starting scraping process...', debug);
/// printLog('Data extracted successfully!', debug);
/// printLog('Network error occurred', debug);
/// ```
void printLog(String message, bool debug, {LogColor color = LogColor.reset}) {
  if (!debug) return;

  /// On web platforms, use standard print function
  /// Color parameter is ignored since browsers don't support ANSI colors
  print(message);
}

/// Web platform stub for dumping response to file.
///
/// This function is a stub implementation for web platforms where file system
/// access is not available. It does nothing when called, maintaining API
/// compatibility with the IO platform version.
///
/// Parameters:
/// - [html]: The HTML content to save (ignored on web)
/// - [debug]: Whether debug mode is enabled (ignored on web)
///
/// Note: Web platforms cannot save files to the local file system due to
/// browser security restrictions. Consider using browser storage APIs
/// (localStorage, sessionStorage) for web-specific caching needs.
void dumpResponseToFile(String html, bool debug) {
  /// No file operations available on web platform
  /// This function exists for API compatibility only
}
