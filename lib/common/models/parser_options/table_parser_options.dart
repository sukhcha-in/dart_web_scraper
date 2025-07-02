import 'dart:convert';

/// Configuration options for table parser behavior.
///
/// This class contains configuration for extracting data from HTML tables
/// and JSON table structures.
class TableParserOptions {
  /// CSS selector for selecting keys row (for HTML tables)
  /// JSON path selector for keys (for JSON tables)
  final String keys;

  /// CSS selector for selecting values row (for HTML tables)
  /// JSON path selector for values (for JSON tables)
  final String? values;

  TableParserOptions({
    required this.keys,
    this.values,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'keys': keys,
      'values': values,
    };
  }

  factory TableParserOptions.fromMap(Map<String, dynamic> map) {
    return TableParserOptions(
      keys: map['keys'] as String,
      values: map['values'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory TableParserOptions.fromJson(String source) =>
      TableParserOptions.fromMap(json.decode(source) as Map<String, dynamic>);
}
