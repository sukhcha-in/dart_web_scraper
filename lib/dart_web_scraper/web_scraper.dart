import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:html/dom.dart';

/// High-level web scraper that combines HTML fetching and data parsing.
///
/// This class provides a simplified interface for web scraping by combining
/// the [Scraper] (for fetching HTML) and [WebParser] (for extracting data)
/// into a single, easy-to-use API.
///
/// Example usage:
/// ```dart
/// final scraper = WebScraper();
/// final configMap = {
///   'example.com': [ScraperConfig(...)]
/// };
///
/// final data = await scraper.scrape(
///   url: Uri.parse('https://example.com'),
///   scraperConfigMap: configMap,
/// );
/// ```
class WebScraper {
  /// Checks if the given URL can be scraped with the provided configuration.
  ///
  /// This method determines if there's a matching [ScraperConfig] for the given URL
  /// by checking if the URL's path matches any of the path patterns defined in
  /// the scraper configurations.
  ///
  /// Parameters:
  /// - [url]: The URL to check for scraping capability
  /// - [scraperConfigMap]: Map of domain names to lists of scraper configurations
  ///
  /// Returns:
  /// - `true` if a matching scraper configuration is found
  /// - `false` if no matching configuration exists
  bool canScrape({
    required Uri url,
    required ScraperConfigMap scraperConfigMap,
  }) {
    ScraperConfig? scraperConfig = findScraperConfig(
      url: url,
      scraperConfigMap: scraperConfigMap,
    );
    return scraperConfig != null;
  }

  /// Performs complete web scraping including HTML fetching and data extraction.
  ///
  /// This is the main method that orchestrates the entire scraping process:
  /// 1. If scraperConfig is provided, it will be used.
  /// 2. If scraperConfig is not provided, scraperConfigMap will be used to find the appropriate scraper configuration for the URL
  /// 3. If no scraper configuration is provided, throw an error
  /// 4. Fetches the HTML content (if required)
  /// 5. Parses the HTML using the configured parsers and returns the extracted data as a map
  ///
  /// Parameters:
  /// - [url]: The URL to scrape
  /// - [scraperConfig]: Scraper configuration for the URL
  /// - [scraperConfigMap]: Map of domain names to lists of scraper configurations
  /// - [proxyAPIConfig]: Optional proxy API URL for routing requests through a proxy
  /// - [debug]: Enable debug logging (default: false)
  /// - [html]: Pre-fetched HTML document (optional, avoids HTTP request if provided)
  /// - [cookies]: Custom cookies to include in HTTP requests
  /// - [headers]: Custom HTTP headers to include in requests
  /// - [userAgent]: Custom user agent string (overrides scraper config setting)
  /// - [concurrentParsing]: Enable concurrent parsing for better performance (default: false)
  ///
  /// Returns:
  /// - Map containing extracted data with parser IDs as keys
  ///
  /// Throws:
  /// - [WebScraperError] if URL is not supported or scraping fails
  Future<Map<String, Object>> scrape({
    required Uri url,
    ScraperConfig? scraperConfig,
    ScraperConfigMap? scraperConfigMap,
    ProxyAPIConfig? proxyAPIConfig,
    bool debug = false,
    Document? html,
    Map<String, String>? cookies,
    Map<String, String>? headers,
    String? userAgent,
    bool concurrentParsing = false,
  }) async {
    /// Find the appropriate scraper configuration for this URL
    ScraperConfig? config;
    if (scraperConfig != null) {
      config = scraperConfig;
    } else if (scraperConfigMap != null) {
      config = findScraperConfig(
        url: url,
        scraperConfigMap: scraperConfigMap,
      );
    }
    if (config == null) {
      throw WebScraperError(
          'No scraper configuration provided or this url is not supported by scraperConfigMap');
    }

    /// Fetch the HTML content using the Scraper class
    Scraper scraping = Scraper();
    Data scrapedData = await scraping.scrape(
      url: url,
      html: html,
      debug: debug,
      scraperConfig: config,
      cookies: cookies,
      headers: headers,
      userAgent: userAgent,
      proxyAPIConfig: proxyAPIConfig,
    );

    /// Parse the HTML content using the WebParser class
    WebParser webParser = WebParser();
    Map<String, Object> parsedData = await webParser.parse(
      scrapedData: scrapedData,
      scraperConfig: config,
      proxyAPIConfig: proxyAPIConfig,
      cookies: cookies,
      debug: debug,
      concurrentParsing: concurrentParsing,
    );

    return parsedData;
  }
}
