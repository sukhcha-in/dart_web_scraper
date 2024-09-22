[![Pub version](https://img.shields.io/pub/v/dart_web_scraper?logo=dart&style=plastic)](https://pub.dev/packages/dart_web_scraper)
[![Pub Likes](https://img.shields.io/pub/likes/dart_web_scraper)](https://pub.dev/packages/dart_web_scraper)
[![Pub Points](https://img.shields.io/pub/points/dart_web_scraper)](https://pub.dev/packages/dart_web_scraper)
[![Pub Popularity](https://img.shields.io/pub/popularity/dart_web_scraper)](https://pub.dev/packages/dart_web_scraper)

Config-based, reusable web scraper for web and API scraping. Scrape multiple pages or APIs without writing parsers or scraping logic, using simple configurations for efficient scraping.

#### Why need this package?

- **Built-in parsers**: This package have built-in parsers for most common scraping tasks.
- **Config-based**: No need to write parsing logic from scratch for each page.
- **Data cleaning**: Clean the data before it's added to the final result.
- **Concurrency**: Parse multiple parsers concurrently using concurrency mode.
- **CSS Selctors**: Use `CSS selectors` to extract data from HTML.
- **API scraping**: Fetch data using `HTTP requests`.
- **Pass cookies**: Pass `cookies` to the scraper or HTTP parsers.
- **JSON parsing**: Decode `JSON` string or extract data using `Json path`.
- **JSON-LD**: Extract all `ld+json` objects and places them into a list.
- **JSON5**: Decode `JSON5` syntax.
- **StrBetween**: Extracts the `string between` two strings.
- **Sibling**: Used when target element doesn't have a valid selector but sibling does.
- **Table**: Extracts data from HTML/JSON table as a `Map`.
- **Attribute**: Extracts `attribute` value from an HTML element.
- **Data Injection**: Inject previously parsed data by parser `selector` using `<slot>`.
- **URL based proxy**: Use URL based proxy for HTTP requests.

## Getting Started

Add `dart_web_scraper` as dependencies in your `pubspec.yaml`:

```yaml
dependencies:
  dart_web_scraper:
```

Or install it with a flutter command:

```bash
$ flutter pub add dart_web_scraper
```

Or install it with a dart command:

```bash
$ dart pub add dart_web_scraper
```

Import the package:

```dart
import 'package:dart_web_scraper/dart_web_scraper.dart';
```

## Usage

```dart
/// Initialize WebScraper
WebScraper webScraper = WebScraper();

/// Scrape website based on configMap
Map<String, Object> result = await webScraper.scrape(
  url: Uri.parse("https://quotes.toscrape.com"),
  configMap: configMap,
  configIndex: 0,
  debug: true,
);

print(jsonEncode(result));
```

Example `configMap` for `quotes.toscrape.com` can be found [here](https://github.com/sukhcha-in/dart_web_scraper/blob/main/example/configs.dart).

### Structure

This is the basic structure for `configMap`:

```dart
  configMap // Map<String, List<Config>>
  ├── quotes.toscrape.com // String
  │   ├── Config
  │   │   ├── parsers // Map<String, List<Parser>>
  │   │   │   └── urltarget.name // String. Name of your UrlTarget
  │   │   │       ├── Parser
  │   │   │       │   ├── id // String. Add _root as entrypoint id
  │   │   │       │   ├── parent // List<String>
  │   │   │       │   ├── type // ParserType
  │   │   │       └── Parser // Another Parser for same UrlTarget
  │   │   └── urlTargets // List<UrlTarget>
  │   │       ├── UrlTarget
  │   │       │   ├── name // String
  │   │       │   └── where // List<String>
  │   │       └── UrlTarget // Another UrlTarget for a Config
  │   └── Config // Another Config for same domain
  └── example.com // Another domain in configMap
```

## Classes and Methods

### Config `class`

Config for a domain.

```dart
Config Config({
  // Scrape the URL again even if `html` is passed to `WebScraper.scrape`. Defaults to false.
  bool forceFetch = false,
  // User agent device. Defaults to mobile.
  UserAgentDevice userAgent = UserAgentDevice.mobile,
  // Allow user passed HTML. Defaults to true.
  bool usePassedHtml = true,
  // Allow user passed User-Agent. Defaults to false.
  bool usePassedUserAgent = false,
  // Map of UrlTarget's name containing list of parsers.
  required Map<String, List<Parser>> parsers,
  // List of UrlTarget. More details below.
  required List<UrlTarget> urlTargets,
})
```

---

### UrlTarget `class`

It is used to target different sections of a website. For example you can have different set of `parsers` in a config object for `/products/foo` and `/search?q=foo`

```dart
UrlTarget UrlTarget({
  // Name of the UrlTarget
  required String name,
  // Set list of static paths in a url. For any path set it to "/"
  required List<String> where,
  // Useful if you want to use API request instead of scraping a webpage. Defaults to true.
  bool needsHtml = true,
  // Parameters cleaner. More details below.
  UrlCleaner? urlCleaner,
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
  required List<String> parent,
  // Set the parser types.
  required ParserType type,
  // List of selectors wil execute one by one and stop execution once data is successfully parsed by one selector.
  List<String> selector = const [],
  // Set parser for private usage. Will be not added to final result.
  bool isPrivate = false,
  // Set multiple to `true` if data is a List.
  bool multiple = false,
  // Optional parameters explained below.
  Optional? optional,
  // Custom cleaner function, clean the data and return data.
  Object? Function(Data, bool)? cleaner,
})
```

---

### Parser Types

| Type                         | Description                                                              | Selector                                                                                                                                       | Optional              |
| ---------------------------- | ------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `ParserType.element`         | Extracts element nodes from HTML using CSS selectors.                    | CSS selector required.                                                                                                                         | `N/A`                 |
| `ParserType.attribute`       | Extracts attribute from HTML element using CSS selectors.                | Use CSS selector to select an element and **append attribute name with `::`**. Ex: `div#myid::name` where `name` refers to the attribute name. | `Optional.any`        |
| `ParsetType.text`            | Extracts text from HTML element using CSS selectors.                     | CSS selector required.                                                                                                                         | `Optional.any`        |
| `ParserType.image`           | Extracts image URL from HTML element.                                    | CSS selector required. After selecting an element it tries to find `src` attribute.                                                            | `Optional.any.any`    |
| `ParserType.url`             | Extracts URL from an HTML element                                        | CSS selector required. After selecting an element it tries to find `href` attribute.                                                           | `Optional.any`        |
| `ParserType.urlParam`        | From an URL it extracts query parameter.                                 | Add parameter name in selector.                                                                                                                | `Optional.any`        |
| `ParserType.table`           | Extracts data from HTML table.                                           | CSS selector required. Select table using this selector.                                                                                       | `Optional.table`      |
| `ParserType.sibling`         | Used when target element doesn't have a valid selector but sibling does. | CSS selector is required.                                                                                                                      | `Optional.sibling`    |
| `ParserType.strBetween`      | Extracts the string between two strings.                                 | Not required                                                                                                                                   | `Optional.strBetween` |
| `ParserType.http`            | Get data using http request                                              | Not required                                                                                                                                   | `Optional.http`       |
| `ParserType.json`            | Decode JSON string or extract data.                                      | [json_path](https://pub.dev/packages/json_path) syntax should be used as a selector                                                            | `Optional.any`        |
| `ParserType.jsonld`          | Extracts all Ld+Json objects and places them into a list                 | Not required                                                                                                                                   | `N/A`                 |
| `ParserType.jsonTable`       | Extracts data from JSON as table.                                        | [json_path](https://pub.dev/packages/json_path) syntax should be used as a selector                                                            | `Optional.table`      |
| `ParserType.json5decode`     | Decodes JSON5 syntax                                                     | Not required                                                                                                                                   | `N/A`                 |
| `ParserType.staticVal`       | Useful if you want to set static values to final result                  | Not required                                                                                                                                   | `Optional.staticVal`  |
| `ParserType.returnUrlParser` | Returns URL which was passed to WebScraper                               | Not required                                                                                                                                   | `Optional.any`        |

#### Data injection to `selector`

You can inject previously parsed data by parser `selector` using `<slot>` For example:

```dart
selector: [
  // for css selector
  "div#<slot>id</slot>"
  // or for json path:
  r"$.data.<slot>id</slot>.value"
]
```

You can also inject data using `slot` into `Optional.http`'s `url` field. For example:

```dart
Parser(
  id: "json",
  parent: ["product_id"],
  type: ParserType.http,
  isPrivate: true,
  optional: Optional.http(
    url: "https://example.com/productdetails/<slot>product_id</slot>",
    responseType: HttpResponseType.json,
  ),
),
```

---

### Optional Parameters

> `Optional.any` `class`

Can be used with any parser.

```dart
Optional.any({
  // Pre defined methods which can be applied to final result
  ApplyMethod? apply,
  // Regex selector and regexGroup can be used together to select data from final result
  String? regex,
  int? regexGroup,
  // regexReplace something with regexReplaceWith
  String? regexReplace,
  String? regexReplaceWith,
  // Replace the first occurence in a string with a string
  Map<String, String>? replaceFirst,
  // Replace all occurences in a string with a string
  Map<String, String>? replaceAll,
  // Crop string from start. If data is List it removes the elements from start.
  int? cropStart,
  // Crop string from end. If data is List it removes the elements from end.
  int? cropEnd,
  // Prepend something to a string
  String? prepend,
  // Append something to a string
  String? append,
  // Converts final result to boolean if data matches with one of the `match` object
  List<Object>? match,
  // Select nth child from a list
  int? nth,
  // Split a string by something
  String? splitBy,
})
```

> `Optional.http` `class`

**Required** with `ParserType.http`

```dart
Optional.http({
  // URL to fetch data
  String? url,
  // GET and POST methods are currently supported
  HttpMethod? method,
  // Custom headers
  Map<String, Object>? headers,
  // Set Useragent to mobile or desktop
  UserAgentDevice? userAgent,
  // Set expected response type
  HttpResponseType? responseType,
  // Payload for POST requests
  Object? payload,
  // Use proxy?
  bool usePassedProxy = false,
  // Set payload type for POST request
  HttpPayload? payloadType,
  // Used for debugging purposes only, saves file to /cache folder
  bool cacheResponse = false,
})
```

> `Optional.strBetween` `class`

**Required** with `ParserType.strBetween`

```dart
Optional.strBetween({
  // Starting of a string
  String? start,
  // Ending of a string
  String? end
})
```

> `Optional.sibling` `class`

Used with `ParserType.sibling`

```dart
Optional.sibling({
  // previous or next sibling, defaults to next if `Optional.sibling` is not passed
  required SiblingDirection direction,
  // Check if sibling.text contains some string
  List<String>? where
})
```

> `Optional.table` `class`

Used with `ParserType.table`
**Required** with `ParserType.jsonTable`

```dart
Optional.table({
  // Set CSS selector for selecting keys row
  // When using jsonTable set keys as json path selector
  String? keys,
  // Set CSS selector for selecting values row
  // When using jsonTable set values as json path selector
  String? values,
})
```

> `Optional.staticVal` `class`

**Required** with `ParserType.staticVal`

```dart
Optional.staticVal({
  // Set string value to result
  String? strVal,
  // Set Map to result
  Map<String, Object>? mapVal
})
```

## Credits

[json_path](https://pub.dev/packages/json_path) - JSON path selector\
[json5](https://pub.dev/packages/json5) - JSON5 syntax decoder
