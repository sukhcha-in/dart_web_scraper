import 'dart:convert';

/// Configuration options for table parser behavior.
///
/// This class contains configuration for extracting data from HTML tables
/// and JSON table structures.
class TableParserOptions {
  /// CSS selector for selecting keys row (for HTML tables)
  /// JSON path selector for keys (for JSON tables)
  ///
  /// This field is required and specifies how to identify the keys/headers
  /// in a table structure. For HTML tables, this would be a CSS selector
  /// like "tr:first-child th" or "thead th". For JSON tables, this would
  /// be a JSON path like "$.headers" or "$.columns".
  final String keys;

  /// CSS selector for selecting values row (for HTML tables)
  /// JSON path selector for values (for JSON tables)
  ///
  /// This field is optional and specifies how to identify the data values
  /// in a table structure. If not provided, the parser will use the keys
  /// selector to determine the structure. For HTML tables, this might be
  /// "tbody tr td". For JSON tables, this could be "$.data" or "$.rows".
  final String? values;

  /// Creates a new TableParserOptions instance.
  ///
  /// [keys] is required and must be a valid selector for identifying
  /// table keys/headers. This can be a CSS selector for HTML tables
  /// or a JSON path for JSON table structures.
  ///
  /// [values] is optional and specifies the selector for table data values.
  /// If omitted, the parser will infer the values based on the keys selector.
  ///
  /// Example usage:
  /// ```dart
  /// // For HTML tables
  /// TableParserOptions(
  ///   keys: "tr th",
  ///   values: "tr td",
  /// )
  ///
  /// // For JSON tables
  /// TableParserOptions(
  ///   keys: "$.headers",
  ///   values: "$.data",
  /// )
  /// ```
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
