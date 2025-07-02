import 'dart:convert';

class RegexTransformationOptions {
  final String regex;
  final int? regexGroup;

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
