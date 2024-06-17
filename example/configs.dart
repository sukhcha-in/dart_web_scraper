import 'package:dart_web_scraper/dart_web_scraper.dart';

/// This is reusable config with parsers based on domain
Map<String, List<Config>> configMap = {
  /// Config for quotes.toscrape.com
  'quotes.toscrape.com': quotesConfig,
  // 'wikipedia.com': [],
};

/// Config for quotes.toscrape.com
List<Config> quotesConfig = [
  /// We can have multiple configs for same domain and use `configIndex` in `WebScraper.scrape` to switch between them
  Config(
    parsers: {
      /// We can have set of parsers for different UrlTargets
      "main": [
        Parser(
          id: "quotes",
          parent: ["_root"],

          /// _root is default parent
          type: ParserType.element,
          selector: [
            ".quote",
          ],
          multiple: true,
        ),
        Parser(
          id: "quote",
          parent: ["quotes"],
          type: ParserType.text,
          selector: [
            "span.text",
          ],
        ),
        Parser(
          id: "author",
          parent: ["quotes"],
          type: ParserType.text,
          selector: [
            "small.author",
          ],
        ),
        Parser(
          id: "tags",
          parent: ["quotes"],
          type: ParserType.text,
          selector: [
            "a.tag",
          ],
          multiple: true,
        ),
        Parser(
          id: "top10tags",
          parent: ["_root"],
          type: ParserType.text,
          selector: [
            "span.tag-item",
          ],
          multiple: true,
        ),
        Parser(
          id: "nextPage",
          parent: ["_root"],
          type: ParserType.url,
          selector: [
            "li.next a",
          ],

          /// Simple functions can be performed using optional parameters
          optional: Optional(
            prepend: "https://quotes.toscrape.com",
          ),

          /// Complex or custom functions can be performed using cleaner function
          cleaner: (data, debug) {
            Object input = data.obj;
            printLog(
              "Custom cleaner input: $input",
              debug,
              color: LogColor.yellow,
            );

            /// Return cleaned data
            return input;
          },
        ),
      ],

      /// We can set parsers for search page
      "search_page": [],
    },
    urlTargets: [
      /// UrlTarget for whole website
      UrlTarget(
        name: 'main',
        where: [
          "/",
        ],
      ),

      /// Example UrlTarget for search page
      UrlTarget(
        name: 'search_page',
        where: [
          "/search",
        ],
      ),
    ],
  ),
];
