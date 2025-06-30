import 'dart:convert';

import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Config for a domain
class Config {
  /// If TRUE scraper will forcefully fetch data from URL even if HTML is passed.
  /// Defaults to FALSE.
  bool forceFetch;

  /// Allow this domain to use passed HTML and skip fetching HTML from URL.
  bool usePassedHtml;

  /// Allow custom user agent passed by user.
  bool usePassedUserAgent;

  /// User Agent selections: [UserAgentDevice.desktop] or [UserAgentDevice.mobile]
  /// Defaults to [UserAgentDevice.mobile]
  UserAgentDevice userAgent;

  /// Map of parsers based on Target name.
  /// Set Target name as key and List of Parser as value.
  Map<String, List<Parser>> parsers;

  /// Targets are set based on page types of target website.
  List<UrlTarget> urlTargets;

  Config({
    this.forceFetch = false,
    this.userAgent = UserAgentDevice.mobile,
    this.usePassedHtml = true,
    this.usePassedUserAgent = false,
    required this.parsers,
    required this.urlTargets,
  });

  /// Creates a Config instance from Map.
  factory Config.fromMap(Map<String, dynamic> map) {
    return Config(
      forceFetch: map['forceFetch'] ?? false,
      userAgent: map['userAgent'] != null
          ? UserAgentDevice.values.firstWhere(
              (e) => e.toString() == 'UserAgentDevice.${map['userAgent']}',
              orElse: () => UserAgentDevice.mobile,
            )
          : UserAgentDevice.mobile,
      usePassedHtml: map['usePassedHtml'] ?? true,
      usePassedUserAgent: map['usePassedUserAgent'] ?? false,
      parsers: (map['parsers'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List).map((p) => Parser.fromMap(p)).toList(),
        ),
      ),
      urlTargets: (map['urlTargets'] as List)
          .map((target) => UrlTarget.fromMap(target))
          .toList(),
    );
  }

  /// Converts the Config instance to Map.
  Map<String, dynamic> toMap() {
    return {
      'forceFetch': forceFetch,
      'userAgent': userAgent.toString().split('.').last,
      'usePassedHtml': usePassedHtml,
      'usePassedUserAgent': usePassedUserAgent,
      'parsers': parsers.map(
        (key, value) => MapEntry(
          key,
          value.map((parser) => parser.toMap()).toList(),
        ),
      ),
      'urlTargets': urlTargets.map((target) => target.toMap()).toList(),
    };
  }

  /// Creates a Config instance from a JSON string.
  factory Config.fromJson(String json) {
    return Config.fromMap(jsonDecode(json));
  }

  /// Converts the Config instance to a JSON string.
  String toJson() {
    return jsonEncode(toMap());
  }
}
