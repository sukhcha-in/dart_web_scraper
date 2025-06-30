import 'dart:convert';

import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Target to target specific type of URL.
class UrlTarget {
  /// Name of our target, parsers in [Config] should contain this value.
  String name;

  /// List of parts of URL to target.
  List<String> where;

  /// If we need to scrape HTML or just start scraper based on URL.
  bool needsHtml;

  /// Pre-clean the url before starting the scraper.
  UrlCleaner? urlCleaner;

  UrlTarget({
    required this.name,
    required this.where,
    this.needsHtml = true,
    this.urlCleaner,
  });

  /// Creates a UrlTarget instance from Map.
  factory UrlTarget.fromMap(Map<String, dynamic> map) {
    return UrlTarget(
      name: map['name'],
      where: List<String>.from(map['where']),
      needsHtml: map['needsHtml'] ?? true,
      urlCleaner: map['urlCleaner'] != null
          ? UrlCleaner.fromMap(map['urlCleaner'])
          : null,
    );
  }

  /// Converts the UrlTarget instance to Map.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'where': where,
      'needsHtml': needsHtml,
      'urlCleaner': urlCleaner?.toMap(),
    };
  }

  /// Creates a Parser instance from a JSON string.
  factory UrlTarget.fromJson(String json) {
    return UrlTarget.fromMap(jsonDecode(json));
  }

  /// Converts the Parser instance to a JSON string.
  String toJson() {
    return jsonEncode(toMap());
  }
}
