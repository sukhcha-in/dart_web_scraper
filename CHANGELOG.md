## 0.2.7
- Update `cleaner` function signature to include `extractedData`
- Add new `ParserType` for `empty` values

## 0.2.6
- Add `overrideProxyAPIConfig` option to `Scraper`, `WebParser` and `WebScraper`.

## 0.2.5
- Added `headers`, `cookies`, and `proxyAPIConfig` options to `ScraperConfig`.
- The HTTP Parser is now independent from the base request. Added `proxyApiConfig` and `cookies` options to `HttpParserOptions`.
- Refactored `cookies`, `headers`, and `userAgent` to `overrideCookies`, `overrideHeaders`, and `overrideUserAgent` for greater clarity.

## 0.2.4
- Fix debug logging functionality and update HTTP response handling in scraper utilities

## 0.2.3
- Fix config map not able to find config
- Added `useNth` option to select nth config from list.
- Dedicated model `ScraperConfigMap` for specifying configs.

## 0.2.2
- Fix exports
- Add more options for generating random user agents

## 0.2.1
- Slot injection to transformations
- Update ParserOptions constructors to require options parameter for improved clarity and consistency

## 0.2.0

- Simplify the codebase.
- Enhance the documentation.
- `ScraperConfig` replaces `Config` and `UrlTarget`
- `ParserOptions` and `TransformationOptions` replaces `Optional` for better readability.

## 0.1.6

- README fix

## 0.1.5

- Create configs using JSON
- Create `CleanerRegistry` to register cleaners
- Update all dependencies.

## 0.1.4

- Update all dependencies.
- Add ProxyAPI and ProxyUrlParam name instead of ProxyUrl.

## 0.1.3

- Support for Web Platform.

## 0.1.2

- Minor changes and fixes.

## 0.1.1

- Add Regex support for `UrlTarget`'s `where` property.

## 0.1.0

- Breaking changes to Optional parameters.
- Replaced AbstractOptional with Optional with named constructors.
- Now you can pass cookies to `WebScraper.scrape`, `WebParser.parse` and `Scraper.scrape`, this removes predefined cookies in your config.

## 0.0.15

- Added `concurrentParsing` variable to `WebParser.parse` and `WebScraper.scrape`.

## 0.0.14

- Add `isUrlSupported` method to `WebScraper`.

## 0.0.13

- Remove dependency on `collection` package.

## 0.0.12

- Update `README.md` file.

## 0.0.11

- Print parser debug information with `Parser.id`.

## 0.0.10

- Fix `queryParameters` bug.

## 0.0.9

- Support header forwarding for ScrapingBee requests.

## 0.0.8

- POST requests can now use `proxyUrl`

## 0.0.7

- Update `Readme.md` file.

## 0.0.6

- Rename `Spider` to `WebScraper`.

## 0.0.5

- Add badges to the `README.md` file.

## 0.0.4

- The package description was too short.

## 0.0.3

- First version of the package.
