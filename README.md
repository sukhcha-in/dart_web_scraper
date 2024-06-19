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

Result:
```json
{
    "quotes": [
        {
            "quote": "“The world as we have created it is a process of our thinking. It cannot be changed without changing our thinking.”",
            "author": "Albert Einstein",
            "tags": [
                "change",
                "deep-thoughts",
                "thinking",
                "world"
            ]
        },
        {
            "quote": "“It is our choices, Harry, that show what we truly are, far more than our abilities.”",
            "author": "J.K. Rowling",
            "tags": [
                "abilities",
                "choices"
            ]
        },
        {
            "quote": "“There are only two ways to live your life. One is as though nothing is a miracle. The other is as though everything is a miracle.”",
            "author": "Albert Einstein",
            "tags": [
                "inspirational",
                "life",
                "live",
                "miracle",
                "miracles"
            ]
        },
        {
            "quote": "“The person, be it gentleman or lady, who has not pleasure in a good novel, must be intolerably stupid.”",
            "author": "Jane Austen",
            "tags": [
                "aliteracy",
                "books",
                "classic",
                "humor"
            ]
        },
        {
            "quote": "“Imperfection is beauty, madness is genius and it's better to be absolutely ridiculous than absolutely boring.”",
            "author": "Marilyn Monroe",
            "tags": [
                "be-yourself",
                "inspirational"
            ]
        },
        {
            "quote": "“Try not to become a man of success. Rather become a man of value.”",
            "author": "Albert Einstein",
            "tags": [
                "adulthood",
                "success",
                "value"
            ]
        },
        {
            "quote": "“It is better to be hated for what you are than to be loved for what you are not.”",
            "author": "André Gide",
            "tags": [
                "life",
                "love"
            ]
        },
        {
            "quote": "“I have not failed. I've just found 10,000 ways that won't work.”",
            "author": "Thomas A. Edison",
            "tags": [
                "edison",
                "failure",
                "inspirational",
                "paraphrased"
            ]
        },
        {
            "quote": "“A woman is like a tea bag; you never know how strong it is until it's in hot water.”",
            "author": "Eleanor Roosevelt",
            "tags": [
                "misattributed-eleanor-roosevelt"
            ]
        },
        {
            "quote": "“A day without sunshine is like, you know, night.”",
            "author": "Steve Martin",
            "tags": [
                "humor",
                "obvious",
                "simile"
            ]
        }
    ],
    "top10tags": [
        "love",
        "inspirational",
        "life",
        "humor",
        "books",
        "reading",
        "friendship",
        "friends",
        "truth",
        "simile"
    ],
    "nextPage": "https://quotes.toscrape.com/page/2/",
    "url": "https://quotes.toscrape.com"
}
```