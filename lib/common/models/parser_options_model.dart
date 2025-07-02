import 'dart:convert';

import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Configuration options specific to individual parser types.
///
/// This class contains parser-specific configuration that controls how
/// a parser behaves during data extraction, separate from data transformations
/// that are applied after extraction.
///
/// Use the appropriate named constructor for the parser type you're configuring:
/// - [ParserOptions.http] for HTTP parsers
/// - [ParserOptions.table] for table and JSON table parsers
/// - [ParserOptions.sibling] for sibling parsers
/// - [ParserOptions.staticValue] for static value parsers
/// - [ParserOptions.stringBetween] for string between parsers
/// - [ParserOptions.urlParam] for url parameter parsers
class ParserOptions {
  /// HTTP request configuration options
  HttpParserOptions? http;

  /// Table processing configuration options
  TableParserOptions? table;

  /// Sibling element configuration options
  SiblingParserOptions? sibling;

  /// Static value configuration options
  StaticValueParserOptions? staticValue;

  /// String between configuration options
  StringBetweenParserOptions? stringBetween;

  /// URL parameter configuration options
  UrlParamParserOptions? urlParam;

  /// Creates ParserOptions for HTTP parser configuration
  ParserOptions.http(HttpParserOptions options)
      : http = options,
        table = null,
        sibling = null,
        staticValue = null,
        stringBetween = null,
        urlParam = null;

  /// Creates ParserOptions for table parser configuration
  ParserOptions.table(TableParserOptions options)
      : http = null,
        table = options,
        sibling = null,
        staticValue = null,
        stringBetween = null,
        urlParam = null;

  /// Creates ParserOptions for sibling parser configuration
  ParserOptions.sibling(SiblingParserOptions options)
      : http = null,
        table = null,
        sibling = options,
        staticValue = null,
        stringBetween = null,
        urlParam = null;

  /// Creates ParserOptions for static value parser configuration
  ParserOptions.staticValue(StaticValueParserOptions options)
      : http = null,
        table = null,
        sibling = null,
        staticValue = options,
        stringBetween = null,
        urlParam = null;

  /// Creates ParserOptions for string between parser configuration
  ParserOptions.stringBetween(StringBetweenParserOptions options)
      : http = null,
        table = null,
        sibling = null,
        staticValue = null,
        stringBetween = options,
        urlParam = null;

  /// Creates ParserOptions for url parameter parser configuration
  ParserOptions.urlParam(UrlParamParserOptions options)
      : http = null,
        table = null,
        sibling = null,
        staticValue = null,
        stringBetween = null,
        urlParam = options;

  /// Creates a ParserOptions instance from a Map.
  ///
  /// This factory constructor is used for deserializing parser options
  /// from JSON or other map-based formats.
  ///
  /// Parameters:
  /// - [map]: Map containing parser options configuration data
  ///
  /// Returns:
  /// - New ParserOptions instance with data from the map
  factory ParserOptions.fromMap(Map<String, dynamic> map) {
    if (map['http'] != null) {
      return ParserOptions.http(HttpParserOptions.fromMap(map['http']));
    } else if (map['table'] != null) {
      return ParserOptions.table(TableParserOptions.fromMap(map['table']));
    } else if (map['sibling'] != null) {
      return ParserOptions.sibling(
          SiblingParserOptions.fromMap(map['sibling']));
    } else if (map['staticValue'] != null) {
      return ParserOptions.staticValue(
          StaticValueParserOptions.fromMap(map['staticValue']));
    } else if (map['stringBetween'] != null) {
      return ParserOptions.stringBetween(
          StringBetweenParserOptions.fromMap(map['stringBetween']));
    } else if (map['urlParam'] != null) {
      return ParserOptions.urlParam(
          UrlParamParserOptions.fromMap(map['urlParam']));
    } else {
      throw ArgumentError('Invalid parser options map: no valid type found');
    }
  }

  /// Converts the ParserOptions instance to a Map.
  ///
  /// This method is used for serializing the parser options configuration
  /// to JSON or other map-based formats.
  ///
  /// Returns:
  /// - Map containing all parser options configuration data
  Map<String, dynamic> toMap() {
    return {
      'http': http?.toMap(),
      'table': table?.toMap(),
      'sibling': sibling?.toMap(),
      'staticValue': staticValue?.toMap(),
      'stringBetween': stringBetween?.toMap(),
      'urlParam': urlParam?.toMap(),
    };
  }

  /// Creates a ParserOptions instance from a JSON string.
  factory ParserOptions.fromJson(String json) {
    return ParserOptions.fromMap(jsonDecode(json));
  }

  /// Converts the ParserOptions instance to JSON string.
  String toJson() {
    return jsonEncode(toMap());
  }
}
