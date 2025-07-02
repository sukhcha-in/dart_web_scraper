import 'dart:convert';

import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Configuration options for sibling parser behavior.
///
/// This class contains configuration for extracting sibling elements
/// relative to the current element.
class SiblingParserOptions {
  /// Direction to look for sibling (previous or next)
  ///
  /// Specifies whether to search for the sibling element that comes
  /// before (previous) or after (next) the current element in the DOM tree.
  /// This is useful when you need to extract data from adjacent elements
  /// that are related to the current context.
  final SiblingDirection? direction;

  /// Optional list of strings to check if sibling text contains
  ///
  /// When provided, this list acts as a filter to ensure the sibling element
  /// contains at least one of the specified strings in its text content.
  /// This is useful for targeting specific sibling elements that contain
  /// particular keywords or identifiers, making the extraction more precise.
  ///
  /// Example: If set to ['price', 'cost'], only sibling elements containing
  /// either "price" or "cost" in their text will be considered.
  final List<String>? where;

  /// Creates a new instance of [SiblingParserOptions].
  ///
  /// [direction] specifies the direction to search for sibling elements.
  /// If null, the parser will use a default direction or search in both directions.
  ///
  /// [where] provides an optional filter list of strings that the sibling
  /// element's text content must contain. If null, no text filtering is applied.
  SiblingParserOptions({
    this.direction,
    this.where,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'direction': direction?.toString().split('.').last,
      'where': where,
    };
  }

  factory SiblingParserOptions.fromMap(Map<String, dynamic> map) {
    return SiblingParserOptions(
      direction: map['direction'] != null
          ? SiblingDirection.values.firstWhere(
              (e) => e.toString() == 'SiblingDirection.${map['direction']}',
            )
          : null,
      where: map['where'] != null ? List<String>.from(map['where']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SiblingParserOptions.fromJson(String source) =>
      SiblingParserOptions.fromMap(json.decode(source) as Map<String, dynamic>);
}
