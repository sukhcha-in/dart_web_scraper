import 'dart:convert';

/// Configuration options for string between parser behavior.
///
/// This class contains configuration for extracting text between
/// two specified strings.
class StringBetweenParserOptions {
  /// Starting string to look for
  final String start;

  /// Ending string to look for
  final String end;

  StringBetweenParserOptions({
    required this.start,
    required this.end,
  });

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
