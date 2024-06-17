[![Pub version](https://img.shields.io/pub/v/dart_web_scraper?logo=dart&style=plastic)](https://pub.dev/packages/dart_web_scraper)
[![Pub Likes](https://img.shields.io/pub/likes/dart_web_scraper)](https://pub.dev/packages/dart_web_scraper)
[![Pub Points](https://img.shields.io/pub/points/dart_web_scraper)](https://pub.dev/packages/dart_web_scraper)
[![Pub Popularity](https://img.shields.io/pub/popularity/dart_web_scraper)](https://pub.dev/packages/dart_web_scraper)
<!-- [![Pub Publisher](https://img.shields.io/pub/publisher/dart_web_scraper)](https://pub.dev/packages/dart_web_scraper) -->



Easy-to-use, reusable web scraper. Extracts and cleans HTML/JSON, providing structured data results.

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