import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:dart_web_scraper/common/utils/http.dart';
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
    Uri? proxyAPI,
    String? proxyUrlParam,
    bool debug = false,
    Document? html,
    Map<String, String>? cookies,
    Map<String, String>? headers,
    String? userAgent,
    bool concurrentParsing = false,
    HttpClientType clientType = HttpClientType.browserClient,
    ConsoleClientOptions consoleClientOptions = const ConsoleClientOptions(),
    CurlClientOptions curlClientOptions = const CurlClientOptions(),
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
      headers: headers,
      userAgent: userAgent,
      proxyAPI: proxyAPI,
      proxyUrlParam: proxyUrlParam,
    );

    /// Parse HTML
    WebParser webParser = WebParser();
    Map<String, Object> parsedData = await webParser.parse(
      scrapedData: scrapedData,
      config: config,
      proxyAPI: proxyAPI,
      proxyUrlParam: proxyUrlParam,
      cookies: cookies,
      debug: debug,
      concurrentParsing: concurrentParsing,
      clientType: clientType,
      consoleClientOptions: consoleClientOptions,
      curlClientOptions: curlClientOptions,
    );

    return parsedData;
  }
}
