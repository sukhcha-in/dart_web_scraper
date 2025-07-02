import 'dart:convert';

/// Configuration options for regex-based text transformations.
///
/// This class defines the parameters needed to apply regular expression
/// transformations to extracted data, allowing for pattern matching
/// and group extraction from text content.
class RegexTransformationOptions {
  /// The regular expression pattern to match against the input text.
  ///
  /// This should be a valid regex string that will be used to find
  /// and extract or transform matching content.
  final String regex;

  /// The specific regex group to extract from the match.
  ///
  /// If provided, only the specified group will be returned.
  /// If null, the entire match will be returned.
  /// Group 0 represents the entire match, groups 1+ represent captured groups.
  final int? regexGroup;

  /// Creates a new RegexTransformationOptions instance.
  ///
  /// [regex] is required and must be a valid regular expression pattern.
  /// [regexGroup] is optional and specifies which capture group to extract.
  RegexTransformationOptions({
    required this.regex,
    this.regexGroup,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'regex': regex,
      'regexGroup': regexGroup,
    };
  }

  factory RegexTransformationOptions.fromMap(Map<String, dynamic> map) {
    return RegexTransformationOptions(
      regex: map['regex'] as String,
      regexGroup: map['regexGroup'] != null ? map['regexGroup'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegexTransformationOptions.fromJson(String source) =>
      RegexTransformationOptions.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
