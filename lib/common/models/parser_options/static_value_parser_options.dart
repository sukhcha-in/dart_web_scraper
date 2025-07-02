import 'dart:convert';

/// Configuration options for static value parser behavior.
///
/// This class contains configuration for returning static values
/// without any data extraction.
class StaticValueParserOptions {
  /// Static string value to return
  final String? stringValue;

  /// Static map value to return
  final Map<String, Object>? mapValue;

  StaticValueParserOptions({
    this.stringValue,
    this.mapValue,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stringValue': stringValue,
      'mapValue': mapValue,
    };
  }

  factory StaticValueParserOptions.fromMap(Map<String, dynamic> map) {
    return StaticValueParserOptions(
      stringValue:
          map['stringValue'] != null ? map['stringValue'] as String : null,
      mapValue: map['mapValue'] != null
          ? Map<String, Object>.from(map['mapValue'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StaticValueParserOptions.fromJson(String source) =>
      StaticValueParserOptions.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
