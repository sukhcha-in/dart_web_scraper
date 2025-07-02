import 'dart:convert';

import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Configuration for targeting and scraping specific types of URLs.
///
/// This class defines how to scrape a particular website or URL pattern.
/// It contains all the necessary settings for:
/// - URL pattern matching to determine when to use this configuration
/// - Parser definitions for extracting data from the page
/// - HTTP request settings (user agent, headers, etc.)
/// - URL preprocessing and cleaning rules
/// - HTML fetching behavior control
///
/// Multiple ScraperConfig instances can be used together to handle
/// different pages on the same website or different websites entirely.
class ScraperConfig {
  /// List of URL path patterns that this configuration should handle.
  ///
  /// These patterns are used to match against the path portion of URLs.
  /// When a URL's path matches any of these patterns, this configuration
  /// will be used for scraping that URL.
  ///
  /// Examples:
  /// - `['/products', '/items']` - matches URLs ending with /products or /items
  /// - `['/category/*']` - matches any URL with /category/ followed by anything
  /// - `['/']` - matches the root path of the domain
  List<String> pathPatterns;

  /// List of parsers that define how to extract data from the page.
  ///
  /// Each parser specifies what data to extract and how to extract it.
  /// Parsers can be organized in a hierarchy where child parsers depend
  /// on parent parsers' output.
  List<Parser> parsers;

  /// Whether HTML content needs to be fetched from the URL.
  ///
  /// If `true` (default), the scraper will fetch the HTML content from the URL.
  /// If `false`, the scraper will skip HTML fetching and rely on pre-provided
  /// HTML or URL-based data extraction only.
  bool requiresHtml;

  /// URL preprocessing and cleaning configuration.
  ///
  /// This defines rules for modifying the URL before making the HTTP request.
  /// Useful for removing tracking parameters, normalizing URLs, or adding
  /// required parameters.
  UrlCleaner? urlCleaner;

  /// Whether to force a fresh HTTP request even if HTML is provided.
  ///
  /// If `true`, the scraper will always fetch fresh HTML from the URL,
  /// ignoring any pre-provided HTML content. This is useful when you want
  /// to ensure you're getting the latest version of the page.
  ///
  /// Defaults to `false`.
  bool forceRefresh;

  /// User agent device type for HTTP requests.
  ///
  /// Determines whether to use a mobile or desktop user agent string
  /// when making HTTP requests. This can affect how the website responds
  /// and what content is returned.
  ///
  /// Defaults to [UserAgentDevice.mobile].
  UserAgentDevice userAgent;

  /// Creates a new ScraperConfig instance.
  ///
  /// Parameters:
  /// - [pathPatterns]: URL path patterns to match
  /// - [parsers]: List of parsers for data extraction
  /// - [requiresHtml]: Whether HTML fetching is required (default: true)
  /// - [urlCleaner]: URL preprocessing configuration (optional)
  /// - [forceRefresh]: Force fresh HTTP requests (default: false)
  /// - [userAgent]: User agent device type (default: mobile)
  ScraperConfig({
    this.pathPatterns = const [],
    this.requiresHtml = true,
    this.urlCleaner,
    required this.parsers,
    this.forceRefresh = false,
    this.userAgent = UserAgentDevice.mobile,
  });

  /// Creates a ScraperConfig instance from a Map.
  ///
  /// This factory constructor is used for deserializing configuration
  /// from JSON or other map-based formats.
  ///
  /// Parameters:
  /// - [map]: Map containing configuration data
  ///
  /// Returns:
  /// - New ScraperConfig instance with data from the map
  factory ScraperConfig.fromMap(Map<String, dynamic> map) {
    return ScraperConfig(
      pathPatterns: List<String>.from(map['pathPatterns']),
      requiresHtml: map['requiresHtml'] ?? true,
      urlCleaner: map['urlCleaner'] != null
          ? UrlCleaner.fromMap(map['urlCleaner'])
          : null,
      parsers: (map['parsers'] as List)
          .map((parser) => Parser.fromMap(parser))
          .toList(),
      forceRefresh: map['forceRefresh'] ?? false,
      userAgent: map['userAgent'] != null
          ? UserAgentDevice.values.firstWhere(
              (e) => e.toString() == 'UserAgentDevice.${map['userAgent']}',
              orElse: () => UserAgentDevice.mobile,
            )
          : UserAgentDevice.mobile,
    );
  }

  /// Converts the ScraperConfig instance to a Map.
  ///
  /// This method is used for serializing the configuration to JSON
  /// or other map-based formats.
  ///
  /// Returns:
  /// - Map containing all configuration data
  Map<String, dynamic> toMap() {
    return {
      'pathPatterns': pathPatterns,
      'requiresHtml': requiresHtml,
      'urlCleaner': urlCleaner?.toMap(),
      'parsers': parsers.map((parser) => parser.toMap()).toList(),
      'forceRefresh': forceRefresh,
      'userAgent': userAgent.toString().split('.').last,
    };
  }

  /// Creates a ScraperConfig instance from a JSON string.
  ///
  /// This factory constructor is used for deserializing configuration
  /// from JSON strings.
  ///
  /// Parameters:
  /// - [json]: JSON string containing configuration data
  ///
  /// Returns:
  /// - New ScraperConfig instance with data from the JSON
  factory ScraperConfig.fromJson(String json) {
    return ScraperConfig.fromMap(jsonDecode(json));
  }

  /// Converts the ScraperConfig instance to a JSON string.
  ///
  /// This method is used for serializing the configuration to JSON.
  ///
  /// Returns:
  /// - JSON string containing all configuration data
  String toJson() {
    return jsonEncode(toMap());
  }
}
