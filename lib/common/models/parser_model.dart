import 'dart:convert';

import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Defines how to extract specific data from HTML or other sources.
///
/// A parser is a configuration block that specifies:
/// - What type of data to extract (text, elements, images, etc.)
/// - Where to find the data (CSS selectors, XPath, etc.)
/// - How to process the extracted data (transformations, cleaning)
/// - When to execute the parser (parent-child relationships)
/// - Whether the result should be public or private
///
/// Parsers can be organized in a hierarchy where child parsers depend
/// on their parent parsers' output, enabling complex nested data extraction.
class Parser {
  /// Unique identifier for this parser's output.
  ///
  /// This ID is used as the key in the final result map. It should be
  /// descriptive of what data this parser extracts (e.g., 'title', 'price', 'description').
  ///
  /// The ID is also used by child parsers to reference this parser as a parent.
  String id;

  /// List of parent parser IDs that this parser depends on.
  ///
  /// This parser will only execute after all its parent parsers have completed.
  /// Use `['_root']` for parsers that should execute first (root parsers).
  ///
  /// Examples:
  /// - `['_root']` - executes first, no dependencies
  /// - `['product']` - executes after the 'product' parser completes
  /// - `['product', 'category']` - executes after both 'product' and 'category' parsers complete
  List<String> parents;

  /// Whether this parser's output should be kept private.
  ///
  /// If `true`, the parser's result will be used internally but not included
  /// in the final output returned to the user. This is useful for parsers
  /// that extract intermediate data needed by other parsers.
  ///
  /// Defaults to `false` (public).
  bool isPrivate = false;

  /// The type of parser that determines how data is extracted.
  ///
  /// Different parser types have different capabilities:
  /// - [ParserType.element] - extracts HTML elements
  /// - [ParserType.text] - extracts text content
  /// - [ParserType.attribute] - extracts attribute values
  /// - [ParserType.image] - extracts image URLs and metadata
  /// - [ParserType.url] - extracts and processes URLs
  /// - [ParserType.json] - extracts and parses JSON data
  /// - [ParserType.http] - makes HTTP requests to extract data
  /// - And many more specialized types...
  ParserType type;

  /// CSS selectors used to locate elements in the HTML.
  ///
  /// These selectors are used to find the specific elements that contain
  /// the data you want to extract. Multiple selectors can be provided;
  /// the parser will try each one until it finds a match.
  ///
  /// Examples:
  /// - `['.product-title']` - finds elements with class 'product-title'
  /// - `['h1', 'h2']` - tries h1 first, then h2 if h1 not found
  /// - `['_self']` - uses the parent element directly
  List<String> selectors;

  /// Whether this parser can extract multiple results.
  ///
  /// If `true`, the parser will return a list of results (e.g., all products
  /// on a page). If `false`, it will return a single result.
  ///
  /// When `true`, child parsers will be executed for each item in the list.
  ///
  /// Defaults to `false` (single result).
  bool multiple = false;

  /// Parser-specific configuration options that control how the parser behaves.
  ///
  /// These options configure the parser's behavior during data extraction,
  /// such as HTTP request settings for HTTP parsers. This is separate from
  /// data transformations that are applied after extraction.
  ParserOptions? parserOptions;

  /// Data transformation options to apply after extraction.
  ///
  /// These transformations can modify the extracted data before it's
  /// returned or passed to child parsers. Examples include:
  /// - Text cleaning and formatting
  /// - Regular expression replacements
  /// - String manipulation (trim, split, etc.)
  /// - Data type conversions
  TransformationOptions? transformationOptions;

  /// Custom cleaning function to process extracted data.
  ///
  /// This function is called after transformations are applied. It can
  /// perform any custom data processing, validation, or cleaning.
  ///
  /// The function receives the extracted data and debug flag, and should
  /// return the cleaned data or null if cleaning fails.
  CleanerFunction? cleaner;

  /// Name of the registered cleaner function for serialization.
  ///
  /// When serializing parser configurations, cleaner functions cannot be
  /// directly serialized. Instead, this name is used to look up the
  /// function from the [CleanerRegistry] during deserialization.
  String? cleanerName;

  /// Creates a new Parser instance.
  ///
  /// Parameters:
  /// - [id]: Unique identifier for the parser's output
  /// - [parents]: List of parent parser IDs this parser depends on
  /// - [type]: Type of parser (element, text, image, etc.)
  /// - [selectors]: CSS selectors to locate elements (default: empty list)
  /// - [isPrivate]: Whether output should be private (default: false)
  /// - [multiple]: Whether to extract multiple results (default: false)
  /// - [parserOptions]: Parser-specific configuration options (optional)
  /// - [transformationOptions]: Data transformation configuration (optional)
  /// - [cleaner]: Custom cleaning function (optional)
  /// - [cleanerName]: Name of registered cleaner function (optional)
  Parser({
    required this.id,
    required this.parents,
    required this.type,
    this.selectors = const [],
    this.isPrivate = false,
    this.multiple = false,
    this.parserOptions,
    this.transformationOptions,
    this.cleaner,
    this.cleanerName,
  }) {
    /// Resolve cleaner function from registry if cleanerName is provided
    if (cleanerName != null) {
      cleaner = CleanerRegistry.resolve(cleanerName);
    }
  }

  /// Creates a Parser instance from a Map.
  ///
  /// This factory constructor is used for deserializing parser configurations
  /// from JSON or other map-based formats.
  ///
  /// Parameters:
  /// - [map]: Map containing parser configuration data
  ///
  /// Returns:
  /// - New Parser instance with data from the map
  factory Parser.fromMap(Map<String, dynamic> map) {
    return Parser(
      id: map['id'],
      parents: List<String>.from(map['parent']),
      type: ParserType.values.firstWhere(
        (e) => e.toString() == 'ParserType.${map['type']}',
      ),
      selectors: map['selectors'] != null
          ? List<String>.from(map['selectors'])
          : const [],
      isPrivate: map['isPrivate'] ?? false,
      multiple: map['multiple'] ?? false,
      parserOptions: map['parserOptions'] != null
          ? ParserOptions.fromMap(map['parserOptions'])
          : null,
      transformationOptions: map['transformationOptions'] != null
          ? TransformationOptions.fromMap(map['transformationOptions'])
          : null,
      cleanerName: map['cleanerName'],

      /// Note: cleaner function will be resolved from registry using cleanerName
    );
  }

  /// Converts the Parser instance to a Map.
  ///
  /// This method is used for serializing the parser configuration to JSON
  /// or other map-based formats.
  ///
  /// Returns:
  /// - Map containing all parser configuration data
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parent': parents,
      'type': type.toString().split('.').last,
      'selectors': selectors,
      'isPrivate': isPrivate,
      'multiple': multiple,
      'parserOptions': parserOptions?.toMap(),
      'transformationOptions': transformationOptions?.toMap(),
      'cleanerName': cleanerName,

      /// Note: cleaner function is serialized via cleanerName reference
    };
  }

  /// Creates a Parser instance from a JSON string.
  ///
  /// This factory constructor is used for deserializing parser configurations
  /// from JSON strings.
  ///
  /// Parameters:
  /// - [json]: JSON string containing parser configuration data
  ///
  /// Returns:
  /// - New Parser instance with data from the JSON
  factory Parser.fromJson(String json) {
    return Parser.fromMap(jsonDecode(json));
  }

  /// Converts the Parser instance to a JSON string.
  ///
  /// This method is used for serializing the parser configuration to JSON.
  ///
  /// Returns:
  /// - JSON string containing all parser configuration data
  String toJson() {
    return jsonEncode(toMap());
  }
}
