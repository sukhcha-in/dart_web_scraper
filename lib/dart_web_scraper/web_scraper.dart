import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:html/dom.dart';

/// Combines scraping and parsing
class WebScraper {
  Future<Map<String, Object>> scrape({
    required Uri url,
    required Map<String, List<Config>> configMap,
    int configIndex = 0,
    Uri? proxyUrl,
    bool debug = false,
    Document? html,
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
      throw SpiderError('Unsupported URL');
    }

    /// Scrape the URL
    Scraper scraping = Scraper();
    Data scrapedData = await scraping.scrape(
      url: url,
      html: html,
      debug: debug,
      config: config,
      proxyUrl: proxyUrl,
    );

    /// Parse HTML
    WebParser webParser = WebParser();
    Map<String, Object> parsedData = await webParser.parse(
      scrapedData: scrapedData,
      config: config,
      proxyUrl: proxyUrl,
      debug: debug,
    );

    return parsedData;
  }
}
