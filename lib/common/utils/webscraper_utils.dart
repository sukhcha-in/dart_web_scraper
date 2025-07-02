import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Finds the appropriate scraper configuration for a given URL.
///
/// This function searches through the scraper configuration map to find
/// a configuration that matches the URL's host and path patterns.
///
/// The matching process:
/// 1. Checks if the URL's host contains any of the configuration keys
/// 2. For matching hosts, checks each scraper configuration's path patterns
/// 3. Matches path patterns using exact string matching or regex patterns
/// 4. Returns the first matching configuration found
///
/// Parameters:
/// - [scraperConfigMap]: Map of domain names to lists of scraper configurations
/// - [url]: The URL to find a configuration for
///
/// Returns:
/// - Matching [ScraperConfig] if found, null otherwise
///
/// Example:
/// ```dart
/// final config = findScraperConfig(
///   scraperConfigMap: {
///     'example.com': [ScraperConfig(pathPatterns: ['/products'], ...)]
///   },
///   url: Uri.parse('https://example.com/products/123'),
/// );
/// ```
ScraperConfig? findScraperConfig({
  required Map<String, List<ScraperConfig>> scraperConfigMap,
  required Uri url,
}) {
  /// Check each domain in the configuration map
  for (final i in scraperConfigMap.keys) {
    if (url.host.contains(i)) {
      /// Check each scraper configuration for this domain
      for (final t in scraperConfigMap[i]!) {
        /// Check each path pattern in the configuration
        for (final urlPart in t.pathPatterns) {
          if (urlPart == "/") {
            /// Root path pattern - always matches
            return t;
          } else if (url.path.contains(urlPart)) {
            /// Simple string matching for path patterns
            return t;
          } else {
            /// Regex pattern matching for complex patterns
            final pattern = RegExp(urlPart);
            if (pattern.hasMatch(url.toString())) {
              return t;
            }
          }
        }
      }
    }
  }
  return null;
}

/// Cleans and normalizes a URL based on scraper configuration settings.
///
/// This function applies URL cleaning rules defined in the [UrlCleaner] configuration:
/// - Removes blacklisted query parameters
/// - Keeps only whitelisted query parameters (if specified)
/// - Adds additional parameters as defined in the configuration
/// - Normalizes the URL structure
///
/// Parameters:
/// - [url]: The original URL to clean
/// - [cleaner]: URL cleaning configuration (optional)
///
/// Returns:
/// - Cleaned and normalized [Uri] object
///
/// Example:
/// ```dart
/// final cleanedUrl = cleanScraperConfigUrl(
///   Uri.parse('https://example.com/page?utm_source=google&id=123'),
///   UrlCleaner(blacklistParams: ['utm_source']),
/// );
/// // Result: https://example.com/page?id=123
/// ```
Uri cleanScraperConfigUrl(Uri url, UrlCleaner? cleaner) {
  /// Initialize parameters map
  Map<String, String> params = {};

  /// If no cleaner is provided, return URL with path only (no parameters)
  if (cleaner == null) {
    return Uri.https(url.authority, url.path);
  }

  /// Handle blacklisted parameters - remove specified parameters
  if (cleaner.blacklistParams != null) {
    url.queryParameters.forEach((key, value) {
      if (!cleaner.blacklistParams!.contains(key)) {
        params[key] = value;
      }
    });
  } else {
    /// If no blacklist, include all original parameters
    params.addAll(url.queryParameters);
  }

  /// Handle whitelisted parameters - keep only specified parameters
  if (cleaner.whitelistParams != null) {
    List<String> toRemove = [];
    params.forEach((key, value) {
      if (!cleaner.whitelistParams!.contains(key)) {
        toRemove.add(key);
      }
    });
    params.removeWhere((k, v) => toRemove.contains(k));
  } else {
    /// If whitelist is specified but no parameters match, clear all
    params.clear();
  }

  /// Add additional parameters as specified in the configuration
  if (cleaner.appendParams != null) {
    cleaner.appendParams!.forEach((key, value) {
      params[key] = value;
    });
  }

  /// Construct and return the cleaned URL
  return Uri.https(url.authority, url.path, params);
}

/// Injects data into a string template using slot placeholders.
///
/// This function replaces slot placeholders in a string with actual data values.
/// Slots are defined using XML-like tags: `<slot>key</slot>`.
///
/// The function supports:
/// - Multiple slot replacements in a single string
/// - Map-based data injection (using keys as slot names)
/// - Error handling for missing or invalid data
/// - Fallback to original string if injection fails
///
/// Parameters:
/// - [name]: The slot name to look for (e.g., "slot", "param")
/// - [data]: Data map containing values to inject
/// - [input]: String template containing slot placeholders
///
/// Returns:
/// - String with slots replaced by actual data values
///
/// Example:
/// ```dart
/// final result = inject(
///   "slot",
///   {"title": "Product Name", "price": "29.99"},
///   "Product: <slot>title</slot> - $<slot>price</slot>"
/// );
/// // Result: "Product: Product Name - $29.99"
/// ```
String inject(String name, Object data, Object input) {
  String result = input.toString();
  try {
    /// Find all placeholders enclosed in <slot> tags
    RegExp slotRegExp = RegExp("<$name>(.*?)</$name>");
    Iterable<Match> matches = slotRegExp.allMatches(input.toString());

    if (data is Map) {
      /// Iterate over matches and replace with values from data map
      for (Match match in matches) {
        String slotName = match.group(1)!;

        /// Extract the slot name
        String slotValue = data[slotName].toString();

        /// Use value from data map
        result = result.replaceFirst(match.group(0)!, slotValue);
      }

      /// Return original input if result is empty
      if (result.trim() == "") {
        return input.toString();
      }
    }
  } catch (e) {
    /// Log injection errors for debugging
    printLog("Injection Error: $e", true, color: LogColor.red);
  }
  return result;
}

/// Extension on [Iterable] to provide indexed search functionality.
///
/// This extension adds a method to find the first element that satisfies
/// a condition, with access to both the element and its index.
///
/// The method returns null if no element matches the condition, unlike
/// the standard `firstWhere` method which throws an exception.
extension IterableExtension<T> on Iterable<T> {
  /// Finds the first element that satisfies the test condition.
  ///
  /// This method is similar to `firstWhere` but:
  /// - Provides access to both the element and its index in the test function
  /// - Returns null instead of throwing an exception when no match is found
  /// - Is safer for cases where you're not sure if a match exists
  ///
  /// Parameters:
  /// - [test]: Function that takes an index and element, returns true if the element matches
  ///
  /// Returns:
  /// - The first matching element, or null if no match is found
  ///
  /// Example:
  /// ```dart
  /// final list = ['a', 'b', 'c', 'd'];
  /// final result = list.firstWhereIndexedOrNull((index, element) =>
  ///   index > 1 && element == 'c'
  /// );
  /// // Result: 'c' (found at index 2)
  /// ```
  T? firstWhereIndexedOrNull(bool Function(int index, T element) test) {
    var index = 0;
    for (var element in this) {
      if (test(index++, element)) return element;
    }
    return null;
  }
}
