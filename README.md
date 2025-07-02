[![Pub version](https://img.shields.io/pub/v/dart_web_scraper?logo=dart&style=plastic)](https://pub.dev/packages/dart_web_scraper)
[![Pub Likes](https://img.shields.io/pub/likes/dart_web_scraper)](https://pub.dev/packages/dart_web_scraper)
[![Pub Points](https://img.shields.io/pub/points/dart_web_scraper)](https://pub.dev/packages/dart_web_scraper)
[![Pub Monthly Downloads](https://img.shields.io/pub/dm/dart_web_scraper)](https://pub.dev/packages/dart_web_scraper)

Config-based, reusable web scraper for web and API scraping. Scrape, parse web pages or APIs without writing parsers or scraping logic, using simple key/value based configs.

## Features

- Config-based, reusable web scraper for web and API scraping.
- Scrape, parse web pages or APIs without writing parsers or scraping logic, using simple key/value based configs.
- 15+ Built-in parsers.
- Data cleaning and transformations.

## Getting Started

Install it with a `flutter` command:

```bash
$ flutter pub add dart_web_scraper
```

Install it with a `dart` command:

```bash
$ dart pub add dart_web_scraper
```

## Usage

This is the most basic example of scraping quotes from quotes.toscrape.com

```dart
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

```
### WebScraper `class`

High-level web scraper that combines HTML fetching and data parsing.

```dart
WebScraper WebScraper()

// Main scraping method
Future<Map<String, Object>> scrape({
  // The URL to scrape
  required Uri url,
  // Scraper configuration for the URL
  ScraperConfig? scraperConfig,
  // Map of domain names to lists of scraper configurations
  Map<String, List<ScraperConfig>>? scraperConfigMap,
  // Optional proxy API configuration
  ProxyAPIConfig? proxyAPIConfig,
  // Enable debug logging
  bool debug = false,
  // Pre-fetched HTML document (optional, avoids HTTP request if provided)
  Document? html,
  // Custom cookies to include in HTTP requests
  Map<String, String>? cookies,
  // Custom HTTP headers to include in requests
  Map<String, String>? headers,
  // Custom user agent string (overrides scraper config setting)
  String? userAgent,
})
```

### ScraperConfig `class`

Configuration for targeting and scraping specific types of URLs.

```dart
ScraperConfig ScraperConfig({
  // List of URL path patterns that this configuration should handle
  List<String> pathPatterns = const [],
  // List of parsers that define how to extract data from the page
  required List<Parser> parsers,
  // Whether HTML content needs to be fetched from the URL
  bool requiresHtml = true,
  // URL preprocessing and cleaning configuration
  UrlCleaner? urlCleaner,
  // Whether to force a fresh HTTP request even if HTML is provided
  bool forceRefresh = false,
  // User agent device type for HTTP requests
  UserAgentDevice userAgent = UserAgentDevice.mobile,
})
```

#### UrlCleaner `class`

Clean the URL before it's passed to a scraper.

```dart
UrlCleaner UrlCleaner({
  // Set whitelisted or blacklisted URL parameters.
  List<String>? whitelistParams,
  List<String>? blacklistParams,
  // Set custom static parameters to a URL.
  Map<String, String>? appendParams,
})
```

---

### Parser `class`

Easy to use and reusable parser class :)

```dart
Parser Parser({
  // `id` is used for final result.
  // Child parsers can reference to parent parser using `id`.
  // You can have multiple parsers with same id and same parent and will execute one by one and stop execution once data is successfully parsed by one parser.
  required String id,
  // A child can have multiple parents, it will execute once parent parser is successfully executed.
  required List<String> parents,
  // Set the parser types.
  required ParserType type,
  // List of selectors will execute one by one and stop execution once data is successfully parsed by one selector.
  List<String> selectors = const [],
  // Set parser for private usage. Will be not added to final result.
  bool isPrivate = false,
  // Set multiple to `true` if data is a List.
  bool multiple = false,
  // Some parsers require additional options to work properly.
  // You can pass these options here.
  // For example, `ParserType.table` requires `ParserOptions.table`.
  ParserOptions? parserOptions;
  // Data transformation options to apply after extraction.
  TransformationOptions? transformationOptions,
  // Custom cleaner function, clean the data and return data.
  Object? Function(Data, bool)? cleaner,
  // If you plan to create configs from JSON, you can pass cleaner name here.
  // This cleaner should be registered in `CleanerRegistry` to be used.
  // If you pass cleaner along with cleanerName, cleanerName function will be ignored.
  String? cleanerName,
})
```

---

### Parser Types

| Type                         | Description                                                              | Selector                                                                                                                                       | ParserOptions                 |
| ---------------------------- | ------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| `ParserType.element`         | Extracts element nodes from HTML using CSS selectors.                    | CSS selector required.                                                                                                                         | `-`                           |
| `ParserType.attribute`       | Extracts attribute value from HTML element using CSS selectors.          | Use CSS selector to select an element and **append attribute name with `::`**. Ex: `div#myid::name` where `name` refers to the attribute name. | `-`                           |
| `ParserType.text`            | Extracts text from HTML element using CSS selectors.                     | CSS selector required.                                                                                                                         | `-`                           |
| `ParserType.image`           | Extracts image URL from HTML element.                                    | CSS selector required. After selecting an element it tries to find `src` attribute.                                                            | `-`                           |
| `ParserType.url`             | Extracts URL from an HTML element                                        | CSS selector required. After selecting an element it tries to find `href` attribute.                                                           | `-`                           |
| `ParserType.urlParam`        | From an URL it extracts query parameter.                                 | Add parameter name in selector.                                                                                                                | `ParserOptions.urlParam`      |
| `ParserType.table`           | Extracts data from HTML table.                                           | CSS selector required. Select table using this selector.                                                                                       | `ParserOptions.table`         |
| `ParserType.sibling`         | Used when target element doesn't have a valid selector but sibling does. | CSS selector is required.                                                                                                                      | `ParserOptions.sibling`       |
| `ParserType.strBetween`      | Extracts the string between two strings.                                 | Not required                                                                                                                                   | `ParserOptions.stringBetween` |
| `ParserType.http`            | Get data using http request                                              | Not required                                                                                                                                   | `ParserOptions.http`          |
| `ParserType.json`            | Decode JSON string or extract data.                                      | [json_path](https://pub.dev/packages/json_path) syntax should be used as a selector                                                            | `-`                           |
| `ParserType.jsonld`          | Extracts all Ld+Json objects and places them into a list                 | Not required                                                                                                                                   | `-`                           |
| `ParserType.jsonTable`       | Extracts data from JSON as table.                                        | [json_path](https://pub.dev/packages/json_path) syntax should be used as a selector                                                            | `ParserOptions.table`         |
| `ParserType.json5decode`     | Decodes JSON5 syntax                                                     | Not required                                                                                                                                   | `-`                           |
| `ParserType.staticVal`       | Useful if you want to set static values to final result                  | Not required                                                                                                                                   | `ParserOptions.staticValue`   |
| `ParserType.returnUrlParser` | Returns URL which was passed to WebScraper                               | Not required                                                                                                                                   | `-`                           |

#### Data injection to `selector`

You can inject previously parsed data using `<slot>`. For example:

```dart
selectors: [
  // for css selector
  "div#<slot>id</slot>"
  // or for json path:
  r"$.data.<slot>id</slot>.value"
]
```

You can also inject data using `slot` into `ParserOptions.http`'s `url` field. For example:

```dart
Parser(
  id: "json",
  parents: ["product_id"],
  type: ParserType.http,
  isPrivate: true,
  parserOptions: ParserOptions.http(
    HttpParserOptions(
      url: "https://example.com/productdetails/<slot>product_id</slot>",
      method: HttpMethod.get,
      responseType: HttpResponseType.json,
    ),
  ),
),
```

---

### ParserOptions `class`

Parser-specific configuration options that control how individual parsers behave during data extraction.

Use the appropriate named constructor for the parser type you're configuring:

```dart
// For HTTP parsers
ParserOptions.http(HttpParserOptions(...))

// For table and JSON table parsers
ParserOptions.table(TableParserOptions(...))

// For sibling parsers
ParserOptions.sibling(SiblingParserOptions(...))

// For static value parsers
ParserOptions.staticValue(StaticValueParserOptions(...))

// For string between parsers
ParserOptions.stringBetween(StringBetweenParserOptions(...))

// For URL parameter parsers
ParserOptions.urlParam(UrlParamParserOptions(...))
```

---

### TransformationOptions `class`

Comprehensive data transformation system that can be applied to extracted data.

```dart
TransformationOptions TransformationOptions({
  // Text to add to the beginning
  String? prepend,
  // Text to add to the end
  String? append,
  // List of values to check for matches, returns boolean
  List<Object>? match,
  // Index to extract from a list (negative for reverse indexing)
  int? nth,
  // Delimiter to split data by
  String? splitBy,
  // Whether to decode URL-encoded strings
  bool? urldecode,
  // Whether to convert map values to a list
  bool? mapToList,
  // Regular expression extraction options
  RegexTransformationOptions? regexMatch,
  // Regular expression replacement options
  RegexReplaceTransformationOptions? regexReplace,
  // Text replacement options
  ReplaceTransformationOptions? replace,
  // Text cropping options (start/end)
  CropTransformationOptions? crop,
  // Extract text between two strings
  StringBetweenTransformationOptions? stringBetween,
  // Extract sibling elements
  SiblingTransformationOptions? sibling,
  // Table processing options
  TableTransformationOptions? table,
  // Return static value options
  StaticValueTransformationOptions? staticValue,
  // Custom order for applying transformations
  List<TransformationType>? transformationOrder,
})
```

## Creating configs from JSON

You can now create configs from JSON string using `ScraperConfig.fromJson` method.

## Cleaner Registry for parsers created using JSON

You can register cleaners using `CleanerRegistry.register` method. This is useful when you want to create configs from JSON and want to use custom cleaner for `Parser`.

For example:

```dart
CleanerRegistry.register('formatPrice', (data, debug) {
  return '\$${data.obj}';
});
```

then pass the cleaner name in `Parser`:

```dart
Parser(
  //...
  cleanerName: 'formatPrice',
  //...
)
```

## Credits

[json_path](https://pub.dev/packages/json_path) - JSON path selector\
[json5](https://pub.dev/packages/json5) - JSON5 syntax decoder

<img src="https://profile-counter.deno.dev/dart_web_scraper/count.svg" alt="Visitor's Count" />
