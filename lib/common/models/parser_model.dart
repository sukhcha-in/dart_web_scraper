import 'dart:convert';

import 'package:dart_web_scraper/dart_web_scraper.dart';

/// A block in the list of parsers
class Parser {
  /// ID to store value of result.
  String id;

  /// List of parent IDs to tell parser when to trigger, base value is _root.
  List<String> parents;

  /// Keep result of this parser private, just for internal use.
  bool isPrivate = true;

  /// Parser type.
  ParserType type;

  /// CSS Selector for this parser.
  List<String> selectors;

  /// If result can contain multiple results as a List. Default is false.
  bool multiple = false;

  /// Parser options.
  ParserOptions? parserOptions;

  /// Transformation options.
  TransformationOptions? transformationOptions;

  //Cleaner function called once data is scraped
  CleanerFunction? cleaner;

  /// Name of the registered cleaner function for serialization
  String? cleanerName;

  Parser({
    required this.id,
    required this.parents,
    required this.type,
    this.selectors = const [],
    this.isPrivate = false,
    this.multiple = false,
    this.parserOptions,
    this.transformationOptions,
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
      parents: List<String>.from(map['parents']),
      type: ParserType.values.firstWhere(
        (e) => e.toString() == 'ParserType.${map['type']}',
      ),
      selectors: map['selectors'] != null
          ? List<String>.from(map['selectors'])
          : const [],
      isPrivate: map['isPrivate'] ?? false,
      multiple: map['multiple'] ?? false,
      parserOptions: map['parserOptions'] != null
          ? ParserOptions.fromMap(map['parserOptions'])
          : null,
      transformationOptions: map['transformationOptions'] != null
          ? TransformationOptions.fromMap(map['transformationOptions'])
          : null,
      cleanerName: map['cleanerName'],
      // Note: cleaner function will be resolved from registry using cleanerName
    );
  }

  /// Converts the Parser instance to Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parents': parents,
      'type': type.toString().split('.').last,
      'selectors': selectors,
      'isPrivate': isPrivate,
      'multiple': multiple,
      'parserOptions': parserOptions?.toMap(),
      'transformationOptions': transformationOptions?.toMap(),
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
