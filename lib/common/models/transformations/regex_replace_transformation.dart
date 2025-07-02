import 'dart:convert';

/// Configuration options for regex-based string replacement transformations.
///
/// This class provides the necessary parameters to perform regex-based
/// find and replace operations on extracted data during web scraping.
/// It allows users to define a regex pattern to match and a replacement string.
class RegexReplaceTransformationOptions {
  /// The regex pattern to search for in the extracted data.
  ///
  /// This should be a valid regular expression string that will be used
  /// to find matches in the data that needs to be transformed.
  final String regexReplace;

  /// The replacement string to substitute for matched regex patterns.
  ///
  /// This string will replace all occurrences of the regex pattern
  /// found in the extracted data. It can include regex capture groups
  /// using $1, $2, etc. for backreferences.
  final String regexReplaceWith;

  /// Creates a new regex replacement transformation configuration.
  ///
  /// [regexReplace] - The regex pattern to search for
  /// [regexReplaceWith] - The replacement string for matched patterns
  RegexReplaceTransformationOptions({
    required this.regexReplace,
    required this.regexReplaceWith,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'regexReplace': regexReplace,
      'regexReplaceWith': regexReplaceWith,
    };
  }

  factory RegexReplaceTransformationOptions.fromMap(Map<String, dynamic> map) {
    return RegexReplaceTransformationOptions(
      regexReplace: map['regexReplace'] as String,
      regexReplaceWith: map['regexReplaceWith'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegexReplaceTransformationOptions.fromJson(String source) =>
      RegexReplaceTransformationOptions.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
