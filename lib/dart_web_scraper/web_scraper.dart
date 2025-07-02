import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:html/dom.dart';

/// Combines scraping and parsing
class WebScraper {
  bool canScrape({
    required Uri url,
    required Map<String, List<ScraperConfig>> scraperConfigMap,
  }) {
    ScraperConfig? scraperConfig = findScraperConfig(
      url: url,
      scraperConfigMap: scraperConfigMap,
    );
    return scraperConfig != null;
  }

  Future<Map<String, Object>> scrape({
    required Uri url,
    required Map<String, List<ScraperConfig>> scraperConfigMap,
    ProxyAPIConfig? proxyAPIConfig,
    bool debug = false,
    Document? html,
    Map<String, String>? cookies,
    Map<String, String>? headers,
    String? userAgent,
    bool concurrentParsing = false,
  }) async {
    /// Find the appropriate scraper configuration for this URL
    ScraperConfig? scraperConfig = findScraperConfig(
      url: url,
      scraperConfigMap: scraperConfigMap,
    );
    if (scraperConfig == null) {
      throw WebScraperError('Unsupported URL');
    }

    /// Scrape the URL
    Scraper scraping = Scraper();
    Data scrapedData = await scraping.scrape(
      url: url,
      html: html,
      debug: debug,
      scraperConfig: scraperConfig,
      cookies: cookies,
      headers: headers,
      userAgent: userAgent,
      proxyAPIConfig: proxyAPIConfig,
    );

    /// Parse HTML
    WebParser webParser = WebParser();
    Map<String, Object> parsedData = await webParser.parse(
      scrapedData: scrapedData,
      scraperConfig: scraperConfig,
      proxyAPIConfig: proxyAPIConfig,
      cookies: cookies,
      debug: debug,
      concurrentParsing: concurrentParsing,
    );

    return parsedData;
  }
}
