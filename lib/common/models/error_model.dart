/// WebScraperError Error Exception.
class WebScraperError implements Exception {
  final String message;

  WebScraperError(this.message);

  @override
  String toString() {
    return 'Error: $message';
  }

  /// Creates a WebScraperError instance from a JSON map.
  factory WebScraperError.fromJson(Map<String, dynamic> json) {
    return WebScraperError(json['message']);
  }

  /// Converts the WebScraperError instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
