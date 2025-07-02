import 'dart:convert';

class RegexReplaceTransformationOptions {
  final String regexReplace;
  final String regexReplaceWith;

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
