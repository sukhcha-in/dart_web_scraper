import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Function signature for custom data cleaning functions.
///
/// This typedef defines the signature that all cleaner functions must follow.
/// Cleaner functions are called after data extraction and transformation to
/// perform custom data processing, validation, or cleaning.
///
/// Parameters:
/// - [data]: The data to clean, containing URL and extracted content
/// - [debug]: Whether debug mode is enabled for logging
///
/// Returns:
/// - Cleaned data of any type, or null if cleaning fails
///
/// Example:
/// ```dart
/// CleanerFunction myCleaner = (Data data, bool debug) {
///   if (data.obj is String) {
///     return (data.obj as String).trim().toLowerCase();
///   }
///   return null;
/// };
/// ```
typedef CleanerFunction<T> = T Function(Data data, bool debug);

/// Registry for managing custom cleaner functions by name.
///
/// This class provides a centralized registry for cleaner functions that can
/// be referenced by name in parser configurations. This allows cleaner functions
/// to be serialized and deserialized using string names rather than function
/// references, which is useful for configuration-based scraping setups.
///
/// The registry supports:
/// - Registering cleaner functions with unique names
/// - Retrieving cleaner functions by name
/// - Checking if a cleaner is registered
/// - Listing all registered cleaner names
/// - Clearing all registered cleaners
///
/// Example usage:
/// ```dart
/// // Register a cleaner function
/// CleanerRegistry.register('trimText', (data, debug) {
///   if (data.obj is String) {
///     return (data.obj as String).trim();
///   }
///   return null;
/// });
///
/// // Use in parser configuration
/// Parser(
///   id: 'title',
///   parents: ['_root'],
///   type: ParserType.text,
///   selectors: ['.title'],
///   cleanerName: 'trimText', // Reference by name
/// );
/// ```
class CleanerRegistry {
  /// Internal storage for registered cleaner functions.
  ///
  /// Maps cleaner names to their corresponding function implementations.
  static final Map<String, CleanerFunction> _cleaners = {};

  /// Registers a cleaner function with a unique name.
  ///
  /// This method allows you to register a cleaner function that can later
  /// be referenced by name in parser configurations. If a cleaner with the
  /// same name already exists, it will be overwritten.
  ///
  /// Parameters:
  /// - [name]: Unique name to register the cleaner function under
  /// - [cleaner]: The cleaner function to register
  ///
  /// Example:
  /// ```dart
  /// CleanerRegistry.register('removeHtml', (data, debug) {
  ///   if (data.obj is String) {
  ///     return (data.obj as String).replaceAll(RegExp(r'<[^>]*>'), '');
  ///   }
  ///   return null;
  /// });
  /// ```
  static void register(String name, CleanerFunction cleaner) {
    _cleaners[name] = cleaner;
  }

  /// Retrieves a cleaner function by name.
  ///
  /// This method looks up a cleaner function in the registry using its name.
  /// Returns null if the name is null or if no cleaner is registered with
  /// that name.
  ///
  /// Parameters:
  /// - [name]: Name of the cleaner function to retrieve
  ///
  /// Returns:
  /// - The registered cleaner function, or null if not found
  ///
  /// Example:
  /// ```dart
  /// CleanerFunction? cleaner = CleanerRegistry.resolve('trimText');
  /// if (cleaner != null) {
  ///   final result = cleaner(data, debug);
  /// }
  /// ```
  static CleanerFunction? resolve(String? name) {
    if (name == null || !has(name)) {
      return null;
    }
    return _cleaners[name];
  }

  /// Checks if a cleaner function is registered with the given name.
  ///
  /// This method can be used to verify that a cleaner exists before
  /// attempting to resolve it.
  ///
  /// Parameters:
  /// - [name]: Name of the cleaner function to check
  ///
  /// Returns:
  /// - True if a cleaner is registered with the given name, false otherwise
  ///
  /// Example:
  /// ```dart
  /// if (CleanerRegistry.has('trimText')) {
  ///   // Safe to resolve the cleaner
  ///   final cleaner = CleanerRegistry.resolve('trimText');
  /// }
  /// ```
  static bool has(String name) {
    return _cleaners.containsKey(name);
  }

  /// Gets a list of all registered cleaner function names.
  ///
  /// This can be useful for debugging, listing available cleaners, or
  /// validating configuration files.
  ///
  /// Returns:
  /// - List of all registered cleaner names
  ///
  /// Example:
  /// ```dart
  /// List<String> availableCleaners = CleanerRegistry.names;
  /// print('Available cleaners: $availableCleaners');
  /// ```
  static List<String> get names => _cleaners.keys.toList();

  /// Removes all registered cleaner functions from the registry.
  ///
  /// This method clears the entire registry, removing all registered
  /// cleaner functions. Use with caution as this will break any parser
  /// configurations that reference the removed cleaners.
  ///
  /// Example:
  /// ```dart
  /// // Clear all registered cleaners
  /// CleanerRegistry.clear();
  /// ```
  static void clear() {
    _cleaners.clear();
  }
}
