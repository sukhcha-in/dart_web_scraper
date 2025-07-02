import 'package:dart_web_scraper/common/utils/cookie_utils.dart';
import 'package:dart_web_scraper/common/utils/http.dart';
import 'package:dart_web_scraper/common/utils/random.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

/// Handles HTTP requests and HTML fetching for web scraping operations.
///
/// This class is responsible for:
/// - Building HTTP headers with appropriate user agents and cookies
/// - Cleaning URLs based on configuration
/// - Fetching HTML content from web pages
/// - Handling proxy requests when configured
/// - Managing HTML parsing and document creation
///
/// The scraper can work with pre-fetched HTML or fetch it automatically
/// based on the scraper configuration settings.
class Scraper {
  /// Fetches HTML content from a URL or uses provided HTML document.
  ///
  /// This method orchestrates the entire HTML fetching process:
  /// 1. Builds HTTP headers with user agent, cookies, and custom headers
  /// 2. Cleans the URL using configured URL cleaners
  /// 3. Fetches HTML content (if required by configuration)
  /// 4. Parses HTML into a Document object
  ///
  /// Parameters:
  /// - [url]: The target URL to scrape
  /// - [scraperConfig]: Configuration defining scraping behavior
  /// - [html]: Pre-fetched HTML document (optional, avoids HTTP request)
  /// - [cookies]: Custom cookies to include in HTTP requests
  /// - [userAgent]: Custom user agent string (overrides config setting)
  /// - [headers]: Additional HTTP headers to include
  /// - [proxyAPIConfig]: Proxy API URL for routing requests through a proxy
  /// - [debug]: Enable debug logging for troubleshooting
  ///
  /// Returns:
  /// - [Data] object containing the URL and parsed HTML document
  ///
  /// Throws:
  /// - [WebScraperError] if HTML fetching fails
  Future<Data> scrape({
    required Uri url,
    required ScraperConfig scraperConfig,
    Document? html,
    Map<String, String>? cookies,
    String? userAgent,
    Map<String, Object>? headers,
    ProxyAPIConfig? proxyAPIConfig,
    bool debug = false,
  }) async {
    /// Build HTTP headers with appropriate defaults and custom settings
    printLog('Scraper: Building headers...', debug, color: LogColor.blue);
    Map<String, String> headersMerged = {
      "Accept-Language": "en-US,en",
    };

    /// Set User-Agent header based on configuration or custom value
    if (userAgent != null) {
      printLog(
        'Scraper: Using user-passed User-Agent...',
        debug,
        color: LogColor.blue,
      );
      headersMerged['User-Agent'] = userAgent;
    }

    /// Generate random User-Agent if not provided by user
    if (!headersMerged.containsKey("User-Agent")) {
      printLog(
        'Scraper: Generating random User-Agent...',
        debug,
        color: LogColor.blue,
      );
      headersMerged['User-Agent'] = randomUserAgent(scraperConfig.userAgent);
    }

    /// Add cookies to headers if provided
    if (cookies != null) {
      printLog(
        'Scraper: Using user-passed cookies...',
        debug,
        color: LogColor.blue,
      );
      headersMerged['Cookie'] = mapToCookie(cookies);
    }

    /// Merge any additional custom headers
    if (headers != null) {
      headers.forEach((key, value) {
        headersMerged[key] = value.toString();
      });
    }

    /// Log the final headers for debugging
    printLog('Scraper: Headers: $headersMerged', debug, color: LogColor.blue);

    /// Clean the URL using configured URL cleaners
    printLog('Scraper: Cleaning URL...', debug, color: LogColor.blue);
    url = cleanScraperConfigUrl(url, scraperConfig.urlCleaner);
    printLog("Scraper: Cleaned URL :) $url", debug, color: LogColor.green);

    /// Initialize data container
    Data dom = Data(url, "");
    printLog(
      'Scraper: Checking if target requires html...',
      debug,
      color: LogColor.blue,
    );

    /// Handle HTML fetching based on configuration and available data
    if (scraperConfig.requiresHtml) {
      printLog('Scraper: Target requires html!!!', debug, color: LogColor.blue);
      String? requestData;

      /// Force HTTP request for fresh HTML content
      if (scraperConfig.forceRefresh) {
        printLog(
          'Scraper: Forcing http request for new html!!!',
          debug,
          color: LogColor.blue,
        );
        requestData = await getRequest(
          url,
          headers: headersMerged,
          debug: debug,
          proxyAPIConfig: proxyAPIConfig,
        );
      }

      /// Use provided HTML if available and has content
      else if (html != null && html.hasContent()) {
        printLog(
          'Scraper: Using user-passed html :)',
          debug,
          color: LogColor.orange,
        );
        dom = Data(url, html);
      }

      /// Fetch HTML from URL
      else {
        printLog('Scraper: Fetching html...', debug, color: LogColor.blue);
        requestData = await getRequest(
          url,
          headers: headersMerged,
          debug: debug,
          proxyAPIConfig: proxyAPIConfig,
        );
      }

      /// Process fetched HTML data
      if (dom.obj != "") {
        printLog('Scraper: HTML fetched :)', debug, color: LogColor.green);
      } else if (requestData != null) {
        printLog('Scraper: HTML fetched :)', debug, color: LogColor.green);
        dom = Data(url, parse(requestData));
      } else {
        printLog(
          'Scraper: Unable to fetch data!',
          debug,
          color: LogColor.red,
        );
        throw WebScraperError('Unable to fetch data!');
      }
    } else {
      /// Skip HTML fetching if not required by configuration
      printLog(
        'Scraper: Target does not need html. Skipping...',
        debug,
        color: LogColor.orange,
      );
    }

    printLog('Scraper: Returning data...', debug, color: LogColor.green);
    return dom;
  }
}
