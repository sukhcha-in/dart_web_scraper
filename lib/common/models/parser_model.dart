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
  AbstractOptional? optional;

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
}
