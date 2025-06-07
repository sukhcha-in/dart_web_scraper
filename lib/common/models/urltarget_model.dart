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

  /// Creates a UrlTarget instance from a JSON map.
  factory UrlTarget.fromJson(Map<String, dynamic> json) {
    return UrlTarget(
      name: json['name'],
      where: List<String>.from(json['where']),
      needsHtml: json['needsHtml'] ?? true,
      urlCleaner: json['urlCleaner'] != null
          ? UrlCleaner.fromJson(json['urlCleaner'])
          : null,
    );
  }

  /// Converts the UrlTarget instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'where': where,
      'needsHtml': needsHtml,
      'urlCleaner': urlCleaner?.toJson(),
    };
  }
}
