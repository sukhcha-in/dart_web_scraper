import 'dart:convert';

import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Configuration options for sibling parser behavior.
///
/// This class contains configuration for extracting sibling elements
/// relative to the current element.
class SiblingParserOptions {
  /// Direction to look for sibling (previous or next)
  final SiblingDirection? direction;

  /// Optional list of strings to check if sibling text contains
  final List<String>? where;

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
