import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:html/dom.dart';

/// Combines scraping and parsing
class WebScraper {
  bool isUrlSupported({
    required Uri url,
    required Map<String, List<Config>> configMap,
    int configIndex = 0,
  }) {
    Config? config = getConfig(
      url,
      configs: configMap,
      configIndex: configIndex,
    );
    UrlTarget? urlTarget;
    if (config != null) {
      urlTarget = fetchTarget(config.urlTargets, url);
    }
    if (config == null || urlTarget == null) {
      return false;
    }
    return true;
  }

  Future<Map<String, Object>> scrape({
    required Uri url,
    required Map<String, List<Config>> configMap,
    int configIndex = 0,
    Uri? proxyUrl,
    bool debug = false,
    Document? html,
    Map<String, String>? cookies,
    bool concurrentParsing = false,
  }) async {
    /// Fetch config and target
    Config? config = getConfig(
      url,
      configs: configMap,
      configIndex: configIndex,
    );
    UrlTarget? urlTarget;
    if (config != null) {
      urlTarget = fetchTarget(config.urlTargets, url);
    }
    if (config == null || urlTarget == null) {
      throw WebScraperError('Unsupported URL');
    }

    /// Scrape the URL
    Scraper scraping = Scraper();
    Data scrapedData = await scraping.scrape(
      url: url,
      html: html,
      debug: debug,
      config: config,
      cookies: cookies,
      proxyUrl: proxyUrl,
    );

    /// Parse HTML
    WebParser webParser = WebParser();
    Map<String, Object> parsedData = await webParser.parse(
      scrapedData: scrapedData,
      config: config,
      proxyUrl: proxyUrl,
      cookies: cookies,
      debug: debug,
      concurrentParsing: concurrentParsing,
    );

    return parsedData;
  }
}
