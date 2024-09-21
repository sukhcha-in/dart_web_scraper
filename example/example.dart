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
    debug: true,
    concurrentParsing: false,
  );

  print(jsonEncode(result));
}
