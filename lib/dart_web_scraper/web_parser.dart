import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/attribute_parser.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/element_parser.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/http_parser.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/image_parser.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/json5decode_parser.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/json_parser.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/json_table_parser.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/jsonld_parser.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/return_url_parser.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/sibling_parser.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/staticvalue_parser.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/string_between_parser.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/table_parser.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/text_parser.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/url_parameter_parser.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/url_parser.dart';

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
        try {
          if (parser.optional!.nth != null && data is List) {
            if (data.length >= (parser.optional!.nth! + 1)) {
              data = data[parser.optional!.nth!];
            }
          }
        } catch (e) {
          printLog(
            "Error in function runParserAndExecuteOptional nth: $e",
            debug,
            color: LogColor.red,
          );
        }

        /// Split by string
        try {
          if (parser.optional!.splitBy != null && data is String) {
            if (data.contains(parser.optional!.splitBy!)) {
              data = data.split(parser.optional!.splitBy!);
            }
          }
        } catch (e) {
          printLog(
            "Error in function runParserAndExecuteOptional split: $e",
            debug,
            color: LogColor.red,
          );
        }

        /// Apply methods
        try {
          if (parser.optional!.apply != null) {
            switch (parser.optional!.apply) {
              case ApplyMethod.urldecode:
                data = Uri.decodeFull(data.toString());
                break;
              case ApplyMethod.mapToList:
                if (data is Map) {
                  data = data.values.toList();
                }
                break;
              default:
            }
          }
        } catch (e) {
          printLog(
            "Error in function runParserAndExecuteOptional applymethod: $e",
            debug,
            color: LogColor.red,
          );
        }

        /// Replace
        try {
          if (parser.optional!.replaceFirst != null ||
              parser.optional!.replaceAll != null) {
            String type = "first";
            if (parser.optional!.replaceAll != null) {
              type = "all";
            }
            if (data is List) {
              List tmpR = [];
              for (final r in data) {
                var tmpD = r;
                if (type == "first") {
                  parser.optional!.replaceFirst!.forEach((key, value) {
                    tmpD = tmpD.toString().replaceFirst(key, value);
                  });
                } else {
                  parser.optional!.replaceAll!.forEach((key, value) {
                    tmpD = tmpD.toString().replaceAll(key, value);
                  });
                }
                tmpR.add(tmpD);
              }
              data = tmpR;
            } else {
              if (type == "first") {
                parser.optional!.replaceFirst!.forEach((key, value) {
                  data = data.toString().replaceFirst(key, value);
                });
              } else {
                parser.optional!.replaceAll!.forEach((key, value) {
                  data = data.toString().replaceAll(key, value);
                });
              }
            }
          }
        } catch (e) {
          printLog(
            "Error in function runParserAndExecuteOptional replace: $e",
            debug,
            color: LogColor.red,
          );
        }

        /// Regex replace
        try {
          if (parser.optional!.regexReplace != null) {
            final re = RegExp(parser.optional!.regexReplace!);
            String replaceWith = "";
            if (parser.optional!.regexReplaceWith != null) {
              replaceWith = parser.optional!.regexReplaceWith!;
            }
            if (data is List) {
              List<String> cleanedData = [];
              for (final l in data as Iterable) {
                String sanitized = l.toString().replaceAll(re, replaceWith);
                if (sanitized != "") {
                  cleanedData.add(sanitized.trim());
                }
              }
              if (cleanedData.isNotEmpty) {
                data = cleanedData;
              }
            } else {
              String? sanitized = (data as String).replaceAll(re, replaceWith);
              if (sanitized != "") {
                data = sanitized;
              }
            }
          }
        } catch (e) {
          printLog(
            "Error in function runParserAndExecuteOptional regexreplace: $e",
            debug,
            color: LogColor.red,
          );
        }

        /// Regex match
        try {
          if (parser.optional!.regex != null) {
            RegExp exp = RegExp(parser.optional!.regex!);
            RegExpMatch? regexed = exp.firstMatch(data.toString());
            if (regexed != null) {
              String? matched = regexed.group(parser.optional!.regexGroup ?? 0);
              if (matched != null) {
                data = matched;
              }
            }
          }
        } catch (e) {
          printLog(
            "Error in function runParserAndExecuteOptional regexmatch: $e",
            debug,
            color: LogColor.red,
          );
        }

        /// Crop String Start
        int? cropStart = parser.optional!.cropStart;
        try {
          if (cropStart != null) {
            if (data is List) {
              if ((data as List).length >= cropStart) {
                (data as List).removeRange(0, cropStart);
              }
            } else if (data is String) {
              if ((data as String).length >= cropStart && cropStart > 0) {
                data = (data as String).substring(cropStart).trim();
              }
            }
          }
        } catch (e) {
          printLog(
            "Error in function runParserAndExecuteOptional cropstringstart: $e",
            debug,
            color: LogColor.red,
          );
        }

        /// Crop String End
        int? cropEnd = parser.optional!.cropEnd;
        try {
          if (cropEnd != null) {
            if (data is List) {
              if (cropEnd <= (data as List).length) {
                (data as List).removeRange(
                    (data as List).length - cropEnd, (data as List).length);
              }
            } else if (data is String) {
              if ((data as String).length >= cropEnd && cropEnd > 0) {
                data = (data as String)
                    .substring(0, (data as String).length - cropEnd)
                    .trim();
              }
            }
          }
        } catch (e) {
          printLog(
            "Error in function runParserAndExecuteOptional cropstringend: $e",
            debug,
            color: LogColor.red,
          );
        }

        /// Prepend
        try {
          if (parser.optional!.prepend != null) {
            if (data is List) {
              List tmpD = [];
              for (final d in data as List) {
                tmpD.add(parser.optional!.prepend! + d);
              }
              data = tmpD;
            } else {
              data = parser.optional!.prepend! + data.toString();
            }
          }
        } catch (e) {
          printLog(
            "Error in function runParserAndExecuteOptional prepend: $e",
            debug,
            color: LogColor.red,
          );
        }

        /// Append
        try {
          if (parser.optional!.append != null) {
            if (data is List) {
              List tmpD = [];
              for (final d in data as List) {
                tmpD.add(d + parser.optional!.append!);
              }
              data = tmpD;
            } else {
              data = (data as String) + parser.optional!.append!;
            }
          }
        } catch (e) {
          printLog(
            "Error in function runParserAndExecuteOptional append: $e",
            debug,
            color: LogColor.red,
          );
        }

        /// Match with list and convert to boolean
        try {
          if (parser.optional!.match != null) {
            printLog(
              "Matching ${parser.optional!.match.toString()} with '${data.toString()}'",
              debug,
              color: LogColor.yellow,
            );
            for (final m in parser.optional!.match!) {
              if (data.toString().trim().contains(m.toString().trim())) {
                data = true;
                break;
              }
            }
            if (data != true) {
              data = false;
            }
          }
        } catch (e) {
          printLog(
            "Error in function runParserAndExecuteOptional matchwithlist: $e",
            debug,
            color: LogColor.red,
          );
        }
      }

      /// If custom cleaned is defined in Parser, clean the data.
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
          debug,
          proxyUrl,
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
        return returnUrlParser(parser, parentData);
      default:
        return null;
    }
  }
}
