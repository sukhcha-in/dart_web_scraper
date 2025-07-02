import 'dart:convert';

/// Configuration options for static value parser behavior.
///
/// This class contains configuration for returning static values
/// without any data extraction. It's useful when you need to return
/// predefined values instead of extracting data from web pages.
///
/// Example usage:
/// ```dart
/// // Return a static string
/// StaticValueParserOptions(stringValue: "Hello World")
///
/// // Return a static map
/// StaticValueParserOptions(mapValue: {"key": "value", "count": 42})
/// ```
class StaticValueParserOptions {
  /// Static string value to return when parsing.
  ///
  /// When this field is set, the parser will return this string value
  /// instead of extracting data from the web page. This is useful for
  /// returning constant values or placeholders.
  ///
  /// If both [stringValue] and [mapValue] are provided, [stringValue] takes precedence.
  final String? stringValue;

  /// Static map value to return when parsing.
  ///
  /// When this field is set, the parser will return this map value
  /// instead of extracting data from the web page. This is useful for
  /// returning structured data or configuration objects.
  ///
  /// The map can contain any combination of string keys and object values.
  /// If both [stringValue] and [mapValue] are provided, [stringValue] takes precedence.
  final Map<String, Object>? mapValue;

  /// Creates a new instance of [StaticValueParserOptions].
  ///
  /// At least one of [stringValue] or [mapValue] should be provided.
  /// If both are provided, [stringValue] will be used and [mapValue] will be ignored.
  ///
  /// Parameters:
  /// - [stringValue]: Optional static string to return
  /// - [mapValue]: Optional static map to return
  StaticValueParserOptions({
    this.stringValue,
    this.mapValue,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stringValue': stringValue,
      'mapValue': mapValue,
    };
  }

  factory StaticValueParserOptions.fromMap(Map<String, dynamic> map) {
    return StaticValueParserOptions(
      stringValue:
          map['stringValue'] != null ? map['stringValue'] as String : null,
      mapValue: map['mapValue'] != null
          ? Map<String, Object>.from(map['mapValue'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StaticValueParserOptions.fromJson(String source) =>
      StaticValueParserOptions.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
