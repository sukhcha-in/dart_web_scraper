import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/exports.dart';

/// Processes scraped HTML data using configurable parsers to extract structured information.
///
/// This class is the core of the data extraction system. It:
/// - Manages a hierarchy of parsers based on parent-child relationships
/// - Executes parsers in the correct order (root parsers first, then children)
/// - Handles both single and multiple data extraction scenarios
/// - Applies transformations and cleaning to extracted data
/// - Supports concurrent parsing for improved performance
/// - Maintains private parser data for internal processing
///
/// The parser system uses a tree structure where child parsers depend on
/// their parent parsers' output, allowing for complex nested data extraction.
class WebParser {
  /// Internal storage for extracted data during parsing process.
  ///
  /// This map stores all parsed data with parser IDs as keys. It's used
  /// internally to share data between parsers and for reference in
  /// subsequent parsing operations.
  final Map<String, Object> extractedData = {};

  /// Main entry point for parsing scraped HTML data.
  ///
  /// This method orchestrates the entire parsing process:
  /// 1. Builds a parent-to-children relationship map from all parsers
  /// 2. Identifies root parsers (those with '_root' as parent)
  /// 3. Executes parsers in hierarchical order
  /// 4. Applies transformations and cleaning to extracted data
  /// 5. Returns the final structured data
  ///
  /// Parameters:
  /// - [scrapedData]: The scraped HTML data to parse
  /// - [scraperConfig]: Configuration containing parser definitions
  /// - [proxyAPIConfig]: Optional proxy API for HTTP requests during parsing
  /// - [cookies]: Cookies to include in any HTTP requests during parsing
  /// - [debug]: Enable debug logging for troubleshooting
  /// - [concurrentParsing]: Enable concurrent parser execution for performance
  ///
  /// Returns:
  /// - Map containing extracted data with parser IDs as keys
  Future<Map<String, Object>> parse({
    required Data scrapedData,
    required ScraperConfig scraperConfig,
    ProxyAPIConfig? proxyAPIConfig,
    Map<String, String>? cookies,
    bool debug = false,
    bool concurrentParsing = false,
  }) async {
    /// Start performance monitoring
    final Stopwatch stopwatch = Stopwatch()..start();

    printLog('Parser: Using scraper config...', debug, color: LogColor.blue);

    /// Get all parsers from the configuration
    final List<Parser> allParsers = scraperConfig.parsers.toList();

    /// Build parent-to-children relationship map for hierarchical parsing
    final Map<String, List<Parser>> parentToChildren =
        _buildParentToChildrenMap(allParsers);

    /// Identify root parsers (those that start the parsing chain)
    final List<Parser> rootParsers = parentToChildren['_root']?.toList() ?? [];

    /// Initialize with the source URL
    extractedData['url'] = scrapedData.url;

    /// Execute the parsing hierarchy starting with root parsers
    final Map<String, Object> parsedData = await _distributeParsers(
      parentToChildren: parentToChildren,
      parsers: rootParsers,
      parentData: scrapedData,
      proxyAPIConfig: proxyAPIConfig,
      cookies: cookies,
      debug: debug,
      concurrent: concurrentParsing,
    );

    /// Ensure URL is always present in the final result
    parsedData.putIfAbsent('url', () => scrapedData.url.toString());

    /// Log parsing performance
    stopwatch.stop();
    printLog(
      'Parsing took ${stopwatch.elapsedMilliseconds} ms.',
      debug,
      color: LogColor.green,
    );

    return parsedData;
  }

  /// Builds a map from parent parser IDs to their child parsers.
  ///
  /// This method creates a hierarchical structure that defines the order
  /// in which parsers should be executed. Child parsers depend on their
  /// parent parsers' output.
  ///
  /// Parameters:
  /// - [allParsers]: List of all parsers from the scraper configuration
  ///
  /// Returns:
  /// - Map where keys are parent parser IDs and values are lists of child parsers
  Map<String, List<Parser>> _buildParentToChildrenMap(List<Parser> allParsers) {
    final Map<String, List<Parser>> map = {};
    for (final parser in allParsers) {
      for (final parent in parser.parents) {
        map.putIfAbsent(parent, () => []).add(parser);
      }
    }
    return map;
  }

  /// Distributes and executes parsers based on their hierarchical relationships.
  ///
  /// This method handles the complex logic of:
  /// - Executing parsers in the correct order (parents before children)
  /// - Managing both single and multiple data scenarios
  /// - Supporting concurrent parsing for performance
  /// - Handling private parsers (internal data not returned to user)
  /// - Recursively processing child parsers
  ///
  /// Parameters:
  /// - [parentToChildren]: Map of parent IDs to their child parsers
  /// - [parsers]: List of parsers to execute at this level
  /// - [parentData]: Data from parent parser (or scraped HTML for root parsers)
  /// - [proxyAPIConfig]: Optional proxy API for HTTP requests
  /// - [proxyUrlParam]: Parameter name for target URL when using proxy
  /// - [cookies]: Cookies for HTTP requests
  /// - [debug]: Enable debug logging
  /// - [concurrent]: Enable concurrent parser execution
  ///
  /// Returns:
  /// - Map containing parsed data from this level and all child levels
  Future<Map<String, Object>> _distributeParsers({
    required Map<String, List<Parser>> parentToChildren,
    required List<Parser> parsers,
    required Data parentData,
    required ProxyAPIConfig? proxyAPIConfig,
    Map<String, String>? cookies,
    required bool debug,
    required bool concurrent,
  }) async {
    final Map<String, Object> parsedData = {};
    final List<String> privateIds = [];

    /// List to hold concurrent parser futures for parallel execution
    final List<Future<void>> parserFutures = [];

    for (final parser in parsers) {
      final String id = parser.id;

      /// Skip if data for this parser ID is already parsed (except 'url')
      if (id != 'url' && parsedData.containsKey(id)) {
        continue;
      }

      /// Define the parser execution task
      Future<void> parserTask() async {
        /// Execute parser and apply transformations
        final Data? data = await _runParserAndApplyTransformations(
          parser: parser,
          parentData: parentData,
          proxyAPIConfig: proxyAPIConfig,
          cookies: cookies,
          debug: debug,
        );

        if (data != null) {
          final Object obj = data.obj;

          /// Track private parsers for later removal
          if (parser.isPrivate) {
            privateIds.add(id);
          }

          /// Store parsed data
          parsedData[id] = obj;

          /// Get child parsers that depend on this parser's output
          final List<Parser> childParsers =
              parentToChildren[id]?.toList() ?? [];

          if (childParsers.isNotEmpty) {
            if (obj is Iterable && parser.multiple) {
              /// Handle multiple data entries (e.g., list of products)
              parsedData[id] = [];

              final List<Future<void>> childFutures = [];

              for (final singleData in obj) {
                /// Define child task for each data item
                Future<void> childTask() async {
                  final Map<String, Object> childrenResults =
                      await _distributeParsers(
                    parentToChildren: parentToChildren,
                    parsers: childParsers,
                    parentData: Data(data.url, singleData),
                    proxyAPIConfig: proxyAPIConfig,
                    cookies: cookies,
                    debug: debug,
                    concurrent: concurrent,
                  );

                  if (childrenResults.isNotEmpty) {
                    (parsedData[id] as List).add(childrenResults);
                  }
                }

                if (concurrent) {
                  childFutures.add(childTask());
                } else {
                  await childTask();
                }
              }

              /// Wait for all child tasks to complete if running concurrently
              if (concurrent && childFutures.isNotEmpty) {
                await Future.wait(childFutures);
              }
            } else {
              /// Handle single data entry
              final Map<String, Object> childResult = await _distributeParsers(
                parentToChildren: parentToChildren,
                parsers: childParsers,
                parentData: data,
                proxyAPIConfig: proxyAPIConfig,
                cookies: cookies,
                debug: debug,
                concurrent: concurrent,
              );

              if (childResult.isNotEmpty) {
                parsedData.addAll(childResult);
              }
            }
          }
        }
      }

      if (concurrent) {
        /// Add parser task to concurrent execution list
        parserFutures.add(parserTask());
      } else {
        /// Execute parser task sequentially
        await parserTask();
      }
    }

    /// Wait for all concurrent parser tasks to complete
    if (concurrent && parserFutures.isNotEmpty) {
      await Future.wait(parserFutures);
    }

    /// Remove private parser data from final result
    for (final String id in privateIds) {
      parsedData.remove(id);
    }

    return parsedData;
  }

  /// Executes a parser and applies any configured transformations and cleaning.
  ///
  /// This method:
  /// 1. Runs the parser based on its type (element, text, image, etc.)
  /// 2. Applies any configured transformations (regex, replace, etc.)
  /// 3. Applies any configured cleaning functions
  /// 4. Stores the result in the internal extractedData map
  ///
  /// Parameters:
  /// - [parser]: The parser configuration to execute
  /// - [parentData]: Data from parent parser or scraped HTML
  /// - [proxyAPIConfig]: Optional proxy API for HTTP requests
  /// - [proxyUrlParam]: Parameter name for target URL when using proxy
  /// - [cookies]: Cookies for HTTP requests
  /// - [debug]: Enable debug logging
  ///
  /// Returns:
  /// - [Data] object containing parsed and processed data, or null if parsing fails
  Future<Data?> _runParserAndApplyTransformations({
    required Parser parser,
    required Data parentData,
    required ProxyAPIConfig? proxyAPIConfig,
    Map<String, String>? cookies,
    required bool debug,
  }) async {
    /// Execute the parser based on its type
    final Data? parsed = await _runParser(
      parser: parser,
      parentData: parentData,
      proxyAPIConfig: proxyAPIConfig,
      cookies: cookies,
      debug: debug,
    );

    if (parsed != null) {
      Object? data = parsed.obj;

      /// Apply transformations if configured
      if (parser.transformationOptions != null) {
        data = parser.transformationOptions!.applyTransformations(data, debug);
      }
      if (data == null) {
        return null;
      }

      /// Apply cleaning function if configured
      if (parser.cleaner != null) {
        printLog("Cleaning ${parser.id}...", debug, color: LogColor.green);
        final CleanerFunction cleaner = parser.cleaner!;
        final Object? cleaned = cleaner(Data(parsed.url, data), debug);
        if (cleaned != null) {
          printLog(
            "Cleaning success for ${parser.id}.",
            debug,
            color: LogColor.green,
          );
          extractedData[parser.id] = cleaned;
          data = cleaned;
        } else {
          printLog(
            "Cleaning failed for ${parser.id}!!",
            debug,
            color: LogColor.red,
          );
        }
      } else {
        extractedData[parser.id] = data;
      }

      return Data(parsed.url, data);
    }

    return null;
  }

  /// Executes a parser based on its type using the appropriate parser function.
  ///
  /// This method routes to the correct parser implementation based on the
  /// parser's type. Each parser type has specialized logic for extracting
  /// different kinds of data from HTML or other sources.
  ///
  /// Parameters:
  /// - [parser]: The parser configuration to execute
  /// - [parentData]: Data from parent parser or scraped HTML
  /// - [proxyAPIConfig]: Optional proxy API for HTTP requests
  /// - [proxyUrlParam]: Parameter name for target URL when using proxy
  /// - [cookies]: Cookies for HTTP requests
  /// - [debug]: Enable debug logging
  ///
  /// Returns:
  /// - [Data] object containing parsed data, or null if parsing fails
  Future<Data?> _runParser({
    required Parser parser,
    required Data parentData,
    required ProxyAPIConfig? proxyAPIConfig,
    Map<String, String>? cookies,
    required bool debug,
  }) async {
    switch (parser.type) {
      case ParserType.element:
        return elementParser(
          parser: parser,
          parentData: parentData,
          allData: extractedData,
          debug: debug,
        );
      case ParserType.text:
        return textParser(
          parser: parser,
          parentData: parentData,
          allData: extractedData,
          debug: debug,
        );
      case ParserType.image:
        return imageParser(
          parser: parser,
          parentData: parentData,
          allData: extractedData,
          debug: debug,
        );
      case ParserType.attribute:
        return attributeParser(
          parser: parser,
          parentData: parentData,
          allData: extractedData,
          debug: debug,
        );
      case ParserType.json:
        return jsonParser(
          parser: parser,
          parentData: parentData,
          allData: extractedData,
          debug: debug,
        );
      case ParserType.url:
        return urlParser(
          parser: parser,
          parentData: parentData,
          allData: extractedData,
          debug: debug,
        );
      case ParserType.http:
        return await httpParser(
          parser: parser,
          parentData: parentData,
          allData: extractedData,
          proxyAPIConfig: proxyAPIConfig,
          cookies: cookies,
          debug: debug,
        );
      case ParserType.strBetween:
        return stringBetweenParser(
          parser: parser,
          parentData: parentData,
          debug: debug,
        );
      case ParserType.jsonld:
        return jsonLdParser(
          parser: parser,
          parentData: parentData,
          debug: debug,
        );
      case ParserType.table:
        return tableParser(
          parser: parser,
          parentData: parentData,
          allData: extractedData,
          debug: debug,
        );
      case ParserType.sibling:
        return siblingParser(
          parser: parser,
          parentData: parentData,
          allData: extractedData,
          debug: debug,
        );
      case ParserType.urlParam:
        return urlParamParser(
          parser: parser,
          parentData: parentData,
          allData: extractedData,
          debug: debug,
        );
      case ParserType.jsonTable:
        return jsonTableParser(
          parser: parser,
          parentData: parentData,
          allData: extractedData,
          debug: debug,
        );
      case ParserType.staticVal:
        return staticValueParser(
          parser: parser,
          parentData: parentData,
          debug: debug,
        );
      case ParserType.json5decode:
        return json5DecodeParser(
          parser: parser,
          parentData: parentData,
          debug: debug,
        );
      case ParserType.returnUrlParser:
        return returnUrlParser(
          parser: parser,
          parentData: parentData,
          debug: debug,
        );
    }
  }
}
