import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Registry for cleaner functions that can be referenced by name
class CleanerRegistry {
  static final Map<String, CleanerFunction> _cleaners = {};

  /// Register a cleaner function with a unique name
  static void register(String name, CleanerFunction cleaner) {
    _cleaners[name] = cleaner;
  }

  /// Get a cleaner function by name
  static CleanerFunction? get(String name) {
    return _cleaners[name];
  }

  /// Check if a cleaner is registered
  static bool has(String name) {
    return _cleaners.containsKey(name);
  }

  /// Get all registered cleaner names
  static List<String> get names => _cleaners.keys.toList();

  /// Clear all registered cleaners
  static void clear() {
    _cleaners.clear();
  }
}