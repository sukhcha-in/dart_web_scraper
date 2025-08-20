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
  /// - [overrideCookies]: Custom cookies to include in HTTP requests
  /// - [overrideUserAgent]: Custom user agent string (overrides config setting)
  /// - [overrideHeaders]: Additional HTTP headers to include
  /// - [overrideProxyAPIConfig]: Proxy API URL for routing requests through a proxy
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
    Map<String, String>? overrideCookies,
    String? overrideUserAgent,
    Map<String, String>? overrideHeaders,
    ProxyAPIConfig? overrideProxyAPIConfig,
    bool debug = false,
  }) async {
    /// Skip scraping if HTML is not required by configuration
    if (!scraperConfig.requiresHtml) {
      printLog(
        'Scraper: Target does not need html. Skipping...',
        debug,
        color: LogColor.orange,
      );
      return Data(url, "");
    }

    /// Build HTTP headers with appropriate defaults and custom settings
    printLog('Scraper: Building headers...', debug, color: LogColor.blue);
    Map<String, String> headersMerged = {};

    /// Set headers from scraperConfig
    if (scraperConfig.headers != null) {
      headersMerged.addAll(scraperConfig.headers!);
    }

    /// Override with user-passed headers if provided
    if (overrideHeaders != null) {
      overrideHeaders.forEach((key, value) {
        headersMerged[key] = value.toString();
      });
    }

    /// Set User-Agent header based on configuration or custom value
    if (overrideUserAgent != null) {
      printLog(
        'Scraper: Using user-passed User-Agent...',
        debug,
        color: LogColor.blue,
      );
      headersMerged['User-Agent'] = overrideUserAgent;
    } else {
      printLog(
        'Scraper: Using User-Agent from scraperConfig...',
        debug,
        color: LogColor.blue,
      );
      headersMerged['User-Agent'] = randomUserAgent(scraperConfig.userAgent);
    }

    /// Set cookies from scraperConfig
    if (scraperConfig.cookies != null) {
      printLog(
        'Scraper: Using cookies from scraperConfig...',
        debug,
        color: LogColor.blue,
      );
      headersMerged['Cookie'] = mapToCookie(scraperConfig.cookies!);
    }

    /// Override with user-passed cookies if provided
    if (overrideCookies != null) {
      printLog(
        'Scraper: Using user-passed cookies...',
        debug,
        color: LogColor.blue,
      );
      headersMerged['Cookie'] = mapToCookie(overrideCookies);
    }

    /// Log the final headers for debugging
    printLog('Scraper: Headers: $headersMerged', debug, color: LogColor.blue);

    /// Clean the URL using configured URL cleaners
    printLog('Scraper: Cleaning URL...', debug, color: LogColor.blue);
    url = cleanScraperConfigUrl(url, scraperConfig.urlCleaner);
    printLog("Scraper: Cleaned URL :) $url", debug, color: LogColor.green);

    /// Initialize data container
    Data dom = Data(url, "");

    /// Handle HTML fetching based on configuration and available data
    String? requestData;

    /// If HTML is passed and forceRefresh is false, use the passed HTML
    if (html != null && !scraperConfig.forceRefresh) {
      printLog(
        'Scraper: Using user-passed html :)',
        debug,
        color: LogColor.orange,
      );
      dom = Data(url, html);
    } else {
      /// Force HTTP request for fresh HTML content
      if (scraperConfig.forceRefresh) {
        printLog(
          'Scraper: Forcing http request for new html!!!',
          debug,
          color: LogColor.blue,
        );
      } else {
        printLog('Scraper: Fetching html...', debug, color: LogColor.blue);
      }

      requestData = await getRequest(
        url,
        headers: headersMerged,
        debug: debug,
        proxyAPIConfig: overrideProxyAPIConfig ?? scraperConfig.proxyAPIConfig,
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

    printLog('Scraper: Returning data...', debug, color: LogColor.green);
    return dom;
  }
}
