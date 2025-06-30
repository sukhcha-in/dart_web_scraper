import 'dart:convert';

/// WebScraperError Error Exception.
class WebScraperError implements Exception {
  final String message;

  WebScraperError(this.message);

  @override
  String toString() {
    return 'Error: $message';
  }

  /// Creates a WebScraperError instance from Map.
  factory WebScraperError.fromMap(Map<String, dynamic> map) {
    return WebScraperError(map['message']);
  }

  /// Converts the WebScraperError instance to Map.
  Map<String, dynamic> toMap() {
    return {
      'message': message,
    };
  }

  /// Creates a WebScraperError instance from a JSON string.
  factory WebScraperError.fromJson(String json) {
    return WebScraperError.fromMap(jsonDecode(json));
  }

  /// Converts the WebScraperError instance to a JSON string.
  String toJson() {
    return jsonEncode(toMap());
  }
}
