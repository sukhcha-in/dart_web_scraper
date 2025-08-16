import 'dart:io';
import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:path/path.dart' as path;

/// Prints colored log messages to stdout for IO platforms (Dart VM, Flutter).
///
/// This function provides debug logging with color coding for different types
/// of messages. It only outputs messages when debug mode is enabled, making
/// it safe to use in production code.
///
/// The function supports various colors for different message types:
/// - [LogColor.red] - Errors and failures
/// - [LogColor.green] - Success messages
/// - [LogColor.yellow] - Warnings
/// - [LogColor.blue] - Information and progress
/// - [LogColor.orange] - Highlights and important notes
/// - [LogColor.cyan] - Debug details
///
/// Parameters:
/// - [message]: The log message to print
/// - [debug]: Whether debug mode is enabled (only prints if true)
/// - [color]: Color to use for the message (default: reset/white)
///
/// Example:
/// ```dart
/// printLog('Starting scraping process...', debug, color: LogColor.blue);
/// printLog('Data extracted successfully!', debug, color: LogColor.green);
/// printLog('Network error occurred', debug, color: LogColor.red);
/// ```
void printLog(String message, bool debug, {LogColor color = LogColor.reset}) {
  if (!debug) return;

  /// ANSI color codes for terminal output
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

  /// Write colored message to stdout with newline and reset color
  stdout.write('${colors[color]}$message\n${colors[LogColor.reset]}');
}

/// Saves HTML content to dump file for debugging purposes.
///
/// This function is used to save HTML content to timestamped files in a dump
/// directory. It's useful for debugging scraping issues by preserving the
/// HTML content that was processed.
///
/// The function:
/// 1. Creates a dump directory if it doesn't exist
/// 2. Saves the current dump.html content to a timestamped file
/// 3. Updates dump.html with the new HTML content
///
/// Parameters:
/// - [html]: The HTML content to save
/// - [debug]: Whether debug mode is enabled (only saves if true)
///
/// Example:
/// ```dart
/// dumpResponse('<html>...</html>', debug);
/// ```

void dumpResponseToFile({required String html, required bool debug}) {
  if (!debug) return;

  try {
    // Generate timestamp for unique filename
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final currentDir = Directory.current;

    // Ensure dump folder exists
    final dumpDir = Directory(path.join(currentDir.path, 'dump'));
    if (!dumpDir.existsSync()) {
      dumpDir.createSync(recursive: true);
      print('Created dump folder at: ${dumpDir.path}');
    }

    // The main dump.html file inside /dump
    final dumpLocation = File(path.join(dumpDir.path, 'dump.html'));

    String oldFileContent = '';
    if (dumpLocation.existsSync()) {
      // Read current dump.html
      oldFileContent = dumpLocation.readAsStringSync();

      // Save old dump content to a timestamped file inside /dump
      final oldDump = File(path.join(dumpDir.path, '$timestamp.html'));
      oldDump.writeAsStringSync(oldFileContent);
    }

    // Update or create dump.html with new content
    dumpLocation.writeAsStringSync(html, mode: FileMode.write);

    print('Dump saved at: ${dumpLocation.path}');
  } catch (e) {
    print('Unable to save file, error: $e');
  }
}

/// Finds the root directory of the current Dart project.
///
/// This function traverses up the directory tree from the current path
/// until it finds a directory containing a `pubspec.yaml` file, which
/// indicates the root of a Dart project.
///
/// This is useful for locating project-specific directories like dump
/// folders or configuration files relative to the project root.
///
/// Parameters:
/// - [currentPath]: The starting path to search from
///
/// Returns:
/// - The absolute path to the project root directory
///
/// Example:
/// ```dart
/// String root = findRootDirectory('/path/to/project/lib/utils');
/// // Returns: /path/to/project
/// ```
String findRootDirectory(String currentPath) {
  /// Traverse up the directory tree until pubspec.yaml is found
  while (!File(path.join(currentPath, 'pubspec.yaml')).existsSync()) {
    currentPath = path.dirname(currentPath);
  }
  return currentPath;
}
