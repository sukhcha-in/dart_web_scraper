/// WebScraperError Error Exception.
class WebScraperError implements Exception {
  final String message;

  WebScraperError(this.message);

  @override
  String toString() {
    return 'Error: $message';
  }
}
