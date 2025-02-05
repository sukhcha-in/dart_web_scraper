import 'dart:convert';

import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'configs.dart';

void main() async {
  /// Initialize WebScraper
  WebScraper webScraper = WebScraper();

  /// Scrape website based on configMap
  Map<String, Object> result = await webScraper.scrape(
    url: Uri.parse("https://quotes.toscrape.com"),
    configMap: configMap,
    configIndex: 0,
    cookies: {
      "foo": "bar",
    },
    userAgent: "DartWebScraper/0.1",
    debug: true,
    concurrentParsing: false,
    // proxyAPI: Uri.parse("https://api.exampleproxy.com/scrape?key=API_KEY"),
    // proxyUrlParam: "url", // The query parameter name for the URL to scrape
  );

  print(jsonEncode(result));
}
