import 'package:dart_web_scraper/dart_web_scraper.dart';

void main() async {
  WebScraper webScraper = WebScraper();

  Map<String, Object> result = await webScraper.scrape(
    url: Uri.parse("https://quotes.toscrape.com"),
    scraperConfig: ScraperConfig(
      parsers: [
        Parser(
          id: "quotes",
          parents: ["_root"],

          /// _root is default parent
          type: ParserType.element,
          selectors: [
            ".quote",
          ],
          multiple: true,
        ),
        Parser(
          id: "quote",
          parents: ["quotes"],
          type: ParserType.text,
          selectors: [
            "span.text",
          ],
        ),
      ],
    ),
  );

  print(result);
}
