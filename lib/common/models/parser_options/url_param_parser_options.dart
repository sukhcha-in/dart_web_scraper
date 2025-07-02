import 'dart:convert';

/// Configuration options for urlParam parser behavior.
///
/// This class contains configuration for extracting data from URL parameters.
/// It is used by the urlParam parser to specify which URL parameter to extract
/// from the current page URL or from URLs found in the HTML content.
class UrlParamParserOptions {
  /// The name of the URL parameter to extract from the URL.
  ///
  /// This field specifies which query parameter should be extracted from the URL.
  /// For example, if the URL is "https://example.com?page=2&id=123", setting
  /// paramName to "id" would extract "123", while setting it to "page" would extract "2".
  ///
  /// If the paramName is a slot, the parser will extract the value of the slot from previously extracted data.
  ///
  /// The parameter name is case-sensitive and must match exactly with the parameter
  /// in the URL query string.
  final String paramName;

  /// Creates a new UrlParamParserOptions instance.
  ///
  /// [paramName] - The name of the URL parameter to extract. This must be a non-empty
  /// string that corresponds to a query parameter in the target URL.
  ///
  /// Throws an ArgumentError if paramName is null or empty.
  UrlParamParserOptions({
    required this.paramName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paramName': paramName,
    };
  }

  factory UrlParamParserOptions.fromMap(Map<String, dynamic> map) {
    return UrlParamParserOptions(
      paramName: map['paramName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UrlParamParserOptions.fromJson(String source) =>
      UrlParamParserOptions.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
