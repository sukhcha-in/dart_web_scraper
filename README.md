An easy to use and reusable web scraper and parser.

## Note
This package is still in development and not ready for production use. Contributions are welcome.

## Features

This package includes 16 parsers to parse the web pages based on configuration file.

## Getting started

Import this package:

```dart
import 'package:dart_web_scraper/dart_web_scraper.dart';
```

## Usage

Create configuration map:

```dart
Map<String, List<Config>> configMap = {
  'quotes.toscrape.com': [
    Config(
      parsers: {
        "main": [
          Parser(
            id: "quotes",
            parent: ["_root"],
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
        ],
      },
      urlTargets: [
        UrlTarget(
          name: 'main',
          where: [
            "/",
          ],
        ),
      ],
    ),
  ],
};
```

Run the scraper:

```dart
WebScraper webScraper = WebScraper();

Map<String, Object> result = await webScraper.scrape(
    url: Uri.parse("https://quotes.toscrape.com"),
    configMap: configMap,
);
```