import 'dart:convert';

/// Custom exception class for web scraping operations.
///
/// This class represents errors that occur during web scraping operations,
/// such as network failures, parsing errors, configuration issues, or
/// unsupported URL patterns.
///
/// The exception includes a descriptive message that explains what went wrong,
/// making it easier to debug and handle errors appropriately.
///
/// Example usage:
/// ```dart
/// try {
///   final data = await scraper.scrape(url: url, scraperConfigMap: config);
/// } on WebScraperError catch (e) {
///   print('Scraping failed: ${e.message}');
/// }
/// ```
class WebScraperError implements Exception {
  /// Descriptive error message explaining what went wrong.
  ///
  /// This message should provide enough detail to understand the error
  /// and potentially fix the underlying issue. Common error messages include:
  /// - "Unsupported URL" - No matching scraper configuration found
  /// - "Unable to fetch data" - Network or HTTP request failed
  /// - "Parser not found" - Invalid parser configuration
  /// - "Invalid selector" - CSS selector syntax error
  final String message;

  /// HTTP status code associated with the error, when applicable.
  ///
  /// Set when the error originates from an HTTP response, e.g. `404` when a URL
  /// is no longer available. Null for non-HTTP errors (configuration issues,
  /// network failures, etc.).
  final int? statusCode;

  /// Creates a new WebScraperError instance.
  ///
  /// Parameters:
  /// - [message]: Descriptive error message
  /// - [statusCode]: Optional HTTP status code associated with the error
  WebScraperError(this.message, {this.statusCode});

  /// Returns a string representation of the error.
  ///
  /// This method is used when the exception is converted to a string,
  /// such as when printing to console or logging.
  ///
  /// Returns:
  /// - Formatted error string with the error message
  @override
  String toString() {
    if (statusCode != null) {
      return 'Error ($statusCode): $message';
    }
    return 'Error: $message';
  }

  /// Creates a WebScraperError instance from a Map.
  ///
  /// This factory constructor is used for deserializing error data from JSON
  /// or other map-based formats.
  ///
  /// Parameters:
  /// - [map]: Map containing error message
  ///
  /// Returns:
  /// - New WebScraperError instance with message from the map
  factory WebScraperError.fromMap(Map<String, dynamic> map) {
    return WebScraperError(
      map['message'],
      statusCode: map['statusCode'] as int?,
    );
  }

  /// Converts the WebScraperError instance to a Map.
  ///
  /// This method is used for serializing the error to JSON or other
  /// map-based formats.
  ///
  /// Returns:
  /// - Map containing the error message
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'statusCode': statusCode,
    };
  }

  /// Creates a WebScraperError instance from a JSON string.
  ///
  /// This factory constructor is used for deserializing error data from JSON strings.
  ///
  /// Parameters:
  /// - [json]: JSON string containing error message
  ///
  /// Returns:
  /// - New WebScraperError instance with message from the JSON
  ///
  /// Throws:
  /// - FormatException if the JSON is invalid
  factory WebScraperError.fromJson(String json) {
    return WebScraperError.fromMap(jsonDecode(json));
  }

  /// Converts the WebScraperError instance to a JSON string.
  ///
  /// This method is used for serializing the error to JSON format.
  ///
  /// Returns:
  /// - JSON string containing the error message
  String toJson() {
    return jsonEncode(toMap());
  }
}
