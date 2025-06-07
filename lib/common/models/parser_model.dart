import 'package:dart_web_scraper/dart_web_scraper.dart';

typedef CleanerFunction = Object? Function(Data data, bool debug);

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

  Parser({
    required this.id,
    required this.parent,
    required this.type,
    this.selector = const [],
    this.isPrivate = false,
    this.multiple = false,
    this.optional,
    this.cleaner,
  });

  /// Creates a Parser instance from a JSON map.
  factory Parser.fromJson(Map<String, dynamic> json) {
    return Parser(
      id: json['id'],
      parent: List<String>.from(json['parent']),
      type: ParserType.values.firstWhere(
        (e) => e.toString() == 'ParserType.${json['type']}',
      ),
      selector: json['selector'] != null ? List<String>.from(json['selector']) : const [],
      isPrivate: json['isPrivate'] ?? false,
      multiple: json['multiple'] ?? false,
      optional: json['optional'] != null ? Optional.fromJson(json['optional']) : null,
      // Note: cleaner function cannot be serialized from JSON
    );
  }

  /// Converts the Parser instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent': parent,
      'type': type.toString().split('.').last,
      'selector': selector,
      'isPrivate': isPrivate,
      'multiple': multiple,
      'optional': optional?.toJson(),
      // Note: cleaner function cannot be serialized to JSON
    };
  }
}
