import 'dart:convert';

import 'package:dart_web_scraper/dart_web_scraper.dart';

/// A block in the list of parsers
class Parser {
  /// ID to store value of result.
  String id;

  /// List of parent IDs to tell parser when to trigger, base value is _root.
  List<String> parent;

  /// Keep result of this parser private, just for internal use.
  bool isPrivate = true;

  /// Parser type.
  ParserType type;

  /// CSS Selector for this parser.
  List<String> selector;

  /// If result can contain multiple results as a List. Default is false.
  bool multiple = false;

  /// Optional parameters.
  Optional? optional;

  //Cleaner function called once data is scraped
  CleanerFunction? cleaner;

  /// Name of the registered cleaner function for serialization
  String? cleanerName;

  Parser({
    required this.id,
    required this.parent,
    required this.type,
    this.selector = const [],
    this.isPrivate = false,
    this.multiple = false,
    this.optional,
    this.cleaner,
    this.cleanerName,
  }) {
    // If cleanerName is provided, resolve the cleaner function from registry
    if (cleanerName != null) {
      cleaner = CleanerRegistry.resolve(cleanerName);
    }
  }

  /// Creates a Parser instance from Map.
  factory Parser.fromMap(Map<String, dynamic> map) {
    return Parser(
      id: map['id'],
      parent: List<String>.from(map['parent']),
      type: ParserType.values.firstWhere(
        (e) => e.toString() == 'ParserType.${map['type']}',
      ),
      selector: map['selector'] != null
          ? List<String>.from(map['selector'])
          : const [],
      isPrivate: map['isPrivate'] ?? false,
      multiple: map['multiple'] ?? false,
      optional:
          map['optional'] != null ? Optional.fromMap(map['optional']) : null,
      cleanerName: map['cleanerName'],
      // Note: cleaner function will be resolved from registry using cleanerName
    );
  }

  /// Converts the Parser instance to Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parent': parent,
      'type': type.toString().split('.').last,
      'selector': selector,
      'isPrivate': isPrivate,
      'multiple': multiple,
      'optional': optional?.toMap(),
      'cleanerName': cleanerName,
      // Note: cleaner function is serialized via cleanerName reference
    };
  }

  /// Creates a Parser instance from a JSON string.
  factory Parser.fromJson(String json) {
    return Parser.fromMap(jsonDecode(json));
  }

  /// Converts the Parser instance to a JSON string.
  String toJson() {
    return jsonEncode(toMap());
  }
}
