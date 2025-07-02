import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/exports.dart';

/// Used for parsing data from scraped HTML.
class WebParser {
  final Map<String, Object> extractedData = {};

  /// Entrypoint
  Future<Map<String, Object>> parse({
    required Data scrapedData,
    required Config config,
    ProxyAPIConfig? proxyAPIConfig,
    Map<String, String>? cookies,
    bool debug = false,
    bool concurrentParsing = false,
  }) async {
    /// Start the stopwatch
    final Stopwatch stopwatch = Stopwatch()..start();

    printLog('Parser: Fetching target...', debug, color: LogColor.blue);

    /// Fetch target based on URL
    final UrlTarget? target = fetchTarget(config.urlTargets, scrapedData.url);
    if (target == null) {
      printLog('Parser: Target not found!', debug, color: LogColor.red);
      throw WebScraperError('Unsupported URL');
    } else {
      printLog('Parser: Target found!', debug, color: LogColor.green);
    }

    /// Retrieve all parsers for the target
    final List<Parser> allParsers = config.parsers[target.name]?.toList() ?? [];

    /// Build a parent-to-children map
    final Map<String, List<Parser>> parentToChildren =
        _buildParentToChildrenMap(allParsers);

    /// Identify root parsers (_root)
    final List<Parser> rootParsers = parentToChildren['_root']?.toList() ?? [];

    /// Initialize extractedData with the URL
    extractedData['url'] = scrapedData.url;

    /// Start parsing
    final Map<String, Object> parsedData = await _distributeParsers(
      parentToChildren: parentToChildren,
      parsers: rootParsers,
      parentData: scrapedData,
      proxyAPIConfig: proxyAPIConfig,
      cookies: cookies,
      debug: debug,
      concurrent: concurrentParsing,
    );

    // Ensure 'url' is present in parsedData
    parsedData.putIfAbsent('url', () => scrapedData.url.toString());

    // Stop the stopwatch
    stopwatch.stop();

    // Log the parsing time
    printLog(
      'Parsing took ${stopwatch.elapsedMilliseconds} ms.',
      debug,
      color: LogColor.green,
    );

    return parsedData;
  }

  /// Builds a map from parent IDs to their child parsers
  Map<String, List<Parser>> _buildParentToChildrenMap(List<Parser> allParsers) {
    final Map<String, List<Parser>> map = {};
    for (final parser in allParsers) {
      for (final parent in parser.parent) {
        map.putIfAbsent(parent, () => []).add(parser);
      }
    }
    return map;
  }

  /// Distributes parsers based on the parent-to-children map, with option to run concurrently
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

    // List to hold all concurrent parser futures
    final List<Future<void>> parserFutures = [];

    for (final parser in parsers) {
      final String id = parser.id;

      // Skip if data for this parser ID is already parsed (except 'url')
      if (id != 'url' && parsedData.containsKey(id)) {
        continue;
      }

      // Define the parser task
      Future<void> parserTask() async {
        final Data? data = await _runParserAndExecuteOptional(
          parser: parser,
          parentData: parentData,
          proxyAPIConfig: proxyAPIConfig,
          cookies: cookies,
          debug: debug,
        );

        if (data != null) {
          final Object obj = data.obj;

          // Handle private parsers
          if (parser.isPrivate) {
            privateIds.add(id);
          }

          // Add parsed data
          parsedData[id] = obj;

          // Retrieve child parsers from the map
          final List<Parser> childParsers =
              parentToChildren[id]?.toList() ?? [];

          if (childParsers.isNotEmpty) {
            if (obj is Iterable && parser.multiple) {
              // Handle multiple data entries
              parsedData[id] = [];

              final List<Future<void>> childFutures = [];

              for (final singleData in obj) {
                // Define child task
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

              if (concurrent && childFutures.isNotEmpty) {
                await Future.wait(childFutures);
              }
            } else {
              // Handle single data entry
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
        // Add parser task to the list for concurrent execution
        parserFutures.add(parserTask());
      } else {
        // Execute parser task sequentially
        await parserTask();
      }
    }

    if (concurrent && parserFutures.isNotEmpty) {
      // Wait for all concurrent parser tasks to complete
      await Future.wait(parserFutures);
    }

    // Remove private parser data
    for (final String id in privateIds) {
      parsedData.remove(id);
    }

    return parsedData;
  }

  /// Runs the parser and executes optional transformations and cleaners
  Future<Data?> _runParserAndExecuteOptional({
    required Parser parser,
    required Data parentData,
    required ProxyAPIConfig? proxyAPIConfig,
    Map<String, String>? cookies,
    required bool debug,
  }) async {
    final Data? parsed = await _runParser(
      parser: parser,
      parentData: parentData,
      proxyAPIConfig: proxyAPIConfig,
      cookies: cookies,
      debug: debug,
    );

    if (parsed != null) {
      Object? data = parsed.obj;

      // Apply optional transformations
      if (parser.optional != null) {
        data = parser.optional!.applyTransformations(data, debug);
      }
      if (data == null) {
        return null;
      }

      // Apply cleaner if defined
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

  /// Runs the parser based on its type
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
