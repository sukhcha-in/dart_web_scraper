import 'package:dart_web_scraper/dart_web_scraper.dart';

/// This is reusable config with parsers based on domain
Map<String, List<ScraperConfig>> configMap = {
  /// Config for quotes.toscrape.com
  'quotes.toscrape.com': [
    ScraperConfig(
      pathPatterns: ["/"],
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
        Parser(
          id: "author",
          parents: ["quotes"],
          type: ParserType.text,
          selectors: [
            "small.author",
          ],
        ),
        Parser(
          id: "tags",
          parents: ["quotes"],
          type: ParserType.text,
          selectors: [
            "a.tag",
          ],
          multiple: true,
        ),
        Parser(
          id: "top10tags",
          parents: ["_root"],
          type: ParserType.text,
          selectors: [
            "span.tag-item",
          ],
          multiple: true,
        ),
        Parser(
          id: "nextPage",
          parents: ["_root"],
          type: ParserType.url,
          selectors: [
            "li.next a",
          ],

          /// Simple functions can be performed using optional parameters
          transformationOptions: TransformationOptions(
            prepend: "https://quotes.toscrape.com",
          ),

          /// Complex or custom functions can be performed using cleaner function
          cleaner: (Data data, Map<String, Object> extractedData, bool debug) {
            Object input = data.obj;
            printLog(
              "Custom cleaner input: $input, allData: $extractedData",
              debug,
              color: LogColor.yellow,
            );

            /// Return cleaned data
            return input;
          },
        ),
      ],
    ),
  ],
  // 'wikipedia.com': [],
};
