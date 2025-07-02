import 'dart:convert';

/// Configuration for cleaning and normalizing URLs before making HTTP requests.
///
/// This class defines rules for modifying URLs to remove unwanted parameters,
/// keep only specific parameters, or add additional parameters. This is useful
/// for:
/// - Removing tracking parameters (utm_source, utm_campaign, etc.)
/// - Normalizing URLs for consistent scraping
///
/// The cleaning process follows this order:
/// 1. Remove blacklisted parameters
/// 2. Keep only whitelisted parameters (if specified)
/// 3. Add additional parameters
class UrlCleaner {
  /// List of query parameters to keep in the cleaned URL.
  ///
  /// If specified, only these parameters will be retained in the final URL.
  /// All other parameters will be removed, regardless of blacklist settings.
  ///
  /// Example:
  /// ```dart
  /// UrlCleaner(whitelistParams: ['id', 'category'])
  /// // Keeps only 'id' and 'category' parameters
  /// ```
  List<String>? whitelistParams;

  /// List of query parameters to remove from the URL.
  ///
  /// These parameters will be removed from the URL before making the request.
  /// Commonly used to remove tracking parameters, session IDs, or other
  /// unwanted parameters.
  ///
  /// Example:
  /// ```dart
  /// UrlCleaner(blacklistParams: ['utm_source', 'utm_campaign', 'session_id'])
  /// // Removes tracking and session parameters
  /// ```
  List<String>? blacklistParams;

  /// Additional parameters to append to the cleaned URL.
  ///
  /// These parameters will be added to the URL after cleaning. Useful for
  /// adding required API parameters, authentication tokens, or other
  /// necessary parameters.
  ///
  /// Example:
  /// ```dart
  /// UrlCleaner(appendParams: {'api_key': 'abc123', 'format': 'json'})
  /// // Adds API key and format parameters
  /// ```
  Map<String, String>? appendParams;

  /// Creates a new UrlCleaner instance.
  ///
  /// Parameters:
  /// - [whitelistParams]: List of parameters to keep (optional)
  /// - [blacklistParams]: List of parameters to remove (optional)
  /// - [appendParams]: Additional parameters to add (optional)
  ///
  /// Note: If both whitelistParams and blacklistParams are specified,
  /// whitelistParams takes precedence and blacklistParams is ignored.
  UrlCleaner({
    this.whitelistParams,
    this.blacklistParams,
    this.appendParams,
  });

  /// Creates a UrlCleaner instance from a Map.
  ///
  /// This factory constructor is used for deserializing URL cleaner
  /// configuration from JSON or other map-based formats.
  ///
  /// Parameters:
  /// - [map]: Map containing URL cleaner configuration
  ///
  /// Returns:
  /// - New UrlCleaner instance with configuration from the map
  factory UrlCleaner.fromMap(Map<String, dynamic> map) {
    return UrlCleaner(
      whitelistParams: map['whitelistParams'] != null
          ? List<String>.from(map['whitelistParams'])
          : null,
      blacklistParams: map['blacklistParams'] != null
          ? List<String>.from(map['blacklistParams'])
          : null,
      appendParams: map['appendParams'] != null
          ? Map<String, String>.from(map['appendParams'])
          : null,
    );
  }

  /// Converts the UrlCleaner instance to a Map.
  ///
  /// This method is used for serializing the URL cleaner configuration
  /// to JSON or other map-based formats.
  ///
  /// Returns:
  /// - Map containing all URL cleaner configuration data
  Map<String, dynamic> toMap() {
    return {
      'whitelistParams': whitelistParams,
      'blacklistParams': blacklistParams,
      'appendParams': appendParams,
    };
  }

  /// Creates a UrlCleaner instance from a JSON string.
  ///
  /// This factory constructor is used for deserializing URL cleaner
  /// configuration from JSON strings.
  ///
  /// Parameters:
  /// - [json]: JSON string containing URL cleaner configuration
  ///
  /// Returns:
  /// - New UrlCleaner instance with configuration from the JSON
  ///
  /// Throws:
  /// - FormatException if the JSON is invalid
  factory UrlCleaner.fromJson(String json) {
    return UrlCleaner.fromMap(jsonDecode(json));
  }

  /// Converts the UrlCleaner instance to a JSON string.
  ///
  /// This method is used for serializing the URL cleaner configuration
  /// to JSON format.
  ///
  /// Returns:
  /// - JSON string containing all URL cleaner configuration data
  String toJson() {
    return jsonEncode(toMap());
  }
}
