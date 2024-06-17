import 'dart:io';
import 'package:path/path.dart' as path;

/// Find root directory of this project
String findRootDirectory(String currentPath) {
  while (!File(path.join(currentPath, 'pubspec.yaml')).existsSync()) {
    currentPath = path.dirname(currentPath);
  }
  return currentPath;
}
