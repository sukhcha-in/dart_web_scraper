import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'cleaner_registry.dart';

/// Utility class for managing cleaner functions and their serialization
class CleanerUtils {
  /// Register a custom cleaner function
  static void registerCleaner(String name, CleanerFunction cleaner) {
    CleanerRegistry.register(name, cleaner);
  }

  /// Get a cleaner function by name
  static CleanerFunction? getCleaner(String name) {
    return CleanerRegistry.get(name);
  }

  /// Get the cleaner function for a parser, resolving from registry if needed
  static CleanerFunction? resolveCleanerForParser(Parser parser) {
    if (parser.cleaner != null) {
      return parser.cleaner;
    }
    
    if (parser.cleanerName != null) {
      return getCleaner(parser.cleanerName!);
    }
    
    return null;
  }
}