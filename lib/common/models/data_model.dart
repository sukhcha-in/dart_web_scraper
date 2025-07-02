import 'dart:convert';

/// Container for scraped data that includes both the source URL and extracted content.
///
/// This class serves as a wrapper for data extracted during web scraping operations.
/// It maintains the relationship between the source URL and the extracted data,
/// which is essential for tracking data provenance and handling relative URLs.
///
/// The [obj] field can contain any type of data:
/// - HTML elements `(Element, List<Element>)`
/// - Text content (String)
/// - Structured data (Map, List)
/// - Parsed JSON data
/// - Any other extracted content
class Data {
  /// The source URL where the data was extracted from.
  ///
  /// This URL is used for:
  /// - Tracking data provenance
  /// - Resolving relative URLs in extracted content
  /// - Debugging and logging purposes
  /// - Building absolute URLs from relative paths
  Uri url;

  /// The extracted data content.
  ///
  /// This field can contain any type of data depending on the parser type:
  /// - [Element] or [List<Element>] for HTML element parsers
  /// - [String] for text parsers
  /// - [Map] for JSON parsers
  /// - [List] for multiple result parsers
  /// - Any other data type returned by specialized parsers
  Object obj;

  /// Creates a new Data instance.
  ///
  /// Parameters:
  /// - [url]: The source URL where data was extracted from
  /// - [obj]: The extracted data content
  Data(
    this.url,
    this.obj,
  );

  /// Creates a Data instance from a Map.
  ///
  /// This factory constructor is used for deserializing data from JSON
  /// or other map-based formats.
  ///
  /// Parameters:
  /// - [map]: Map containing URL and data content
  ///
  /// Returns:
  /// - New Data instance with data from the map
  ///
  /// Throws:
  /// - FormatException if the URL string is invalid
  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      Uri.parse(map['url']),
      map['obj'],
    );
  }

  /// Converts the Data instance to a Map.
  ///
  /// This method is used for serializing the data to JSON or other
  /// map-based formats.
  ///
  /// Returns:
  /// - Map containing URL and data content
  Map<String, dynamic> toMap() {
    return {
      'url': url.toString(),
      'obj': obj,
    };
  }

  /// Creates a Data instance from a JSON string.
  ///
  /// This factory constructor is used for deserializing data from JSON strings.
  ///
  /// Parameters:
  /// - [json]: JSON string containing URL and data content
  ///
  /// Returns:
  /// - New Data instance with data from the JSON
  ///
  /// Throws:
  /// - FormatException if the JSON is invalid or URL is malformed
  factory Data.fromJson(String json) {
    return Data.fromMap(jsonDecode(json));
  }

  /// Converts the Data instance to a JSON string.
  ///
  /// This method is used for serializing the data to JSON format.
  ///
  /// Returns:
  /// - JSON string containing URL and data content
  String toJson() {
    return jsonEncode(toMap());
  }
}
