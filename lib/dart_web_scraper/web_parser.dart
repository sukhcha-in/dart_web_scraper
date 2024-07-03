import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:dart_web_scraper/dart_web_scraper/optional/exports.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/exports.dart';

/// Used for parsing data from scraped HTML.
class WebParser {
  Map<String, Object> extractedData = {};

  /// Entrypoint
  Future<Map<String, Object>> parse({
    required Data scrapedData,
    required Config config,
    Uri? proxyUrl,
    bool debug = false,
  }) async {
    /// Root parsers
    List<Parser> rootParsers = [];

    /// Find if target is available for specified URL
    printLog('Parser: Fetching target...', debug, color: LogColor.blue);
    UrlTarget? target = fetchTarget(config.urlTargets, scrapedData.url);
    if (target == null) {
      printLog('Parser: Target not found!', debug, color: LogColor.red);
      throw WebScraperError('Unsupported URL');
    } else {
      printLog('Parser: Target found!', debug, color: LogColor.green);
    }

    /// Set all parsers
    List<Parser> allParsers = [];
    for (final p in config.parsers[target.name]!) {
      allParsers.add(p);
    }

    /// Set _root parsers
    rootParsers = childFinder('_root', allParsers);

    extractedData.addAll({"url": scrapedData.url});

    /// Start parsing
    Map<String, Object> parsedData = await distributeParsers(
      allParsers: allParsers,
      rootParsers: rootParsers,
      parentData: scrapedData,
      proxyUrl: proxyUrl,
      debug: debug,
    );
    if (!parsedData.containsKey('url')) {
      parsedData.addAll({'url': scrapedData.url.toString()});
    }
    return parsedData;
  }

  /// Helper function to distribute parsers
  Future<Map<String, Object>> distributeParsers({
    required List<Parser> allParsers,
    required List<Parser> rootParsers,
    required Data parentData,
    required Uri? proxyUrl,
    required bool debug,
  }) async {
    /// Ids used for internal functionality, no need to return it to user
    List<String> privateIds = [];

    /// Final data parsed
    Map<String, Object> parsedData = {};

    for (final parser in rootParsers) {
      String id = parser.id;

      /// Skip other parsers with same id because we already got data
      if (parsedData.containsKey(id) && id != "url") {
        continue;
      }

      Data? data = await runParserAndExecuteOptional(
        parser: parser,
        parentData: parentData,
        proxyUrl: proxyUrl,
        debug: debug,
      );
      Object? obj = data?.obj;
      if (obj != null) {
        if (parser.isPrivate) {
          privateIds.add(id);
        }
        parsedData.addAll({id: obj});
        List<Parser> childParsers = childFinder(id, allParsers);
        if (childParsers.isNotEmpty) {
          if (obj is Iterable && parser.multiple) {
            /// Run child parsers for each data entry
            /// Add parent id to public data as empty list
            parsedData.addAll({id: []});
            for (final singleData in obj) {
              var childrenResults = await distributeParsers(
                allParsers: allParsers,
                rootParsers: childParsers,
                parentData: Data(Uri.base, singleData),
                proxyUrl: proxyUrl,
                debug: debug,
              );

              if (childrenResults.isNotEmpty) {
                (parsedData[id] as List).add(childrenResults);
              }
            }
          } else {
            /// Run child parsers for data
            Map<String, Object> childResult = await distributeParsers(
              allParsers: allParsers,
              rootParsers: childParsers,
              parentData: data!,
              proxyUrl: proxyUrl,
              debug: debug,
            );
            if (childResult.isNotEmpty) {
              parsedData.addAll(childResult);
            }
          }
        }
      }
    }
    for (String id in privateIds) {
      parsedData.remove(id);
    }
    return parsedData;
  }

  /// Helper function to run parser and execute optional methods
  Future<Data?> runParserAndExecuteOptional({
    required Parser parser,
    required Data parentData,
    required Uri? proxyUrl,
    required bool debug,
  }) async {
    Data? parsed = await runParser(
      parser: parser,
      parentData: parentData,
      proxyUrl: proxyUrl,
      debug: debug,
    );
    if (parsed != null) {
      Object data = parsed.obj;
      if (parser.optional != null) {
        /// Select nth result
        Object? nth = nthOptional(parser, data, debug);
        if (nth != null) {
          data = nth;
        }

        /// Split by string
        Object? splitBy = splitByOptional(parser, data, debug);
        if (splitBy != null) {
          data = splitBy;
        }

        /// Apply methods
        Object? applyMethod = applyOptional(parser, data, debug);
        if (applyMethod != null) {
          data = applyMethod;
        }

        /// Replace
        Object? replace = replaceOptional(parser, data, debug);
        if (replace != null) {
          data = replace;
        }

        /// Regex replace
        Object? regexReplace = regexReplaceOptional(parser, data, debug);
        if (regexReplace != null) {
          data = regexReplace;
        }

        /// Regex match
        Object? regexMatch = regexMatchOptional(parser, data, debug);
        if (regexMatch != null) {
          data = regexMatch;
        }

        /// Crop Start
        Object? cropStart = cropStartOptional(parser, data, debug);
        if (cropStart != null) {
          data = cropStart;
        }

        /// Crop End
        Object? cropEnd = cropEndOptional(parser, data, debug);
        if (cropEnd != null) {
          data = cropEnd;
        }

        /// Prepend
        Object? prepend = prependOptional(parser, data, debug);
        if (prepend != null) {
          data = prepend;
        }

        /// Append
        Object? append = appendOptional(parser, data, debug);
        if (append != null) {
          data = append;
        }

        /// Match with list and convert to boolean
        Object? match = matchOptional(parser, data, debug);
        if (match != null) {
          data = match;
        }
      }

      /// If custom cleaner is defined in Parser, clean the data.
      if (parser.cleaner != null) {
        printLog("Cleaning ${parser.id}...", debug, color: LogColor.green);
        Function cleaner = parser.cleaner!;
        Object? cleaned = cleaner(Data(parsed.url, data), debug);
        if (cleaned != null) {
          printLog(
            "Cleaning success for ${parser.id}.",
            debug,
            color: LogColor.green,
          );
          extractedData.addAll({parser.id: cleaned});
          data = cleaned;
        } else {
          printLog(
            "Cleaning failed for ${parser.id}!!",
            debug,
            color: LogColor.red,
          );
        }
      } else {
        extractedData.addAll({parser.id: data});
      }

      return Data(parsed.url, data);
    } else {
      return null;
    }
  }

  /// Find all children of parser
  static List<Parser> childFinder(String parent, List<Parser> allParsers) {
    return allParsers.where((p) => p.parent.contains(parent)).toList();
  }

  /// Run parser based on type
  Future<Data?> runParser({
    required Parser parser,
    required Data parentData,
    required Uri? proxyUrl,
    required bool debug,
  }) async {
    switch (parser.type) {
      case ParserType.element:
        return elementParser(parser, parentData, extractedData, debug);
      case ParserType.text:
        return textParser(parser, parentData, extractedData, debug);
      case ParserType.image:
        return imageParser(parser, parentData, extractedData, debug);
      case ParserType.attribute:
        return attributeParser(parser, parentData, extractedData, debug);
      case ParserType.json:
        return jsonParser(parser, parentData, extractedData, debug);
      case ParserType.url:
        return urlParser(parser, parentData, extractedData, debug);
      case ParserType.http:
        return await httpParser(
          parser,
          parentData,
          extractedData,
          proxyUrl,
          debug,
        );
      case ParserType.strBetween:
        return stringBetweenParser(parser, parentData, debug);
      case ParserType.jsonld:
        return jsonLdParser(parser, parentData, debug);
      case ParserType.table:
        return tableParser(parser, parentData, extractedData, debug);
      case ParserType.sibling:
        return siblingParser(parser, parentData, extractedData, debug);
      case ParserType.urlParam:
        return urlParamParser(parser, parentData, extractedData, debug);
      case ParserType.jsonTable:
        return jsonTableParser(parser, parentData, extractedData, debug);
      case ParserType.staticVal:
        return staticValueParser(parser, parentData, debug);
      case ParserType.json5decode:
        return json5DecodeParser(parser, parentData, debug);
      case ParserType.returnUrlParser:
        return returnUrlParser(parser, parentData, debug);
      default:
        return null;
    }
  }
}
