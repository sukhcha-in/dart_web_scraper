import 'dart:convert';

/// Configuration options for string between parser behavior.
///
/// This class contains configuration for extracting text between
/// two specified strings.
///
/// The string between parser searches for content that appears between
/// a specified start string and end string in the source text.
/// This is useful for extracting specific sections of text from
/// HTML, JSON, or any other text-based content.
///
/// Example usage:
/// ```dart
/// final options = StringBetweenParserOptions(
///   start: '<title>',
///   end: '</title>'
/// );
/// ```
class StringBetweenParserOptions {
  /// Starting string to look for
  ///
  /// This is the string that marks the beginning of the content
  /// to be extracted. The parser will search for this string
  /// in the source text and start extracting from the position
  /// immediately after this string.
  ///
  /// Must not be null or empty.
  final String start;

  /// Ending string to look for
  ///
  /// This is the string that marks the end of the content
  /// to be extracted. The parser will search for this string
  /// starting from the position after the start string and
  /// stop extracting at the position where this string begins.
  ///
  /// Must not be null or empty.
  final String end;

  /// Creates a new StringBetweenParserOptions instance.
  ///
  /// Both [start] and [end] parameters are required and must be
  /// non-null strings. These strings will be used to delimit
  /// the content that should be extracted from the source text.
  ///
  /// The parser will extract all content that appears between
  /// the first occurrence of [start] and the first occurrence
  /// of [end] that follows it.
  ///
  /// Throws an [ArgumentError] if either [start] or [end] is null
  /// or empty.
  StringBetweenParserOptions({
    required this.start,
    required this.end,
  })  : assert(start.isNotEmpty, 'Start string cannot be empty'),
        assert(end.isNotEmpty, 'End string cannot be empty');

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'start': start,
      'end': end,
    };
  }

  factory StringBetweenParserOptions.fromMap(Map<String, dynamic> map) {
    return StringBetweenParserOptions(
      start: map['start'] as String,
      end: map['end'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StringBetweenParserOptions.fromJson(String source) =>
      StringBetweenParserOptions.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
