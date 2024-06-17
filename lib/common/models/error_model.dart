/// Spider Error Exception.
class SpiderError implements Exception {
  final String message;

  SpiderError(this.message);

  @override
  String toString() {
    return 'Error: $message';
  }
}
