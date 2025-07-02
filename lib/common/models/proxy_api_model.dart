/// Configuration for routing HTTP requests through a proxy API.
///
/// This class defines how to route web scraping requests through a proxy API.
/// The proxy API acts as an intermediary that forwards requests to the target URL
/// and returns the response, which can help bypass rate limiting, geo-restrictions,
/// or other access controls.
///
/// Example usage:
/// ```dart
/// final proxyConfig = ProxyAPIConfig(
///   apiUrl: 'https://api.proxyservice.com/scrape',
///   targetUrlParameter: 'url',
/// );
///
/// // This will make a request to:
/// // https://api.proxyservice.com/scrape?url=https://example.com
/// ```
class ProxyAPIConfig {
  /// The base URL of the proxy API that will handle the requests.
  ///
  /// This is the endpoint of your proxy API that accepts requests
  /// and forwards them to the target URL.
  ///
  /// Example: `https://api.proxyservice.com/scrape`
  final Uri apiUrl;

  /// The query parameter name used by the proxy API to specify the target URL.
  ///
  /// When making a request to the proxy API, the target URL will be passed
  /// as a query parameter with this name.
  ///
  /// Example: If this is `"url"`, then the request will be:
  /// `https://api.proxyservice.com/scrape?url=https://target-site.com`
  final String targetUrlParameter;

  /// Creates a new proxy API configuration.
  ///
  /// Parameters:
  /// - [apiUrl]: The base URL of the proxy API
  /// - [targetUrlParameter]: The query parameter name for the target URL
  const ProxyAPIConfig({
    required this.apiUrl,
    required this.targetUrlParameter,
  });

  /// Returns a new URL with the target URL parameter added.
  Uri generateUrl(Uri url) {
    return apiUrl.replace(queryParameters: {
      ...apiUrl.queryParameters,
      targetUrlParameter: url.toString(),
    });
  }
}
